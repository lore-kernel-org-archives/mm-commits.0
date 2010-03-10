From: akpm@linux-foundation.org
Subject: [to-be-updated] sysctl-convert-modprobe_path-to-proc_rcu_string.patch removed from -mm tree
Date: Wed, 10 Mar 2010 12:29:54 -0800
Message-ID: <201003102029.o2AKTs6t001927@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58571 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757032Ab0CJUa0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 15:30:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@linux.intel.com, ebiederm@xmission.com, paulmck@us.ibm.com, rmk+lkml@arm.linux.org.uk, rusty@rustcorp.com.au, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     sysctl: convert modprobe_path to proc_rcu_string()
has been removed from the -mm tree.  Its filename was
     sysctl-convert-modprobe_path-to-proc_rcu_string.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl: convert modprobe_path to proc_rcu_string()
From: Andi Kleen <andi@firstfloor.org>

Avoids races with lockless sysctl

Also saves ~220 bytes in the data segment for default kernels.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c   |   36 ++++++++++++++++++++++++++++--------
 kernel/sysctl.c |    4 ++--
 2 files changed, 30 insertions(+), 10 deletions(-)

diff -puN kernel/kmod.c~sysctl-convert-modprobe_path-to-proc_rcu_string kernel/kmod.c
--- a/kernel/kmod.c~sysctl-convert-modprobe_path-to-proc_rcu_string
+++ a/kernel/kmod.c
@@ -35,6 +35,7 @@
 #include <linux/resource.h>
 #include <linux/notifier.h>
 #include <linux/suspend.h>
+#include <linux/rcustring.h>
 #include <asm/uaccess.h>
 
 #include <trace/events/module.h>
@@ -48,7 +49,12 @@ static struct workqueue_struct *khelper_
 /*
 	modprobe_path is set via /proc/sys.
 */
-char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";
+char *modprobe_path = "/sbin/modprobe";
+
+static void free_arg(char **argv, char **env)
+{
+	kfree(argv[0]);
+}
 
 /**
  * __request_module - try to load a kernel module
@@ -71,7 +77,8 @@ int __request_module(bool wait, const ch
 	char module_name[MODULE_NAME_LEN];
 	unsigned int max_modprobes;
 	int ret;
-	char *argv[] = { modprobe_path, "-q", "--", module_name, NULL };
+	char *mp_copy;
+	char *argv[] = { NULL, "-q", "--", module_name, NULL };
 	static char *envp[] = { "HOME=/",
 				"TERM=linux",
 				"PATH=/sbin:/usr/sbin:/bin:/usr/bin",
@@ -80,15 +87,24 @@ int __request_module(bool wait, const ch
 #define MAX_KMOD_CONCURRENT 50	/* Completely arbitrary value - KAO */
 	static int kmod_loop_msg;
 
+	/* Get a stable-over-sleeps private copy of modprobe_path */
+	mp_copy = access_rcu_string(&modprobe_path, KMOD_PATH_LEN,
+					wait ? GFP_KERNEL : GFP_ATOMIC);
+	if (!mp_copy)
+		return -ENOMEM;
+	argv[0] = mp_copy;
+
 	va_start(args, fmt);
 	ret = vsnprintf(module_name, MODULE_NAME_LEN, fmt, args);
 	va_end(args);
-	if (ret >= MODULE_NAME_LEN)
-		return -ENAMETOOLONG;
+	if (ret >= MODULE_NAME_LEN) {
+		ret = -ENAMETOOLONG;
+		goto error;
+	}
 
 	ret = security_kernel_module_request(module_name);
 	if (ret)
-		return ret;
+		goto error;
 
 	/* If modprobe needs a service that is in a module, we get a recursive
 	 * loop.  Limit the number of running kmod threads to max_threads/2 or
@@ -111,14 +127,18 @@ int __request_module(bool wait, const ch
 			       "request_module: runaway loop modprobe %s\n",
 			       module_name);
 		atomic_dec(&kmod_concurrent);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto error;
 	}
 
 	trace_module_request(module_name, wait, _RET_IP_);
 
-	ret = call_usermodehelper(modprobe_path, argv, envp,
-			wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC);
+	ret = call_usermodehelper_cleanup(mp_copy, argv, envp,
+			wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC, free_arg);
+	mp_copy = NULL; /* free_arg frees */
 	atomic_dec(&kmod_concurrent);
+error:
+	kfree(mp_copy);
 	return ret;
 }
 EXPORT_SYMBOL(__request_module);
diff -puN kernel/sysctl.c~sysctl-convert-modprobe_path-to-proc_rcu_string kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-convert-modprobe_path-to-proc_rcu_string
+++ a/kernel/sysctl.c
@@ -127,7 +127,7 @@ static int min_percpu_pagelist_fract = 8
 static int ngroups_max = NGROUPS_MAX;
 
 #ifdef CONFIG_MODULES
-extern char modprobe_path[];
+extern char *modprobe_path;
 extern int modules_disabled;
 #endif
 #ifdef CONFIG_CHR_DEV_SG
@@ -538,7 +538,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &modprobe_path,
 		.maxlen		= KMOD_PATH_LEN,
 		.mode		= 0644,
-		.proc_handler	= proc_dostring,
+		.proc_handler	= proc_rcu_string,
 	},
 	{
 		.procname	= "modules_disabled",
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
sysctl-convert-modprobe_path-to-proc_rcu_string.patch
sysctl-convert-poweroff_command-to-proc_rcu_string.patch
sysctl-convert-hotplug-helper-string-to-proc_rcu_string.patch
sysctl-use-rcu-protected-sysctl-for-ocfs-group-add-helper.patch
sysctl-fix-up-remaining-references-to-uevent_helper.patch
sysctl-fix-up-remaining-references-to-uevent_helper-fix.patch

