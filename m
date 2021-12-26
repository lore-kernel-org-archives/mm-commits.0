Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D41BBC433F5
	for <mm-commits@archiver.kernel.org>; Sun, 26 Dec 2021 22:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234705AbhLZWUU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Dec 2021 17:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234715AbhLZWUU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Dec 2021 17:20:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0338AC061401
        for <mm-commits@vger.kernel.org>; Sun, 26 Dec 2021 14:20:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 974A360F17
        for <mm-commits@vger.kernel.org>; Sun, 26 Dec 2021 22:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0CD7C36AE9;
        Sun, 26 Dec 2021 22:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640557219;
        bh=14VlHCELA2rzly9Z0nSlpWc/qUvj3Dehvnqeg76ID4s=;
        h=Date:From:To:Subject:From;
        b=uvD71cJbWGLZEu/1pNTWyZGRFsBv5XDj5eWlXkzuie5uMsvtOMMksEoeiFD+Mo7Cd
         uu3dU52ZrjhDObNw5HVzuFGrJp66bt4O5ywQlLYDiGShamUunq55xMzZ9oWYDExxnm
         SPqaNH7SXTTa3/o58T69c1ixtJ5WV9RtdRlpgplQ=
Date:   Sun, 26 Dec 2021 14:20:18 -0800
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, ebiederm@xmission.com, elver@google.com,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        rdunlap@infradead.org, richard@nod.at, tglx@linutronix.de,
        viro@zeniv.linux.org.uk
Subject:  [merged] signal-clean-up-kernel-doc-comments.patch
 removed from -mm tree
Message-ID: <20211226222018.oDJ6h6Dpv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: signal: clean up kernel-doc comments
has been removed from the -mm tree.  Its filename was
     signal-clean-up-kernel-doc-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-mempolicy-fix-all-kernel-doc-warnings.patch

