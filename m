Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3619A7E110
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 19:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765912604; cv=none; b=QuzU7wBWKR1dmptCTxNMkyZlTaQRHVliU1BLonxYUNS51WFTLn5qV2P9Mon8XsuR6nwf5sb2rEuQtWNMo9D/NhQdFSL9GxNacq8zqFzq7HZuVkQYuUyd56NMtuAGVZdEextlkq5fkDE4Uz39sIfJhbLyLLCYXETDcKCcSknxJfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765912604; c=relaxed/simple;
	bh=cPHi4FTFKsKtV6ji+zC5Z8cwZ/7Oz56Yjdi/I+QkuGY=;
	h=Date:To:From:Subject:Message-Id; b=K/PNZ+BHqzto/FnXbKllH6VmhObJ12IW1kMcuE32byPKGr3voMW1P0rn+b9iHgECurWzXQKI+rCWfai5+EWdSaY8k1zN9uHXJhA2dfWZRu5CtJd5H+v/UBeTal+6KAWanDE026dm43ImmBJuJm4uN1vHWGcaRPxoxnoTbPh+/H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SU9L5GPv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SU9L5GPv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85CBCC4CEF1;
	Tue, 16 Dec 2025 19:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765912603;
	bh=cPHi4FTFKsKtV6ji+zC5Z8cwZ/7Oz56Yjdi/I+QkuGY=;
	h=Date:To:From:Subject:From;
	b=SU9L5GPvj1VQlvJ9DTRWgXFX01Fjs+qmLd+dEfQ2o5wV1r1I+Z/yES4w3yjJBYILE
	 ixfwZZMeKU9+ZCK20auz41t0V1GUmPLZZu2c5vE3hlzJGbFBAyU6ojpVgJbSUemJWf
	 NV0hGydT8sjMieFwYcOX+j/O5mNNlLZNujydh9o8=
Date: Tue, 16 Dec 2025 11:16:42 -0800
To: mm-commits@vger.kernel.org,yonghong.song@linux.dev,song@kernel.org,sdf@fomichev.me,npiggin@gmail.com,martin.lau@linux.dev,lance.yang@linux.dev,kpsingh@kernel.org,jolsa@kernel.org,john.fastabend@gmail.com,haoluo@google.com,eddyz87@gmail.com,lirongqing@baidu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-softlockup-panic-when-lockup-duration-exceeds-n-thresholds.patch added to mm-nonmm-unstable branch
Message-Id: <20251216191643.85CBCC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: watchdog: softlockup: panic when lockup duration exceeds N thresholds
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-softlockup-panic-when-lockup-duration-exceeds-n-thresholds.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-softlockup-panic-when-lockup-duration-exceeds-n-thresholds.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Li RongQing <lirongqing@baidu.com>
Subject: watchdog: softlockup: panic when lockup duration exceeds N thresholds
Date: Tue, 16 Dec 2025 02:45:21 -0500

The softlockup_panic sysctl is currently a binary option: panic
immediately or never panic on soft lockups.

Panicking on any soft lockup, regardless of duration, can be overly
aggressive for brief stalls that may be caused by legitimate operations. 
Conversely, never panicking may allow severe system hangs to persist
undetected.

Extend softlockup_panic to accept an integer threshold, allowing the
kernel to panic only when the normalized lockup duration exceeds N
watchdog threshold periods.  This provides finer-grained control to
distinguish between transient delays and persistent system failures.

The accepted values are:
- 0: Don't panic (unchanged)
- 1: Panic when duration >= 1 * threshold (20s default, original behavior)
- N > 1: Panic when duration >= N * threshold (e.g., 2 = 40s, 3 = 60s.)

The original behavior is preserved for values 0 and 1, maintaining full
backward compatibility while allowing systems to tolerate brief lockups
while still catching severe, persistent hangs.

Link: https://lkml.kernel.org/r/20251216074521.2796-1-lirongqing@baidu.com
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Hao Luo <haoluo@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Song Liu <song@kernel.org>
Cc: Stanislav Fomichev <sdf@fomichev.me>
Cc: Yonghong Song <yonghong.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt      |   10 +++----
 arch/arm/configs/aspeed_g5_defconfig                 |    2 -
 arch/arm/configs/pxa3xx_defconfig                    |    2 -
 arch/openrisc/configs/or1klitex_defconfig            |    2 -
 arch/powerpc/configs/skiroot_defconfig               |    2 -
 drivers/gpu/drm/ci/arm.config                        |    2 -
 drivers/gpu/drm/ci/arm64.config                      |    2 -
 drivers/gpu/drm/ci/x86_64.config                     |    2 -
 kernel/watchdog.c                                    |    8 +++---
 lib/Kconfig.debug                                    |   13 +++++-----
 tools/testing/selftests/bpf/config                   |    2 -
 tools/testing/selftests/wireguard/qemu/kernel.config |    2 -
 12 files changed, 26 insertions(+), 23 deletions(-)

