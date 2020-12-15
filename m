Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28C08C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 02:14:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4262206E5
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 02:14:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbgLOCON (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 21:14:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:40434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725964AbgLOCOE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 21:14:04 -0500
Date:   Mon, 14 Dec 2020 18:13:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607998403;
        bh=DN/aoPVzgyTVT2ajnRjFuWm+ya44QALuYrMrv3OYx9g=;
        h=From:To:Subject:From;
        b=Z2LXBt9tS7SxjNlZ6rSsqVoTZ25oZy6XkXynHDBmHg2lcD1Gu9JPXae+tXkTrEvVs
         DLUlnLIm7AJZ5+LKXgZBHKX4STk3Ie5qPKRn5zreFtMHXgwF6LSEQRx1Ia33Mq0eTH
         xEPOVZA3CsdNG7DaskF5sdx29elfkXh5tIigi64I=
From:   akpm@linux-foundation.org
To:     jhubbard@nvidia.com, john.garry@huawei.com,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com,
        rdunlap@infradead.org, song.bao.hua@hisilicon.com
Subject:  [folded-merged]
 mm-gup_benchmark-gup_benchmark-depends-on-debug_fs-v2.patch removed from
 -mm tree
Message-ID: <20201215021322.vc3QZUmvF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-gup_benchmark-gup_benchmark-depends-on-debug_fs-v2
has been removed from the -mm tree.  Its filename was
     mm-gup_benchmark-gup_benchmark-depends-on-debug_fs-v2.patch

This patch was dropped because it was folded into mm-gup_benchmark-gup_benchmark-depends-on-debug_fs.patch

------------------------------------------------------
From: Barry Song <song.bao.hua@hisilicon.com>
Subject: mm-gup_benchmark-gup_benchmark-depends-on-debug_fs-v2

add comment as a prompt to users as commented by John and Randy

Link: https://lkml.kernel.org/r/20201108083732.15336-1-song.bao.hua@hisilicon.com
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
Suggested-by: John Garry <john.garry@huawei.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/Kconfig~mm-gup_benchmark-gup_benchmark-depends-on-debug_fs-v2
+++ a/mm/Kconfig
@@ -841,6 +841,9 @@ config GUP_TEST
 
 	  See tools/testing/selftests/vm/gup_test.c
 
+comment "GUP_TEST needs to have DEBUG_FS enabled"
+	depends on !GUP_TEST && !DEBUG_FS
+
 config GUP_GET_PTE_LOW_HIGH
 	bool
 
_

Patches currently in -mm which might be from song.bao.hua@hisilicon.com are

mm-gup_benchmark-mark-gup_benchmark_init-as-__init-function.patch
mm-gup_benchmark-gup_benchmark-depends-on-debug_fs.patch
mm-zswap-move-to-use-crypto_acomp-api-for-hardware-acceleration.patch

