From: akpm@linux-foundation.org
Subject: + mm-make-ttus-return-boolean.patch added to -mm tree
Date: Wed, 15 Mar 2017 12:36:58 -0700
Message-ID: <58c997da.6a02UNFNFAvS00Tp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49900 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752964AbdCOThA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2017 15:37:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, n-horiguchi@ah.jp.nec.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make ttu's return boolean
has been added to the -mm tree.  Its filename is
     mm-make-ttus-return-boolean.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-make-ttus-return-boolean.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-make-ttus-return-boolean.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: make ttu's return boolean

try_to_unmap() returns SWAP_SUCCESS or SWAP_FAIL so it's suitable for
boolean return.  This patch changes it.

Link: http://lkml.kernel.org/r/1489555493-14659-8-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    4 ++--
 mm/huge_memory.c     |    6 +++---
 mm/memory-failure.c  |   26 ++++++++++++--------------
 mm/rmap.c            |    8 +++-----
 mm/vmscan.c          |    7 +------
 5 files changed, 21 insertions(+), 30 deletions(-)

diff -puN include/linux/rmap.h~mm-make-ttus-return-boolean include/linux/rmap.h
--- a/include/linux/rmap.h~mm-make-ttus-return-boolean
+++ a/include/linux/rmap.h
@@ -191,7 +191,7 @@ static inline void page_dup_rmap(struct
 int page_referenced(struct page *, int is_locked,
 			struct mem_cgroup *memcg, unsigned long *vm_flags);
 
-int try_to_unmap(struct page *, enum ttu_flags flags);
+bool try_to_unmap(struct page *, enum ttu_flags flags);
 
 /* Avoid racy checks */
 #define PVMW_SYNC		(1 << 0)
@@ -281,7 +281,7 @@ static inline int page_referenced(struct
 	return 0;
 }
 
-#define try_to_unmap(page, refs) SWAP_FAIL
+#define try_to_unmap(page, refs) false
 
 static inline int page_mkclean(struct page *page)
 {
diff -puN mm/huge_memory.c~mm-make-ttus-return-boolean mm/huge_memory.c
--- a/mm/huge_memory.c~mm-make-ttus-return-boolean
+++ a/mm/huge_memory.c
@@ -2144,15 +2144,15 @@ static void freeze_page(struct page *pag
 {
 	enum ttu_flags ttu_flags = TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS |
 		TTU_RMAP_LOCKED | TTU_SPLIT_HUGE_PMD;
-	int ret;
+	bool unmap_success;
 
 	VM_BUG_ON_PAGE(!PageHead(page), page);
 
 	if (PageAnon(page))
 		ttu_flags |= TTU_MIGRATION;
 
-	ret = try_to_unmap(page, ttu_flags);
-	VM_BUG_ON_PAGE(ret, page);
+	unmap_success = try_to_unmap(page, ttu_flags);
+	VM_BUG_ON_PAGE(!unmap_success, page);
 }
 
 static void unfreeze_page(struct page *page)
diff -puN mm/memory-failure.c~mm-make-ttus-return-boolean mm/memory-failure.c
--- a/mm/memory-failure.c~mm-make-ttus-return-boolean
+++ a/mm/memory-failure.c
@@ -322,7 +322,7 @@ static void add_to_kill(struct task_stru
  * wrong earlier.
  */
 static void kill_procs(struct list_head *to_kill, int forcekill, int trapno,
-			  int fail, struct page *page, unsigned long pfn,
+			  bool fail, struct page *page, unsigned long pfn,
 			  int flags)
 {
 	struct to_kill *tk, *next;
@@ -904,13 +904,13 @@ EXPORT_SYMBOL_GPL(get_hwpoison_page);
  * Do all that is necessary to remove user space mappings. Unmap
  * the pages and send SIGBUS to the processes if the data was dirty.
  */
-static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
+static bool hwpoison_user_mappings(struct page *p, unsigned long pfn,
 				  int trapno, int flags, struct page **hpagep)
 {
 	enum ttu_flags ttu = TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS;
 	struct address_space *mapping;
 	LIST_HEAD(tokill);
-	int ret;
+	bool unmap_success;
 	int kill = 1, forcekill;
 	struct page *hpage = *hpagep;
 
@@ -919,20 +919,20 @@ static int hwpoison_user_mappings(struct
 	 * other types of pages.
 	 */
 	if (PageReserved(p) || PageSlab(p))
-		return SWAP_SUCCESS;
+		return true;
 	if (!(PageLRU(hpage) || PageHuge(p)))
-		return SWAP_SUCCESS;
+		return true;
 
 	/*
 	 * This check implies we don't kill processes if their pages
 	 * are in the swap cache early. Those are always late kills.
 	 */
 	if (!page_mapped(hpage))
-		return SWAP_SUCCESS;
+		return true;
 
 	if (PageKsm(p)) {
 		pr_err("Memory failure: %#lx: can't handle KSM pages.\n", pfn);
-		return SWAP_FAIL;
+		return false;
 	}
 
 	if (PageSwapCache(p)) {
@@ -971,8 +971,8 @@ static int hwpoison_user_mappings(struct
 	if (kill)
 		collect_procs(hpage, &tokill, flags & MF_ACTION_REQUIRED);
 
-	ret = try_to_unmap(hpage, ttu);
-	if (ret != SWAP_SUCCESS)
+	unmap_success = try_to_unmap(hpage, ttu);
+	if (!unmap_success)
 		pr_err("Memory failure: %#lx: failed to unmap page (mapcount=%d)\n",
 		       pfn, page_mapcount(hpage));
 
@@ -987,10 +987,9 @@ static int hwpoison_user_mappings(struct
 	 * any accesses to the poisoned memory.
 	 */
 	forcekill = PageDirty(hpage) || (flags & MF_MUST_KILL);
-	kill_procs(&tokill, forcekill, trapno,
-		      ret != SWAP_SUCCESS, p, pfn, flags);
+	kill_procs(&tokill, forcekill, trapno, !unmap_success, p, pfn, flags);
 
-	return ret;
+	return unmap_success;
 }
 
 static void set_page_hwpoison_huge_page(struct page *hpage)
@@ -1230,8 +1229,7 @@ int memory_failure(unsigned long pfn, in
 	 * When the raw error page is thp tail page, hpage points to the raw
 	 * page after thp split.
 	 */
-	if (hwpoison_user_mappings(p, pfn, trapno, flags, &hpage)
-	    != SWAP_SUCCESS) {
+	if (!hwpoison_user_mappings(p, pfn, trapno, flags, &hpage)) {
 		action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
 		res = -EBUSY;
 		goto out;
diff -puN mm/rmap.c~mm-make-ttus-return-boolean mm/rmap.c
--- a/mm/rmap.c~mm-make-ttus-return-boolean
+++ a/mm/rmap.c
@@ -1501,12 +1501,10 @@ static int page_mapcount_is_zero(struct
  *
  * Tries to remove all the page table entries which are mapping this
  * page, used in the pageout path.  Caller must hold the page lock.
- * Return values are:
  *
- * SWAP_SUCCESS	- we succeeded in removing all mappings
- * SWAP_FAIL	- the page is unswappable
+ * If unmap is successful, return true. Otherwise, false.
  */
-int try_to_unmap(struct page *page, enum ttu_flags flags)
+bool try_to_unmap(struct page *page, enum ttu_flags flags)
 {
 	struct rmap_walk_control rwc = {
 		.rmap_one = try_to_unmap_one,
@@ -1531,7 +1529,7 @@ int try_to_unmap(struct page *page, enum
 	else
 		rmap_walk(page, &rwc);
 
-	return !page_mapcount(page) ? SWAP_SUCCESS : SWAP_FAIL;
+	return !page_mapcount(page) ? true : false;
 }
 
 static int page_not_mapped(struct page *page)
diff -puN mm/vmscan.c~mm-make-ttus-return-boolean mm/vmscan.c
--- a/mm/vmscan.c~mm-make-ttus-return-boolean
+++ a/mm/vmscan.c
@@ -970,7 +970,6 @@ static unsigned long shrink_page_list(st
 		int may_enter_fs;
 		enum page_references references = PAGEREF_RECLAIM_CLEAN;
 		bool dirty, writeback;
-		int ret = SWAP_SUCCESS;
 
 		cond_resched();
 
@@ -1143,13 +1142,9 @@ static unsigned long shrink_page_list(st
 		 * processes. Try to unmap it here.
 		 */
 		if (page_mapped(page)) {
-			switch (ret = try_to_unmap(page,
-				ttu_flags | TTU_BATCH_FLUSH)) {
-			case SWAP_FAIL:
+			if (!try_to_unmap(page, ttu_flags | TTU_BATCH_FLUSH)) {
 				nr_unmap_fail++;
 				goto activate_locked;
-			case SWAP_SUCCESS:
-				; /* try to free the page below */
 			}
 		}
 
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-reclaim-madv_free-pages-fix.patch
mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one.patch
mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one-fix.patch
mm-do-not-use-double-negation-for-testing-page-flags.patch
mm-remove-unncessary-ret-in-page_referenced.patch
mm-remove-swap_dirty-in-ttu.patch
mm-remove-swap_mlock-check-for-swap_success-in-ttu.patch
mm-make-the-try_to_munlock-void-function.patch
mm-remove-swap_mlock-in-ttu.patch
mm-remove-swap_again-in-ttu.patch
mm-make-ttus-return-boolean.patch
mm-make-rmap_walk-void-function.patch
mm-make-rmap_one-boolean-function.patch
mm-remove-swap_.patch

