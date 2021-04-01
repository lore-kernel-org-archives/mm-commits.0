Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB0B0C433B4
	for <mm-commits@archiver.kernel.org>; Thu,  1 Apr 2021 00:43:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A09D761056
	for <mm-commits@archiver.kernel.org>; Thu,  1 Apr 2021 00:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbhDAAnV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Mar 2021 20:43:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229812AbhDAAnL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 31 Mar 2021 20:43:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 363576052B;
        Thu,  1 Apr 2021 00:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617237787;
        bh=vXY9B6d4bgKe5X9MaHT7bWeRm6upkJWsTp3EwLgo6VA=;
        h=Date:From:To:Subject:From;
        b=OuZMEv5D57PAYry4NU6tY+2N23S/IpQ38BxrW5De4nxgYrqMccCSZBwH+B267yDnw
         KGXeoz7JMc3g93XqtsXtUousHzPlKb2pEi3VYFXu6QzM6/BuKRrqTFvygnUVirDBB6
         H+w4zihg8L8N+DOly4BcNzHrmctNHJsULpssHqi4=
Date:   Wed, 31 Mar 2021 17:43:06 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, naresh.kamboju@linaro.org,
        vbabka@suse.cz
Subject:  [folded-merged]
 selftests-add-a-kselftest-for-slub-debugging-functionality-fix.patch
 removed from -mm tree
Message-ID: <20210401004306.-mSZB4avx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: add a kselftest for SLUB debugging functionality-fix
has been removed from the -mm tree.  Its filename was
     selftests-add-a-kselftest-for-slub-debugging-functionality-fix.patch

This patch was dropped because it was folded into selftests-add-a-kselftest-for-slub-debugging-functionality.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: selftests: add a kselftest for SLUB debugging functionality-fix

Remove a BUILD_BUG_ON left over from original resiliency_test() that breaks
builds.

Link: https://lkml.kernel.org/r/53cc267d-aa0a-071a-f9f8-0b47ec4b2b9d@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_slub.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/lib/test_slub.c~selftests-add-a-kselftest-for-slub-debugging-functionality-fix
+++ a/lib/test_slub.c
@@ -97,9 +97,6 @@ static void __init test_clobber_redzone_
 
 static void __init resiliency_test(void)
 {
-
-	BUILD_BUG_ON(KMALLOC_MIN_SIZE > 16 || KMALLOC_SHIFT_HIGH < 10);
-
 	pr_err("SLUB resiliency testing\n");
 	pr_err("-----------------------\n");
 	pr_err("A. Corruption after allocation\n");
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-enable-slub_debug-static-key-when-creating-cache-with-explicit-debug-flags.patch
selftests-add-a-kselftest-for-slub-debugging-functionality.patch

