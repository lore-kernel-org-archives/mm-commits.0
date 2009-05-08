From: akpm@linux-foundation.org
Subject: + proc-export-more-page-flags-in-proc-kpageflags.patch added to -mm tree
Date: Fri, 08 May 2009 13:40:46 -0700
Message-ID: <200905082040.n48KelUE010391@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759306AbZEHUpt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 May 2009 16:45:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, adobriyan@gmail.com, andi@firstfloor.org, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, mpm@selenic.com


The patch titled
     proc: export more page flags in /proc/kpageflags
has been added to the -mm tree.  Its filename is
     proc-export-more-page-flags-in-proc-kpageflags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: export more page flags in /proc/kpageflags
From: Wu Fengguang <fengguang.wu@intel.com>

Export all page flags faithfully in /proc/kpageflags.

	11. KPF_MMAP		(pseudo flag) memory mapped page
	12. KPF_ANON		(pseudo flag) memory mapped page (anonymous)
	13. KPF_SWAPCACHE	page is in swap cache
	14. KPF_SWAPBACKED	page is swap/RAM backed
	15. KPF_COMPOUND_HEAD	(*)
	16. KPF_COMPOUND_TAIL	(*)
	17. KPF_HUGE		hugeTLB pages
	18. KPF_UNEVICTABLE	page is in the unevictable LRU list
	19. KPF_HWPOISON(TBD)	hardware detected corruption
	20. KPF_NOPAGE		(pseudo flag) no page frame at the address
	32-39.			more obscure flags for kernel developers

	(*) For compound pages, exporting _both_ head/tail info enables
	    users to tell where a compound page starts/ends, and its order.

The acompanied page-types tool will handle the details like decoupling
overloaded flags and hiding obscure flags to normal users.

Thanks to KOSAKI and Andi for their valuable recommendations!

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |  148 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 118 insertions(+), 30 deletions(-)

diff -puN fs/proc/page.c~proc-export-more-page-flags-in-proc-kpageflags fs/proc/page.c
--- a/fs/proc/page.c~proc-export-more-page-flags-in-proc-kpageflags
+++ a/fs/proc/page.c
@@ -71,19 +71,124 @@ static const struct file_operations proc
 
 /* These macros are used to decouple internal flags from exported ones */
 
-#define KPF_LOCKED     0
-#define KPF_ERROR      1
-#define KPF_REFERENCED 2
-#define KPF_UPTODATE   3
-#define KPF_DIRTY      4
-#define KPF_LRU        5
-#define KPF_ACTIVE     6
-#define KPF_SLAB       7
-#define KPF_WRITEBACK  8
-#define KPF_RECLAIM    9
-#define KPF_BUDDY     10
+#define KPF_LOCKED		0
+#define KPF_ERROR		1
+#define KPF_REFERENCED		2
+#define KPF_UPTODATE		3
+#define KPF_DIRTY		4
+#define KPF_LRU			5
+#define KPF_ACTIVE		6
+#define KPF_SLAB		7
+#define KPF_WRITEBACK		8
+#define KPF_RECLAIM		9
+#define KPF_BUDDY		10
+
+/* 11-20: new additions in 2.6.31 */
+#define KPF_MMAP		11
+#define KPF_ANON		12
+#define KPF_SWAPCACHE		13
+#define KPF_SWAPBACKED		14
+#define KPF_COMPOUND_HEAD	15
+#define KPF_COMPOUND_TAIL	16
+#define KPF_HUGE		17
+#define KPF_UNEVICTABLE		18
+#define KPF_NOPAGE		20
+
+/* kernel hacking assistances
+ * WARNING: subject to change, never rely on them!
+ */
+#define KPF_RESERVED		32
+#define KPF_MLOCKED		33
+#define KPF_MAPPEDTODISK	34
+#define KPF_PRIVATE		35
+#define KPF_PRIVATE_2		36
+#define KPF_OWNER_PRIVATE	37
+#define KPF_ARCH		38
+#define KPF_UNCACHED		39
 
