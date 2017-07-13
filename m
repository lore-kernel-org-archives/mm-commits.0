From: akpm@linux-foundation.org
Subject: [merged]
 forkrandom-use-get_random_canary-to-set-tsk-stack_canary.patch removed from
 -mm tree
Date: Thu, 13 Jul 2017 13:42:33 -0700
Message-ID: <20170713204233.zajzF0EWU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59580 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752905AbdGMUme (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:42:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, danielmicay@gmail.com, hpa@zytor.com, keescook@chromium.org, luto@amacapital.net, mingo@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, tytso@mit.edu, ysato@users.sourceforge.jp


The patch titled
     Subject: fork,random: use get_random_canary() to set tsk->stack_canary
has been removed from the -mm tree.  Its filename was
     forkrandom-use-get_random_canary-to-set-tsk-stack_canary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -554,7 +554,7 @@ static struct task_struct *dup_task_stru
 	set_task_stack_end_magic(tsk);
 
 #ifdef CONFIG_CC_STACKPROTECTOR
-	tsk->stack_canary = get_random_long();
+	tsk->stack_canary = get_random_canary();
 #endif
 
 	/*
_

Patches currently in -mm which might be from riel@redhat.com are


