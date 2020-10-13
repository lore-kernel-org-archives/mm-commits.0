Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C80ECC433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:54:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 909AE208B3
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633276;
	bh=ewxwFNxgCRFgnd+4sEPTPAz5Y0g2RSyyo/qjj7rrSJ8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=C1oNW8R7uxGcph4bNXYGnV1xgIywsqWDdQszcZ0aNJUQ2Itbz+OjLjeCq7RwutYnE
	 FnTX3bSYZpfN4X3n/ZMpprSHea/bT0Cn4liOiJOUH7+M54dV2aO/5UoRrDuJ8XJUXV
	 ls0/JQaRPEFiBF4JoByBSQXODwOR4ewsrWJ4Yn5Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387743AbgJMXye (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:54:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387742AbgJMXye (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:54:34 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12637206D5;
        Tue, 13 Oct 2020 23:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633273;
        bh=ewxwFNxgCRFgnd+4sEPTPAz5Y0g2RSyyo/qjj7rrSJ8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=UFJon1fuLNy7WDulLkpsh4kLwMyujeFEWqM+EhS1aWA5BCxAg7hh/CIuE1Q+vIy0H
         8l7roEFUifmWYo6geypWyP7beqcbF2jyZBVsflhZNpqXb7LAzGBaz6OatShlLfJlqR
         tBaOMIs03LnUsFsOdt9jnfqRn1ae0UqrNTvz23eE=
Date:   Tue, 13 Oct 2020 16:54:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jglisse@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com,
        torvalds@linux-foundation.org
Subject:  [patch 112/181] lib/test_hmm.c: remove unused
 dmirror_zero_page
Message-ID: <20201013235432.3brXEAuYv%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
