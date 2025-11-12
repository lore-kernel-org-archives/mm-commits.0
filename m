Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8234B14B96E
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908583; cv=none; b=q//5eP0VnmatFuOwE4DLAUotxzLOoJHsuPsHGxORojwfC78fb+xiIqpsPu534Hj3eW0SK0Nx6EvMHdP1q19aXQqWO5BMzt1/TJvz5iGRRu8WeO83PMI/dc/1TGmcHw2VkfNQUv9kioVA/gFKxJJ+gbWCTqOnfkGatKvDOGl9CHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908583; c=relaxed/simple;
	bh=FjY0ffteh7L4EtsVge2ovUuX1mQg6XQB+cjg5LXfzB8=;
	h=Date:To:From:Subject:Message-Id; b=NYa8lMAu3JdoSjIFA9NNZ23Uj6nrlXW0sEE7h1QYB4rc40KKl11wlBBFRXoNC1tMxsJAes51Ij5Oid2LqE2VET47pxEYNcoVC0ignEHgTN2Rq4hC0d+aozHMs5p/FtrrWzGwJsURFLMlrwqysWHEDfUJcmkTZAAySp3fxFgGZ0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I5nCdfta; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I5nCdfta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289F7C116B1;
	Wed, 12 Nov 2025 00:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908583;
	bh=FjY0ffteh7L4EtsVge2ovUuX1mQg6XQB+cjg5LXfzB8=;
	h=Date:To:From:Subject:From;
	b=I5nCdfta1L9C/938oR2M7mgt0aigUMClfOR7BHIVu7tY8ZsFFP2DAj8E7Hmrl07in
	 K4PJOPYDqizEr+NQlzHA9OsFmx0LS9CQeprG1f4M1uoav1XkHhqsvB03San12htVsY
	 mRp/SRAiuPx3nEILVnq8GhsatMzgKaZgCqaP6ZVA=
Date: Tue, 11 Nov 2025 16:49:42 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sdf@fomichev.me,rostedt@goodmis.org,rdunlap@infradead.org,pmladek@suse.com,pawan.kumar.gupta@linux.intel.com,paulmck@kernel.org,pauld@redhat.com,mhiramat@kernel.org,lorenzo.stoakes@oracle.com,linux@armlinux.org.uk,liam.howlett@oracle.com,lance.yang@linux.dev,kuba@kernel.org,kees@kernel.org,joel@jms.id.au,joel.granados@kernel.org,jason@zx2c4.com,horms@kernel.org,fw@strlen.de,david@redhat.com,corbet@lwn.net,arnd@arndb.de,anshuman.khandual@arm.com,andrew@codeconstruct.com.au,lirongqing@baidu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hung_task-panic-when-there-are-more-than-n-hung-tasks-at-the-same-time.patch removed from -mm tree
Message-Id: <20251112004943.289F7C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hung_task: panic when there are more than N hung tasks at the same time
has been removed from the -mm tree.  Its filename was
     hung_task-panic-when-there-are-more-than-n-hung-tasks-at-the-same-time.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li RongQing <lirongqing@baidu.com>
Subject: hung_task: panic when there are more than N hung tasks at the same time
Date: Wed, 15 Oct 2025 14:36:15 +0800

The hung_task_panic sysctl is currently a blunt instrument: it's all or
nothing.

Panicking on a single hung task can be an overreaction to a transient
glitch.  A more reliable indicator of a systemic problem is when
multiple tasks hang simultaneously.

Extend hung_task_panic to accept an integer threshold, allowing the
kernel to panic only when N hung tasks are detected in a single scan. 
This provides finer control to distinguish between isolated incidents
and system-wide failures.

The accepted values are:
- 0: Don't panic (unchanged)
- 1: Panic on the first hung task (unchanged)
- N > 1: Panic after N hung tasks are detected in a single scan

The original behavior is preserved for values 0 and 1, maintaining full
backward compatibility.

[lance.yang@linux.dev: new changelog]
Link: https://lkml.kernel.org/r/20251015063615.2632-1-lirongqing@baidu.com
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Andrew Jeffery <andrew@codeconstruct.com.au> [aspeed_g5_defconfig]
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
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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


