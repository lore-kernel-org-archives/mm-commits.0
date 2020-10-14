Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D50C2BD10
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 248EE22248
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709316;
	bh=sbNP+7u/A5Ay5RvpKO7mW9MdUZhvBbqCjplEsNIK+SA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=vYgjWt5AwVbECQqFoW+a13Reaf+7wL8mCoVt+GL8TdyjGzVwssW278asdtXd5CXqG
	 YwLXXurNhruLLgM0mgkSh7Z+TflGxFM7NFfhwMLKz6MtT0sscGaGGB0W/YY9sBPGRg
	 bgS8+EL3Z+/TuuSvO6Tzl6U+euBviSiEOlRQfdL0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730490AbgJNVBo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:01:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:51374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730559AbgJNVBn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:01:43 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FE35221FF;
        Wed, 14 Oct 2020 21:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709303;
        bh=sbNP+7u/A5Ay5RvpKO7mW9MdUZhvBbqCjplEsNIK+SA=;
        h=Date:From:To:Subject:From;
        b=NYTcwqGWHXtiOAinjonjF/3Fi6VpSPiWhN03KNw3iW6329f00eBU+8lYX2cwy+PdP
         i8opoh7e5ae96xUsViLCkfQVoCJBO7i9ClvhhbcPRuyaP7weVWl+lrSvzsb3Cti4SV
         HSGed9DzfV1hwcj295mf69IN959cOlupz/cF8K5w=
Date:   Wed, 14 Oct 2020 14:01:43 -0700
From:   akpm@linux-foundation.org
To:     jglisse@redhat.com, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com
Subject:  [merged] hmm-test-remove-unused-dmirror_zero_page.patch
 removed from -mm tree
Message-ID: <20201014210143.tpCmrMNM6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_hmm.c: remove unused dmirror_zero_page
has been removed from the -mm tree.  Its filename was
     hmm-test-remove-unused-dmirror_zero_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ralph Campbell <rcampbell@nvidia.com>
Subject: lib/test_hmm.c: remove unused dmirror_zero_page

The variable dmirror_zero_page is unused in the HMM self test driver which
was probably intended to demonstrate how a driver could use
migrate_vma_setup() to share a single read-only device private zero page
similar to how the CPU does.  However, this isn't needed for the self
tests so remove it.

Link: https://lkml.kernel.org/r/20200914213801.16520-1-rcampbell@nvidia.com
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |   14 --------------
 1 file changed, 14 deletions(-)

--- a/lib/test_hmm.c~hmm-test-remove-unused-dmirror_zero_page
+++ a/lib/test_hmm.c
@@ -36,7 +36,6 @@
 static const struct dev_pagemap_ops dmirror_devmem_ops;
 static const struct mmu_interval_notifier_ops dmirror_min_ops;
 static dev_t dmirror_dev;
-static struct page *dmirror_zero_page;
 
 struct dmirror_device;
 
@@ -1127,17 +1126,6 @@ static int __init hmm_dmirror_init(void)
 			goto err_chrdev;
 	}
 
-	/*
-	 * Allocate a zero page to simulate a reserved page of device private
-	 * memory which is always zero. The zero_pfn page isn't used just to
-	 * make the code here simpler (i.e., we need a struct page for it).
-	 */
-	dmirror_zero_page = alloc_page(GFP_HIGHUSER | __GFP_ZERO);
-	if (!dmirror_zero_page) {
-		ret = -ENOMEM;
-		goto err_chrdev;
-	}
-
 	pr_info("HMM test module loaded. This is only for testing HMM.\n");
 	return 0;
 
@@ -1153,8 +1141,6 @@ static void __exit hmm_dmirror_exit(void
 {
 	int id;
 
-	if (dmirror_zero_page)
-		__free_page(dmirror_zero_page);
 	for (id = 0; id < DMIRROR_NDEVICES; id++)
 		dmirror_device_remove(dmirror_devices + id);
 	unregister_chrdev_region(dmirror_dev, DMIRROR_NDEVICES);
_

Patches currently in -mm which might be from rcampbell@nvidia.com are


