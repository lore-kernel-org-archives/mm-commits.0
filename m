From: akpm@linux-foundation.org
Subject: + add-kernel-notifierc-fix-2.patch added to -mm tree
Date: Fri, 20 Jul 2007 11:24:51 -0700
Message-ID: <200707201824.l6KIOpNe009942@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50788 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752157AbXGTSeW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 14:34:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru


The patch titled
     add-kernel-notifierc-fix 2
has been added to the -mm tree.  Its filename is
     add-kernel-notifierc-fix-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add-kernel-notifierc-fix 2
From: Alexey Dobriyan <adobriyan@sw.ru>

It fixes [Space][Tab][Space] places and removes lines between kernel-doc
comment and function itself.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/notifier.c |   31 ++++++++-----------------------
 1 files changed, 8 insertions(+), 23 deletions(-)

diff -puN kernel/notifier.c~add-kernel-notifierc-fix-2 kernel/notifier.c
--- a/kernel/notifier.c~add-kernel-notifierc-fix-2
+++ a/kernel/notifier.c
@@ -10,7 +10,6 @@
  *	at shutdown. This is used to stop any idling DMA operations
  *	and the like.
  */
-
 BLOCKING_NOTIFIER_HEAD(reboot_notifier_list);
 
 /*
@@ -50,13 +49,12 @@ static int notifier_chain_unregister(str
  *	@val:		Value passed unmodified to notifier function
  *	@v:		Pointer passed unmodified to notifier function
  *	@nr_to_call:	Number of notifier functions to be called. Don't care
- *		     	value of this parameter is -1.
+ *			value of this parameter is -1.
  *	@nr_calls:	Records the number of notifications sent. Don't care
- *		   	value of this field is NULL.
- * 	@returns:	notifier_call_chain returns the value returned by the
+ *			value of this field is NULL.
+ *	@returns:	notifier_call_chain returns the value returned by the
  *			last notifier function called.
  */
-
 static int __kprobes notifier_call_chain(struct notifier_block **nl,
 					unsigned long val, void *v,
 					int nr_to_call,	int *nr_calls)
@@ -95,7 +93,6 @@ static int __kprobes notifier_call_chain
  *
  *	Currently always returns zero.
  */
-
 int atomic_notifier_chain_register(struct atomic_notifier_head *nh,
 		struct notifier_block *n)
 {
@@ -151,7 +148,6 @@ EXPORT_SYMBOL_GPL(atomic_notifier_chain_
  *	Otherwise the return value is the return value
  *	of the last notifier function called.
  */
-
 int __kprobes __atomic_notifier_call_chain(struct atomic_notifier_head *nh,
 					unsigned long val, void *v,
 					int nr_to_call, int *nr_calls)
@@ -187,7 +183,6 @@ EXPORT_SYMBOL_GPL(atomic_notifier_call_c
  *
  *	Currently always returns zero.
  */
-
 int blocking_notifier_chain_register(struct blocking_notifier_head *nh,
 		struct notifier_block *n)
 {
@@ -256,7 +251,6 @@ EXPORT_SYMBOL_GPL(blocking_notifier_chai
  *	Otherwise the return value is the return value
  *	of the last notifier function called.
  */
-
 int __blocking_notifier_call_chain(struct blocking_notifier_head *nh,
 				   unsigned long val, void *v,
 				   int nr_to_call, int *nr_calls)
@@ -300,7 +294,6 @@ EXPORT_SYMBOL_GPL(blocking_notifier_call
  *
  *	Currently always returns zero.
  */
-
 int raw_notifier_chain_register(struct raw_notifier_head *nh,
 		struct notifier_block *n)
 {
@@ -344,7 +337,6 @@ EXPORT_SYMBOL_GPL(raw_notifier_chain_unr
  *	Otherwise the return value is the return value
  *	of the last notifier function called.
  */
-
 int __raw_notifier_call_chain(struct raw_notifier_head *nh,
 			      unsigned long val, void *v,
 			      int nr_to_call, int *nr_calls)
@@ -375,7 +367,6 @@ EXPORT_SYMBOL_GPL(raw_notifier_call_chai
  *
  *	Currently always returns zero.
  */
-
 int srcu_notifier_chain_register(struct srcu_notifier_head *nh,
 		struct notifier_block *n)
 {
@@ -445,7 +436,6 @@ EXPORT_SYMBOL_GPL(srcu_notifier_chain_un
  *	Otherwise the return value is the return value
  *	of the last notifier function called.
  */
-
 int __srcu_notifier_call_chain(struct srcu_notifier_head *nh,
 			       unsigned long val, void *v,
 			       int nr_to_call, int *nr_calls)
@@ -479,7 +469,6 @@ EXPORT_SYMBOL_GPL(srcu_notifier_call_cha
  *	up by calling srcu_cleanup_notifier_head().  Otherwise the head's
  *	per-cpu data (used by the SRCU mechanism) will leak.
  */
-
 void srcu_init_notifier_head(struct srcu_notifier_head *nh)
 {
 	mutex_init(&nh->mutex);
@@ -499,7 +488,6 @@ EXPORT_SYMBOL_GPL(srcu_init_notifier_hea
  *	Currently always returns zero, as blocking_notifier_chain_register()
  *	always returns zero.
  */
-
 int register_reboot_notifier(struct notifier_block *nb)
 {
 	return blocking_notifier_chain_register(&reboot_notifier_list, nb);
@@ -515,28 +503,25 @@ EXPORT_SYMBOL(register_reboot_notifier);
  *
  *	Returns zero on success, or %-ENOENT on failure.
  */
-
 int unregister_reboot_notifier(struct notifier_block *nb)
 {
 	return blocking_notifier_chain_unregister(&reboot_notifier_list, nb);
 }
 EXPORT_SYMBOL(unregister_reboot_notifier);
 
-
 static ATOMIC_NOTIFIER_HEAD(die_chain);
 
 int notify_die(enum die_val val, const char *str,
 	       struct pt_regs *regs, long err, int trap, int sig)
 {
 	struct die_args args = {
-		.regs		= regs,
-		.str		= str,
-		.err		= err,
-		.trapnr		= trap,
-		.signr		= sig,
+		.regs	= regs,
+		.str	= str,
+		.err	= err,
+		.trapnr	= trap,
+		.signr	= sig,
 
 	};
-
 	return atomic_notifier_call_chain(&die_chain, val, &args);
 }
 
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
consolidate-ptrace_detach.patch
git-dvb.patch
use-list_head-in-binfmt-handling.patch
make-unregister_binfmt-return-void.patch
fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats.patch
fix-leak-on-proc-lockdep_stats.patch
slab_panic-more-proc-posix-timers-shmem.patch
add-kernel-notifierc.patch
add-kernel-notifierc-fix.patch
add-kernel-notifierc-fix-2.patch
