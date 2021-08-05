Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8F1FC432BE
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 23:53:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB5CA61156
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 23:53:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242614AbhHEXxa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Aug 2021 19:53:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:38438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242611AbhHEXxa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 5 Aug 2021 19:53:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CD5B610E7;
        Thu,  5 Aug 2021 23:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628207595;
        bh=ADfT0cN1WMFpnzzCxwmjOZMUlb0c9kashO+NuV8wRKg=;
        h=Date:From:To:Subject:From;
        b=wt1WP7HKBuNL8yWm5kom3Zhq9lH3KEoXziS7+1VQgYvym6C2IG3c0WWOQSgtDZan5
         JTI0td+re0Imb3E8YZX+8QJULtJF338QO2QcNL6JLhLSripeATYA2+rTfs1ZGxc7Lx
         /ZTdR/vKx/nON9AVJ7k98eLCkp8LGspJpbsSLzPM=
Date:   Thu, 05 Aug 2021 16:53:15 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        rdunlap@infradead.org, npiggin@gmail.com, linux@roeck-us.net,
        broonie@kernel.org, akpm@linux-foundation.org
Subject:  +
 fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix-fix.patch added to
 -mm tree
Message-ID: <20210805235315.yG-_w%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix-fix
has been added to the -mm tree.  Its filename is
     fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-compaction-optimize-proactive-compaction-deferrals-fix.patch
mm-compaction-support-triggering-of-proactive-compaction-by-user-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix-fix.patch
log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

