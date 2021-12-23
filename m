Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86857C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 23 Dec 2021 00:06:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345084AbhLWAG4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Dec 2021 19:06:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbhLWAGz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Dec 2021 19:06:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66861C061574
        for <mm-commits@vger.kernel.org>; Wed, 22 Dec 2021 16:06:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DD42B81EA0
        for <mm-commits@vger.kernel.org>; Thu, 23 Dec 2021 00:06:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B678C36AE8;
        Thu, 23 Dec 2021 00:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640218012;
        bh=whTELGeSyeWClDQQXZOGYc3vDbUkanXTpLIRkV8EkXY=;
        h=Date:From:To:Subject:From;
        b=kV0AuFRNpIJi5n88Ojr6m6ZbeTAboV/Zqt1KwvzO6FDllRMP3rzy4Vt2a2iXYgPaH
         91F/UGopeD22X5+iYNXg8b6x4tHoEiJOc3LTlCQN8ViCyauVwHN38pbpolx4jhBIS3
         v50qeaSXkafeGle/uYqupHW89Xog0os5Jkfyj6Fc=
Date:   Wed, 22 Dec 2021 16:06:52 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        tglx@linutronix.de, richard@nod.at, peterz@infradead.org,
        elver@google.com, ebiederm@xmission.com, axboe@kernel.dk,
        rdunlap@infradead.org
Subject:  + signal-clean-up-kernel-doc-comments.patch added to -mm
 tree
Message-ID: <20211223000652.ne0dP%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: signal: clean up kernel-doc comments
has been added to the -mm tree.  Its filename is
     signal-clean-up-kernel-doc-comments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/signal-clean-up-kernel-doc-comments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/signal-clean-up-kernel-doc-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: signal: clean up kernel-doc comments

Fix kernel-doc warnings in kernel/signal.c:

kernel/signal.c:1830: warning: Function parameter or member 'force_coredump' not described in 'force_sig_seccomp'
kernel/signal.c:2873: warning: missing initial short description on line:
 * signal_delivered -

Also add a closing parenthesis to the comments in signal_delivered().

Link: https://lkml.kernel.org/r/20211222031027.29694-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Richard Weinberger <richard@nod.at>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Marco Elver <elver@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/signal.c~signal-clean-up-kernel-doc-comments
+++ a/kernel/signal.c
@@ -1820,6 +1820,7 @@ int force_sig_perf(void __user *addr, u3
  * force_sig_seccomp - signals the task to allow in-process syscall emulation
  * @syscall: syscall number to send to userland
  * @reason: filter-supplied reason code to send to userland (via si_errno)
+ * @force_coredump: true to trigger a coredump
  *
  * Forces a SIGSYS with a code of SYS_SECCOMP and related sigsys info.
  */
@@ -2863,13 +2864,13 @@ out:
 }
 
 /**
- * signal_delivered - 
+ * signal_delivered - called after signal delivery to update blocked signals
  * @ksig:		kernel signal struct
  * @stepping:		nonzero if debugger single-step or block-step in use
  *
  * This function should be called when a signal has successfully been
  * delivered. It updates the blocked signals accordingly (@ksig->ka.sa.sa_mask
- * is always blocked, and the signal itself is blocked unless %SA_NODEFER
+ * is always blocked), and the signal itself is blocked unless %SA_NODEFER
  * is set in @ksig->ka.sa.sa_flags.  Tracing is notified.
  */
 static void signal_delivered(struct ksignal *ksig, int stepping)
_

Patches currently in -mm which might be from rdunlap@infradead.org are

maintainers-mark-more-list-instances-as-moderated.patch
mm-mempolicy-fix-all-kernel-doc-warnings.patch
signal-clean-up-kernel-doc-comments.patch

