Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B326FC001DC
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jul 2023 16:43:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjG0QnG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jul 2023 12:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbjG0Qmz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2023 12:42:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D26910CB;
        Thu, 27 Jul 2023 09:42:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C6F761ED4;
        Thu, 27 Jul 2023 16:42:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E833C433C8;
        Thu, 27 Jul 2023 16:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690476173;
        bh=N/7boeydpD/qEHnRt6kBK78KWS/T4w2CKelANcwVU9A=;
        h=Date:To:From:Subject:From;
        b=2vZnVksIU1DhbfpwATDt1Wt/BYls+W75YObHfna9nzSU09Jti3CvczCW5lq5qIvjJ
         3819KrVTbTVHKGwxq1BAhYMfksr5cau1VrzXp6wleHb5U8lH4e/4o2j8tMbD0j5q9J
         KqOYe3X4UTtWe6QvBUpO147/chK1ZKZpBtUOAsFw=
Date:   Thu, 27 Jul 2023 09:42:52 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, koct9i@gmail.com, colin.i.king@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + radix-tree-test-suite-fix-incorrect-allocation-size-for-pthreads.patch added to mm-hotfixes-unstable branch
Message-Id: <20230727164253.8E833C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: radix tree test suite: fix incorrect allocation size for pthreads
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     radix-tree-test-suite-fix-incorrect-allocation-size-for-pthreads.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/radix-tree-test-suite-fix-incorrect-allocation-size-for-pthreads.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: radix tree test suite: fix incorrect allocation size for pthreads
Date: Thu, 27 Jul 2023 17:09:30 +0100

Currently the pthread allocation for each array item is based on the size
of a pthread_t pointer and should be the size of the pthread_t structure,
so the allocation is under-allocating the correct size.  Fix this by using
the size of each element in the pthreads array.

Static analysis cppcheck reported:
tools/testing/radix-tree/regression1.c:180:2: warning: Size of pointer
'threads' used instead of size of its data. [pointerSize]

Link: https://lkml.kernel.org/r/20230727160930.632674-1-colin.i.king@gmail.com
Fixes: 1366c37ed84b ("radix tree test harness")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/regression1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/radix-tree/regression1.c~radix-tree-test-suite-fix-incorrect-allocation-size-for-pthreads
+++ a/tools/testing/radix-tree/regression1.c
@@ -177,7 +177,7 @@ void regression1_test(void)
 	nr_threads = 2;
 	pthread_barrier_init(&worker_barrier, NULL, nr_threads);
 
-	threads = malloc(nr_threads * sizeof(pthread_t *));
+	threads = malloc(nr_threads * sizeof(*threads));
 
 	for (i = 0; i < nr_threads; i++) {
 		arg = i;
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

radix-tree-test-suite-fix-incorrect-allocation-size-for-pthreads.patch
fs-hfsplus-make-extend-error-rate-limited.patch

