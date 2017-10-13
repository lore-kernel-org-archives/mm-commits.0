From: akpm@linux-foundation.org
Subject: + mm-zero-reserved-and-unavailable-struct-pages.patch added to
 -mm tree
Date: Fri, 13 Oct 2017 14:18:52 -0700
Message-ID: <59e12dbc.LSRtbaqnVzWAyrGh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58850 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751348AbdJMVSy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Oct 2017 17:18:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pasha.tatashin@oracle.com, ard.biesheuvel@linaro.org, aryabinin@virtuozzo.com, bob.picco@oracle.com, borntraeger@de.ibm.com, catalin.marinas@arm.com, daniel.m.jordan@oracle.com, davem@davemloft.net, dvyukov@google.com, glider@google.com, heiko.carstens@de.ibm.com, hpa@zytor.com, mark.rutland@arm.com, mgorman@techsingularity.net, mhocko@kernel.org, mhocko@suse.com, mingo@redhat.com, sam@ravnborg.org, steven.sistare@oracle.com, tglx@linutronix.de, will.deacon@arm.com, willy@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: zero reserved and unavailable struct pages
has been added to the -mm tree.  Its filename is
     mm-zero-reserved-and-unavailable-struct-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zero-reserved-and-unavailable-struct-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zero-reserved-and-unavailable-struct-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@oracle.com>
Subject: mm: zero reserved and unavailable struct pages

Some memory is reserved but unavailable: not present in memblock.memory
(because not backed by physical pages), but present in memblock.reserved. 
Such memory has backing struct pages, but they are not initialized by
going through __init_single_page().

In some cases these struct pages are accessed even if they do not contain
any data.  One example is page_to_pfn() might access page->flags if this
is where section information is stored (CONFIG_SPARSEMEM,
SECTION_IN_PAGE_FLAGS).

One example of such memory: trim_low_memory_range() unconditionally
reserves from pfn 0, but e820__memblock_setup() might provide the exiting
memory from pfn 1 (i.e.  KVM).

Since struct pages are zeroed in __init_single_page(), and not during
allocation time, we must zero such struct pages explicitly.

The patch involves adding a new memblock iterator:
	for_each_resv_unavail_range(i, p_start, p_end)

Which iterates through reserved && !memory lists, and we zero struct pages
explicitly by calling mm_zero_struct_page().

===

Here is more detailed example of problem that this patch is addressing:

Run tested on qemu with the following arguments:

	-enable-kvm -cpu kvm64 -m 512 -smp 2

This patch reports that there are 98 unavailable pages.

They are: pfn 0 and pfns in range [159, 255].

Note, trim_low_memory_range() reserves only pfns in range [0, 15], it does
not reserve [159, 255] ones.

e820__memblock_setup() reports linux that the following physical ranges are
available:
    [1 , 158]
[256, 130783]

Notice, that exactly unavailable pfns are missing!

Now, lets check what we have in zone 0: [1, 131039]

pfn 0, is not part of the zone, but pfns [1, 158], are.

However, the bigger problem we have if we do not initialize these struct
pages is with memory hotplug.  Because, that path operates at 2M
boundaries (section_nr).  And checks if 2M range of pages is hot
removable.  It starts with first pfn from zone, rounds it down to 2M
boundary (sturct pages are allocated at 2M boundaries when vmemmap is
created), and checks if that section is hot removable.  In this case start
with pfn 1 and convert it down to pfn 0.  Later pfn is converted to struct
page, and some fields are checked.  Now, if we do not zero struct pages,
we get unpredictable results.

In fact when CONFIG_VM_DEBUG is enabled, and we explicitly set all vmemmap
memory to ones, the following panic is observed with kernel test without
this patch applied:

BUG: unable to handle kernel NULL pointer dereference at          (null)
IP: is_pageblock_removable_nolock+0x35/0x90
PGD 0 P4D 0
Oops: 0000 [#1] PREEMPT
...
task: ffff88001f4e2900 task.stack: ffffc90000314000
RIP: 0010:is_pageblock_removable_nolock+0x35/0x90
RSP: 0018:ffffc90000317d60 EFLAGS: 00010202
RAX: ffffffffffffffff RBX: ffff88001d92b000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000200000 RDI: ffff88001d92b000
RBP: ffffc90000317d80 R08: 00000000000010c8 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88001db2b000
R13: ffffffff81af6d00 R14: ffff88001f7d5000 R15: ffffffff82a1b6c0
FS:  00007f4eb857f7c0(0000) GS:ffffffff81c27000(0000) knlGS:0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000001f4e6000 CR4: 00000000000006b0
Call Trace:
 ? is_mem_section_removable+0x5a/0xd0
 show_mem_removable+0x6b/0xa0
 dev_attr_show+0x1b/0x50
 sysfs_kf_seq_show+0xa1/0x100
 kernfs_seq_show+0x22/0x30
 seq_read+0x1ac/0x3a0
 kernfs_fop_read+0x36/0x190
 ? security_file_permission+0x90/0xb0
 __vfs_read+0x16/0x30
 vfs_read+0x81/0x130
 SyS_read+0x44/0xa0
 entry_SYSCALL_64_fastpath+0x1f/0xbd

Link: http://lkml.kernel.org/r/20171013173214.27300-7-pasha.tatashin@oracle.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Reviewed-by: Steven Sistare <steven.sistare@oracle.com>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Reviewed-by: Bob Picco <bob.picco@oracle.com>
Tested-by: Bob Picco <bob.picco@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |   16 ++++++++++++++
 include/linux/mm.h       |   15 +++++++++++++
 mm/page_alloc.c          |   40 +++++++++++++++++++++++++++++++++++++
 3 files changed, 71 insertions(+)

diff -puN include/linux/memblock.h~mm-zero-reserved-and-unavailable-struct-pages include/linux/memblock.h
--- a/include/linux/memblock.h~mm-zero-reserved-and-unavailable-struct-pages
+++ a/include/linux/memblock.h
@@ -237,6 +237,22 @@ unsigned long memblock_next_valid_pfn(un
 	for_each_mem_range_rev(i, &memblock.memory, &memblock.reserved,	\
 			       nid, flags, p_start, p_end, p_nid)
 
+/**
+ * for_each_resv_unavail_range - iterate through reserved and unavailable memory
+ * @i: u64 used as loop variable
+ * @flags: pick from blocks based on memory attributes
+ * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
+ * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
+ *
+ * Walks over unavailable but reserved (reserved && !memory) areas of memblock.
+ * Available as soon as memblock is initialized.
+ * Note: because this memory does not belong to any physical node, flags and
+ * nid arguments do not make sense and thus not exported as arguments.
+ */
+#define for_each_resv_unavail_range(i, p_start, p_end)			\
+	for_each_mem_range(i, &memblock.reserved, &memblock.memory,	\
+			   NUMA_NO_NODE, MEMBLOCK_NONE, p_start, p_end, NULL)
+
 static inline void memblock_set_region_flags(struct memblock_region *r,
 					     unsigned long flags)
 {
diff -puN include/linux/mm.h~mm-zero-reserved-and-unavailable-struct-pages include/linux/mm.h
--- a/include/linux/mm.h~mm-zero-reserved-and-unavailable-struct-pages
+++ a/include/linux/mm.h
@@ -95,6 +95,15 @@ extern int mmap_rnd_compat_bits __read_m
 #endif
 
 /*
+ * On some architectures it is expensive to call memset() for small sizes.
+ * Those architectures should provide their own implementation of "struct page"
+ * zeroing by defining this macro in <asm/pgtable.h>.
+ */
+#ifndef mm_zero_struct_page
+#define mm_zero_struct_page(pp)  ((void)memset((pp), 0, sizeof(struct page)))
+#endif
+
+/*
  * Default maximum number of active map areas, this limits the number of vmas
  * per mm struct. Users can overwrite this number by sysctl but there is a
  * problem.
@@ -2029,6 +2038,12 @@ extern int __meminit __early_pfn_to_nid(
 					struct mminit_pfnnid_cache *state);
 #endif
 
+#ifdef CONFIG_HAVE_MEMBLOCK
+void zero_resv_unavail(void);
+#else
+static inline void zero_resv_unavail(void) {}
+#endif
+
 extern void set_dma_reserve(unsigned long new_dma_reserve);
 extern void memmap_init_zone(unsigned long, int, unsigned long,
 				unsigned long, enum memmap_context);
diff -puN mm/page_alloc.c~mm-zero-reserved-and-unavailable-struct-pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-zero-reserved-and-unavailable-struct-pages
+++ a/mm/page_alloc.c
@@ -6201,6 +6201,44 @@ void __paginginit free_area_init_node(in
 	free_area_init_core(pgdat);
 }
 
+#ifdef CONFIG_HAVE_MEMBLOCK
+/*
+ * Only struct pages that are backed by physical memory are zeroed and
+ * initialized by going through __init_single_page(). But, there are some
+ * struct pages which are reserved in memblock allocator and their fields
+ * may be accessed (for example page_to_pfn() on some configuration accesses
+ * flags). We must explicitly zero those struct pages.
+ */
+void __paginginit zero_resv_unavail(void)
+{
+	phys_addr_t start, end;
+	unsigned long pfn;
+	u64 i, pgcnt;
+
+	/*
+	 * Loop through ranges that are reserved, but do not have reported
+	 * physical memory backing.
+	 */
+	pgcnt = 0;
+	for_each_resv_unavail_range(i, &start, &end) {
+		for (pfn = PFN_DOWN(start); pfn < PFN_UP(end); pfn++) {
+			mm_zero_struct_page(pfn_to_page(pfn));
+			pgcnt++;
+		}
+	}
+
+	/*
+	 * Struct pages that do not have backing memory. This could be because
+	 * firmware is using some of this memory, or for some other reasons.
+	 * Once memblock is changed so such behaviour is not allowed: i.e.
+	 * list of "reserved" memory must be a subset of list of "memory", then
+	 * this code can be removed.
+	 */
+	if (pgcnt)
+		pr_info("Reserved but unavailable: %lld pages", pgcnt);
+}
+#endif /* CONFIG_HAVE_MEMBLOCK */
+
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 
 #if MAX_NUMNODES > 1
@@ -6624,6 +6662,7 @@ void __init free_area_init_nodes(unsigne
 			node_set_state(nid, N_MEMORY);
 		check_for_memory(pgdat, nid);
 	}
+	zero_resv_unavail();
 }
 
 static int __init cmdline_parse_core(char *p, unsigned long *core)
@@ -6787,6 +6826,7 @@ void __init free_area_init(unsigned long
 {
 	free_area_init_node(0, zones_size,
 			__pa(PAGE_OFFSET) >> PAGE_SHIFT, NULL);
+	zero_resv_unavail();
 }
 
 static int page_alloc_cpu_dead(unsigned int cpu)
_

Patches currently in -mm which might be from pasha.tatashin@oracle.com are

mm-deferred_init_memmap-improvements.patch
x86-mm-setting-fields-in-deferred-pages.patch
sparc64-mm-setting-fields-in-deferred-pages.patch
sparc64-simplify-vmemmap_populate.patch
mm-defining-memblock_virt_alloc_try_nid_raw.patch
mm-zero-reserved-and-unavailable-struct-pages.patch
x86-kasan-add-and-use-kasan_map_populate.patch
arm64-kasan-add-and-use-kasan_map_populate.patch
mm-stop-zeroing-memory-during-allocation-in-vmemmap.patch
sparc64-optimized-struct-page-zeroing.patch
sparc64-ng4-memset-32-bits-overflow.patch