-#define kpf_copy_bit(flags, dstpos, srcpos) (((flags >> srcpos) & 1) << dstpos)
+static inline u64 kpf_copy_bit(u64 kflags, int ubit, int kbit)
+{
+	return ((kflags >> kbit) & 1) << ubit;
+}
+
+static u64 get_uflags(struct page *page)
+{
+	u64 k;
+	u64 u;
+
+	/*
+	 * pseudo flag: KPF_NOPAGE
+	 * it differentiates a memory hole from a page with no flags
+	 */
+	if (!page)
+		return 1 << KPF_NOPAGE;
+
+	k = page->flags;
+	u = 0;
+
+	/*
+	 * pseudo flags for the well known (anonymous) memory mapped pages
+	 *
+	 * Note that page->_mapcount is overloaded in SLOB/SLUB/SLQB, so the
+	 * simple test in page_mapped() is not enough.
+	 */
+	if (!PageSlab(page) && page_mapped(page))
+		u |= 1 << KPF_MMAP;
+	if (PageAnon(page))
+		u |= 1 << KPF_ANON;
+
+	/*
+	 * compound pages: export both head/tail info
+	 * they together define a compound page's start/end pos and order
+	 */
+	if (PageHead(page))
+		u |= 1 << KPF_COMPOUND_HEAD;
+	if (PageTail(page))
+		u |= 1 << KPF_COMPOUND_TAIL;
+	if (PageHuge(page))
+		u |= 1 << KPF_HUGE;
+
+	u |= kpf_copy_bit(k, KPF_LOCKED,	PG_locked);
+
+	/*
+	 * Caveats on high order pages:
+	 * PG_buddy will only be set on the head page; SLUB/SLQB do the same
+	 * for PG_slab; SLOB won't set PG_slab at all on compound pages.
+	 */
+	u |= kpf_copy_bit(k, KPF_SLAB,		PG_slab);
+	u |= kpf_copy_bit(k, KPF_BUDDY,		PG_buddy);
+
+	u |= kpf_copy_bit(k, KPF_ERROR,		PG_error);
+	u |= kpf_copy_bit(k, KPF_DIRTY,		PG_dirty);
+	u |= kpf_copy_bit(k, KPF_UPTODATE,	PG_uptodate);
+	u |= kpf_copy_bit(k, KPF_WRITEBACK,	PG_writeback);
+
+	u |= kpf_copy_bit(k, KPF_LRU,		PG_lru);
+	u |= kpf_copy_bit(k, KPF_REFERENCED,	PG_referenced);
+	u |= kpf_copy_bit(k, KPF_ACTIVE,	PG_active);
+	u |= kpf_copy_bit(k, KPF_RECLAIM,	PG_reclaim);
+
+	u |= kpf_copy_bit(k, KPF_SWAPCACHE,	PG_swapcache);
+	u |= kpf_copy_bit(k, KPF_SWAPBACKED,	PG_swapbacked);
+
+#ifdef CONFIG_UNEVICTABLE_LRU
+	u |= kpf_copy_bit(k, KPF_UNEVICTABLE,	PG_unevictable);
+	u |= kpf_copy_bit(k, KPF_MLOCKED,	PG_mlocked);
+#endif
+
+#ifdef CONFIG_IA64_UNCACHED_ALLOCATOR
+	u |= kpf_copy_bit(k, KPF_UNCACHED,	PG_uncached);
+#endif
+
+	u |= kpf_copy_bit(k, KPF_RESERVED,	PG_reserved);
+	u |= kpf_copy_bit(k, KPF_MAPPEDTODISK,	PG_mappedtodisk);
+	u |= kpf_copy_bit(k, KPF_PRIVATE,	PG_private);
+	u |= kpf_copy_bit(k, KPF_PRIVATE_2,	PG_private_2);
+	u |= kpf_copy_bit(k, KPF_OWNER_PRIVATE,	PG_owner_priv_1);
+	u |= kpf_copy_bit(k, KPF_ARCH,		PG_arch_1);
+
+	return u;
+};
 
 static ssize_t kpageflags_read(struct file *file, char __user *buf,
 			     size_t count, loff_t *ppos)
