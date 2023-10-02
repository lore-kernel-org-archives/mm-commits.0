Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 476F4E784BC
	for <mm-commits@archiver.kernel.org>; Mon,  2 Oct 2023 15:33:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238121AbjJBPdM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 2 Oct 2023 11:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237779AbjJBPdM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Oct 2023 11:33:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD34B7
        for <mm-commits@vger.kernel.org>; Mon,  2 Oct 2023 08:33:09 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37856C433C8;
        Mon,  2 Oct 2023 15:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696260789;
        bh=e8wLKamHu5FMCfZ8evWoiRzUObDE2NpRWQDnHFZ0Zv4=;
        h=Date:To:From:Subject:From;
        b=dosiHfSuWFDxVVGG1ftVryaSYssLsnVZz07gQazSEhbRMr+kELl2deN1sdTpSklDO
         OFOmV/kzKHE7h90r4sTpJpdtI0a3bOCjaY9WSR7HXhyC8MWj2gELvx7h/c/E3NpGXp
         28Vx8sJbRBvvnUjlgcZktZZ4SCm8Km0oYWLS8aKw=
Date:   Mon, 02 Oct 2023 08:33:08 -0700
To:     mm-commits@vger.kernel.org, oleg@redhat.com, kunyu@nfschina.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-signal-remove-unnecessary-null-values-from-ucounts.patch added to mm-nonmm-unstable branch
Message-Id: <20231002153309.37856C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/signal: remove unnecessary NULL values from ucounts
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-signal-remove-unnecessary-null-values-from-ucounts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-signal-remove-unnecessary-null-values-from-ucounts.patch

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

--- a/kernel/signal.c~kernel-signal-remove-unnecessary-null-values-from-ucounts
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

