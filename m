From: akpm@linux-foundation.org
Subject: [patch 135/142] mm: drop zap_details::ignore_dirty
Date: Wed, 22 Feb 2017 15:46:31 -0800
Message-ID: <58ae22d7.IkoqpR3zxIbFP/w8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49750 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933793AbdBVXqc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:46:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, peterz@infradead.org, riel@redhat.com

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: drop zap_details::ignore_dirty

The only user of ignore_dirty is oom-reaper.  But it doesn't really use
it.

ignore_dirty only has effect on file pages mapped with dirty pte.  But
oom-repear skips shared VMAs, so there's no way we can dirty file pte in
them.

Link: http://lkml.kernel.org/r/20170118122429.43661-1-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 -
 mm/memory.c        |    6 ------
 mm/oom_kill.c      |    3 +--
 3 files changed, 1 insertion(+), 9 deletions(-)

diff -puN include/linux/mm.h~mm-drop-zap_details-ignore_dirty include/linux/mm.h
--- a/include/linux/mm.h~mm-drop-zap_details-ignore_dirty
+++ a/include/linux/mm.h
@@ -1175,7 +1175,6 @@ struct zap_details {
 	struct address_space *check_mapping;	/* Check page->mapping if set */
 	pgoff_t	first_index;			/* Lowest page->index to unmap */
 	pgoff_t last_index;			/* Highest page->index to unmap */
-	bool ignore_dirty;			/* Ignore dirty pages */
 	bool check_swap_entries;		/* Check also swap entries */
 };
 
diff -puN mm/memory.c~mm-drop-zap_details-ignore_dirty mm/memory.c
--- a/mm/memory.c~mm-drop-zap_details-ignore_dirty
+++ a/mm/memory.c
@@ -1155,12 +1155,6 @@ again:
 
 			if (!PageAnon(page)) {
 				if (pte_dirty(ptent)) {
-					/*
-					 * oom_reaper cannot tear down dirty
-					 * pages
-					 */
-					if (unlikely(details && details->ignore_dirty))
-						continue;
 					force_flush = 1;
 					set_page_dirty(page);
 				}
diff -puN mm/oom_kill.c~mm-drop-zap_details-ignore_dirty mm/oom_kill.c
--- a/mm/oom_kill.c~mm-drop-zap_details-ignore_dirty
+++ a/mm/oom_kill.c
@@ -465,8 +465,7 @@ static bool __oom_reap_task_mm(struct ta
 {
 	struct mmu_gather tlb;
 	struct vm_area_struct *vma;
-	struct zap_details details = {.check_swap_entries = true,
-				      .ignore_dirty = true};
+	struct zap_details details = {.check_swap_entries = true};
 	bool ret = true;
 
 	/*
_
