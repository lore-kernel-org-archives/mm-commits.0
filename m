From: akpm@linux-foundation.org
Subject: - kexec-jump-clean-up-ifdef-and-comments.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:39:23 -0700
Message-ID: <200808181939.m7IJdNIg008292@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59759 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762693AbYHRTkI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:40:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, ebiederm@xmission.com, mingo@elte.hu, pavel@ucw.cz, rjw@sisk.pl, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kexec jump: clean up #ifdef and comments
has been removed from the -mm tree.  Its filename was
     kexec-jump-clean-up-ifdef-and-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 	if (!xchg(&kexec_lock, 0))
_

Patches currently in -mm which might be from ying.huang@intel.com are

origin.patch

