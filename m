From: akpm@linux-foundation.org
Subject: + sysctl-convert-poweroff_command-to-proc_rcu_string.patch added to -mm tree
Date: Fri, 08 Jan 2010 15:54:15 -0800
Message-ID: <201001082354.o08NsFD4021880@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754434Ab0AHXya (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jan 2010 18:54:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, ebiederm@xmission.com, paulmck@us.ibm.com, rmk+lkml@arm.linux.org.uk, rusty@rustcorp.com.au, sam@ravnborg.org


The patch titled
     sysctl: convert poweroff_command to proc_rcu_string
has been added to the -mm tree.  Its filename is
     sysctl-convert-poweroff_command-to-proc_rcu_string.patch

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
@@ -1726,7 +1726,7 @@ SYSCALL_DEFINE3(getcpu, unsigned __user 
 	return err ? -EFAULT : 0;
 }
 
-char poweroff_cmd[POWEROFF_CMD_PATH_LEN] = "/sbin/poweroff";
+char *poweroff_cmd = "/sbin/poweroff";
 
 static void argv_cleanup(char **argv, char **envp)
 {
@@ -1743,7 +1743,7 @@ static void argv_cleanup(char **argv, ch
 int orderly_poweroff(bool force)
 {
 	int argc;
-	char **argv = argv_split(GFP_ATOMIC, poweroff_cmd, &argc);
+	char **argv;
 	static char *envp[] = {
 		"HOME=/",
 		"PATH=/sbin:/bin:/usr/sbin:/usr/bin",
@@ -1752,6 +1752,10 @@ int orderly_poweroff(bool force)
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
@@ -871,7 +871,7 @@ static struct ctl_table kern_table[] = {
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

kernel-signalc-fix-kernel-information-leak-with-print-fatal-signals=1.patch
proc-revert-procfs-provide-stack-information-for-threads.patch
kfifo-use-void-pointers-for-user-buffers.patch
kfifo-sanitize-_user-error-handling.patch
kfifo-add-kfifo_out_peek.patch
kfifo-add-kfifo_initialized.patch
kfifo-document-everywhere-that-size-has-to-be-power-of-two.patch
hardware-latency-detector-remove-default-m.patch
kbuild-move-fno-dwarf2-cfi-asm-to-powerpc-only.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
coredump-unify-dump_seek-implementations-for-each-binfmt_c.patch
coredump-move-dump_write-and-dump_seek-into-a-header-file.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions.patch
elf-coredump-make-offset-calculation-process-and-writing-process-explicit.patch
elf-coredump-add-extended-numbering-support.patch
tracehooks-kill-some-pt_ptraced-checks.patch
tracehooks-check-pt_ptraced-before-reporting-the-single-step.patch
ptrace_signal-check-pt_ptraced-before-reporting-a-signal.patch
export-__ptrace_detach-and-do_notify_parent_cldstop.patch
reorder-the-code-in-kernel-ptracec.patch
implement-utrace-ptrace.patch
utrace-core.patch
rcu-add-rcustring-adt-for-rcu-protected-strings.patch
add-a-kernel_address-that-works-for-data-too.patch
sysctl-add-proc_rcu_string-to-manage-sysctls-using-rcu-strings.patch
sysctl-use-rcu-strings-for-core_pattern-sysctl.patch
sysctl-add-call_usermodehelper_cleanup.patch
sysctl-convert-modprobe_path-to-proc_rcu_string.patch
sysctl-convert-poweroff_command-to-proc_rcu_string.patch
sysctl-convert-hotplug-helper-string-to-proc_rcu_string.patch
sysctl-use-rcu-protected-sysctl-for-ocfs-group-add-helper.patch