@@ -93,7 +198,6 @@ static ssize_t kpageflags_read(struct fi
 	unsigned long src = *ppos;
 	unsigned long pfn;
 	ssize_t ret = 0;
-	u64 kflags, uflags;
 
 	pfn = src / KPMSIZE;
 	count = min_t(unsigned long, count, (max_pfn * KPMSIZE) - src);
@@ -105,24 +209,8 @@ static ssize_t kpageflags_read(struct fi
 			ppage = pfn_to_page(pfn);
 		else
 			ppage = NULL;
-		if (!ppage)
-			kflags = 0;
-		else
-			kflags = ppage->flags;
-
-		uflags = kpf_copy_bit(kflags, KPF_LOCKED, PG_locked) |
-			kpf_copy_bit(kflags, KPF_ERROR, PG_error) |
-			kpf_copy_bit(kflags, KPF_REFERENCED, PG_referenced) |
-			kpf_copy_bit(kflags, KPF_UPTODATE, PG_uptodate) |
-			kpf_copy_bit(kflags, KPF_DIRTY, PG_dirty) |
-			kpf_copy_bit(kflags, KPF_LRU, PG_lru) |
-			kpf_copy_bit(kflags, KPF_ACTIVE, PG_active) |
-			kpf_copy_bit(kflags, KPF_SLAB, PG_slab) |
-			kpf_copy_bit(kflags, KPF_WRITEBACK, PG_writeback) |
-			kpf_copy_bit(kflags, KPF_RECLAIM, PG_reclaim) |
-			kpf_copy_bit(kflags, KPF_BUDDY, PG_buddy);
 
-		if (put_user(uflags, out)) {
+		if (put_user(get_uflags(ppage), out)) {
 			ret = -EFAULT;
 			break;
 		}
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
readahead-make-mmap_miss-an-unsigned-int.patch
readahead-move-max_sane_readahead-calls-into-force_page_cache_readahead.patch
readahead-apply-max_sane_readahead-limit-in-ondemand_readahead.patch
readahead-remove-one-unnecessary-radix-tree-lookup.patch
readahead-increase-interleaved-readahead-size.patch
readahead-remove-sync-async-readahead-call-dependency.patch
readahead-clean-up-and-simplify-the-code-for-filemap-page-fault-readahead.patch
readahead-sequential-mmap-readahead.patch
readahead-enforce-full-readahead-size-on-async-mmap-readahead.patch
readahead-record-mmap-read-around-states-in-file_ra_state.patch
radix-tree-add-radix_tree_prev_hole.patch
readahead-move-the-random-read-case-to-bottom.patch
readahead-introduce-context-readahead-algorithm.patch
readahead-introduce-context-readahead-algorithm-update.patch
readahead-remove-redundant-test-in-shrink_readahead_size_eio.patch
readahead-enforce-full-sync-mmap-readahead-size.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages.patch
slob-use-pg_slab-for-identifying-slob-pages.patch
proc-kpagecount-kpageflags-code-cleanup.patch
proc-export-more-page-flags-in-proc-kpageflags.patch
pagemap-document-clarifications.patch
pagemap-document-9-more-exported-page-flags.patch
pagemap-add-page-types-tool.patch
pagemap-export-pg_hwpoison.patch
vmscan-cleanup-the-scan-batching-code.patch
vmscan-dont-export-nr_saved_scan-in-proc-zoneinfo.patch
vmscan-zvc-updates-in-shrink_active_list-can-be-done-once.patch
inotify-reimplement-inotify-using-fsnotify-report-rounded-up-event-size-to-user-space.patch

