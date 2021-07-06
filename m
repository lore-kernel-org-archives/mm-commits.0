Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EB57C07E9C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E7B361C9A
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbhGFTXK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:23:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231698AbhGFTXJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:23:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85E5961C9D;
        Tue,  6 Jul 2021 19:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599230;
        bh=KKgxMox7y8PZLAKRExFM1zV8piezOFqy03muB+99ITs=;
        h=Date:From:To:Subject:From;
        b=1X+kMCtTj2O8Usou3xzhxlP5b0Ac2Fvox5V8ruvbbZC9NuELdCQtxkIVapA/rmaG3
         c021Nd2mTv8ypes6kMCXN1UYp/LufGnFqQC2ZX46d+Jhc04ptI2uI99OYj8rCMRvgX
         fo0PplDriaEvoQkN2XdhxuBJ79VuW8KAvp4rJcRI=
Date:   Tue, 06 Jul 2021 12:20:30 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, colin.king@canonical.com, ddstreet@ieee.org,
        linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        nathan@kernel.org, sjenning@redhat.com, tiantao6@hisilicon.com,
        vitaly.wool@konsulko.com
Subject:  [merged]
 mm-zswapc-remove-unused-function-zswap_debugfs_exit.patch removed from -mm
 tree
Message-ID: <20210706192030.goPo71ty-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap.c: remove unused function zswap_debugfs_exit()
has been removed from the -mm tree.  Its filename was
     mm-zswapc-remove-unused-function-zswap_debugfs_exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/zswap.c: remove unused function zswap_debugfs_exit()

Patch series "Cleanup and fixup for zswap".

This series contains cleanups to remove unused function and avoid
unnecessary copy-in at map time.  Also this fixes two bugs in the function
zswap_writeback_entry().  More details can be found in the respective
changelogs.


This patch (of 3):

zswap_debugfs_exit() is unused, remove it.

Link: https://lkml.kernel.org/r/20210522092242.3233191-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210522092242.3233191-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Tian Tao <tiantao6@hisilicon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/mm/zswap.c~mm-zswapc-remove-unused-function-zswap_debugfs_exit
+++ a/mm/zswap.c
@@ -1427,18 +1427,11 @@ static int __init zswap_debugfs_init(voi
 
 	return 0;
 }
-
-static void __exit zswap_debugfs_exit(void)
-{
-	debugfs_remove_recursive(zswap_debugfs_root);
-}
 #else
 static int __init zswap_debugfs_init(void)
 {
 	return 0;
 }
-
-static void __exit zswap_debugfs_exit(void) { }
 #endif
 
 /*********************************
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

