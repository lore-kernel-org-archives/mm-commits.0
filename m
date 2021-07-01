Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16BE3C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:52:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 017F26147D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:52:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238496AbhGABzU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:55:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238416AbhGABzT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:55:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B182561477;
        Thu,  1 Jul 2021 01:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104370;
        bh=CuZGpym98MNTmM4CbOTAGVfaql3a/d9kPHOZYP3C3o0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OP6tSmkg3KzDXFLeBuYqCOAlb5j7JrFBPc/y/swjsr+eBb+iOPT3EfW/iIK4GCqpP
         H0ni+D/jqwHfVr0Ma9bhHJYtIT2m8jnERP3L5o5IZ42nG2GCeq6wFw/loTAxKx8+dm
         yYsQH0r4vW+gBW5FE2PmvxDkKM6U45A74Im8emuQ=
Date:   Wed, 30 Jun 2021 18:52:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        colin.king@canonical.com, ddstreet@ieee.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, nathan@kernel.org,
        sjenning@redhat.com, tiantao6@hisilicon.com,
        torvalds@linux-foundation.org, vitaly.wool@konsulko.com
Subject:  [patch 105/192] mm/zswap.c: remove unused function
 zswap_debugfs_exit()
Message-ID: <20210701015249.mnF3Kg_Tt%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
