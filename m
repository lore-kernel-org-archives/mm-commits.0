Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67709C43462
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 05:06:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E071611C0
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 05:06:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbhDIFHD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Apr 2021 01:07:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:51256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233245AbhDIFGp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Apr 2021 01:06:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9117861186;
        Fri,  9 Apr 2021 05:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617944778;
        bh=A+jQ8DF0KUZU2Hkx1igY8TWgtT1Uso3/P+1scnBBhZ0=;
        h=Date:From:To:Subject:From;
        b=JWsj2bPBZL3C1ONoYFA/IJpP6DimmUKjPJedvc8CqP0q8fTYA3XJ3uF8NzCGLbMz3
         YU8hN4KWlRw2lcMmcvh4//+ejre+YVUBAZTIY9PclsTenLroeVQV03Ek8kNkTXYd6Y
         n1QlK1zloQ5pmX9FMaBZ2XzXyRXiCyB1VfTJ0dB8=
Date:   Thu, 08 Apr 2021 22:06:18 -0700
From:   akpm@linux-foundation.org
To:     mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, songmuchun@bytedance.com
Subject:  [to-be-updated]
 hugetlb-make-free_huge_page-irq-safe-fix.patch removed from -mm tree
Message-ID: <20210409050618.QerRBfkZH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: fix irq locking omissions
has been removed from the -mm tree.  Its filename was
     hugetlb-make-free_huge_page-irq-safe-fix.patch

This patch was dropped because an updated version will be merged

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

hugetlb-add-lockdep_assert_held-calls-for-hugetlb_lock.patch

