Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10F66C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 31 Dec 2020 18:24:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFA3E223E4
	for <mm-commits@archiver.kernel.org>; Thu, 31 Dec 2020 18:24:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgLaSYJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Dec 2020 13:24:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:34126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbgLaSYJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 31 Dec 2020 13:24:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C42B22483;
        Thu, 31 Dec 2020 18:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609438986;
        bh=IiX2L1ZM1XbxMwlAM5pETMH6hEHew5fNhZsYz08MppU=;
        h=Date:From:To:Subject:From;
        b=VXEx9kU8uJOVhBRbJE/++rd3yUdSpHLnKGYdzG2YU4SjCcvcL30cHf44FeWDkIkHf
         50OxNZrSzg66+IcA2YREm91HApi8tbunYqAPcxtvSjCilOcbffKly0SeJTeAsfBzRL
         bQzQx4/HTaeZ0kP6Uqx2MDB2ixs6ZdI5Bj5INxtE=
Date:   Thu, 31 Dec 2020 10:23:06 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sjhuang@iluvatar.ai
Subject:  [merged] sizesh-add-sz_8g-sz_16g-sz_32g-macros.patch
 removed from -mm tree
Message-ID: <20201231182306.VSfp5C_MJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sizes.h: add SZ_8G/SZ_16G/SZ_32G macros
has been removed from the -mm tree.  Its filename was
     sizesh-add-sz_8g-sz_16g-sz_32g-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


