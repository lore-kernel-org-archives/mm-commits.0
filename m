Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5CB9C4361B
	for <mm-commits@archiver.kernel.org>; Thu, 10 Dec 2020 02:37:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC30123B77
	for <mm-commits@archiver.kernel.org>; Thu, 10 Dec 2020 02:37:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729071AbgLJChd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Dec 2020 21:37:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:41882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726620AbgLJChY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 9 Dec 2020 21:37:24 -0500
Date:   Wed, 09 Dec 2020 18:36:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607567804;
        bh=FjsK/L70ppz6o8yqUzeSp1u3auOqV3UOWbTxMsjKoak=;
        h=From:To:Subject:From;
        b=N42N+RG+lAPyoSar/sIkONmKe1v60gwdVERcZZDqDtpsVLMDBBRhFAUCfpA1mK9rN
         rIQcMtz5sWA2T7m6nWrKLADOXTVdI8GAYoPIDR6zTYBsHyCmDQ7zHbgT9irI9ABA4N
         kxFXD/iNq2gYJrwZweVW5g+N3GyDOXbZfFUKWQDU=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, anton@tuxera.com,
        zhengzengkai@huawei.com
Subject:  [alternative-merged]
 fs-ntfs-fix-set-but-not-used-variable-log_page_mask.patch removed from -mm
 tree
Message-ID: <20201210023642.xotj9%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ntfs: fix set but not used variable 'log_page_mask'
has been removed from the -mm tree.  Its filename was
     fs-ntfs-fix-set-but-not-used-variable-log_page_mask.patch

This patch was dropped because an alternative patch was merged

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


