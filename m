Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B986C04A95
	for <mm-commits@archiver.kernel.org>; Sun, 25 Sep 2022 19:42:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbiIYTmX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 25 Sep 2022 15:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiIYTmW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 25 Sep 2022 15:42:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF802B193
        for <mm-commits@vger.kernel.org>; Sun, 25 Sep 2022 12:42:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 244DA60B8D
        for <mm-commits@vger.kernel.org>; Sun, 25 Sep 2022 19:42:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FF4C433C1;
        Sun, 25 Sep 2022 19:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664134940;
        bh=yuczU8Edpc00FZG4d6SAS9mj4/esfUivqeeEbHzJiuw=;
        h=Date:To:From:Subject:From;
        b=T3GDaeOOeQwZGVb8f/h+Ayjg/x45UaK8I7bPGLWr5eS79QM4YKZt+kONuQ+aNUhWm
         v3iKZMi9SeyDhxaaR7KhaT43FIH5EkzwCLW9kwlq5axZEBezbGHhVPQIO16cGOEYw4
         ZxNCVZaX4Rg+E2gp0HHBt+afe+srUem73lX25/SY=
Date:   Sun, 25 Sep 2022 12:42:19 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        osalvador@suse.de, mike.kravetz@oracle.com, david@redhat.com,
        xhao@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-add-available_huge_pages-func.patch added to mm-unstable branch
Message-Id: <20220925194220.55FF4C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: add available_huge_pages() func
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-add-available_huge_pages-func.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-add-available_huge_pages-func.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Xin Hao <xhao@linux.alibaba.com>
Subject: mm/hugetlb: add available_huge_pages() func
Date: Thu, 22 Sep 2022 10:19:29 +0800

In hugetlb.c there are several places which compare the values of
'h->free_huge_pages' and 'h->resv_huge_pages', it looks a bit messy, so
add a new available_huge_pages() function to do these.

Link: https://lkml.kernel.org/r/20220922021929.98961-1-xhao@linux.alibaba.com
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/hugetlb.c~mm-hugetlb-add-available_huge_pages-func
+++ a/mm/hugetlb.c
@@ -1191,6 +1191,11 @@ retry_cpuset:
 	return NULL;
 }
 
+static unsigned long available_huge_pages(struct hstate *h)
+{
+	return h->free_huge_pages - h->resv_huge_pages;
+}
+
 static struct page *dequeue_huge_page_vma(struct hstate *h,
 				struct vm_area_struct *vma,
 				unsigned long address, int avoid_reserve,
@@ -1207,12 +1212,11 @@ static struct page *dequeue_huge_page_vm
 	 * have no page reserves. This check ensures that reservations are
 	 * not "stolen". The child may still get SIGKILLed
 	 */
-	if (!vma_has_reserves(vma, chg) &&
-			h->free_huge_pages - h->resv_huge_pages == 0)
+	if (!vma_has_reserves(vma, chg) && !available_huge_pages(h))
 		goto err;
 
 	/* If reserves cannot be used, ensure enough pages are in the pool */
-	if (avoid_reserve && h->free_huge_pages - h->resv_huge_pages == 0)
+	if (avoid_reserve && !available_huge_pages(h))
 		goto err;
 
 	gfp_mask = htlb_alloc_mask(h);
@@ -2124,7 +2128,7 @@ retry:
 	if (!page_count(page)) {
 		struct page *head = compound_head(page);
 		struct hstate *h = page_hstate(head);
-		if (h->free_huge_pages - h->resv_huge_pages == 0)
+		if (!available_huge_pages(h))
 			goto out;
 
 		/*
@@ -2311,7 +2315,7 @@ struct page *alloc_huge_page_nodemask(st
 		nodemask_t *nmask, gfp_t gfp_mask)
 {
 	spin_lock_irq(&hugetlb_lock);
-	if (h->free_huge_pages - h->resv_huge_pages > 0) {
+	if (available_huge_pages(h)) {
 		struct page *page;
 
 		page = dequeue_huge_page_nodemask(h, gfp_mask, preferred_nid, nmask);
_

Patches currently in -mm which might be from xhao@linux.alibaba.com are

mm-damon-simply-damon_ctx-check-in-damon_sysfs_before_terminate.patch
mm-damon-remove-duplicate-get_monitoring_region-definitions.patch
mm-damon-sysfs-change-few-functions-execute-order.patch
mm-damon-simplify-scheme-create-in-damon_lru_sort_apply_parameters.patch
mm-damon-sysfs-avoid-call-damon_target_has_pid-repeatedly.patch
mm-damon-sysfs-avoid-call-damon_target_has_pid-repeatedly-fix.patch
mm-damon-simplify-scheme-create-in-lru_sortc.patch
mm-damon-sysfs-return-err-value-when-call-kstrtoul-failed.patch
mm-hugetlb-add-available_huge_pages-func.patch

