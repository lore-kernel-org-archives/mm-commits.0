Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38AA0C07E96
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 04:27:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 278516136E
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 04:27:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236350AbhGOE3x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Jul 2021 00:29:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230076AbhGOE3w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Jul 2021 00:29:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E204C61360;
        Thu, 15 Jul 2021 04:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626323219;
        bh=ISLOowqcXFi7D/AecfCO5p2bdmuAJjYUwY8N6CDHt1c=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=tZsgM3blwJDRydnOBuqbwUx6MQqj9d3U690Ff9YPSKxtmMQVgrlWMF0oyxIkwuJkE
         wI9UB2M5kqjbayPMClFRX/1elgqMBbMdy2Q1xODKv6mVRRyvCVVhQ+ER/9r+/C87fH
         vxXKGiVJB2qlz5o+9D6t1JUCM+DUhC4iEpFmQMkk=
Date:   Wed, 14 Jul 2021 21:26:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apopple@nvidia.com, hulkci@huawei.com,
        jrdr.linux@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, oliver.sang@intel.com,
        torvalds@linux-foundation.org, yangyingliang@huawei.com
Subject:  [patch 09/13] lib/test_hmm: remove set but unused page
 variable
Message-ID: <20210715042658.PXuvewt1u%akpm@linux-foundation.org>
In-Reply-To: <20210714212609.fad116e584ba1194981a6294@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alistair Popple <apopple@nvidia.com>
Subject: lib/test_hmm: remove set but unused page variable

The HMM selftests use atomic_check_access() to check atomic access to a
page has been revoked.  It doesn't matter if the page mapping has been
removed from the mirrored page tables as that also implies atomic access
has been revoked.  Therefore remove the unused page variable to fix this
compiler warning:

  lib/test_hmm.c:631:16: warning: variable `page' set but not used [-Wunused-but-set-variable]

Link: https://lkml.kernel.org/r/20210706025603.4059-1-apopple@nvidia.com
Fixes: b659baea7546 ("mm: selftests for exclusive device memory")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Reported-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Souptick Joarder <jrdr.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |    2 --
 1 file changed, 2 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmm-remove-set-but-unused-page-variable
+++ a/lib/test_hmm.c
@@ -628,10 +628,8 @@ static int dmirror_check_atomic(struct d
 
 	for (pfn = start >> PAGE_SHIFT; pfn < (end >> PAGE_SHIFT); pfn++) {
 		void *entry;
-		struct page *page;
 
 		entry = xa_load(&dmirror->pt, pfn);
-		page = xa_untag_pointer(entry);
 		if (xa_pointer_tag(entry) == DPT_XA_TAG_ATOMIC)
 			return -EPERM;
 	}
_
