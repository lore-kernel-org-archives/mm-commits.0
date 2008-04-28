From: akpm@linux-foundation.org
Subject: - pageflags_extended-and-separate-page-flags-for-head-and-tail.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:52:34 -0700
Message-ID: <200804282152.m3SLqYE5017786@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53078 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933775AbYD1Vwh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:52:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     PAGEFLAGS_EXTENDED and separate page flags for Head and Tail
has been removed from the -mm tree.  Its filename was
     pageflags_extended-and-separate-page-flags-for-head-and-tail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PAGEFLAGS_EXTENDED and separate page flags for Head and Tail
From: Christoph Lameter <clameter@sgi.com>

Having separate page flags for the head and the tail of a compound page allows
the compiler to use bitops instead of operations on a word to check for a tail
page.  That is f.e.  important for virt_to_head_page() which is used in
various critical code paths (kfree for example):

Code for PageTail(page)

Before:

 mov    (%rdi),%rdx		page->flags
 mov    %rdx,%rax		3 bytes
 and    $0x12000,%eax		5 bytes
 cmp    $0x12000,%rax		6 bytes
 je     897 <kfree+0xa7>

After:

 mov    (%rdi),%rax
 test   $0x40,%ah			(3 bytes)
 jne    887 <kfree+0x97>

So we go from 14 bytes to 3 bytes and from 3 instructions to one.  From the
use of 2 registers we go to none.

We can only use page flags for this if we have page flags available.  This
patch introduces CONFIG_PAGEFLAGS_EXTENDED that is set if pageflags are not
scarce due to SPARSEMEM using page flags for its sectionid on 32 bit NUMA
platforms.

Additional page flag definitions can be added to the CONFIG_PAGEFLAGS_EXTENDED
section in page-flags.h if the functionality depends on PAGEFLAGS_EXTENDED or
if more page flag overlapping tricks are used for the !PAGEFLAGS_EXTENDED
fallback (the upcoming virtual compound patch may hook in here and Rik's/Lee's
additional page flags to solve the reclaim issues could also be added there
[hint...  hint...  where are these patchsets?]).

Avoiding the overlaying of Pg_reclaim also clears the way for possible use of
compound pages for the pagecache or on the LRU.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   28 ++++++++++++++++++++++++++++
 mm/Kconfig                 |   12 ++++++++++++
 2 files changed, 40 insertions(+)

diff -puN include/linux/page-flags.h~pageflags_extended-and-separate-page-flags-for-head-and-tail include/linux/page-flags.h
--- a/include/linux/page-flags.h~pageflags_extended-and-separate-page-flags-for-head-and-tail
+++ a/include/linux/page-flags.h
@@ -83,7 +83,12 @@ enum pageflags {
 	PG_reserved,
 	PG_private,		/* If pagecache, has fs-private data */
 	PG_writeback,		/* Page is under writeback */
+#ifdef CONFIG_PAGEFLAGS_EXTENDED
+	PG_head,		/* A head page */
+	PG_tail,		/* A tail page */
+#else
 	PG_compound,		/* A compound page */
+#endif
 	PG_swapcache,		/* Swap page: swp_entry_t in private */
 	PG_mappedtodisk,	/* Has blocks allocated on-disk */
 	PG_reclaim,		/* To be reclaimed asap */
@@ -248,6 +253,28 @@ static inline void set_page_writeback(st
 	test_set_page_writeback(page);
 }
 
+#ifdef CONFIG_PAGEFLAGS_EXTENDED
+/*
+ * System with lots of page flags available. This allows separate
+ * flags for PageHead() and PageTail() checks of compound pages so that bit
+ * tests can be used in performance sensitive paths. PageCompound is
+ * generally not used in hot code paths.
+ */
+__PAGEFLAG(Head, head)
+__PAGEFLAG(Tail, tail)
+
+static inline int PageCompound(struct page *page)
+{
+	return page->flags & ((1L << PG_head) | (1L << PG_tail));
+
+}
+#else
+/*
+ * Reduce page flag use as much as possible by overlapping
+ * compound page flags with the flags used for page cache pages. Possible
+ * because PageCompound is always set for compound pages and not for
+ * pages on the LRU and/or pagecache.
+ */
 TESTPAGEFLAG(Compound, compound)
 __PAGEFLAG(Head, compound)
 
@@ -278,5 +305,6 @@ static inline void __ClearPageTail(struc
 	page->flags &= ~PG_head_tail_mask;
 }
 
+#endif /* !PAGEFLAGS_EXTENDED */
 #endif /* !__GENERATING_BOUNDS_H */
 #endif	/* PAGE_FLAGS_H */
diff -puN mm/Kconfig~pageflags_extended-and-separate-page-flags-for-head-and-tail mm/Kconfig
--- a/mm/Kconfig~pageflags_extended-and-separate-page-flags-for-head-and-tail
+++ a/mm/Kconfig
@@ -143,6 +143,18 @@ config MEMORY_HOTREMOVE
 	depends on MEMORY_HOTPLUG && ARCH_ENABLE_MEMORY_HOTREMOVE
 	depends on MIGRATION
 
+#
+# If we have space for more page flags then we can enable additional
+# optimizations and functionality.
+#
+# Regular Sparsemem takes page flag bits for the sectionid if it does not
+# use a virtual memmap. Disable extended page flags for 32 bit platforms
+# that require the use of a sectionid in the page flags.
+#
+config PAGEFLAGS_EXTENDED
+	def_bool y
+	depends on 64BIT || SPARSEMEM_VMEMMAP || !NUMA || !SPARSEMEM
+
 # Heavily threaded applications may benefit from splitting the mm-wide
 # page_table_lock, so that faults on different parts of the user address
 # space can be handled with less contention: split it at this NR_CPUS.
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
git-unionfs.patch
git-pekka.patch
page-allcoator-smarter-retry-of-costly-order-allocations.patch
page-allocator-explicitly-retry-hugepage-allocations.patch
ipc-add-definitions-of-ushort_max-and-others.patch
mm-add-nr_writeback_temp-counter.patch
remove-div_long_long_rem.patch
slab-add-a-flag-to-prevent-debug_free-checks-on-a-kmem_cache.patch
add-kbuildh-that-contains-common-definitions-for-kbuild-users.patch
x86-use-kbuildh.patch
mips-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch
alpha-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch
ia64-use-kbuildh-macros-instead-of-defining-macros-in-asm-offsetsc.patch
arm-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch
xtensa-use-kbuildh-macros-instead-of-defining-them-in-asm-offsetsc.patch
sparc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
avr32-use-kbuildh-macros-instead-of-defining-macros-in-asm-offsetsc.patch
blackfin-use-kbuildh-instead-of-defining-macros-in-asm-macrosc.patch
frv-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
h8300-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
m68k-m68kmmu-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
mn10300-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
parisc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
ppc-powerpc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc-update.patch
sh-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
v850-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch

