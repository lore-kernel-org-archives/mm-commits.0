Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B8D22AE65
	for <mm-commits@vger.kernel.org>; Mon, 13 Oct 2025 23:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760399262; cv=none; b=Fp8fvhGFpyjb/1O13wiCma7Py+LaymhvOf3Wa2nQtiZPPjqUx1gKHYFsMRgJl09w2rsey6UOi47jSLZ3z6C+LhjEBdkXA2pJj2HGRCFrPZ7zlmm6VORigPEK6Rkcvf2vSkkFmddNEj5PqVgYM5SJrC9FadHEnwvxQokiNmxSfRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760399262; c=relaxed/simple;
	bh=02TOffIphDhhPRpKszpm+NOhHjFbpjUYWrzRt3dCS3s=;
	h=Date:To:From:Subject:Message-Id; b=qpycBxOTcM1mJhIgoCS64Nq25rfGl635PMGrt3VMo9ieW+Hc8jN5C+8EzziGEZZ1hHd5aff9ZgBvpvOLyQH0r5oYDmIVI7sP51UHN+f9DbuSEBeaE96b6Q9bcTwtfEWEAw/iot/IbAVi1fcW+puTcoIaa4SsLEgijp6Te2zg9mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=coSOG09c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="coSOG09c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E283C4CEFE;
	Mon, 13 Oct 2025 23:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760399261;
	bh=02TOffIphDhhPRpKszpm+NOhHjFbpjUYWrzRt3dCS3s=;
	h=Date:To:From:Subject:From;
	b=coSOG09c4StznQOS8lEEdU/8rboGCdXTMA+aWgfX6s9UtNPJYFxL7kuNe0p9zPR44
	 qxNDVjSKFl7GGuYbZCSpdqaz516HR4zkxb80NG+LvhBdwslWJvZzJL47/VdG1Hmee3
	 oZ6hE8Bp6jW2Z9BL8pBBbKZcseraoUJf200L/bL8=
Date: Mon, 13 Oct 2025 16:47:40 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sdf@fomichev.me,rostedt@goodmis.org,rdunlap@infradead.org,pmladek@suse.com,pawan.kumar.gupta@linux.intel.com,paulmck@kernel.org,pauld@redhat.com,mhiramat@kernel.org,lorenzo.stoakes@oracle.com,linux@armlinux.org.uk,liam.howlett@oracle.com,lance.yang@linux.dev,kuba@kernel.org,kees@kernel.org,joel@jms.id.au,joel.granados@kernel.org,jason@zx2c4.com,horms@kernel.org,fw@strlen.de,david@redhat.com,corbet@lwn.net,arnd@arndb.de,anshuman.khandual@arm.com,andrew@codeconstruct.com.au,lirongqing@baidu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hung_task-panic-after-fixed-number-of-hung-tasks.patch added to mm-nonmm-unstable branch
Message-Id: <20251013234741.5E283C4CEFE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hung_task: panic after fixed number of hung tasks
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hung_task-panic-after-fixed-number-of-hung-tasks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hung_task-panic-after-fixed-number-of-hung-tasks.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Li RongQing <lirongqing@baidu.com>
Subject: hung_task: panic after fixed number of hung tasks
Date: Sun, 12 Oct 2025 19:50:35 +0800

Currently, when 'hung_task_panic' is enabled, the kernel panics
immediately upon detecting the first hung task.  However, some hung tasks
are transient and the system can recover, while others are persistent and
may accumulate progressively.

This patch extends the 'hung_task_panic' sysctl to allow specifying the
number of hung tasks that must be detected before triggering a kernel
panic.  This provides finer control for environments where transient hangs
may occur but persistent hangs should still be fatal.

The sysctl can be set to:
- 0: disabled (never panic)
- 1: original behavior (panic on first hung task)
- N: panic when N hung tasks are detected

This maintains backward compatibility while providing more flexibility
for handling different hang scenarios.

