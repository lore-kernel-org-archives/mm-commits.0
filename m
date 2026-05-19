Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9146E3EA961
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 16:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779208157; cv=none; b=WIgbyjfyTDnsrWbYBV71bHXaxAaTv/umU0bg/a2j+5BLBpBOpIyOn5nv3/rbUPoSr8oP56Hj7uRcHJCT9l8F+cQW/B6OjGG2rouyOlSdzRUoxA/CyKSD2qYxYo4WVNKSQKjI3u46sWAV8MdK/WuE6svq1XywS+wMhGRxPrwtxso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779208157; c=relaxed/simple;
	bh=1jbrHl6tMyBWczSLCOaECvJvx8tipflZeBGxKLMltb0=;
	h=Date:To:From:Subject:Message-Id; b=K8MnhhfJsbo2kfYAvvmihVkMT+oyQZwy4KwALmmlFq7dPBaaKX98LfGWadLP3XyFBePXeatpApR3rmpa/h/mZg4Bcc28pt6wHAb9DA6d4k1f+TgM6cm8wJX8nlbYw12hhn0lbgNft87sOvgEgMo0oje9ea0dN7kNdVUqjb7x9/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=utk54RYB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="utk54RYB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24CDEC2BCB3;
	Tue, 19 May 2026 16:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779208157;
	bh=1jbrHl6tMyBWczSLCOaECvJvx8tipflZeBGxKLMltb0=;
	h=Date:To:From:Subject:From;
	b=utk54RYBM+XrzhE34CsHQoSH7a487uFPihQWZDiyL9uZb2zgSBqoXkXUU4+ymhBq3
	 6RqnPMCjVeBaC8fWq4m8To2bVnVla4nlZ936pgTkKI9edX0xDhYIyAGdZFOYCPr9xH
	 HabzE4sK6fvOUNC2ueKdmlkNrShQrHbgP/yDd1Hw=
Date: Tue, 19 May 2026 09:29:16 -0700
To: mm-commits@vger.kernel.org,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] arm64-delay-move-some-constants-out-to-a-separate-header.patch removed from -mm tree
Message-Id: <20260519162917.24CDEC2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64/delay: move some constants out to a separate header
has been removed from the -mm tree.  Its filename was
     arm64-delay-move-some-constants-out-to-a-separate-header.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Ankur Arora <ankur.a.arora@oracle.com>
Subject: arm64/delay: move some constants out to a separate header
Date: Wed, 8 Apr 2026 17:55:27 +0530

Moves some constants and functions related to xloops, cycles computation
out to a new header.  Also make __delay_cycles() available outside of
arch/arm64/lib/delay.c.

Rename some macros in qcom/rpmh-rsc.c which were occupying the same
namespace.

No functional change.

Link: https://lore.kernel.org/20260408122538.3610871-4-ankur.a.arora@oracle.com
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Konrad Dybcio <konradybcio@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Boqun Feng <boqun@kernel.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: David Gow <davidgow@google.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: Haris Okanovic <harisokn@amazon.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/delay-const.h |   27 +++++++++++++++++++++++++
 arch/arm64/lib/delay.c               |   15 +++----------
 drivers/soc/qcom/rpmh-rsc.c          |    8 +++----
 3 files changed, 35 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/delay-const.h a/arch/arm64/include/asm/delay-const.h
new file mode 100644
--- /dev/null
+++ a/arch/arm64/include/asm/delay-const.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASM_DELAY_CONST_H
+#define _ASM_DELAY_CONST_H
+
+#include <asm/param.h>	/* For HZ */
+
+/* 2**32 / 1000000 (rounded up) */
+#define __usecs_to_xloops_mult	0x10C7UL
+
+/* 2**32 / 1000000000 (rounded up) */
+#define __nsecs_to_xloops_mult	0x5UL
+
+extern unsigned long loops_per_jiffy;
+static inline unsigned long xloops_to_cycles(unsigned long xloops)
+{
+	return (xloops * loops_per_jiffy * HZ) >> 32;
+}
+
+#define USECS_TO_CYCLES(time_usecs) \
+	xloops_to_cycles((time_usecs) * __usecs_to_xloops_mult)
+
+#define NSECS_TO_CYCLES(time_nsecs) \
+	xloops_to_cycles((time_nsecs) * __nsecs_to_xloops_mult)
+
+u64 notrace __delay_cycles(void);
+
+#endif	/* _ASM_DELAY_CONST_H */
--- a/arch/arm64/lib/delay.c~arm64-delay-move-some-constants-out-to-a-separate-header
+++ a/arch/arm64/lib/delay.c
@@ -12,17 +12,10 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/timex.h>
+#include <asm/delay-const.h>
 
 #include <clocksource/arm_arch_timer.h>
 
