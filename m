Return-Path: <SRS0=oQto=CZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74B34C433E2
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 01:57:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 412082087D
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 01:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600221434;
	bh=mBcXocW0t/4ij9EQWW4DcJLFcGxLHllJl6aQSWN1+/4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=t+WvO/1mte88H3OM/TPSriYlWLR6m04WdVeV9GWg0RfOxrNzje0vKAeTz4c73ksct
	 4QmWi9wAMCsfSZjYm6W58aJlNXF6Om9SLnKpOXwaDBCAuaP1rCcTYoJk+aSf0CLbf6
	 B48OxlSA+pJk2A2Db7s/imWNTDh6LOO8afDOnwXA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgIPB5N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Sep 2020 21:57:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726061AbgIPB5N (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Sep 2020 21:57:13 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 096592087D;
        Wed, 16 Sep 2020 01:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600221431;
        bh=mBcXocW0t/4ij9EQWW4DcJLFcGxLHllJl6aQSWN1+/4=;
        h=Date:From:To:Subject:From;
        b=xJTgjzG2zH3E5+baqoxm3o8UKI5nkbDNCnwPigEK91ZmyHSeynjEaJLwhN4Iv0F06
         e61kVJJntuPhCXajXIMNYTBU9vrtBjpyOH69BJNCklLF65QgaVD6MmqX8C8MiY5HLH
         zWRG0Allj7Ip6bsvG/liOZ9UBaxfR7mLvP7uUGTg=
Date:   Tue, 15 Sep 2020 18:57:10 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, jglisse@redhat.com,
        rcampbell@nvidia.com
Subject:  + hmm-test-remove-unused-dmirror_zero_page.patch added to
 -mm tree
Message-ID: <20200916015710.dbzWy%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_hmm.c: remove unused dmirror_zero_page
has been added to the -mm tree.  Its filename is
     hmm-test-remove-unused-dmirror_zero_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hmm-test-remove-unused-dmirror_zero_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hmm-test-remove-unused-dmirror_zero_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-thp-fix-__split_huge_pmd_locked-for-migration-pmd.patch
mm-test-use-the-new-skip-macro.patch
hmm-test-remove-unused-dmirror_zero_page.patch
mm-migrate-remove-cpages-in-migrate_vma_finalize.patch
mm-migrate-remove-obsolete-comment-about-device-public.patch

