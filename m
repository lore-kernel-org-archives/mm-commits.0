Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ACFDC2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:33:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15EF5223D6
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:33:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbgLODds (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:33:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:34234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727243AbgLODGT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:06:19 -0500
Date:   Mon, 14 Dec 2020 19:05:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001538;
        bh=uZam2wyar1G/yseLKpY3GiqkPM4+jXiI6Hz4JEKz+Xk=;
        h=From:To:Subject:In-Reply-To:From;
        b=gjTH8UKFBx7ah6BYGDsRrQpiBtyRECOeVesByuovqDgHfKyiyGdGigXDsLS0/Uctc
         Zf5iRnsRFZt04Yc8I3k43TCRNeI9Oq6jKPvCqIUS1jW0X3ECAxVjA8+TC/4VLuQp9X
         wu1JfnLdSeioISX6LnUXfb31t3tOCzNPHay7BWZI=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jhubbard@nvidia.com,
        john.garry@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com,
        rdunlap@infradead.org, song.bao.hua@hisilicon.com,
        torvalds@linux-foundation.org
Subject:  [patch 042/200] mm/gup_test: GUP_TEST depends on DEBUG_FS
Message-ID: <20201215030538.mwTxJ3H3J%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Barry Song <song.bao.hua@hisilicon.com>
Subject: mm/gup_test: GUP_TEST depends on DEBUG_FS

Without DEBUG_FS, all the code in gup_benchmark becomes meaningless.
For sure kernel provides debugfs stub while DEBUG_FS is disabled, but
the point here is that GUP_TEST can do nothing without DEBUG_FS.

[song.bao.hua@hisilicon.com: add comment as a prompt to users as commented by John and Randy]
  Link: https://lkml.kernel.org/r/20201108083732.15336-1-song.bao.hua@hisilicon.com
Link: https://lkml.kernel.org/r/20201104100552.20156-1-song.bao.hua@hisilicon.com
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
Suggested-by: John Garry <john.garry@huawei.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/Kconfig~mm-gup_benchmark-gup_benchmark-depends-on-debug_fs
+++ a/mm/Kconfig
@@ -823,6 +823,7 @@ config PERCPU_STATS
 
 config GUP_TEST
 	bool "Enable infrastructure for get_user_pages()-related unit tests"
+	depends on DEBUG_FS
 	help
 	  Provides /sys/kernel/debug/gup_test, which in turn provides a way
 	  to make ioctl calls that can launch kernel-based unit tests for
@@ -840,6 +841,9 @@ config GUP_TEST
 
 	  See tools/testing/selftests/vm/gup_test.c
 
+comment "GUP_TEST needs to have DEBUG_FS enabled"
+	depends on !GUP_TEST && !DEBUG_FS
+
 config GUP_GET_PTE_LOW_HIGH
 	bool
 
_