Link: https://lkml.kernel.org/r/20251012115035.2169-1-lirongqing@baidu.com
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Cc: Andrew Jeffery <andrew@codeconstruct.com.au>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Florian Wesphal <fw@strlen.de>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Joel Stanley <joel@jms.id.au>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <kees@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Phil Auld <pauld@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Simon Horman <horms@kernel.org>
Cc: Stanislav Fomichev <sdf@fomichev.me>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt      |   20 ++++++----
 Documentation/admin-guide/sysctl/kernel.rst          |    3 +
 arch/arm/configs/aspeed_g5_defconfig                 |    2 -
 kernel/configs/debug.config                          |    2 -
 kernel/hung_task.c                                   |   16 +++++---
 lib/Kconfig.debug                                    |   10 +++--
 tools/testing/selftests/wireguard/qemu/kernel.config |    2 -
 7 files changed, 35 insertions(+), 20 deletions(-)

--- a/arch/arm/configs/aspeed_g5_defconfig~hung_task-panic-after-fixed-number-of-hung-tasks
+++ a/arch/arm/configs/aspeed_g5_defconfig
@@ -308,7 +308,7 @@ CONFIG_PANIC_ON_OOPS=y
 CONFIG_PANIC_TIMEOUT=-1
 CONFIG_SOFTLOCKUP_DETECTOR=y
 CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
-CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
+CONFIG_BOOTPARAM_HUNG_TASK_PANIC=1
 CONFIG_WQ_WATCHDOG=y
 # CONFIG_SCHED_DEBUG is not set
 CONFIG_FUNCTION_TRACER=y
--- a/Documentation/admin-guide/kernel-parameters.txt~hung_task-panic-after-fixed-number-of-hung-tasks
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -2010,14 +2010,20 @@
 			the added memory block itself do not be affected.
 
 	hung_task_panic=
-			[KNL] Should the hung task detector generate panics.
-			Format: 0 | 1
+			[KNL] Number of hung tasks to trigger kernel panic.
+			Format: <int>
 
-			A value of 1 instructs the kernel to panic when a
-			hung task is detected. The default value is controlled
-			by the CONFIG_BOOTPARAM_HUNG_TASK_PANIC build-time
-			option. The value selected by this boot parameter can
-			be changed later by the kernel.hung_task_panic sysctl.
+			Set this to the number of hung tasks that must be
+			detected before triggering a kernel panic.
+
+			0: don't panic
+			1: panic immediately on first hung task
+			N: panic after N hung tasks are detect
+
+			The default value is controlled by the
+			CONFIG_BOOTPARAM_HUNG_TASK_PANIC build-time option. The value
+			selected by this boot parameter can be changed later by the
+			kernel.hung_task_panic sysctl.
 
 	hvc_iucv=	[S390]	Number of z/VM IUCV hypervisor console (HVC)
 				terminal devices. Valid values: 0..8
--- a/Documentation/admin-guide/sysctl/kernel.rst~hung_task-panic-after-fixed-number-of-hung-tasks
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -397,7 +397,8 @@ a hung task is detected.
 hung_task_panic
 ===============
 
-Controls the kernel's behavior when a hung task is detected.
+When set to a non-zero value, a kernel panic will be triggered if the
+number of detected hung tasks reaches this value
 This file shows up if ``CONFIG_DETECT_HUNG_TASK`` is enabled.
 
 = =================================================
--- a/kernel/configs/debug.config~hung_task-panic-after-fixed-number-of-hung-tasks
+++ a/kernel/configs/debug.config
@@ -83,7 +83,7 @@ CONFIG_SLUB_DEBUG_ON=y
 #
 # Debug Oops, Lockups and Hangs
 #
-# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
+CONFIG_BOOTPARAM_HUNG_TASK_PANIC=0
 # CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
 CONFIG_DEBUG_ATOMIC_SLEEP=y
 CONFIG_DETECT_HUNG_TASK=y
--- a/kernel/hung_task.c~hung_task-panic-after-fixed-number-of-hung-tasks
+++ a/kernel/hung_task.c
@@ -81,7 +81,7 @@ static unsigned int __read_mostly sysctl
  * hung task is detected:
  */
 static unsigned int __read_mostly sysctl_hung_task_panic =
