Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA454C2BBCA
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 854F5224D2
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgLODd4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:33:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:60822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727053AbgLODFu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:05:50 -0500
Date:   Mon, 14 Dec 2020 19:05:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001535;
        bh=ew5/WZfddGNz/xb3DPpe2lqcJbwAorUFFf/aWH2oaYc=;
        h=From:To:Subject:In-Reply-To:From;
        b=UFScvJLyDFLk6VQuqmvjoxiEEfswS9gV8orA6eT3yNnA4uKSFxrUAI1dkIgK1EyLg
         e6CtmXfb5hpieQTe28cQsIUncSK2LXq4ChlQRNAde6/vPX1eI9+bSmD54lSMxwZ4F0
         U5yQdiBPo1WeCmzYbkondokHrvZpcmgW9NkG9jmo=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jgg@nvidia.com, jhubbard@nvidia.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, song.bao.hua@hisilicon.com,
        torvalds@linux-foundation.org
Subject:  [patch 041/200] mm/gup_test.c: mark gup_test_init as
 __init function
Message-ID: <20201215030534.zZYVs46Yf%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Barry Song <song.bao.hua@hisilicon.com>
Subject: mm/gup_test.c: mark gup_test_init as __init function

gup_test_init() is only called during initialization, mark it as __init to
save some memory.

Link: https://lkml.kernel.org/r/20201103081016.16532-1-song.bao.hua@hisilicon.com
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup_test.c~mm-gup_benchmark-mark-gup_benchmark_init-as-__init-function
+++ a/mm/gup_test.c
@@ -236,7 +236,7 @@ static const struct file_operations gup_
 	.unlocked_ioctl = gup_test_ioctl,
 };
 
-static int gup_test_init(void)
+static int __init gup_test_init(void)
 {
 	debugfs_create_file_unsafe("gup_test", 0600, NULL, NULL,
 				   &gup_test_fops);
_