-#define USECS_TO_CYCLES(time_usecs)			\
-	xloops_to_cycles((time_usecs) * 0x10C7UL)
-
-static inline unsigned long xloops_to_cycles(unsigned long xloops)
-{
-	return (xloops * loops_per_jiffy * HZ) >> 32;
-}
-
 /*
  * Force the use of CNTVCT_EL0 in order to have the same base as WFxT.
  * This avoids some annoying issues when CNTVOFF_EL2 is not reset 0 on a
@@ -32,7 +25,7 @@ static inline unsigned long xloops_to_cy
  * Note that userspace cannot change the offset behind our back either,
  * as the vcpu mutex is held as long as KVM_RUN is in progress.
  */
-static cycles_t notrace __delay_cycles(void)
+u64 notrace __delay_cycles(void)
 {
 	guard(preempt_notrace)();
 	return __arch_counter_get_cntvct_stable();
@@ -73,12 +66,12 @@ EXPORT_SYMBOL(__const_udelay);
 
 void __udelay(unsigned long usecs)
 {
-	__const_udelay(usecs * 0x10C7UL); /* 2**32 / 1000000 (rounded up) */
+	__const_udelay(usecs * __usecs_to_xloops_mult);
 }
 EXPORT_SYMBOL(__udelay);
 
 void __ndelay(unsigned long nsecs)
 {
-	__const_udelay(nsecs * 0x5UL); /* 2**32 / 1000000000 (rounded up) */
+	__const_udelay(nsecs * __nsecs_to_xloops_mult);
 }
 EXPORT_SYMBOL(__ndelay);
--- a/drivers/soc/qcom/rpmh-rsc.c~arm64-delay-move-some-constants-out-to-a-separate-header
+++ a/drivers/soc/qcom/rpmh-rsc.c
@@ -146,10 +146,10 @@ enum {
  *  +---------------------------------------------------+
  */
 
-#define USECS_TO_CYCLES(time_usecs)			\
-	xloops_to_cycles((time_usecs) * 0x10C7UL)
+#define RPMH_USECS_TO_CYCLES(time_usecs)		\
+	rpmh_xloops_to_cycles((time_usecs) * 0x10C7UL)
 
-static inline unsigned long xloops_to_cycles(u64 xloops)
+static inline unsigned long rpmh_xloops_to_cycles(u64 xloops)
 {
 	return (xloops * loops_per_jiffy * HZ) >> 32;
 }
@@ -819,7 +819,7 @@ void rpmh_rsc_write_next_wakeup(struct r
 	wakeup_us = ktime_to_us(wakeup);
 
 	/* Convert the wakeup to arch timer scale */
-	wakeup_cycles = USECS_TO_CYCLES(wakeup_us);
+	wakeup_cycles = RPMH_USECS_TO_CYCLES(wakeup_us);
 	wakeup_cycles += arch_timer_read_counter();
 
 exit:
_

Patches currently in -mm which might be from ankur.a.arora@oracle.com are

arm64-support-wfet-in-smp_cond_load_relaxed_timeout.patch
arm64-rqspinlock-remove-private-copy-of-smp_cond_load_acquire_timewait.patch
asm-generic-barrier-add-smp_cond_load_acquire_timeout.patch
atomic-add-atomic_cond_read__timeout.patch
locking-atomic-scripts-build-atomic_long_cond_read__timeout.patch
bpf-rqspinlock-switch-check_timeout-to-a-clock-interface.patch
bpf-rqspinlock-use-smp_cond_load_acquire_timeout.patch
sched-add-need-resched-timed-wait-interface.patch
cpuidle-poll_state-wait-for-need-resched-via-tif_need_resched_relaxed_wait.patch
kunit-enable-testing-smp_cond_load_relaxed_timeout.patch
kunit-add-tests-for-smp_cond_load_relaxed_timeout.patch

