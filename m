Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5FB3806D1
	for <mm-commits@vger.kernel.org>; Thu, 23 Apr 2026 17:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776964637; cv=none; b=d0iJu2xGXO/czbKvTmphYOzWvHHkXvtlP/K2DNrmQhg/awttxE2sIVWP/qVoAX1o1ijG46bXtJQoiaPfHhGO2F8IlSz+D6A7ipkbmP98OkmYydbw/rWv2K2Xn5tRZwvpe6sXaC81WMssN9Q26qUdAvfErrqeh920j1BN9WSLb54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776964637; c=relaxed/simple;
	bh=vp40wLLF8Y41j2tC1dEldpu7TQK7tRXE0XpvQBw8/kI=;
	h=Date:To:From:Subject:Message-Id; b=uuJJYODM8a2xIESQ5Y+02JEF6F8LM/bLm4caaNi+CzveP4Ba/InXabeIU5Kfomcf1xoDhPY4eNmoaEL435gIxUkIomEYFxXZBjIkIRAWRTfNZDQa0/GoxIDqJkjtrrnEBDoVF/5NQpVugBPd0pYiDAFQNduLR/hjrRUE2q+f+1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1E1vwEdn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1E1vwEdn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A912C2BCAF;
	Thu, 23 Apr 2026 17:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776964637;
	bh=vp40wLLF8Y41j2tC1dEldpu7TQK7tRXE0XpvQBw8/kI=;
	h=Date:To:From:Subject:From;
	b=1E1vwEdnUoOJou3WYqPMI4jG2ODUBORzz4n0WElM+Uee0+XI9MrwZRUKLf5nNGEVP
	 1Ukd3MPVx1WfcMMKhH58FIEwRLI0f2ocxX5zdelpKJDrXpe+Fh5rKdCXZuOQBVvN3W
	 g2ESFxdKNPnFoepXKb1jRoQzAxM4ggSzvaVC+Ayo=
Date: Thu, 23 Apr 2026 10:17:16 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,rafael@kernel.org,peterz@infradead.org,mingo@kernel.org,memxor@gmail.com,mark.rutland@arm.com,konradybcio@kernel.org,harisokn@amazon.com,gary@garyguo.net,davidgow@google.com,daniel.lezcano@linaro.org,cl@linux.com,catalin.marinas@arm.com,boqun@kernel.org,boqun.feng@gmail.com,ast@kernel.org,arnd@arndb.de,andersson@kernel.org,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-barrier-support-smp_cond_load_relaxed_timeout.patch added to mm-new branch
Message-Id: <20260423171717.6A912C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64: barrier: support smp_cond_load_relaxed_timeout()
has been added to the -mm mm-new branch.  Its filename is
     arm64-barrier-support-smp_cond_load_relaxed_timeout.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-barrier-support-smp_cond_load_relaxed_timeout.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
@@ -1594,6 +1594,9 @@ config ARCH_SUPPORTS_CRASH_DUMP
 config ARCH_DEFAULT_CRASH_DUMP
 	def_bool y
 
+config ARCH_HAS_CPU_RELAX
+	def_bool y
+
 config ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
 	def_bool CRASH_RESERVE
 
_

Patches currently in -mm which might be from ankur.a.arora@oracle.com are

asm-generic-barrier-add-smp_cond_load_relaxed_timeout.patch
arm64-barrier-support-smp_cond_load_relaxed_timeout.patch
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

