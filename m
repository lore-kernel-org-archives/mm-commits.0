From: akpm@linux-foundation.org
Subject: [merged] kernel-add-panic_on_warn.patch removed from -mm tree
Date: Thu, 11 Dec 2014 10:58:39 -0800
Message-ID: <5489e95f.FrHuEtAGhJC/1jF6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45543 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758526AbaLKS6k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:58:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: prarit@redhat.com, ak@linux.intel.com, corbet@lwn.net, fabf@skynet.be, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, masami.hiramatsu.pt@hitachi.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel: add panic_on_warn
has been removed from the -mm tree.  Its filename was
     kernel-add-panic_on_warn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Prarit Bhargava <prarit@redhat.com>
Subject: kernel: add panic_on_warn

There have been several times where I have had to rebuild a kernel to
cause a panic when hitting a WARN() in the code in order to get a crash
dump from a system.  Sometimes this is easy to do, other times (such as in
the case of a remote admin) it is not trivial to send new images to the
user.

A much easier method would be a switch to change the WARN() over to a
panic.  This makes debugging easier in that I can now test the actual
image the WARN() was seen on and I do not have to engage in remote
debugging.

This patch adds a panic_on_warn kernel parameter and
/proc/sys/kernel/panic_on_warn calls panic() in the warn_slowpath_common()
path.  The function will still print out the location of the warning.

An example of the panic_on_warn output:

The first line below is from the WARN_ON() to output the WARN_ON()'s
location.  After that the panic() output is displayed.

WARNING: CPU: 30 PID: 11698 at /home/prarit/dummy_module/dummy-module.c:25 init_dummy+0x1f/0x30 [dummy_module]()
Kernel panic - not syncing: panic_on_warn set ...

CPU: 30 PID: 11698 Comm: insmod Tainted: G        W  OE  3.17.0+ #57
Hardware name: Intel Corporation S2600CP/S2600CP, BIOS RMLSDP.86I.00.29.D696.1311111329 11/11/2013
 0000000000000000 000000008e3f87df ffff88080f093c38 ffffffff81665190
 0000000000000000 ffffffff818aea3d ffff88080f093cb8 ffffffff8165e2ec
 ffffffff00000008 ffff88080f093cc8 ffff88080f093c68 000000008e3f87df
Call Trace:
 [<ffffffff81665190>] dump_stack+0x46/0x58
 [<ffffffff8165e2ec>] panic+0xd0/0x204
 [<ffffffffa038e05f>] ? init_dummy+0x1f/0x30 [dummy_module]
 [<ffffffff81076b90>] warn_slowpath_common+0xd0/0xd0
 [<ffffffffa038e040>] ? dummy_greetings+0x40/0x40 [dummy_module]
 [<ffffffff81076c8a>] warn_slowpath_null+0x1a/0x20
 [<ffffffffa038e05f>] init_dummy+0x1f/0x30 [dummy_module]
 [<ffffffff81002144>] do_one_initcall+0xd4/0x210
 [<ffffffff811b52c2>] ? __vunmap+0xc2/0x110
 [<ffffffff810f8889>] load_module+0x16a9/0x1b30
 [<ffffffff810f3d30>] ? store_uevent+0x70/0x70
 [<ffffffff810f49b9>] ? copy_module_from_fd.isra.44+0x129/0x180
 [<ffffffff810f8ec6>] SyS_finit_module+0xa6/0xd0
 [<ffffffff8166cf29>] system_call_fastpath+0x12/0x17

Successfully tested by me.

hpa said: There is another very valid use for this: many operators would
rather a machine shuts down than being potentially compromised either
functionally or security-wise.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Acked-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kdump/kdump.txt       |    7 ++++
 Documentation/kernel-parameters.txt |    3 +
 Documentation/sysctl/kernel.txt     |   40 ++++++++++++++++----------
 include/linux/kernel.h              |    1 
 include/uapi/linux/sysctl.h         |    1 
 kernel/panic.c                      |   13 ++++++++
 kernel/sysctl.c                     |    9 +++++
 kernel/sysctl_binary.c              |    1 
 8 files changed, 61 insertions(+), 14 deletions(-)

diff -puN Documentation/kdump/kdump.txt~kernel-add-panic_on_warn Documentation/kdump/kdump.txt
--- a/Documentation/kdump/kdump.txt~kernel-add-panic_on_warn
+++ a/Documentation/kdump/kdump.txt
@@ -471,6 +471,13 @@ format. Crash is available on Dave Ander
 
    http://people.redhat.com/~anderson/
 
+Trigger Kdump on WARN()
+=======================
+
+The kernel parameter, panic_on_warn, calls panic() in all WARN() paths.  This
+will cause a kdump to occur at the panic() call.  In cases where a user wants
+to specify this during runtime, /proc/sys/kernel/panic_on_warn can be set to 1
+to achieve the same behaviour.
 
 Contact
 =======
diff -puN Documentation/kernel-parameters.txt~kernel-add-panic_on_warn Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~kernel-add-panic_on_warn
+++ a/Documentation/kernel-parameters.txt
@@ -2509,6 +2509,9 @@ bytes respectively. Such letter suffixes
 			timeout < 0: reboot immediately
 			Format: <timeout>
 
+	panic_on_warn	panic() instead of WARN().  Useful to cause kdump
+			on a WARN().
+
 	crash_kexec_post_notifiers
 			Run kdump after running panic-notifiers and dumping
 			kmsg. This only for the users who doubt kdump always
diff -puN Documentation/sysctl/kernel.txt~kernel-add-panic_on_warn Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~kernel-add-panic_on_warn
+++ a/Documentation/sysctl/kernel.txt
@@ -54,8 +54,9 @@ show up in /proc/sys/kernel:
 - overflowuid
 - panic
 - panic_on_oops
