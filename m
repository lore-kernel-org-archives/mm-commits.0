Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3E52C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:22:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A545061101
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:22:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347188AbhIHCXI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:23:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235450AbhIHCXH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:23:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2CDA61090;
        Wed,  8 Sep 2021 02:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631067721;
        bh=qlIbhhsGU1ewE7fRMcB3GDmnEFzH3B5Y8phwF0zHvrI=;
        h=Date:From:To:Subject:From;
        b=Z6qur2DiN9iMysXbsk+j4qqJKldUFBcJDmUc4rg3GbCtuGDPFUPXjXoCN9IfxxqYl
         6hMCI6YpELvx1Cy7cKk9IJcrDJM2BkrvA9pCZ95BkR6sMxMYTMgTb2wxTOshaiZLQS
         ewY/wraVt2Umc/hRLHdoPVHnVGlNQR/61Um/dOok=
Date:   Tue, 07 Sep 2021 19:22:00 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, broonie@kernel.org, linux@roeck-us.net,
        mm-commits@vger.kernel.org, npiggin@gmail.com,
        rdunlap@infradead.org, sfr@canb.auug.org.au
Subject:  [folded-merged]
 fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix-fix.patch
 removed from -mm tree
Message-ID: <20210908022200.jhMly3QRO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix-fix
has been removed from the -mm tree.  Its filename was
     fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix-fix.patch

This patch was dropped because it was folded into fs-epoll-use-a-per-cpu-counter-for-users-watches-count.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix-fix

tweak user_epoll_alloc(), per Guenter

Link: https://lkml.kernel.org/r/20210804191421.GA1900577@roeck-us.net
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Mark Brown <broonie@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/user.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/user.c~fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix-fix
+++ a/kernel/user.c
@@ -133,8 +133,9 @@ static int user_epoll_alloc(struct user_
 {
 #ifdef CONFIG_EPOLL
 	return percpu_counter_init(&up->epoll_watches, 0, GFP_KERNEL);
-#endif
+#else
 	return 0;
+#endif
 }
 
 static void user_epoll_free(struct user_struct *up)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-epoll-use-a-per-cpu-counter-for-users-watches-count.patch
log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

