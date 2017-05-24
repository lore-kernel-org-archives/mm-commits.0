From: akpm@linux-foundation.org
Subject: + forkrandom-use-get_random_canary-to-set-tsk-stack_canary.patch
 added to -mm tree
Date: Wed, 24 May 2017 14:22:18 -0700
Message-ID: <5925f98a.tmvMwYqAIAP8vkRg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44858 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033614AbdEXVWT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 May 2017 17:22:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, catalin.marinas@arm.com, danielmicay@gmail.com, hpa@zytor.com, keescook@chromium.org, luto@amacapital.net, mingo@kernel.org, tytso@mit.edu, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fork,random: use get_random_canary() to set tsk->stack_canary
has been added to the -mm tree.  Its filename is
     forkrandom-use-get_random_canary-to-set-tsk-stack_canary.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/forkrandom-use-get_random_canary-to-set-tsk-stack_canary.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/forkrandom-use-get_random_canary-to-set-tsk-stack_canary.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: fork,random: use get_random_canary() to set tsk->stack_canary

Use the ascii-armor canary to prevent unterminated C string overflows from
being able to successfully overwrite the canary, even if they somehow
obtain the canary value.

Inspired by execshield ascii-armor and Daniel Micay's linux-hardened tree.

Link: http://lkml.kernel.org/r/20170524155751.424-3-riel@redhat.com
Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/fork.c~forkrandom-use-get_random_canary-to-set-tsk-stack_canary kernel/fork.c
--- a/kernel/fork.c~forkrandom-use-get_random_canary-to-set-tsk-stack_canary
+++ a/kernel/fork.c
@@ -560,7 +560,7 @@ static struct task_struct *dup_task_stru
 	set_task_stack_end_magic(tsk);
 
 #ifdef CONFIG_CC_STACKPROTECTOR
-	tsk->stack_canary = get_random_long();
+	tsk->stack_canary = get_random_canary();
 #endif
 
 	/*
_

Patches currently in -mm which might be from riel@redhat.com are

randomstackprotect-introduce-get_random_canary-function.patch
forkrandom-use-get_random_canary-to-set-tsk-stack_canary.patch
x86-ascii-armor-the-x86_64-boot-init-stack-canary.patch
arm64-ascii-armor-the-arm64-boot-init-stack-canary.patch
sh64-ascii-armor-the-sh64-boot-init-stack-canary.patch