-- panic_on_unrecovered_nmi
 - panic_on_stackoverflow
+- panic_on_unrecovered_nmi
+- panic_on_warn
 - pid_max
 - powersave-nap               [ PPC only ]
 - printk
@@ -527,19 +528,6 @@ the recommended setting is 60.
 
 ==============================================================
 
-panic_on_unrecovered_nmi:
-
-The default Linux behaviour on an NMI of either memory or unknown is
-to continue operation. For many environments such as scientific
-computing it is preferable that the box is taken out and the error
-dealt with than an uncorrected parity/ECC error get propagated.
-
-A small number of systems do generate NMI's for bizarre random reasons
-such as power management so the default is off. That sysctl works like
-the existing panic controls already in that directory.
-
-==============================================================
-
 panic_on_oops:
 
 Controls the kernel's behaviour when an oops or BUG is encountered.
@@ -563,6 +551,30 @@ This file shows up if CONFIG_DEBUG_STACK
 
 ==============================================================
 
+panic_on_unrecovered_nmi:
+
+The default Linux behaviour on an NMI of either memory or unknown is
+to continue operation. For many environments such as scientific
+computing it is preferable that the box is taken out and the error
+dealt with than an uncorrected parity/ECC error get propagated.
+
+A small number of systems do generate NMI's for bizarre random reasons
+such as power management so the default is off. That sysctl works like
+the existing panic controls already in that directory.
+
+==============================================================
+
+panic_on_warn:
+
+Calls panic() in the WARN() path when set to 1.  This is useful to avoid
+a kernel rebuild when attempting to kdump at the location of a WARN().
+
+0: only WARN(), default behaviour.
+
+1: call panic() after printing out WARN() location.
+
+==============================================================
+
 perf_cpu_time_max_percent:
 
 Hints to the kernel how much CPU time it should be allowed to
diff -puN include/linux/kernel.h~kernel-add-panic_on_warn include/linux/kernel.h
--- a/include/linux/kernel.h~kernel-add-panic_on_warn
+++ a/include/linux/kernel.h
@@ -427,6 +427,7 @@ extern int panic_timeout;
 extern int panic_on_oops;
 extern int panic_on_unrecovered_nmi;
 extern int panic_on_io_nmi;
+extern int panic_on_warn;
 extern int sysctl_panic_on_stackoverflow;
 /*
  * Only to be used by arch init code. If the user over-wrote the default
diff -puN include/uapi/linux/sysctl.h~kernel-add-panic_on_warn include/uapi/linux/sysctl.h
--- a/include/uapi/linux/sysctl.h~kernel-add-panic_on_warn
+++ a/include/uapi/linux/sysctl.h
@@ -153,6 +153,7 @@ enum
 	KERN_MAX_LOCK_DEPTH=74, /* int: rtmutex's maximum lock depth */
 	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
 	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
+	KERN_PANIC_ON_WARN=77, /* int: call panic() in WARN() functions */
 };
 
 
diff -puN kernel/panic.c~kernel-add-panic_on_warn kernel/panic.c
--- a/kernel/panic.c~kernel-add-panic_on_warn
+++ a/kernel/panic.c
@@ -33,6 +33,7 @@ static int pause_on_oops;
 static int pause_on_oops_flag;
 static DEFINE_SPINLOCK(pause_on_oops_lock);
 static bool crash_kexec_post_notifiers;
+int panic_on_warn __read_mostly;
 
 int panic_timeout = CONFIG_PANIC_TIMEOUT;
 EXPORT_SYMBOL_GPL(panic_timeout);
@@ -428,6 +429,17 @@ static void warn_slowpath_common(const c
 	if (args)
 		vprintk(args->fmt, args->args);
 
+	if (panic_on_warn) {
+		/*
+		 * This thread may hit another WARN() in the panic path.
+		 * Resetting this prevents additional WARN() from panicking the
+		 * system on this thread.  Other threads are blocked by the
+		 * panic_mutex in panic().
+		 */
+		panic_on_warn = 0;
+		panic("panic_on_warn set ...\n");
+	}
+
 	print_modules();
 	dump_stack();
 	print_oops_end_marker();
@@ -485,6 +497,7 @@ EXPORT_SYMBOL(__stack_chk_fail);
 
 core_param(panic, panic_timeout, int, 0644);
 core_param(pause_on_oops, pause_on_oops, int, 0644);
+core_param(panic_on_warn, panic_on_warn, int, 0644);
 
 static int __init setup_crash_kexec_post_notifiers(char *s)
 {
diff -puN kernel/sysctl.c~kernel-add-panic_on_warn kernel/sysctl.c
--- a/kernel/sysctl.c~kernel-add-panic_on_warn
+++ a/kernel/sysctl.c
@@ -1104,6 +1104,15 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
+	{
+		.procname	= "panic_on_warn",
+		.data		= &panic_on_warn,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
 	{ }
 };
 
diff -puN kernel/sysctl_binary.c~kernel-add-panic_on_warn kernel/sysctl_binary.c
--- a/kernel/sysctl_binary.c~kernel-add-panic_on_warn
+++ a/kernel/sysctl_binary.c
@@ -137,6 +137,7 @@ static const struct bin_table bin_kern_t
 	{ CTL_INT,	KERN_COMPAT_LOG,		"compat-log" },
 	{ CTL_INT,	KERN_MAX_LOCK_DEPTH,		"max_lock_depth" },
 	{ CTL_INT,	KERN_PANIC_ON_NMI,		"panic_on_unrecovered_nmi" },
+	{ CTL_INT,	KERN_PANIC_ON_WARN,		"panic_on_warn" },
 	{}
 };
 
_

Patches currently in -mm which might be from prarit@redhat.com are

origin.patch
linux-next.patch

