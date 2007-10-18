From: akpm@linux-foundation.org
Subject: - add-kernel-notifierc-fix-2.patch removed from -mm tree
Date: Thu, 18 Oct 2007 13:30:48 -0700
Message-ID: <200710182030.l9IKUmJA029694@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43177 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754900AbXJRUbz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 16:31:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, mm-commits@vger.kernel.org


The patch titled
     add-kernel-notifierc-fix 2
has been removed from the -mm tree.  Its filename was
     add-kernel-notifierc-fix-2.patch

This patch was dropped because it was folded into add-kernel-notifierc.patch

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
sysctl-core-stop-using-the-unnecessary-ctl_table-typedef.patch
sysctl-factor-out-sysctl_data.patch
sysct-mqueue-remove-the-binary-sysctl-numbers.patch
sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work.patch
sysctl-fix-neighbour-table-sysctls.patch
sysctl-ipv6-route-flushing-kill-binary-path.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
sysctl-x86_64-remove-unnecessary-binary-paths.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch
sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
sysctl-error-on-bad-sysctl-tables.patch
sysctl-update-sysctl_check_table.patch
add-kernel-notifierc.patch
add-kernel-notifierc-fix-2.patch
add-kernel-notifierc-fix-2-fix-3.patch
uninline-forkc-exitc.patch
uninline-forkc-exitc-checkpatch-fixes.patch
single_open-seq_release-leak-diagnostics.patch
