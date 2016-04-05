From: akpm@linux-foundation.org
Subject: + mm-update_lru_size-warn-and-reset-bad-lru_size.patch added to
 -mm tree
Date: Tue, 05 Apr 2016 15:53:47 -0700
Message-ID: <570441fb.IbMtcnk17hzxQanP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56474 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbcDEWxv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 18:53:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, andreslc@google.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mgorman@techsingularity.net, quning@gmail.com, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: update_lru_size warn and reset bad lru_size
has been added to the -mm tree.  Its filename is
     mm-update_lru_size-warn-and-reset-bad-lru_size.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-update_lru_size-warn-and-reset-bad-lru_size.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-update_lru_size-warn-and-reset-bad-lru_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: update_lru_size warn and reset bad lru_size

Though debug kernels have a VM_BUG_ON to help protect from misaccounting
lru_size, non-debug kernels are liable to wrap it around: and then the
vast unsigned long size draws page reclaim into a loop of repeatedly doing
nothing on an empty list, without even a cond_resched().

That soft lockup looks confusingly like an over-busy reclaim scenario,
with lots of contention on the lru_lock in shrink_inactive_list(): yet has
a totally different origin.

Help differentiate with a custom warning in mem_cgroup_update_lru_size(),
even in non-debug kernels; and reset the size to avoid the lockup.  But
the particular bug which suggested this change was mine alone, and since
fixed.

Make it a WARN_ONCE: the first occurrence is the most informative, a
flurry may follow, yet even when rate-limited little more is learnt.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Ning Qu <quning@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |    2 +-
 mm/memcontrol.c           |   24 ++++++++++++++++++++----
 2 files changed, 21 insertions(+), 5 deletions(-)

diff -puN include/linux/mm_inline.h~mm-update_lru_size-warn-and-reset-bad-lru_size include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~mm-update_lru_size-warn-and-reset-bad-lru_size
+++ a/include/linux/mm_inline.h
@@ -35,8 +35,8 @@ static __always_inline void del_page_fro
 				struct lruvec *lruvec, enum lru_list lru)
 {
 	int nr_pages = hpage_nr_pages(page);
-	mem_cgroup_update_lru_size(lruvec, lru, -nr_pages);
 	list_del(&page->lru);
+	mem_cgroup_update_lru_size(lruvec, lru, -nr_pages);
 	__mod_zone_page_state(lruvec_zone(lruvec), NR_LRU_BASE + lru, -nr_pages);
 }
 
diff -puN mm/memcontrol.c~mm-update_lru_size-warn-and-reset-bad-lru_size mm/memcontrol.c
--- a/mm/memcontrol.c~mm-update_lru_size-warn-and-reset-bad-lru_size
+++ a/mm/memcontrol.c
@@ -1022,22 +1022,38 @@ out:
  * @lru: index of lru list the page is sitting on
  * @nr_pages: positive when adding or negative when removing
  *
- * This function must be called when a page is added to or removed from an
- * lru list.
+ * This function must be called under lru_lock, just before a page is added
+ * to or just after a page is removed from an lru list (that ordering being
+ * so as to allow it to check that lru_size 0 is consistent with list_empty).
  */
 void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
 				int nr_pages)
 {
 	struct mem_cgroup_per_zone *mz;
 	unsigned long *lru_size;
+	long size;
+	bool empty;
 
 	if (mem_cgroup_disabled())
 		return;
 
 	mz = container_of(lruvec, struct mem_cgroup_per_zone, lruvec);
 	lru_size = mz->lru_size + lru;
-	*lru_size += nr_pages;
-	VM_BUG_ON((long)(*lru_size) < 0);
+	empty = list_empty(lruvec->lists + lru);
+
+	if (nr_pages < 0)
+		*lru_size += nr_pages;
+
+	size = *lru_size;
+	if (WARN_ONCE(size < 0 || empty != !size,
+		"%s(%p, %d, %d): lru_size %ld but %sempty\n",
+		__func__, lruvec, lru, nr_pages, size, empty ? "" : "not ")) {
+		VM_BUG_ON(1);
+		*lru_size = 0;
+	}
+
+	if (nr_pages > 0)
+		*lru_size += nr_pages;
 }
 
 bool task_in_mem_cgroup(struct task_struct *task, struct mem_cgroup *memcg)
_

Patches currently in -mm which might be from hughd@google.com are

mm-update_lru_size-warn-and-reset-bad-lru_size.patch
mm-update_lru_size-do-the-__mod_zone_page_state.patch
mm-use-__setpageswapbacked-and-dont-clearpageswapbacked.patch
tmpfs-preliminary-minor-tidyups.patch
mm-proc-sys-vm-stat_refresh-to-force-vmstat-update.patch
huge-mm-move_huge_pmd-does-not-need-new_vma.patch
huge-pagecache-extend-mremap-pmd-rmap-lockout-to-files.patch
huge-pagecache-mmap_sem-is-unlocked-when-truncation-splits-pmd.patch
arch-fix-has_transparent_hugepage.patch

