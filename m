From: akpm@linux-foundation.org
Subject: [to-be-updated]
 memblock-introduce-a-for_each_reserved_mem_region-iterator.patch removed
 from -mm tree
Date: Wed, 29 Apr 2015 13:36:23 -0700
Message-ID: <554140c7.rToP+w4NdHT2cg6I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57632 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbbD2UgY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Apr 2015 16:36:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holt@sgi.com, daniel@numascale.com, dave.hansen@intel.com, hpa@zytor.com, mgorman@suse.de, mingo@elte.hu, nzimmer@sgi.com, scott.norton@hp.com, tglx@linutronix.de, tony.luck@intel.com, waiman.long@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: introduce a for_each_reserved_mem_region iterator
has been removed from the -mm tree.  Its filename was
     memblock-introduce-a-for_each_reserved_mem_region-iterator.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Robin Holt <holt@sgi.com>
Subject: memblock: introduce a for_each_reserved_mem_region iterator

Struct page initialisation had been identified as one of the reasons why
large machines take a long time to boot. Patches were posted a long time ago
to defer initialisation until they were first used.  This was rejected on
the grounds it should not be necessary to hurt the fast paths. This series
reuses much of the work from that time but defers the initialisation of
memory to kswapd so that one thread per node initialises memory local to
that node.

After applying the series and setting the appropriate Kconfig variable I
see this in the boot log on a 64G machine

[    7.383764] kswapd 0 initialised deferred memory in 188ms
[    7.404253] kswapd 1 initialised deferred memory in 208ms
[    7.411044] kswapd 3 initialised deferred memory in 216ms
[    7.411551] kswapd 2 initialised deferred memory in 216ms

On a 1TB machine, I see

[    8.406511] kswapd 3 initialised deferred memory in 1116ms
[    8.428518] kswapd 1 initialised deferred memory in 1140ms
[    8.435977] kswapd 0 initialised deferred memory in 1148ms
[    8.437416] kswapd 2 initialised deferred memory in 1148ms

Once booted the machine appears to work as normal. Boot times were measured
from the time shutdown was called until ssh was available again.  In the
64G case, the boot time savings are negligible. On the 1TB machine, the
savings were 16 seconds.


This patch (of 13):

As part of initializing struct page's in 2MiB chunks, we noticed that at
the end of free_all_bootmem(), there was nothing which had forced the
reserved/allocated 4KiB pages to be initialized.

This helper function will be used for that expansion.

Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Nate Zimmer <nzimmer@sgi.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Waiman Long <waiman.long@hp.com>
Cc: Scott Norton <scott.norton@hp.com>
Cc: Daniel J Blueman <daniel@numascale.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |   18 ++++++++++++++++++
 mm/memblock.c            |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff -puN include/linux/memblock.h~memblock-introduce-a-for_each_reserved_mem_region-iterator include/linux/memblock.h
--- a/include/linux/memblock.h~memblock-introduce-a-for_each_reserved_mem_region-iterator
+++ a/include/linux/memblock.h
@@ -93,6 +93,9 @@ void __next_mem_range_rev(u64 *idx, int
 			  struct memblock_type *type_b, phys_addr_t *out_start,
 			  phys_addr_t *out_end, int *out_nid);
 
+void __next_reserved_mem_region(u64 *idx, phys_addr_t *out_start,
+			       phys_addr_t *out_end);
+
 /**
  * for_each_mem_range - iterate through memblock areas from type_a and not
  * included in type_b. Or just type_a if type_b is NULL.
@@ -132,6 +135,21 @@ void __next_mem_range_rev(u64 *idx, int
 	     __next_mem_range_rev(&i, nid, type_a, type_b,		\
 				  p_start, p_end, p_nid))
 
+/**
+ * for_each_reserved_mem_region - iterate over all reserved memblock areas
+ * @i: u64 used as loop variable
+ * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
+ * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
+ *
+ * Walks over reserved areas of memblock. Available as soon as memblock
+ * is initialized.
+ */
+#define for_each_reserved_mem_region(i, p_start, p_end)			\
+	for (i = 0UL,							\
+	     __next_reserved_mem_region(&i, p_start, p_end);		\
+	     i != (u64)ULLONG_MAX;					\
+	     __next_reserved_mem_region(&i, p_start, p_end))
+
 #ifdef CONFIG_MOVABLE_NODE
 static inline bool memblock_is_hotpluggable(struct memblock_region *m)
 {
diff -puN mm/memblock.c~memblock-introduce-a-for_each_reserved_mem_region-iterator mm/memblock.c
--- a/mm/memblock.c~memblock-introduce-a-for_each_reserved_mem_region-iterator
+++ a/mm/memblock.c
@@ -779,6 +779,38 @@ int __init_memblock memblock_clear_hotpl
 }
 
 /**
+ * __next_reserved_mem_region - next function for for_each_reserved_region()
+ * @idx: pointer to u64 loop variable
+ * @out_start: ptr to phys_addr_t for start address of the region, can be %NULL
+ * @out_end: ptr to phys_addr_t for end address of the region, can be %NULL
+ *
+ * Iterate over all reserved memory regions.
+ */
+void __init_memblock __next_reserved_mem_region(u64 *idx,
+					   phys_addr_t *out_start,
+					   phys_addr_t *out_end)
+{
+	struct memblock_type *rsv = &memblock.reserved;
+
+	if (*idx >= 0 && *idx < rsv->cnt) {
+		struct memblock_region *r = &rsv->regions[*idx];
+		phys_addr_t base = r->base;
+		phys_addr_t size = r->size;
+
+		if (out_start)
+			*out_start = base;
+		if (out_end)
+			*out_end = base + size - 1;
+
+		*idx += 1;
+		return;
+	}
+
+	/* signal end of iteration */
+	*idx = ULLONG_MAX;
+}
+
+/**
  * __next__mem_range - next function for for_each_free_mem_range() etc.
  * @idx: pointer to u64 loop variable
  * @nid: node selector, %NUMA_NO_NODE for all nodes
_

Patches currently in -mm which might be from holt@sgi.com are

mm-meminit-move-page-initialization-into-a-separate-function.patch
mm-meminit-only-set-page-reserved-in-the-memblock-region.patch
mm-page_alloc-pass-pfn-to-__free_pages_bootmem.patch
mm-meminit-make-__early_pfn_to_nid-smp-safe-and-introduce-meminit_pfn_in_nid.patch
mm-meminit-inline-some-helper-functions.patch
mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set.patch
mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set-fix.patch
mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd.patch
mm-meminit-minimise-number-of-pfn-page-lookups-during-initialisation.patch
x86-mm-enable-deferred-struct-page-initialisation-on-x86-64.patch
mm-meminit-free-pages-in-large-chunks-where-possible.patch
mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init.patch
mm-meminit-remove-mminit_verify_page_links.patch

