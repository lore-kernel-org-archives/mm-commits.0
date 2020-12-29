Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F39A6C433DB
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 23:15:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCC3A20771
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 23:15:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgL2XPu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Dec 2020 18:15:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:37862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726276AbgL2XPu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 29 Dec 2020 18:15:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32D2A222F9;
        Tue, 29 Dec 2020 23:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609283693;
        bh=x0NZjp5VphPdynm83woAsFIiq7baeESf695ofWEr/AM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=aTnwF23hsM7Cw30k8jF8CXKU+saApLU+mG48xLsdBLZ8Fv36vKpJ5ioTBu6V7n9fm
         fKh8dIh/8f9nvnv16ZwLJVfDkHynGs0A5Iiq/tlNSKMG6WdKuTDP+GktHti3TII69F
         ipz60P/lowpVsLlHoeYko4iepGkThVu7XSROlDRs=
Date:   Tue, 29 Dec 2020 15:14:52 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sjhuang@iluvatar.ai,
        torvalds@linux-foundation.org
Subject:  [patch 11/16] sizes.h: add SZ_8G/SZ_16G/SZ_32G macros
Message-ID: <20201229231452.CgFl3pPUt%akpm@linux-foundation.org>
In-Reply-To: <20201229151349.3285926ec0d1f65a27ac8534@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Huang Shijie <sjhuang@iluvatar.ai>
Subject: sizes.h: add SZ_8G/SZ_16G/SZ_32G macros

Add these macros, since we can use them in drivers.

Link: https://lkml.kernel.org/r/20201229072819.11183-1-sjhuang@iluvatar.ai
Signed-off-by: Huang Shijie <sjhuang@iluvatar.ai>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sizes.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/sizes.h~sizesh-add-sz_8g-sz_16g-sz_32g-macros
+++ a/include/linux/sizes.h
@@ -44,6 +44,9 @@
 #define SZ_2G				0x80000000
 
 #define SZ_4G				_AC(0x100000000, ULL)
+#define SZ_8G				_AC(0x200000000, ULL)
+#define SZ_16G				_AC(0x400000000, ULL)
+#define SZ_32G				_AC(0x800000000, ULL)
 #define SZ_64T				_AC(0x400000000000, ULL)
 
 #endif /* __LINUX_SIZES_H__ */
_
