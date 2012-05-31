From: akpm@linux-foundation.org
Subject: [merged] mm-memory_failure-let-the-compiler-add-the-function-name.patch removed from -mm tree
Date: Thu, 31 May 2012 12:13:36 -0700
Message-ID: <20120531191336.61ACBA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:64880 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321Ab2EaTNi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:13:38 -0400
Received: by bkty5 with SMTP id y5so75304bkt.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:13:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: borislav.petkov@amd.com, andi@firstfloor.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_failure: let the compiler add the function name
has been removed from the -mm tree.  Its filename was
     mm-memory_failure-let-the-compiler-add-the-function-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from borislav.petkov@amd.com are

origin.patch
linux-next.patch

