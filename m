Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC962C47437
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C2F322DD6
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbgLOX7z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:32898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729861AbgLOX0I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:26:08 -0500
Date:   Tue, 15 Dec 2020 15:17:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074245;
        bh=K+NKcL6ygbgyE5vdAZDniSyCWoSYj9SLjE4VezBlk8M=;
        h=From:To:Subject:From;
        b=Q5ttndOqQKpFi8MILA+HZl39dBbyiz5R8hTQqiW4v83n3h0MLnFursMs/Xd4ZJqUC
         Su+svfBV1ZGclsuKpzks5ON5qO1PsUGG8UhAgGeoizuIVnSAv3agGL8R4Oiip8/LpT
         XKsOgdf1StsMKIf+eGxNU9fczzC7qy/rIYCvovk8=
From:   akpm@linux-foundation.org
To:     jgg@nvidia.com, jhubbard@nvidia.com, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, song.bao.hua@hisilicon.com
Subject:  [merged]
 mm-gup_benchmark-mark-gup_benchmark_init-as-__init-function.patch removed
 from -mm tree
Message-ID: <20201215231725.tneYNbZjz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup_test.c: mark gup_test_init as __init function
has been removed from the -mm tree.  Its filename was
     mm-gup_benchmark-mark-gup_benchmark_init-as-__init-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from song.bao.hua@hisilicon.com are


