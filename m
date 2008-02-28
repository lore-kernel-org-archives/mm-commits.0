From: akpm@linux-foundation.org
Subject: + remove-the-macro-get_personality.patch added to -mm tree
Date: Wed, 27 Feb 2008 17:05:41 -0800
Message-ID: <200802280105.m1S15fBA008327@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760646AbYB1BHD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 20:07:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, adobriyan@gmail.com, bryan.wu@analog.com, dhowells@redhat.com, hch@infradead.org


The patch titled
     Remove the macro get_personality
has been added to the -mm tree.  Its filename is
     remove-the-macro-get_personality.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Remove the macro get_personality
From: WANG Cong <xiyou.wangcong@gmail.com>

Remove the macro get_personality, use ->personality instead.

Cc: Christoph Hellwig <hch@infradead.org
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/kernel/signal.c |    2 +-
 arch/frv/kernel/signal.c      |    4 ++--
 include/linux/personality.h   |    4 ----
 3 files changed, 3 insertions(+), 7 deletions(-)

diff -puN arch/blackfin/kernel/signal.c~remove-the-macro-get_personality arch/blackfin/kernel/signal.c
--- a/arch/blackfin/kernel/signal.c~remove-the-macro-get_personality
+++ a/arch/blackfin/kernel/signal.c
@@ -224,7 +224,7 @@ setup_rt_frame(int sig, struct k_sigacti
 
 	/* Set up registers for signal handler */
 	wrusp((unsigned long)frame);
-	if (get_personality & FDPIC_FUNCPTRS) {
+	if (current->personality & FDPIC_FUNCPTRS) {
 		struct fdpic_func_descriptor __user *funcptr =
 			(struct fdpic_func_descriptor *) ka->sa.sa_handler;
 		__get_user(regs->pc, &funcptr->text);
diff -puN arch/frv/kernel/signal.c~remove-the-macro-get_personality arch/frv/kernel/signal.c
--- a/arch/frv/kernel/signal.c~remove-the-macro-get_personality
+++ a/arch/frv/kernel/signal.c
@@ -297,7 +297,7 @@ static int setup_frame(int sig, struct k
 	__frame->lr   = (unsigned long) &frame->retcode;
 	__frame->gr8  = sig;
 
-	if (get_personality & FDPIC_FUNCPTRS) {
+	if (current->personality & FDPIC_FUNCPTRS) {
 		struct fdpic_func_descriptor __user *funcptr =
 			(struct fdpic_func_descriptor __user *) ka->sa.sa_handler;
 		__get_user(__frame->pc, &funcptr->text);
@@ -396,7 +396,7 @@ static int setup_rt_frame(int sig, struc
 	__frame->gr8 = sig;
 	__frame->gr9 = (unsigned long) &frame->info;
 
-	if (get_personality & FDPIC_FUNCPTRS) {
+	if (current->personality & FDPIC_FUNCPTRS) {
 		struct fdpic_func_descriptor __user *funcptr =
 			(struct fdpic_func_descriptor __user *) ka->sa.sa_handler;
 		__get_user(__frame->pc, &funcptr->text);
diff -puN include/linux/personality.h~remove-the-macro-get_personality include/linux/personality.h
--- a/include/linux/personality.h~remove-the-macro-get_personality
+++ a/include/linux/personality.h
@@ -105,10 +105,6 @@ struct exec_domain {
  */
 #define personality(pers)	(pers & PER_MASK)
 
-/*
- * Personality of the currently running process.
- */
-#define get_personality		(current->personality)
 
 /*
  * Change personality of the currently running process.
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

git-hrt.patch
arch-um-kernel-um_archc-some-small-improvements.patch
remove-the-macro-get_personality.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