-	IS_ENABLED(CONFIG_BOOTPARAM_HUNG_TASK_PANIC);
+	CONFIG_BOOTPARAM_HUNG_TASK_PANIC;
 
 static int
 hung_task_panic(struct notifier_block *this, unsigned long event, void *ptr)
@@ -218,8 +218,11 @@ static inline void debug_show_blocker(st
 }
 #endif
 
-static void check_hung_task(struct task_struct *t, unsigned long timeout)
+static void check_hung_task(struct task_struct *t, unsigned long timeout,
+		unsigned long prev_detect_count)
 {
+	unsigned long total_hung_task;
+
 	if (!task_is_hung(t, timeout))
 		return;
 
@@ -229,9 +232,11 @@ static void check_hung_task(struct task_
 	 */
 	sysctl_hung_task_detect_count++;
 
+	total_hung_task = sysctl_hung_task_detect_count - prev_detect_count;
 	trace_sched_process_hang(t);
 
-	if (sysctl_hung_task_panic) {
+	if (sysctl_hung_task_panic &&
+			(total_hung_task >= sysctl_hung_task_panic)) {
 		console_verbose();
 		hung_task_show_lock = true;
 		hung_task_call_panic = true;
@@ -300,6 +305,7 @@ static void check_hung_uninterruptible_t
 	int max_count = sysctl_hung_task_check_count;
 	unsigned long last_break = jiffies;
 	struct task_struct *g, *t;
+	unsigned long prev_detect_count = sysctl_hung_task_detect_count;
 
 	/*
 	 * If the system crashed already then all bets are off,
@@ -320,7 +326,7 @@ static void check_hung_uninterruptible_t
 			last_break = jiffies;
 		}
 
-		check_hung_task(t, timeout);
+		check_hung_task(t, timeout, prev_detect_count);
 	}
  unlock:
 	rcu_read_unlock();
@@ -389,7 +395,7 @@ static const struct ctl_table hung_task_
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
+		.extra2		= SYSCTL_INT_MAX,
 	},
 	{
 		.procname	= "hung_task_check_count",
--- a/lib/Kconfig.debug~hung_task-panic-after-fixed-number-of-hung-tasks
+++ a/lib/Kconfig.debug
@@ -1257,12 +1257,14 @@ config DEFAULT_HUNG_TASK_TIMEOUT
 	  Keeping the default should be fine in most cases.
 
 config BOOTPARAM_HUNG_TASK_PANIC
-	bool "Panic (Reboot) On Hung Tasks"
+	int "Number of hung tasks to trigger kernel panic"
 	depends on DETECT_HUNG_TASK
+	default 0
 	help
-	  Say Y here to enable the kernel to panic on "hung tasks",
-	  which are bugs that cause the kernel to leave a task stuck
-	  in uninterruptible "D" state.
+	  The number of hung tasks must be detected to trigger kernel panic.
+
+	  - 0: Don't trigger panic
+	  - N: Panic when N hung tasks are detected
 
 	  The panic can be used in combination with panic_timeout,
 	  to cause the system to reboot automatically after a
--- a/tools/testing/selftests/wireguard/qemu/kernel.config~hung_task-panic-after-fixed-number-of-hung-tasks
+++ a/tools/testing/selftests/wireguard/qemu/kernel.config
@@ -81,7 +81,7 @@ CONFIG_WQ_WATCHDOG=y
 CONFIG_DETECT_HUNG_TASK=y
 CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
 CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
-CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
+CONFIG_BOOTPARAM_HUNG_TASK_PANIC=1
 CONFIG_PANIC_TIMEOUT=-1
 CONFIG_STACKTRACE=y
 CONFIG_EARLY_PRINTK=y
_

Patches currently in -mm which might be from lirongqing@baidu.com are

hung_task-panic-after-fixed-number-of-hung-tasks.patch

