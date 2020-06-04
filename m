From: akpm@linux-foundation.org
Subject: [merged]
 mm-mempolicy-fix-up-gup-usage-in-lookup_node.patch removed from -mm tree
Date: Thu, 04 Jun 2020 10:21:17 -0700
Message-ID: <20200604172117.lKz-oO6Nj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730050AbgFDRVT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:21:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, mm-commits@vger.kernel.org, peterx@redhat.com


The patch titled
     Subject: mm, mempolicy: fix up gup usage in lookup_node
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-fix-up-gup-usage-in-lookup_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, mempolicy: fix up gup usage in lookup_node

ba841078cd05 ("mm/mempolicy: Allow lookup_node() to handle fatal signal")
has added a special casing for 0 return value because that was a possible
gup return value when interrupted by fatal signal.  This has been fixed by
ae46d2aa6a7f ("mm/gup: Let __get_user_pages_locked() return -EINTR for
fatal signal") in the mean time so ba841078cd05 can be reverted.

This patch however doesn't go all the way to revert it because the check
for 0 is wrong and confusing here.  Firstly it is inherently unsafe to
access the page when get_user_pages_locked returns 0 (aka no page
returned).

Fortunatelly this will not happen because get_user_pages_locked will not
return 0 when nr_pages > 0 unless FOLL_NOWAIT is specified which is not
the case here.  Document this potential error code in gup code while we
are at it.

Link: http://lkml.kernel.org/r/20200421071026.18394-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c       |    5 +++++
 mm/mempolicy.c |    5 +----
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/mm/gup.c~mm-mempolicy-fix-up-gup-usage-in-lookup_node
+++ a/mm/gup.c
@@ -989,6 +989,7 @@ static int check_vma_flags(struct vm_are
  * -- If nr_pages is >0, but no pages were pinned, returns -errno.
  * -- If nr_pages is >0, and some pages were pinned, returns the number of
  *    pages pinned. Again, this may be less than nr_pages.
+ * -- 0 return value is possible when the fault would need to be retried.
  *
  * The caller is responsible for releasing returned @pages, via put_page().
  *
@@ -1265,6 +1266,10 @@ retry:
 }
 EXPORT_SYMBOL_GPL(fixup_user_fault);
 
+/*
+ * Please note that this function, unlike __get_user_pages will not
+ * return 0 for nr_pages > 0 without FOLL_NOWAIT
+ */
 static __always_inline long __get_user_pages_locked(struct task_struct *tsk,
 						struct mm_struct *mm,
 						unsigned long start,
--- a/mm/mempolicy.c~mm-mempolicy-fix-up-gup-usage-in-lookup_node
+++ a/mm/mempolicy.c
@@ -927,10 +927,7 @@ static int lookup_node(struct mm_struct
 
 	int locked = 1;
 	err = get_user_pages_locked(addr & PAGE_MASK, 1, 0, &p, &locked);
-	if (err == 0) {
-		/* E.g. GUP interrupted by fatal signal */
-		err = -EFAULT;
-	} else if (err > 0) {
+	if (err > 0) {
 		err = page_to_nid(p);
 		put_page(p);
 	}
_

Patches currently in -mm which might be from mhocko@suse.com are
