Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1261F2D24AC
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 21:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760565123; cv=none; b=YQl33bXnoah87bml1B7oYlwGyW+X3PE85pOkdTRlJMe/wg1FVX5uVYT5fqNlCY4ZqLwLil64Pc5D39DWVM7m7ipIa3WjDtOoFHtc8yvGHuggfSlBMz9EMcQc05SutmKYF/iPdNNPfSUdKAejKYa9v/fpZXNvQfzLxBxQnA/6Kyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760565123; c=relaxed/simple;
	bh=UjZd9WXAmeC9bS5seaHr8QwIa1fVldXzbEzwbL1pYgI=;
	h=Date:To:From:Subject:Message-Id; b=saXK45kLIOWpzjzF5AT4vncT18PAywW7jOE0zfm6SHRXqjHaOOO0oYYzIT6zLnBIpcsfMk92me0cmaJDlaBYQMx2O77hjS2IL3/z9uFZ+PjL8/Rz5sI0U/NnjXpZ5BIpNH/lXLv06LRXFMyqoBmw2V8JSfGB9dO+6D5uCYMLxvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hsWC3tZY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hsWC3tZY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D764C4CEF8;
	Wed, 15 Oct 2025 21:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760565122;
	bh=UjZd9WXAmeC9bS5seaHr8QwIa1fVldXzbEzwbL1pYgI=;
	h=Date:To:From:Subject:From;
	b=hsWC3tZYkeJ/r1Rceu+WBS41chYw0My4uEX4LhPBxuzGVGX29EKbsmYDBgJSOEUb9
	 54LCCFXgowyN8r6/fcNgmB4NBhpARfZIvYsNjE63xJm3cF1Qz/PVHogFKd4S83ClZ8
	 4ia7likloMK7u+6hxkfLh/1G1/7+CatQJwjGyyXo=
Date: Wed, 15 Oct 2025 14:52:01 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sdf@fomichev.me,rostedt@goodmis.org,rdunlap@infradead.org,pmladek@suse.com,pawan.kumar.gupta@linux.intel.com,paulmck@kernel.org,pauld@redhat.com,mhiramat@kernel.org,lorenzo.stoakes@oracle.com,linux@armlinux.org.uk,liam.howlett@oracle.com,lance.yang@linux.dev,kuba@kernel.org,kees@kernel.org,joel@jms.id.au,joel.granados@kernel.org,jason@zx2c4.com,horms@kernel.org,fw@strlen.de,david@redhat.com,corbet@lwn.net,arnd@arndb.de,anshuman.khandual@arm.com,andrew@codeconstruct.com.au,lirongqing@baidu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hung_task-panic-when-there-are-more-than-n-hung-tasks-at-the-same-time.patch added to mm-nonmm-unstable branch
Message-Id: <20251015215202.7D764C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hung_task: Panic when there are more than N hung tasks at the same time
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hung_task-panic-when-there-are-more-than-n-hung-tasks-at-the-same-time.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hung_task-panic-when-there-are-more-than-n-hung-tasks-at-the-same-time.patch

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
Subject: hung_task: Panic when there are more than N hung tasks at the same time
Date: Wed, 15 Oct 2025 14:36:15 +0800

Currently, when 'hung_task_panic' is enabled, the kernel panics
immediately upon detecting the first hung task.  However, some hung tasks
are transient and allow system recovery, while persistent hangs should
trigger a panic when accumulating beyond a threshold.

Extend the 'hung_task_panic' sysctl to accept a threshold value specifying
the number of hung tasks that must be detected before triggering a kernel
panic.  This provides finer control for environments where transient hangs
may occur but persistent hangs should be fatal.

The sysctl now accepts:
- 0: don't panic (maintains original behavior)
- 1: panic on first hung task (maintains original behavior)
- N > 1: panic after N hung tasks are detected in a single scan

This maintains backward compatibility while providing flexibility for
different hang scenarios.

Link: https://lkml.kernel.org/r/20251015063615.2632-1-lirongqing@baidu.com
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
 Documentation/admin-guide/sysctl/kernel.rst          |    9 ++--
 arch/arm/configs/aspeed_g5_defconfig                 |    2 -
 kernel/configs/debug.config                          |    2 -
 kernel/hung_task.c                                   |   15 +++++--
 lib/Kconfig.debug                                    |    9 ++--
 tools/testing/selftests/wireguard/qemu/kernel.config |    2 -
 7 files changed, 36 insertions(+), 23 deletions(-)

