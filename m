Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0359EC43460
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 03:59:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA32D6115C
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 03:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbhDID7k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 8 Apr 2021 23:59:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233210AbhDID7j (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 8 Apr 2021 23:59:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B2E861178;
        Fri,  9 Apr 2021 03:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617940766;
        bh=P3RsU/+hAFEaHlulo+5gc67wOoHgIZ5yHsvYSBc8Gxg=;
        h=Date:From:To:Subject:From;
        b=KLx7DwvNZIeh8vwIwoc76Nep39oUtPUqtNCQYdhIbfyJtLlBT5ncjFvI/szk4OfC0
         NbMyNA2xo4D5P67dMESbSAdEKR5RJTb7ihzViRl/zMOKjcGO0cmJlHQbk7ucQ0g3e2
         FXANN2ho5QVgGWWS1kQIllSpoOBY3OitCg44O/x4=
Date:   Thu, 08 Apr 2021 20:59:25 -0700
From:   akpm@linux-foundation.org
To:     lujialin4@huawei.com, mm-commits@vger.kernel.org
Subject:  + mm-fix-typos-in-comments-2.patch added to -mm tree
Message-ID: <20210409035925.Cko8Ho1uy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix typos in comments
has been added to the -mm tree.  Its filename is
     mm-fix-typos-in-comments-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-typos-in-comments-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-typos-in-comments-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lu Jialin <lujialin4@huawei.com>
Subject: mm: fix typos in comments

succed -> succeed in mm/hugetlb.c
wil -> will in mm/mempolicy.c
wit -> with in mm/page_alloc.c
Retruns -> Returns in mm/page_vma_mapped.c
confict -> conflict in mm/secretmem.c
No functionality changed.

Link: https://lkml.kernel.org/r/20210408140027.60623-1-lujialin4@huawei.com
Signed-off-by: Lu Jialin <lujialin4@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c         |    2 +-
 mm/mempolicy.c       |    2 +-
 mm/page_alloc.c      |    2 +-
 mm/page_vma_mapped.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-fix-typos-in-comments-2
+++ a/mm/hugetlb.c
@@ -2310,7 +2310,7 @@ retry:
 	} else if (!HPageFreed(old_page)) {
 		/*
 		 * Page's refcount is 0 but it has not been enqueued in the
-		 * freelist yet. Race window is small, so we can succed here if
+		 * freelist yet. Race window is small, so we can succeed here if
 		 * we retry.
 		 */
 		spin_unlock_irq(&hugetlb_lock);
--- a/mm/mempolicy.c~mm-fix-typos-in-comments-2
+++ a/mm/mempolicy.c
@@ -994,7 +994,7 @@ static long do_get_mempolicy(int *policy
 		if (flags & MPOL_F_ADDR) {
 			/*
 			 * Take a refcount on the mpol, lookup_node()
-			 * wil drop the mmap_lock, so after calling
+			 * will drop the mmap_lock, so after calling
 			 * lookup_node() only "pol" remains valid, "vma"
 			 * is stale.
 			 */
--- a/mm/page_alloc.c~mm-fix-typos-in-comments-2
+++ a/mm/page_alloc.c
@@ -4173,7 +4173,7 @@ out:
 }
 
 /*
- * Maximum number of compaction retries wit a progress before OOM
+ * Maximum number of compaction retries with a progress before OOM
  * killer is consider as the only way to move forward.
  */
 #define MAX_COMPACT_RETRIES 16
--- a/mm/page_vma_mapped.c~mm-fix-typos-in-comments-2
+++ a/mm/page_vma_mapped.c
@@ -134,7 +134,7 @@ static bool check_pte(struct page_vma_ma
  * regardless of which page table level the page is mapped at. @pvmw->pmd is
  * NULL.
  *
- * Retruns false if there are no more page table entries for the page in
+ * Returns false if there are no more page table entries for the page in
  * the vma. @pvmw->ptl is unlocked and @pvmw->pte is unmapped.
  *
  * If you need to stop the walk before page_vma_mapped_walk() returned false,
_

Patches currently in -mm which might be from lujialin4@huawei.com are

mm-fix-typos-in-comments-2.patch

