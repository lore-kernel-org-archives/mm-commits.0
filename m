From: akpm@linux-foundation.org
Subject: [folded-merged] mm-support-madvisemadv_free-fix-2.patch removed
 from -mm tree
Date: Fri, 15 Jan 2016 16:25:56 -0800
Message-ID: <56998e14.qLdpNsXfEz0pCnP3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37302 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030180AbcAPAZ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 19:25:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, danielmicay@gmail.com, hannes@cmpxchg.org, hughd@google.com, je@fb.com, kirill@shutemov.name, mhocko@suse.cz, riel@redhat.com, shli@kernel.org, yalin.wang2010@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: account pglazyfreed exactly
has been removed from the -mm tree.  Its filename was
     mm-support-madvisemadv_free-fix-2.patch

This patch was dropped because it was folded into mm-support-madvisemadv_free.patch

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: account pglazyfreed exactly

If anon pages are zapped by unmapping between page_mapped check and
try_to_unmap in shrink_page_list, they could be !PG_dirty although thre
are not MADV_FREEed pages so that VM accoutns it as pglazyfreed wrongly.

To fix, this patch counts the number of lazyfree ptes in try_to_unmap_one
and try_to_unmap returns SWAP_LZFREE only if the count is not zero, page
is !PG_dirty and SWAP_SUCCESS.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Jason Evans <je@fb.com>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Shaohua Li <shli@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: <yalin.wang2010@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    1 +
 mm/rmap.c            |   29 +++++++++++++++++++++++++----
 mm/vmscan.c          |    8 ++++++--
 3 files changed, 32 insertions(+), 6 deletions(-)

diff -puN include/linux/rmap.h~mm-support-madvisemadv_free-fix-2 include/linux/rmap.h
--- a/include/linux/rmap.h~mm-support-madvisemadv_free-fix-2
+++ a/include/linux/rmap.h
@@ -312,5 +312,6 @@ static inline int page_mkclean(struct pa
 #define SWAP_AGAIN	1
 #define SWAP_FAIL	2
 #define SWAP_MLOCK	3
+#define SWAP_LZFREE	4
 
 #endif	/* _LINUX_RMAP_H */
diff -puN mm/rmap.c~mm-support-madvisemadv_free-fix-2 mm/rmap.c
--- a/mm/rmap.c~mm-support-madvisemadv_free-fix-2
+++ a/mm/rmap.c
@@ -1411,6 +1411,11 @@ void page_remove_rmap(struct page *page,
 	 */
 }
 
+struct rmap_private {
+	enum ttu_flags flags;
+	int lazyfreed;
+};
+
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
@@ -1422,7 +1427,8 @@ static int try_to_unmap_one(struct page
 	pte_t pteval;
 	spinlock_t *ptl;
 	int ret = SWAP_AGAIN;
-	enum ttu_flags flags = (enum ttu_flags)arg;
+	struct rmap_private *rp = arg;
+	enum ttu_flags flags = rp->flags;
 
 	/* munlock has nothing to gain from examining un-locked vmas */
 	if ((flags & TTU_MUNLOCK) && !(vma->vm_flags & VM_LOCKED))
@@ -1518,6 +1524,7 @@ static int try_to_unmap_one(struct page
 		if (!PageDirty(page) && (flags & TTU_LZFREE)) {
 			/* It's a freeable page by MADV_FREE */
 			dec_mm_counter(mm, MM_ANONPAGES);
+			rp->lazyfreed++;
 			goto discard;
 		}
 
@@ -1594,9 +1601,14 @@ static int page_not_mapped(struct page *
 int try_to_unmap(struct page *page, enum ttu_flags flags)
 {
 	int ret;
+	struct rmap_private rp = {
+		.flags = flags,
+		.lazyfreed = 0,
+	};
+
 	struct rmap_walk_control rwc = {
 		.rmap_one = try_to_unmap_one,
-		.arg = (void *)flags,
+		.arg = (void *)&rp,
 		.done = page_not_mapped,
 		.anon_lock = page_lock_anon_vma_read,
 	};
@@ -1616,8 +1628,11 @@ int try_to_unmap(struct page *page, enum
 
 	ret = rmap_walk(page, &rwc);
 
-	if (ret != SWAP_MLOCK && !page_mapped(page))
+	if (ret != SWAP_MLOCK && !page_mapped(page)) {
 		ret = SWAP_SUCCESS;
+		if (rp.lazyfreed && !PageDirty(page))
+			ret = SWAP_LZFREE;
+	}
 	return ret;
 }
 
@@ -1639,9 +1654,15 @@ int try_to_unmap(struct page *page, enum
 int try_to_munlock(struct page *page)
 {
 	int ret;
+
+	struct rmap_private rp = {
+		.flags = TTU_MUNLOCK,
+		.lazyfreed = 0,
+	};
+
 	struct rmap_walk_control rwc = {
 		.rmap_one = try_to_unmap_one,
-		.arg = (void *)TTU_MUNLOCK,
+		.arg = (void *)&rp,
 		.done = page_not_mapped,
 		.anon_lock = page_lock_anon_vma_read,
 
diff -puN mm/vmscan.c~mm-support-madvisemadv_free-fix-2 mm/vmscan.c
--- a/mm/vmscan.c~mm-support-madvisemadv_free-fix-2
+++ a/mm/vmscan.c
@@ -907,6 +907,7 @@ static unsigned long shrink_page_list(st
 		enum page_references references = PAGEREF_RECLAIM_CLEAN;
 		bool dirty, writeback;
 		bool lazyfree = false;
+		int ret = SWAP_SUCCESS;
 
 		cond_resched();
 
@@ -1062,7 +1063,7 @@ static unsigned long shrink_page_list(st
 		 * processes. Try to unmap it here.
 		 */
 		if (page_mapped(page) && mapping) {
-			switch (try_to_unmap(page, lazyfree ?
+			switch (ret = try_to_unmap(page, lazyfree ?
 				(ttu_flags | TTU_BATCH_FLUSH | TTU_LZFREE) :
 				(ttu_flags | TTU_BATCH_FLUSH))) {
 			case SWAP_FAIL:
@@ -1071,6 +1072,8 @@ static unsigned long shrink_page_list(st
 				goto keep_locked;
 			case SWAP_MLOCK:
 				goto cull_mlocked;
+			case SWAP_LZFREE:
+				goto lazyfree;
 			case SWAP_SUCCESS:
 				; /* try to free the page below */
 			}
@@ -1177,6 +1180,7 @@ static unsigned long shrink_page_list(st
 			}
 		}
 
+lazyfree:
 		if (!mapping || !__remove_mapping(mapping, page, true))
 			goto keep_locked;
 
@@ -1189,7 +1193,7 @@ static unsigned long shrink_page_list(st
 		 */
 		__ClearPageLocked(page);
 free_it:
-		if (lazyfree && !PageDirty(page))
+		if (ret == SWAP_LZFREE)
 			count_vm_event(PGLAZYFREED);
 
 		nr_reclaimed++;
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-support-madvisemadv_free.patch
mm-define-madv_free-for-some-arches.patch
mm-free-swp_entry-in-madvise_free.patch
mm-move-lazily-freed-pages-to-inactive-list.patch
mm-mark-stable-page-dirty-in-ksm.patch
x86-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_mkclean-for-thp.patch
mm-dont-split-thp-page-when-syscall-is-called.patch

