From: akpm@linux-foundation.org
Subject: + sparc-exec-remove-redundant-addr_limit-assignment.patch added to -mm tree
Date: Mon, 20 Jun 2011 14:48:22 -0700
Message-ID: <201106202148.p5KLmMeG023360@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47368 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755460Ab1FTVsz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jun 2011 17:48:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minipli@googlemail.com, davem@davemloft.net


The patch titled
     sparc, exec: remove redundant addr_limit assignment
has been added to the -mm tree.  Its filename is
     sparc-exec-remove-redundant-addr_limit-assignment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sparc, exec: remove redundant addr_limit assignment
From: Mathias Krause <minipli@googlemail.com>

The address limit is already set in flush_old_exec() so this assignment of
USER_DS is redundant.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/process_32.c |    3 +--
 arch/sparc/kernel/process_64.c |    3 ---
 2 files changed, 1 insertion(+), 5 deletions(-)

diff -puN arch/sparc/kernel/process_32.c~sparc-exec-remove-redundant-addr_limit-assignment arch/sparc/kernel/process_32.c
--- a/arch/sparc/kernel/process_32.c~sparc-exec-remove-redundant-addr_limit-assignment
+++ a/arch/sparc/kernel/process_32.c
@@ -380,8 +380,7 @@ void flush_thread(void)
 #endif
 	}
 
-	/* Now, this task is no longer a kernel thread. */
-	current->thread.current_ds = USER_DS;
+	/* This task is no longer a kernel thread. */
 	if (current->thread.flags & SPARC_FLAG_KTHREAD) {
 		current->thread.flags &= ~SPARC_FLAG_KTHREAD;
 
diff -puN arch/sparc/kernel/process_64.c~sparc-exec-remove-redundant-addr_limit-assignment arch/sparc/kernel/process_64.c
--- a/arch/sparc/kernel/process_64.c~sparc-exec-remove-redundant-addr_limit-assignment
+++ a/arch/sparc/kernel/process_64.c
@@ -368,9 +368,6 @@ void flush_thread(void)
 
 	/* Clear FPU register state. */
 	t->fpsaved[0] = 0;
-	
-	if (get_thread_current_ds() != ASI_AIUS)
-		set_fs(USER_DS);
 }
 
 /* It's a bit more tricky when 64-bit tasks are involved... */
_

Patches currently in -mm which might be from minipli@googlemail.com are

origin.patch
linux-next.patch
alpha-exec-remove-redundant-set_fsuser_ds.patch
arm-exec-remove-redundant-set_fsuser_ds.patch
cris-exec-remove-redundant-set_fsuser_ds.patch
frv-exec-remove-redundant-set_fsuser_ds.patch
h8300-exec-remove-redundant-set_fsuser_ds.patch
ia64-exec-remove-redundant-set_fsuser_ds.patch
m32r-exec-remove-redundant-set_fsuser_ds.patch
m68k-exec-remove-redundant-set_fsuser_ds.patch
microblaze-exec-remove-redundant-set_fsuser_ds.patch
mips-exec-remove-redundant-addr_limit-assignment.patch
mn10300-exec-remove-redundant-set_fsuser_ds.patch
parisc-exec-remove-redundant-set_fsuser_ds.patch
ppc-exec-remove-redundant-set_fsuser_ds.patch
s390-exec-remove-redundant-set_fsuser_ds.patch
sparc-exec-remove-redundant-addr_limit-assignment.patch
um-exec-remove-redundant-set_fsuser_ds.patch
unicore32-exec-remove-redundant-set_fsuser_ds.patch

