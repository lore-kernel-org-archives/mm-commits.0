Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94D27E82CB1
	for <mm-commits@archiver.kernel.org>; Wed, 27 Sep 2023 16:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbjI0QJm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Sep 2023 12:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbjI0QJi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Sep 2023 12:09:38 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7893DE
        for <mm-commits@vger.kernel.org>; Wed, 27 Sep 2023 09:09:37 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A99C433C8;
        Wed, 27 Sep 2023 16:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695830977;
        bh=Wc4nEyvop2ii2rFakJX0RwmKtlJyKlRa0fcWxxKGFho=;
        h=Date:To:From:Subject:From;
        b=s5+FDEtlDuLBT9UXYpnFQZ2/Q5l/155iRxlsCR8SRZBROynjjYkRkDy8QhL6Y0MFK
         JVnJPAYOF4WqBJKXAY/0ls7F+U3JARwZljKVw+ZGQK7iwT8he7iRbpttJOlFm9D8ps
         KV5FLGAf0H1qGgd/kls1xvxwssdkbgXdb/zUe6is=
Date:   Wed, 27 Sep 2023 09:09:36 -0700
To:     mm-commits@vger.kernel.org, oleg@redhat.com, kunyu@nfschina.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + =utf-8qkernel-signal-=20remove=20unnecessary=20=-=utf-8q=e2=80=98null=e2=80=99=20values=20from=20ucounts=.patch added to mm-nonmm-unstable branch
Message-Id: <20230927160937.71A99C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/signal: remove unnecessary NULL values from ucounts
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     =utf-8qkernel-signal-=20remove=20unnecessary=20=-=utf-8q=e2=80=98null=e2=80=99=20values=20from=20ucounts=.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/=utf-8qkernel-signal-=20remove=20unnecessary=20=-=utf-8q=e2=80=98null=e2=80=99=20values=20from=20ucounts=.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

=utf-8qkernel-signal-=20remove=20unnecessary=20=-=utf-8q=e2=80=98null=e2=80=99=20values=20from=20ucounts=.patch

