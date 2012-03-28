From: akpm@linux-foundation.org
Subject: + mm-memory_failure-let-the-compiler-add-the-function-name.patch added to -mm tree
Date: Wed, 28 Mar 2012 16:54:14 -0700
Message-ID: <20120328235414.A66C7A023F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:47877 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758851Ab2C1XyQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Mar 2012 19:54:16 -0400
Received: by qcsp5 with SMTP id p5so206082qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Mar 2012 16:54:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: borislav.petkov@amd.com, andi@firstfloor.org, rientjes@google.com


The patch titled
     Subject: mm/memory_failure: let the compiler add the function name
has been added to the -mm tree.  Its filename is
     mm-memory_failure-let-the-compiler-add-the-function-name.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Borislav Petkov <borislav.petkov@amd.com>
Subject: mm/memory_failure: let the compiler add the function name

These things tend to get out of sync with time so let the compiler
automatically enter the current function name using __func__.

No functional change.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Acked-by: Andi Kleen <andi@firstfloor.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/memory-failure.c~mm-memory_failure-let-the-compiler-add-the-function-name mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory_failure-let-the-compiler-add-the-function-name
+++ a/mm/memory-failure.c
@@ -1388,16 +1388,16 @@ static int get_any_page(struct page *p, 
 	 */
 	if (!get_page_unless_zero(compound_head(p))) {
 		if (PageHuge(p)) {
-			pr_info("get_any_page: %#lx free huge page\n", pfn);
+			pr_info("%s: %#lx free huge page\n", __func__, pfn);
 			ret = dequeue_hwpoisoned_huge_page(compound_head(p));
 		} else if (is_free_buddy_page(p)) {
-			pr_info("get_any_page: %#lx free buddy page\n", pfn);
+			pr_info("%s: %#lx free buddy page\n", __func__, pfn);
 			/* Set hwpoison bit while page is still isolated */
 			SetPageHWPoison(p);
 			ret = 0;
 		} else {
-			pr_info("get_any_page: %#lx: unknown zero refcount page type %lx\n",
-				pfn, p->flags);
+			pr_info("%s: %#lx: unknown zero refcount page type %lx\n",
+				__func__, pfn, p->flags);
 			ret = -EIO;
 		}
 	} else {
_
Subject: Subject: mm/memory_failure: let the compiler add the function name

Patches currently in -mm which might be from borislav.petkov@amd.com are

origin.patch
linux-next.patch
mm-memory_failure-let-the-compiler-add-the-function-name.patch

