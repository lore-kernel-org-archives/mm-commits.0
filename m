From: akpm@linux-foundation.org
Subject: + mm-rmap-remove-redundant-variable-cend.patch added to -mm tree
Date: Wed, 11 Oct 2017 15:57:21 -0700
Message-ID: <59dea1d1.lr2ServwoLOVU0CY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40440 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750959AbdJKW5W (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Oct 2017 18:57:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap.c: remove redundant variable cend
has been added to the -mm tree.  Its filename is
     mm-rmap-remove-redundant-variable-cend.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-remove-redundant-variable-cend.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-remove-redundant-variable-cend.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: mm/rmap.c: remove redundant variable cend

Variable cend is set but never read, hence it is redundant and can be
removed.

Cleans up clang build warning: Value stored to 'cend' is never read

Link: http://lkml.kernel.org/r/20171011174942.1372-1-colin.king@canonical.com
Fixes: 369ea8242c0f ("mm/rmap: update to new mmu_notifier semantic v2")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/rmap.c~mm-rmap-remove-redundant-variable-cend mm/rmap.c
--- a/mm/rmap.c~mm-rmap-remove-redundant-variable-cend
+++ a/mm/rmap.c
@@ -899,7 +899,7 @@ static bool page_mkclean_one(struct page
 	mmu_notifier_invalidate_range_start(vma->vm_mm, start, end);
 
 	while (page_vma_mapped_walk(&pvmw)) {
-		unsigned long cstart, cend;
+		unsigned long cstart;
 		int ret = 0;
 
 		cstart = address = pvmw.address;
@@ -915,7 +915,6 @@ static bool page_mkclean_one(struct page
 			entry = pte_wrprotect(entry);
 			entry = pte_mkclean(entry);
 			set_pte_at(vma->vm_mm, address, pte, entry);
-			cend = cstart + PAGE_SIZE;
 			ret = 1;
 		} else {
 #ifdef CONFIG_TRANSPARENT_HUGE_PAGECACHE
@@ -931,7 +930,6 @@ static bool page_mkclean_one(struct page
 			entry = pmd_mkclean(entry);
 			set_pmd_at(vma->vm_mm, address, pmd, entry);
 			cstart &= PMD_MASK;
-			cend = cstart + PMD_SIZE;
 			ret = 1;
 #else
 			/* unexpected pmd-mapped page? */
_

Patches currently in -mm which might be from colin.king@canonical.com are

mm-rmap-remove-redundant-variable-cend.patch