--- a/arch/arm/configs/aspeed_g5_defconfig~watchdog-softlockup-panic-when-lockup-duration-exceeds-n-thresholds
+++ a/arch/arm/configs/aspeed_g5_defconfig
@@ -306,7 +306,7 @@ CONFIG_SCHED_STACK_END_CHECK=y
 CONFIG_PANIC_ON_OOPS=y
 CONFIG_PANIC_TIMEOUT=-1
 CONFIG_SOFTLOCKUP_DETECTOR=y
-CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
+CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=1
 CONFIG_BOOTPARAM_HUNG_TASK_PANIC=1
 CONFIG_WQ_WATCHDOG=y
 # CONFIG_SCHED_DEBUG is not set
--- a/arch/arm/configs/pxa3xx_defconfig~watchdog-softlockup-panic-when-lockup-duration-exceeds-n-thresholds
+++ a/arch/arm/configs/pxa3xx_defconfig
@@ -100,7 +100,7 @@ CONFIG_PRINTK_TIME=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_SHIRQ=y
-CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
+CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=1
 # CONFIG_SCHED_DEBUG is not set
 CONFIG_DEBUG_SPINLOCK=y
 CONFIG_DEBUG_SPINLOCK_SLEEP=y
--- a/arch/openrisc/configs/or1klitex_defconfig~watchdog-softlockup-panic-when-lockup-duration-exceeds-n-thresholds
+++ a/arch/openrisc/configs/or1klitex_defconfig
@@ -52,5 +52,5 @@ CONFIG_LSM="lockdown,yama,loadpin,safese
 CONFIG_PRINTK_TIME=y
 CONFIG_PANIC_ON_OOPS=y
 CONFIG_SOFTLOCKUP_DETECTOR=y
-CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
+CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=1
 CONFIG_BUG_ON_DATA_CORRUPTION=y
--- a/arch/powerpc/configs/skiroot_defconfig~watchdog-softlockup-panic-when-lockup-duration-exceeds-n-thresholds
+++ a/arch/powerpc/configs/skiroot_defconfig
@@ -289,7 +289,7 @@ CONFIG_SCHED_STACK_END_CHECK=y
 CONFIG_DEBUG_STACKOVERFLOW=y
 CONFIG_PANIC_ON_OOPS=y
 CONFIG_SOFTLOCKUP_DETECTOR=y
-CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
+CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=1
 CONFIG_HARDLOCKUP_DETECTOR=y
 CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
 CONFIG_WQ_WATCHDOG=y
--- a/Documentation/admin-guide/kernel-parameters.txt~watchdog-softlockup-panic-when-lockup-duration-exceeds-n-thresholds
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -6934,12 +6934,12 @@ Kernel parameters
 
 	softlockup_panic=
 			[KNL] Should the soft-lockup detector generate panics.
-			Format: 0 | 1
+			Format: <int>
 
-			A value of 1 instructs the soft-lockup detector
-			to panic the machine when a soft-lockup occurs. It is
-			also controlled by the kernel.softlockup_panic sysctl
-			and CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC, which is the
+			A value of non-zero instructs the soft-lockup detector
+			to panic the machine when a soft-lockup duration exceeds
+			N thresholds. It is also controlled by the kernel.softlockup_panic
+			sysctl and CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC, which is the
 			respective build-time switch to that functionality.
 
 	softlockup_all_cpu_backtrace=
--- a/drivers/gpu/drm/ci/arm64.config~watchdog-softlockup-panic-when-lockup-duration-exceeds-n-thresholds
+++ a/drivers/gpu/drm/ci/arm64.config
@@ -161,7 +161,7 @@ CONFIG_TMPFS=y
 CONFIG_PROVE_LOCKING=n
 CONFIG_DEBUG_LOCKDEP=n
 CONFIG_SOFTLOCKUP_DETECTOR=y
-CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
+CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=1
 
 CONFIG_DETECT_HUNG_TASK=y
 
--- a/drivers/gpu/drm/ci/arm.config~watchdog-softlockup-panic-when-lockup-duration-exceeds-n-thresholds
+++ a/drivers/gpu/drm/ci/arm.config
@@ -52,7 +52,7 @@ CONFIG_TMPFS=y
 CONFIG_PROVE_LOCKING=n
 CONFIG_DEBUG_LOCKDEP=n
 CONFIG_SOFTLOCKUP_DETECTOR=n
-CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=n
+CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=0
 
 CONFIG_FW_LOADER_COMPRESS=y
 
--- a/drivers/gpu/drm/ci/x86_64.config~watchdog-softlockup-panic-when-lockup-duration-exceeds-n-thresholds
+++ a/drivers/gpu/drm/ci/x86_64.config
@@ -47,7 +47,7 @@ CONFIG_TMPFS=y
 CONFIG_PROVE_LOCKING=n
 CONFIG_DEBUG_LOCKDEP=n
 CONFIG_SOFTLOCKUP_DETECTOR=y
-CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
+CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=1
 
 CONFIG_DETECT_HUNG_TASK=y
 
--- a/kernel/watchdog.c~watchdog-softlockup-panic-when-lockup-duration-exceeds-n-thresholds
+++ a/kernel/watchdog.c
@@ -363,7 +363,7 @@ static struct cpumask watchdog_allowed_m
 
 /* Global variables, exported for sysctl */
 unsigned int __read_mostly softlockup_panic =
-			IS_ENABLED(CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC);
+			CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC;
 
 static bool softlockup_initialized __read_mostly;
 static u64 __read_mostly sample_period;
@@ -879,7 +879,9 @@ static enum hrtimer_restart watchdog_tim
 
 		add_taint(TAINT_SOFTLOCKUP, LOCKDEP_STILL_OK);
 		sys_info(softlockup_si_mask & ~SYS_INFO_ALL_BT);
-		if (softlockup_panic)
+		duration = duration / get_softlockup_thresh();
+
+		if (softlockup_panic && duration >= softlockup_panic)
 			panic("softlockup: hung tasks");
 	}
 
@@ -1228,7 +1230,7 @@ static const struct ctl_table watchdog_s
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
+		.extra2		= SYSCTL_INT_MAX,
 	},
 	{
 		.procname	= "softlockup_sys_info",
--- a/lib/Kconfig.debug~watchdog-softlockup-panic-when-lockup-duration-exceeds-n-thresholds
+++ a/lib/Kconfig.debug
@@ -1110,13 +1110,14 @@ config SOFTLOCKUP_DETECTOR_INTR_STORM
 	  the CPU stats and the interrupt counts during the "soft lockups".
 
 config BOOTPARAM_SOFTLOCKUP_PANIC
-	bool "Panic (Reboot) On Soft Lockups"
+	int "Panic (Reboot) On Soft Lockups"
 	depends on SOFTLOCKUP_DETECTOR
+	default 0
 	help
-	  Say Y here to enable the kernel to panic on "soft lockups",
-	  which are bugs that cause the kernel to loop in kernel
-	  mode for more than 20 seconds (configurable using the watchdog_thresh
-	  sysctl), without giving other tasks a chance to run.
+	  Set to a non-zero value N to enable the kernel to panic on "soft
+	  lockups", which are bugs that cause the kernel to loop in kernel
+	  mode for more than (N * 20 seconds) (configurable using the
+	  watchdog_thresh sysctl), without giving other tasks a chance to run.
 
 	  The panic can be used in combination with panic_timeout,
 	  to cause the system to reboot automatically after a
@@ -1124,7 +1125,7 @@ config BOOTPARAM_SOFTLOCKUP_PANIC
 	  high-availability systems that have uptime guarantees and
 	  where a lockup must be resolved ASAP.
 
-	  Say N if unsure.
+	  Say 0 if unsure.
 
 config HAVE_HARDLOCKUP_DETECTOR_BUDDY
 	bool
--- a/tools/testing/selftests/bpf/config~watchdog-softlockup-panic-when-lockup-duration-exceeds-n-thresholds
+++ a/tools/testing/selftests/bpf/config
@@ -1,6 +1,6 @@
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
-CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
+CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=1
 CONFIG_BPF=y
 CONFIG_BPF_EVENTS=y
 CONFIG_BPF_JIT=y
--- a/tools/testing/selftests/wireguard/qemu/kernel.config~watchdog-softlockup-panic-when-lockup-duration-exceeds-n-thresholds
+++ a/tools/testing/selftests/wireguard/qemu/kernel.config
@@ -80,7 +80,7 @@ CONFIG_HARDLOCKUP_DETECTOR=y
 CONFIG_WQ_WATCHDOG=y
 CONFIG_DETECT_HUNG_TASK=y
 CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
-CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
+CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=1
 CONFIG_BOOTPARAM_HUNG_TASK_PANIC=1
 CONFIG_PANIC_TIMEOUT=-1
 CONFIG_STACKTRACE=y
_

Patches currently in -mm which might be from lirongqing@baidu.com are

watchdog-softlockup-panic-when-lockup-duration-exceeds-n-thresholds.patch

