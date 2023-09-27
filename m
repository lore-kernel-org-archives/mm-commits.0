Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 496F0E82CB0
	for <mm-commits@archiver.kernel.org>; Wed, 27 Sep 2023 16:10:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbjI0QKH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Sep 2023 12:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbjI0QKE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Sep 2023 12:10:04 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604791BD
        for <mm-commits@vger.kernel.org>; Wed, 27 Sep 2023 09:09:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97933C433C7;
        Wed, 27 Sep 2023 16:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695830996;
        bh=a4PSQPxR2LnuRn1Givwa2MuauoXL+1CfhAd3V6QyGcM=;
        h=Date:To:From:Subject:From;
        b=lw86vSTu0x4+dbuNzulePqFroNvBxJdiXS4dhovehxHEW8yoa9VrAnph/IF4HqoWC
         c4PxeDQ/8Y59/IzceiQVWydtC9FL9bjKBEdE2rPT9BsCj61f3PO/HAQyy6hXXtHCZh
         n9t2nDuRpn1twRrliyIkXRkniK8+RBxD1InV9T38=
Date:   Wed, 27 Sep 2023 09:09:56 -0700
To:     mm-commits@vger.kernel.org, oleg@redhat.com, kunyu@nfschina.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-signal-remove-unnecessary-null-values-from-ucounts.patch added to mm-hotfixes-stable branch
Message-Id: <20230927160956.97933C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/signal: remove unnecessary NULL values from ucounts
has been added to the -mm mm-hotfixes-stable branch.  Its filename is
     kernel-signal-remove-unnecessary-null-values-from-ucounts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-signal-remove-unnecessary-null-values-from-ucounts.patch

This patch will later appear in the mm-hotfixes-stable branch at
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
From: Li kunyu <kunyu@nfschina.com>
Subject: kernel/signal: remove unnecessary NULL values from ucounts
Date: Tue, 26 Sep 2023 10:24:10 +0800

ucounts is assigned first, so it does not need to initialize the
assignment.

Link: https://lkml.kernel.org/r/20230926022410.4280-1-kunyu@nfschina.com
Signed-off-by: Li kunyu <kunyu@nfschina.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/signal.c~=utf-8qkernel-signal-=20remove=20unnecessary=20=-=utf-8q=e2=80=98null=e2=80=99=20values=20from=20ucounts=
+++ a/kernel/signal.c
@@ -415,7 +415,7 @@ __sigqueue_alloc(int sig, struct task_st
 		 int override_rlimit, const unsigned int sigqueue_flags)
 {
 	struct sigqueue *q = NULL;
-	struct ucounts *ucounts = NULL;
+	struct ucounts *ucounts;
 	long sigpending;
 
 	/*
_

Patches currently in -mm which might be from kunyu@nfschina.com are

kernel-signal-remove-unnecessary-null-values-from-ucounts.patch

