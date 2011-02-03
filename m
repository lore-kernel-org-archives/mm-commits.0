From: akpm@linux-foundation.org
Subject: [merged] thp-fix-splitting-of-hwpoisoned-hugepages.patch removed from -mm tree
Date: Thu, 03 Feb 2011 11:46:14 -0800
Message-ID: <201102031946.p13JkEwg020993@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756712Ab1BCTqe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2011 14:46:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jin.dongming@np.css.fujitsu.com, aarcange@redhat.com, andi@firstfloor.org, seto.hidetoshi@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     thp: fix splitting of hwpoisoned hugepages
has been removed from the -mm tree.  Its filename was
     thp-fix-splitting-of-hwpoisoned-hugepages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: fix splitting of hwpoisoned hugepages
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>

The poisoned THP is now split with split_huge_page() in
collect_procs_anon().  If kmalloc() is failed in collect_procs(),
split_huge_page() could not be called.  And the work after
split_huge_page() for collecting the processes using poisoned page will
not be done, too.  So the processes using the poisoned page could not be
killed.

The condition becomes worse when CONFIG_DEBUG_VM == "Y".  Because the
poisoned THP could not be split, system panic will be caused by
VM_BUG_ON(PageTransHuge(page)) in try_to_unmap().

This patch does:
  1. move split_huge_page() to the place before collect_procs().
     This can be sure the failure of splitting THP is caused by itself.
  2. when splitting THP is failed, stop the operations after it.
     This can avoid unexpected system panic or non sense works.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff -puN mm/memory-failure.c~thp-fix-splitting-of-hwpoisoned-hugepages mm/memory-failure.c
--- a/mm/memory-failure.c~thp-fix-splitting-of-hwpoisoned-hugepages
+++ a/mm/memory-failure.c
@@ -386,8 +386,6 @@ static void collect_procs_anon(struct pa
 	struct task_struct *tsk;
 	struct anon_vma *av;
 
-	if (!PageHuge(page) && unlikely(split_huge_page(page)))
-		return;
 	read_lock(&tasklist_lock);
 	av = page_lock_anon_vma(page);
 	if (av == NULL)	/* Not actually mapped anymore */
@@ -896,6 +894,34 @@ static int hwpoison_user_mappings(struct
 		}
 	}
 
+	if (PageTransHuge(hpage)) {
+		/*
+		 * Verify that this isn't a hugetlbfs head page, the check for
+		 * PageAnon is just for avoid tripping a split_huge_page
+		 * internal debug check, as split_huge_page refuses to deal with
+		 * anything that isn't an anon page. PageAnon can't go away fro
+		 * under us because we hold a refcount on the hpage, without a
+		 * refcount on the hpage. split_huge_page can't be safely called
+		 * in the first place, having a refcount on the tail isn't
+		 * enough * to be safe.
+		 */
+		if (!PageHuge(hpage) && PageAnon(hpage)) {
+			if (unlikely(split_huge_page(hpage))) {
+				/*
+				 * FIXME: if splitting THP is failed, it is
+				 * better to stop the following operation rather
+				 * than causing panic by unmapping. System might
+				 * survive if the page is freed later.
+				 */
+				printk(KERN_INFO
+					"MCE %#lx: failed to split THP\n", pfn);
+
+				BUG_ON(!PageHWPoison(p));
+				return SWAP_FAIL;
+			}
+		}
+	}
+
 	/*
 	 * First collect all the processes that have the page
 	 * mapped in dirty form.  This has to be done before try_to_unmap,
_

Patches currently in -mm which might be from jin.dongming@np.css.fujitsu.com are

origin.patch

