Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9463BC07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:23:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FCAB61CAD
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbhGFTZx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:25:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:59086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229958AbhGFTZx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:25:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7862561C9D;
        Tue,  6 Jul 2021 19:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599393;
        bh=wTJtv9cPCY9GYvKWBZ2B5R01e2wXH6M59Z/xG6g6E3U=;
        h=Date:From:To:Subject:From;
        b=i0q+u5i2Cs6lJT8alQJ7bOLMjZCYoigYmSlXzhi0pZbKvP7otDt6pc+5sjRC3wilI
         Bt7n1BZfRvevUwQfCFY5PGgySeF0zZ+HE7r2VVK3xoBJD3XVXJKYnhxFr4vL+8is87
         0MJiDjEF3KnUuLn6TrysK0Xuy5+MvRkDc+rLLWMU=
Date:   Tue, 06 Jul 2021 12:23:13 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, oleg@redhat.com, viro@zeniv.linux.org.uk
Subject:  [merged]
 =?US-ASCII?Q?x86-signal-dont-do-sas=5Fss=5Freset-until-we-are-certain-t?=
 =?US-ASCII?Q?hat-sigframe-wont-be-abandoned.patch?= removed from -mm tree
Message-ID: <20210706192313.DQvGMpQPj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86: signal: don't do sas_ss_reset() until we are certain that sigframe won't be abandoned
has been removed from the -mm tree.  Its filename was
     x86-signal-dont-do-sas_ss_reset-until-we-are-certain-that-sigframe-wont-be-abandoned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Al Viro <viro@zeniv.linux.org.uk>
Subject: x86: signal: don't do sas_ss_reset() until we are certain that sigframe won't be abandoned

Currently we handle SS_AUTODISARM as soon as we have stored the altstack
settings into sigframe - that's the point when we have set the things up
for eventual sigreturn to restore the old settings.  And if we manage to
set the sigframe up (we are not done with that yet), everything's fine. 
However, in case of failure we end up with sigframe-to-be abandoned and
SIGSEGV force-delivered.  And in that case we end up with inconsistent
rules - late failures have altstack reset, early ones do not.

It's trivial to get consistent behaviour - just handle SS_AUTODISARM once
we have set the sigframe up and are committed to entering the handler,
i.e.  in signal_delivered().

Link: https://lore.kernel.org/lkml/20200404170604.GN23230@ZenIV.linux.org.uk/
Link: https://github.com/ClangBuiltLinux/linux/issues/876
Link: https://lkml.kernel.org/r/20210422230846.1756380-1-ndesaulniers@google.com
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compat.h |    2 --
 include/linux/signal.h |    2 --
 kernel/signal.c        |   14 ++++----------
 3 files changed, 4 insertions(+), 14 deletions(-)

--- a/include/linux/compat.h~x86-signal-dont-do-sas_ss_reset-until-we-are-certain-that-sigframe-wont-be-abandoned
+++ a/include/linux/compat.h
@@ -532,8 +532,6 @@ int __compat_save_altstack(compat_stack_
 			&__uss->ss_sp, label); \
 	unsafe_put_user(t->sas_ss_flags, &__uss->ss_flags, label); \
 	unsafe_put_user(t->sas_ss_size, &__uss->ss_size, label); \
-	if (t->sas_ss_flags & SS_AUTODISARM) \
-		sas_ss_reset(t); \
 } while (0);
 
 /*
--- a/include/linux/signal.h~x86-signal-dont-do-sas_ss_reset-until-we-are-certain-that-sigframe-wont-be-abandoned
+++ a/include/linux/signal.h
@@ -462,8 +462,6 @@ int __save_altstack(stack_t __user *, un
 	unsafe_put_user((void __user *)t->sas_ss_sp, &__uss->ss_sp, label); \
 	unsafe_put_user(t->sas_ss_flags, &__uss->ss_flags, label); \
 	unsafe_put_user(t->sas_ss_size, &__uss->ss_size, label); \
-	if (t->sas_ss_flags & SS_AUTODISARM) \
-		sas_ss_reset(t); \
 } while (0);
 
 #ifdef CONFIG_PROC_FS
--- a/kernel/signal.c~x86-signal-dont-do-sas_ss_reset-until-we-are-certain-that-sigframe-wont-be-abandoned
+++ a/kernel/signal.c
@@ -2829,6 +2829,8 @@ static void signal_delivered(struct ksig
 	if (!(ksig->ka.sa.sa_flags & SA_NODEFER))
 		sigaddset(&blocked, ksig->sig);
 	set_current_blocked(&blocked);
+	if (current->sas_ss_flags & SS_AUTODISARM)
+		sas_ss_reset(current);
 	tracehook_signal_handler(stepping);
 }
 
@@ -4147,11 +4149,7 @@ int __save_altstack(stack_t __user *uss,
 	int err = __put_user((void __user *)t->sas_ss_sp, &uss->ss_sp) |
 		__put_user(t->sas_ss_flags, &uss->ss_flags) |
 		__put_user(t->sas_ss_size, &uss->ss_size);
-	if (err)
-		return err;
-	if (t->sas_ss_flags & SS_AUTODISARM)
-		sas_ss_reset(t);
-	return 0;
+	return err;
 }
 
 #ifdef CONFIG_COMPAT
@@ -4206,11 +4204,7 @@ int __compat_save_altstack(compat_stack_
 			 &uss->ss_sp) |
 		__put_user(t->sas_ss_flags, &uss->ss_flags) |
 		__put_user(t->sas_ss_size, &uss->ss_size);
-	if (err)
-		return err;
-	if (t->sas_ss_flags & SS_AUTODISARM)
-		sas_ss_reset(t);
-	return 0;
+	return err;
 }
 #endif
 
_

Patches currently in -mm which might be from viro@zeniv.linux.org.uk are


