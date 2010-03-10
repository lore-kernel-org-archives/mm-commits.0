From: akpm@linux-foundation.org
Subject: [to-be-updated] sysctl-convert-poweroff_command-to-proc_rcu_string.patch removed from -mm tree
Date: Wed, 10 Mar 2010 12:29:57 -0800
Message-ID: <201003102029.o2AKTvOq001937@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757034Ab0CJUa2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 15:30:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@linux.intel.com, ebiederm@xmission.com, paulmck@us.ibm.com, rmk+lkml@arm.linux.org.uk, rusty@rustcorp.com.au, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     sysctl: convert poweroff_command to proc_rcu_string
has been removed from the -mm tree.  Its filename was
     sysctl-convert-poweroff_command-to-proc_rcu_string.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl: convert poweroff_command to proc_rcu_string
From: Andi Kleen <andi@firstfloor.org>

Avoids races with lockless sysctl.

Also saves ~220 bytes in the data segment for default kernels.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/reboot.h |    2 +-
 kernel/sys.c           |    8 ++++++--
 kernel/sysctl.c        |    2 +-
 3 files changed, 8 insertions(+), 4 deletions(-)

diff -puN include/linux/reboot.h~sysctl-convert-poweroff_command-to-proc_rcu_string include/linux/reboot.h
--- a/include/linux/reboot.h~sysctl-convert-poweroff_command-to-proc_rcu_string
+++ a/include/linux/reboot.h
@@ -67,7 +67,7 @@ extern void kernel_power_off(void);
 void ctrl_alt_del(void);
 
 #define POWEROFF_CMD_PATH_LEN	256
-extern char poweroff_cmd[POWEROFF_CMD_PATH_LEN];
+extern char *poweroff_cmd;
 
 extern int orderly_poweroff(bool force);
 
diff -puN kernel/sys.c~sysctl-convert-poweroff_command-to-proc_rcu_string kernel/sys.c
--- a/kernel/sys.c~sysctl-convert-poweroff_command-to-proc_rcu_string
+++ a/kernel/sys.c
@@ -1789,7 +1789,7 @@ SYSCALL_DEFINE3(getcpu, unsigned __user 
 	return err ? -EFAULT : 0;
 }
 
-char poweroff_cmd[POWEROFF_CMD_PATH_LEN] = "/sbin/poweroff";
+char *poweroff_cmd = "/sbin/poweroff";
 
 static void argv_cleanup(char **argv, char **envp)
 {
@@ -1806,7 +1806,7 @@ static void argv_cleanup(char **argv, ch
 int orderly_poweroff(bool force)
 {
 	int argc;
-	char **argv = argv_split(GFP_ATOMIC, poweroff_cmd, &argc);
+	char **argv;
 	static char *envp[] = {
 		"HOME=/",
 		"PATH=/sbin:/bin:/usr/sbin:/usr/bin",
@@ -1815,6 +1815,10 @@ int orderly_poweroff(bool force)
 	int ret = -ENOMEM;
 	struct subprocess_info *info;
 
+	/* RCU protection for poweroff_cmd */
+	rcu_read_lock();
+	argv = argv_split(GFP_ATOMIC, rcu_dereference(poweroff_cmd), &argc);
+	rcu_read_unlock();
 	if (argv == NULL) {
 		printk(KERN_WARNING "%s failed to allocate memory for \"%s\"\n",
 		       __func__, poweroff_cmd);
diff -puN kernel/sysctl.c~sysctl-convert-poweroff_command-to-proc_rcu_string kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-convert-poweroff_command-to-proc_rcu_string
+++ a/kernel/sysctl.c
@@ -886,7 +886,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &poweroff_cmd,
 		.maxlen		= POWEROFF_CMD_PATH_LEN,
 		.mode		= 0644,
-		.proc_handler	= proc_dostring,
+		.proc_handler	= proc_rcu_string,
 	},
 #ifdef CONFIG_KEYS
 	{
_

Patches currently in -mm which might be from andi@firstfloor.org are

mm-introduce-dump_page-and-print-symbolic-flag-names.patch
linux-next.patch
hardware-latency-detector-remove-default-m.patch
modpost-support-objects-with-more-than-64k-sections.patch
tracehooks-kill-some-pt_ptraced-checks.patch
tracehooks-check-pt_ptraced-before-reporting-the-single-step.patch
ptrace_signal-check-pt_ptraced-before-reporting-a-signal.patch
export-__ptrace_detach-and-do_notify_parent_cldstop.patch
reorder-the-code-in-kernel-ptracec.patch
implement-utrace-ptrace.patch
utrace-core.patch
sysctl-convert-poweroff_command-to-proc_rcu_string.patch
sysctl-convert-hotplug-helper-string-to-proc_rcu_string.patch
sysctl-use-rcu-protected-sysctl-for-ocfs-group-add-helper.patch
sysctl-fix-up-remaining-references-to-uevent_helper.patch
sysctl-fix-up-remaining-references-to-uevent_helper-fix.patch

