Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E840C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Dec 2020 00:36:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA2FD23B4B
	for <mm-commits@archiver.kernel.org>; Wed,  9 Dec 2020 00:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731915AbgLIAf6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Dec 2020 19:35:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:53070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731846AbgLIAf6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 8 Dec 2020 19:35:58 -0500
Date:   Tue, 08 Dec 2020 16:35:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607474111;
        bh=nmqNM52KQ2mShMnFsnO6QZcPvUV7u0zxl3doJ9sRJTc=;
        h=From:To:Subject:From;
        b=KyVFUCUBaRXhurh5DDeJG4ASUvo08qNbqoUcgLm0yzSlfkg9ZQKrWY3PXIluVl7eR
         ZcpvQ2SGQVsctAi23VY6UOWxqJXwsBmLfCoUTInMlitXuPijRR68/20ug2cioXVdQh
         SrMBvqXd9DiqAkqmoTZ4e+pOb62JQLBLbpWQ4MRo=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, anton@tuxera.com,
        zhengzengkai@huawei.com
Subject:  + fs-ntfs-fix-set-but-not-used-variable-log_page_mask.patch
 added to -mm tree
Message-ID: <20201209003510.d4hjs%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ntfs: fix set but not used variable 'log_page_mask'
has been added to the -mm tree.  Its filename is
     fs-ntfs-fix-set-but-not-used-variable-log_page_mask.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-ntfs-fix-set-but-not-used-variable-log_page_mask.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-ntfs-fix-set-but-not-used-variable-log_page_mask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zheng Zengkai <zhengzengkai@huawei.com>
Subject: fs/ntfs: fix set but not used variable 'log_page_mask'

Fixes gcc '-Wunused-but-set-variable' warning:

fs/ntfs/logfile.c: In function ntfs_check_logfile:
fs/ntfs/logfile.c:481:21:
 warning: variable log_page_mask set but not used [-Wunused-but-set-variable]

Actually log_page_mask can be used to replace 'log_page_size - 1' as it is set.

Link: https://lkml.kernel.org/r/20200312041353.19877-1-zhengzengkai@huawei.com
Signed-off-by: Zheng Zengkai <zhengzengkai@huawei.com>
Acked-by: Anton Altaparmakov <anton@tuxera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/logfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ntfs/logfile.c~fs-ntfs-fix-set-but-not-used-variable-log_page_mask
+++ a/fs/ntfs/logfile.c
@@ -506,7 +506,7 @@ bool ntfs_check_logfile(struct inode *lo
 	 * optimize log_page_size and log_page_bits into constants.
 	 */
 	log_page_bits = ntfs_ffs(log_page_size) - 1;
-	size &= ~(s64)(log_page_size - 1);
+	size &= ~(s64)(log_page_mask);
 	/*
 	 * Ensure the log file is big enough to store at least the two restart
 	 * pages and the minimum number of log record pages.
_

Patches currently in -mm which might be from zhengzengkai@huawei.com are

fs-ntfs-fix-set-but-not-used-variable-log_page_mask.patch

