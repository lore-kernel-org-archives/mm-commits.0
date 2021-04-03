Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B048AC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  3 Apr 2021 00:26:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6ABC061152
	for <mm-commits@archiver.kernel.org>; Sat,  3 Apr 2021 00:26:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235598AbhDCA0K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Apr 2021 20:26:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234161AbhDCA0J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 2 Apr 2021 20:26:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3A0B61185;
        Sat,  3 Apr 2021 00:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617409566;
        bh=B6tiQv+ZKzh9XTkhwNNPuqru7PLMfbRacbUEgGjpE7U=;
        h=Date:From:To:Subject:From;
        b=j2S7tDdSCv5NumHvGQjxZWGpjmLOtSTqD/WeKqnPKVmnv7xeFwYQ956ojTyBu2LOQ
         RDgUFNnmQXONr5UlShNaeN/tn8vSsdMvzOfYb0J13mpbbtq6Decp3+HEOy1EEqqYQq
         8Rb7jwpTUX3y9uHrucp5HUslQZ6xy3Yi+0RBY/kU=
Date:   Fri, 02 Apr 2021 17:26:06 -0700
From:   akpm@linux-foundation.org
To:     mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, songmuchun@bytedance.com
Subject:  + hugetlb-make-free_huge_page-irq-safe-fix.patch added to
 -mm tree
Message-ID: <20210403002606.CfssP36fd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: fix irq locking omissions
has been added to the -mm tree.  Its filename is
     hugetlb-make-free_huge_page-irq-safe-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-make-free_huge_page-irq-safe-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-make-free_huge_page-irq-safe-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: fix irq locking omissions

The pach "hugetlb: make free_huge_page irq safe" changed spin_*lock
calls to spin_*lock_irq* calls.  However, it missed several places
in the file hugetlb.c.  Add the overlooked changes.

Link: https://lkml.kernel.org/r/b0b081e2-9d78-77ab-684f-a0989a7f1d27@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/hugetlb.c~hugetlb-make-free_huge_page-irq-safe-fix
+++ a/mm/hugetlb.c
@@ -2278,7 +2278,7 @@ static int alloc_and_dissolve_huge_page(
 	 */
 	page_ref_dec(new_page);
 retry:
-	spin_lock(&hugetlb_lock);
+	spin_lock_irq(&hugetlb_lock);
 	if (!PageHuge(old_page)) {
 		/*
 		 * Freed from under us. Drop new_page too.
@@ -2291,7 +2291,7 @@ retry:
 		 * Fail with -EBUSY if not possible.
 		 */
 		update_and_free_page(h, new_page);
-		spin_unlock(&hugetlb_lock);
+		spin_unlock_irq(&hugetlb_lock);
 		if (!isolate_huge_page(old_page, list))
 			ret = -EBUSY;
 		return ret;
@@ -2301,7 +2301,7 @@ retry:
 		 * freelist yet. Race window is small, so we can succed here if
 		 * we retry.
 		 */
-		spin_unlock(&hugetlb_lock);
+		spin_unlock_irq(&hugetlb_lock);
 		cond_resched();
 		goto retry;
 	} else {
@@ -2317,7 +2317,7 @@ retry:
 		__enqueue_huge_page(&h->hugepage_freelists[nid], new_page);
 	}
 unlock:
-	spin_unlock(&hugetlb_lock);
+	spin_unlock_irq(&hugetlb_lock);
 
 	return ret;
 }
@@ -2333,15 +2333,15 @@ int isolate_or_dissolve_huge_page(struct
 	 * to carefully check the state under the lock.
 	 * Return success when racing as if we dissolved the page ourselves.
 	 */
-	spin_lock(&hugetlb_lock);
+	spin_lock_irq(&hugetlb_lock);
 	if (PageHuge(page)) {
 		head = compound_head(page);
 		h = page_hstate(head);
 	} else {
-		spin_unlock(&hugetlb_lock);
+		spin_unlock_irq(&hugetlb_lock);
 		return 0;
 	}
-	spin_unlock(&hugetlb_lock);
+	spin_unlock_irq(&hugetlb_lock);
 
 	/*
 	 * Fence off gigantic pages as there is a cyclic dependency between
@@ -2729,7 +2729,7 @@ static int set_max_huge_pages(struct hst
 	 * pages in hstate via the proc/sysfs interfaces.
 	 */
 	mutex_lock(&h->resize_lock);
-	spin_lock(&hugetlb_lock);
+	spin_lock_irq(&hugetlb_lock);
 
 	/*
 	 * Check for a node specific request.
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

mm-cma-change-cma-mutex-to-irq-safe-spinlock.patch
hugetlb-no-need-to-drop-hugetlb_lock-to-call-cma_release.patch
hugetlb-add-per-hstate-mutex-to-synchronize-user-adjustments.patch
hugetlb-create-remove_hugetlb_page-to-separate-functionality.patch
hugetlb-call-update_and_free_page-without-hugetlb_lock.patch
hugetlb-change-free_pool_huge_page-to-remove_pool_huge_page.patch
hugetlb-make-free_huge_page-irq-safe.patch
hugetlb-make-free_huge_page-irq-safe-fix.patch
hugetlb-add-lockdep_assert_held-calls-for-hugetlb_lock.patch

