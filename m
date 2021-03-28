Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE16BC433C1
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 22:08:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DBAD6195F
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 22:08:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhC1WIA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 18:08:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229655AbhC1WHr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 18:07:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A35346195E;
        Sun, 28 Mar 2021 22:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616969266;
        bh=1TVxeHIs3KFI5ETdieWXM9e5MHhIvE5qMd1PniU+U5Q=;
        h=Date:From:To:Subject:From;
        b=UHODMTscWcNPrnvUdgYq78qhiYabztYY5XoSaDzLsxts37K9SYG7PDEBRmaowI9+t
         qg8VlSo12iz0DkDjdBFDcdk4pNAhjRWUVhRoO++W/n3iy4O15/Cnn7jcVkfu4O/Rxr
         L7D6XPzd8w891ss//5eEJ0VKldEDVbwg6JNaMs78=
Date:   Sun, 28 Mar 2021 15:07:46 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, naresh.kamboju@linaro.org,
        vbabka@suse.cz
Subject:  +
 selftests-add-a-kselftest-for-slub-debugging-functionality-fix.patch added
 to -mm tree
Message-ID: <20210328220746.suKqqZ6Nc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: add a kselftest for SLUB debugging functionality-fix
has been added to the -mm tree.  Its filename is
     selftests-add-a-kselftest-for-slub-debugging-functionality-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-add-a-kselftest-for-slub-debugging-functionality-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-add-a-kselftest-for-slub-debugging-functionality-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
selftests-add-a-kselftest-for-slub-debugging-functionality-fix.patch