--- a/arch/arm/configs/aspeed_g5_defconfig~hung_task-panic-when-there-are-more-than-n-hung-tasks-at-the-same-time
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
--- a/Documentation/admin-guide/kernel-parameters.txt~hung_task-panic-when-there-are-more-than-n-hung-tasks-at-the-same-time
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
+			When set to a non-zero value, a kernel panic will be triggered if
+			the number of detected hung tasks reaches this value.
+
+			0: don't panic
+			1: panic immediately on first hung task
+			N: panic after N hung tasks are detected in a single scan
+
+			The default value is controlled by the
+			CONFIG_BOOTPARAM_HUNG_TASK_PANIC build-time option. The value
+			selected by this boot parameter can be changed later by the
+			kernel.hung_task_panic sysctl.
 
 	hvc_iucv=	[S390]	Number of z/VM IUCV hypervisor console (HVC)
 				terminal devices. Valid values: 0..8
--- a/Documentation/admin-guide/sysctl/kernel.rst~hung_task-panic-when-there-are-more-than-n-hung-tasks-at-the-same-time
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -397,13 +397,14 @@ a hung task is detected.
 hung_task_panic
 ===============
 
-Controls the kernel's behavior when a hung task is detected.
+When set to a non-zero value, a kernel panic will be triggered if the
+number of hung tasks found during a single scan reaches this value.
 This file shows up if ``CONFIG_DETECT_HUNG_TASK`` is enabled.
 
-= =================================================
+= =======================================================
 0 Continue operation. This is the default behavior.
-1 Panic immediately.
-= =================================================
+N Panic when N hung tasks are found during a single scan.
+= =======================================================
 
 
 hung_task_check_count
--- a/kernel/configs/debug.config~hung_task-panic-when-there-are-more-than-n-hung-tasks-at-the-same-time
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
--- a/kernel/hung_task.c~hung_task-panic-when-there-are-more-than-n-hung-tasks-at-the-same-time
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
 
@@ -229,9 +232,10 @@ static void check_hung_task(struct task_
 	 */
 	sysctl_hung_task_detect_count++;
 
+	total_hung_task = sysctl_hung_task_detect_count - prev_detect_count;
 	trace_sched_process_hang(t);
 
-	if (sysctl_hung_task_panic) {
+	if (sysctl_hung_task_panic && total_hung_task >= sysctl_hung_task_panic) {
 		console_verbose();
 		hung_task_show_lock = true;
 		hung_task_call_panic = true;
@@ -300,6 +304,7 @@ static void check_hung_uninterruptible_t
 	int max_count = sysctl_hung_task_check_count;
 	unsigned long last_break = jiffies;
 	struct task_struct *g, *t;
+	unsigned long prev_detect_count = sysctl_hung_task_detect_count;
 
 	/*
 	 * If the system crashed already then all bets are off,
@@ -320,7 +325,7 @@ static void check_hung_uninterruptible_t
 			last_break = jiffies;
 		}
 
-		check_hung_task(t, timeout);
+		check_hung_task(t, timeout, prev_detect_count);
 	}
  unlock:
 	rcu_read_unlock();
@@ -389,7 +394,7 @@ static const struct ctl_table hung_task_
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
+		.extra2		= SYSCTL_INT_MAX,
 	},
 	{
 		.procname	= "hung_task_check_count",
--- a/lib/Kconfig.debug~hung_task-panic-when-there-are-more-than-n-hung-tasks-at-the-same-time
+++ a/lib/Kconfig.debug
@@ -1257,12 +1257,13 @@ config DEFAULT_HUNG_TASK_TIMEOUT
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
+	  When set to a non-zero value, a kernel panic will be triggered
+	  if the number of hung tasks found during a single scan reaches
+	  this value.
 
 	  The panic can be used in combination with panic_timeout,
 	  to cause the system to reboot automatically after a
--- a/tools/testing/selftests/wireguard/qemu/kernel.config~hung_task-panic-when-there-are-more-than-n-hung-tasks-at-the-same-time
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

hung_task-panic-when-there-are-more-than-n-hung-tasks-at-the-same-time.patch
hung_task-panic-after-fixed-number-of-hung-tasks.patch

