From: akpm@linux-foundation.org
Subject: + kexec-jump-clean-up-ifdef-and-comments.patch added to -mm tree
Date: Tue, 12 Aug 2008 16:15:41 -0700
Message-ID: <200808122315.m7CNFfwW018732@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751351AbYHLXQU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 19:16:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ying.huang@intel.com, ebiederm@xmission.com, mingo@elte.hu, pavel@ucw.cz, rjw@sisk.pl, vgoyal@redhat.com


The patch titled
     kexec jump: clean up #ifdef and comments
has been added to the -mm tree.  Its filename is
     kexec-jump-clean-up-ifdef-and-comments.patch

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
Subject: kexec jump: clean up #ifdef and comments
From: Huang Ying <ying.huang@intel.com>

Move if (kexec_image->preserve_context) { ...  } into #ifdef
CONFIG_KEXEC_JUMP to make code looks cleaner.

Fix no longer correct comments of kernel_kexec().

Signed-off-by: Huang Ying <ying.huang@intel.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN kernel/kexec.c~kexec-jump-clean-up-ifdef-and-comments kernel/kexec.c
--- a/kernel/kexec.c~kexec-jump-clean-up-ifdef-and-comments
+++ a/kernel/kexec.c
@@ -1426,11 +1426,9 @@ static int __init crash_save_vmcoreinfo_
 
 module_init(crash_save_vmcoreinfo_init)
 
-/**
- *	kernel_kexec - reboot the system
- *
- *	Move into place and start executing a preloaded standalone
- *	executable.  If nothing was preloaded return an error.
+/*
+ * Move into place and start executing a preloaded standalone
+ * executable.  If nothing was preloaded return an error.
  */
 int kernel_kexec(void)
 {
@@ -1443,8 +1441,8 @@ int kernel_kexec(void)
 		goto Unlock;
 	}
 
-	if (kexec_image->preserve_context) {
 #ifdef CONFIG_KEXEC_JUMP
+	if (kexec_image->preserve_context) {
 		mutex_lock(&pm_mutex);
 		pm_prepare_console();
 		error = freeze_processes();
@@ -1471,8 +1469,9 @@ int kernel_kexec(void)
 		if (error)
 			goto Enable_irqs;
 		save_processor_state();
+	} else
 #endif
-	} else {
+	{
 		blocking_notifier_call_chain(&reboot_notifier_list,
 					     SYS_RESTART, NULL);
 		system_state = SYSTEM_RESTART;
@@ -1484,8 +1483,8 @@ int kernel_kexec(void)
 
 	machine_kexec(kexec_image);
 
-	if (kexec_image->preserve_context) {
 #ifdef CONFIG_KEXEC_JUMP
+	if (kexec_image->preserve_context) {
 		restore_processor_state();
 		device_power_up(PMSG_RESTORE);
  Enable_irqs:
@@ -1499,8 +1498,8 @@ int kernel_kexec(void)
  Restore_console:
 		pm_restore_console();
 		mutex_unlock(&pm_mutex);
-#endif
 	}
+#endif
 
  Unlock:
 	xchg(&kexec_lock, 0);
_

Patches currently in -mm which might be from ying.huang@intel.com are

origin.patch
kexec-jump-clean-up-ifdef-and-comments.patch
kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size.patch
kexec-jump-check-code-size-in-control-page.patch
kexec-jump-remove-duplication-of-kexec_restart_prepare.patch
kexec-jump-in-sync-with-hibernation-implementation.patch
kexec-jump-__ftrace_enabled_save-restore.patch
kexec-jump-fix-for-ftrace.patch

