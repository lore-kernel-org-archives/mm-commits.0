Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2420140963F
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 16:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779208156; cv=none; b=O+Pl55OQRf+EG/ZDga6NNoxbIamVhXCydzB2bTu5sZx02+o1x2mZkjRIV+Gu79rzRexZM67ezffperkgZl3vsGlAD4QNjExUxahFx5Y3OXJvjSs+hI+76u4jToNyGr2Q/GJrh1jIqz49TqGFhV2VI8glaiRymh/vyd4RK4hZrlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779208156; c=relaxed/simple;
	bh=swMZbCDH07dPA319lXM2aqaRb8opCFJpOmmoZbc/UOI=;
	h=Date:To:From:Subject:Message-Id; b=gDEfZCDNVdQrVg2iH3zzVzg0hvBDxpflej7GJ5449tnC5XgQ97xnP6RJikQF55qZcBf3GPB/TtZfN+gRokWh9r5WezShw1tTOlGYunZl8XX6gZkEcHPHsHNjY7LmGkVjpXrhlYTRlqsUK/0RFuVWWM5aQ9b2Cq2ZOoz5TOr02IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EcOu4Xkb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EcOu4Xkb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC427C2BCB8;
	Tue, 19 May 2026 16:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779208155;
	bh=swMZbCDH07dPA319lXM2aqaRb8opCFJpOmmoZbc/UOI=;
	h=Date:To:From:Subject:From;
	b=EcOu4XkbKWUxTvM3FA5juBAUa0NE7WUIyAMluS1+MbCq2/M3ZRQJWyiFHkVAICg/S
	 QnuKI7d8uAeBCKhYv3aHY0QHXPEP3omjeMr4NfoOceTZ2TekZdMi6+cPzllzyviaUh
	 Vj2YZcjl3P+PMzUQ6hFsahCmBW0Bzjdgsy29OHhw=
Date: Tue, 19 May 2026 09:29:15 -0700
To: mm-commits@vger.kernel.org,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] arm64-barrier-support-smp_cond_load_relaxed_timeout.patch removed from -mm tree
Message-Id: <20260519162915.BC427C2BCB8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: barrier: support smp_cond_load_relaxed_timeout()
has been removed from the -mm tree.  Its filename was
     arm64-barrier-support-smp_cond_load_relaxed_timeout.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Ankur Arora <ankur.a.arora@oracle.com>
Subject: arm64: barrier: support smp_cond_load_relaxed_timeout()
Date: Wed, 8 Apr 2026 17:55:26 +0530

Support waiting in smp_cond_load_relaxed_timeout() via
__cmpwait_relaxed().  To ensure that we wake from waiting in WFE
periodically and don't block forever if there are no stores to ptr, this
path is only used when the event-stream is enabled.

Note that when using __cmpwait_relaxed() we ignore the timeout value,
allowing an overshoot by up to the event-stream period.  And, in the
unlikely event that the event-stream is unavailable, fallback to
spin-waiting.

Also set SMP_TIMEOUT_POLL_COUNT to 1 so we do the time-check in each
iteration of smp_cond_load_relaxed_timeout().

And finally define ARCH_HAS_CPU_RELAX to indicate that we have an
optimized implementation of cpu_poll_relax().

Link: https://lore.kernel.org/20260408122538.3610871-3-ankur.a.arora@oracle.com
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Suggested-by: Will Deacon <will@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Boqun Feng <boqun@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: David Gow <davidgow@google.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: Haris Okanovic <harisokn@amazon.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Konrad Dybcio <konradybcio@kernel.org>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig               |    3 +++
 arch/arm64/include/asm/barrier.h |   21 +++++++++++++++++++++
 2 files changed, 24 insertions(+)

--- a/arch/arm64/include/asm/barrier.h~arm64-barrier-support-smp_cond_load_relaxed_timeout
+++ a/arch/arm64/include/asm/barrier.h
@@ -12,6 +12,7 @@
 #include <linux/kasan-checks.h>
 
 #include <asm/alternative-macros.h>
+#include <asm/vdso/processor.h>
 
 #define __nops(n)	".rept	" #n "\nnop\n.endr\n"
 #define nops(n)		asm volatile(__nops(n))
@@ -219,6 +220,26 @@ do {									\
 	(typeof(*ptr))VAL;						\
 })
 
+/* Re-declared here to avoid include dependency. */
+extern bool arch_timer_evtstrm_available(void);
+
+/*
+ * In the common case, cpu_poll_relax() sits waiting in __cmpwait_relaxed()
+ * for the ptr value to change.
+ *
+ * Since this period is reasonably long, choose SMP_TIMEOUT_POLL_COUNT
+ * to be 1, so smp_cond_load_{relaxed,acquire}_timeout() does a
+ * time-check in each iteration.
+ */
+#define SMP_TIMEOUT_POLL_COUNT	1
+
+#define cpu_poll_relax(ptr, val, timeout_ns) do {			\
+	if (arch_timer_evtstrm_available())				\
+		__cmpwait_relaxed(ptr, val);				\
+	else								\
+		cpu_relax();						\
+} while (0)
+
 #include <asm-generic/barrier.h>
 
 #endif	/* __ASSEMBLER__ */
--- a/arch/arm64/Kconfig~arm64-barrier-support-smp_cond_load_relaxed_timeout
+++ a/arch/arm64/Kconfig
@@ -1606,6 +1606,9 @@ config ARCH_SUPPORTS_CRASH_DUMP
 config ARCH_DEFAULT_CRASH_DUMP
 	def_bool y
 
+config ARCH_HAS_CPU_RELAX
+	def_bool y
+
 config ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
 	def_bool CRASH_RESERVE
 
_

Patches currently in -mm which might be from ankur.a.arora@oracle.com are

arm64-delay-move-some-constants-out-to-a-separate-header.patch
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

