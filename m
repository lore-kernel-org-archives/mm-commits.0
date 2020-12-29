Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13372C433E0
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 19:06:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C66AC207CF
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 19:06:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgL2TGW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Dec 2020 14:06:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:46160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbgL2TGW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 29 Dec 2020 14:06:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC972207BD;
        Tue, 29 Dec 2020 19:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609268741;
        bh=OEJR4GenEI6KVxxjhT9JrWNfPqNAvhC0NvHSlorMR6M=;
        h=Date:From:To:Subject:From;
        b=ELsX6GfHTZSHZ5JQwB5zXVn9zT61NgKqq49S695cEQert3g7BFv/RTZgalHfINd7a
         c7PMwd27lcaZLLyWvT/z2lM36RbBaN9y+Af4ZQ0e8qnrStVcPAilc/Q06dx6mznPcW
         k4m5efa50NmjMZ5X0LiIRNKlyxtd/KxRNjSLkqYY=
Date:   Tue, 29 Dec 2020 11:05:41 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sjhuang@iluvatar.ai
Subject:  + sizesh-add-sz_8g-sz_16g-sz_32g-macros.patch added to -mm
 tree
Message-ID: <20201229190541.XkCmz%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sizes.h: add SZ_8G/SZ_16G/SZ_32G macros
has been added to the -mm tree.  Its filename is
     sizesh-add-sz_8g-sz_16g-sz_32g-macros.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/sizesh-add-sz_8g-sz_16g-sz_32g-macros.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/sizesh-add-sz_8g-sz_16g-sz_32g-macros.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from sjhuang@iluvatar.ai are

sizesh-add-sz_8g-sz_16g-sz_32g-macros.patch

