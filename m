From: akpm@linux-foundation.org
Subject: - remove-the-macro-get_personality.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:40:17 -0700
Message-ID: <200804300540.m3U5eHMt028948@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754785AbYD3Fkq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:40:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, adobriyan@gmail.com, bryan.wu@analog.com, dhowells@redhat.com, hch@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Remove the macro get_personality
has been removed from the -mm tree.  Its filename was
     remove-the-macro-get_personality.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -212,7 +212,7 @@ setup_rt_frame(int sig, struct k_sigacti
 
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

origin.patch

