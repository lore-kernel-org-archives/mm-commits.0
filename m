Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE06F3ED3D0
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 16:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779208155; cv=none; b=byh1pUVI5yLi0yDLupOiPxi09xpIwUYCewD5PdT/dQybiNrhWWVOwt3/dAsjCzYzdtWbkYt8vkcVE6S6Z9lXv8ksoCmsPmp8igCbMzCM2hc/QPK5fAiydWHvT1Rb0nH/NeqbnN4E3ujv8K87Q5/TqT1hWPu+9evcFnP0UGnKBs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779208155; c=relaxed/simple;
	bh=ExzzvkfPiCkRJ/UZkOHRz9B8BfYelyKFtMwJty4nDGg=;
	h=Date:To:From:Subject:Message-Id; b=OCgdV5Lk184xJakpzEo6uaxaDITrhko4MJmdQYPyvme9WdEbYV35sIeGK2NQ1UBF+x4W29yXYOl8yLw4Nq0hFa/WRdM9WY9dY8ahLBj5HCbFGuCaFyI9YqjoXk7hwKO4npbuTkTy0vfKyW3J8iLKhgLD2acZYA7OpoUsWOZCQLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PhcbS2Ot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PhcbS2Ot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63470C2BCB3;
	Tue, 19 May 2026 16:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779208154;
	bh=ExzzvkfPiCkRJ/UZkOHRz9B8BfYelyKFtMwJty4nDGg=;
	h=Date:To:From:Subject:From;
	b=PhcbS2OtsMwARcwI4toBFJfkuisxy+nz3xwp+dqHI4AmQ+emWdqAtRK/+8usLuiDu
	 SNZaW2m97jN7rYZdwn97cWaNLjfV4LzzD2YNmdrYair0134QeIvdFHRQxjpX7iMkyZ
	 FdYDzTsD2kTAbAmTdzBNYBmO6LGtUvAmabgC3ChA=
Date: Tue, 19 May 2026 09:29:13 -0700
To: mm-commits@vger.kernel.org,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] asm-generic-barrier-add-smp_cond_load_relaxed_timeout.patch removed from -mm tree
Message-Id: <20260519162914.63470C2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: asm-generic: barrier: add smp_cond_load_relaxed_timeout()
has been removed from the -mm tree.  Its filename was
     asm-generic-barrier-add-smp_cond_load_relaxed_timeout.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Ankur Arora <ankur.a.arora@oracle.com>
Subject: asm-generic: barrier: add smp_cond_load_relaxed_timeout()
Date: Wed, 8 Apr 2026 17:55:25 +0530

Patch series "barrier: Add smp_cond_load_{relaxed,acquire}_timeout()",
v11.

The core kernel often uses smp_cond_load_{relaxed,acquire}() to spin on
condition variables with architectural primitives used to avoid hammering
the relevant cachelines.

(This primitive can vary greatly across architectures: on x86 it's a
cpu_relax() to slow down the pipeline.  On arm64, this is a __cmpwait()
which waits for a cacheline to change state in a time limited fashion.)

Regardless of architectural details, typical smp_cond_load*() usage does
not allow for termination until the condition change occurs.

Beyond the core kernel, there are cases where it is useful to additionally
terminate on a timeout.  Two cases:

  - cpuidle poll_idle(): wait for need-resched until the cpuidle polling
    duration expires.

  - rqspinlock: nested qspinlock acquisition that terminates on timeout
    or deadlock.

Accordingly add two interfaces (with their generic and arm64 specific
implementations):

   smp_cond_load_relaxed_timeout(ptr, cond_expr, time_expr, timeout)
   smp_cond_load_acquire_timeout(ptr, cond_expr, time_expr, timeout)

Also add tif_need_resched_relaxed_wait() which wraps the polling pattern
and its scheduler specific details in poll_idle().  In addition add
atomic_cond_read_*_timeout(), atomic64_cond_read_*_timeout(), and
atomic_long wrappers.

Structurally, both the smp_cond_load_*_timeout() interfaces are similar to
smp_cond_load*(), with the addition of a rate-limited time-check.

Usage
=====

These interfaces drop straight-forwardly into the rqspinlock logic since
qspinlock already uses smp_cond_load*(), and the time-check extension can
now be used for timeout and deadlock handling.

Using tif_need_resched_relaxed_wait() in poll_idle() removes any
architectural details allowing arm64 to straight-forwardly support that
path.

(However, for efficiency reasons cpuidle/poll_state.c continues to depend
on ARCH_HAS_CPU_RELAX since that is defined on architectures with an
optimized architectural primitive.)


Performance
===========

Apart from simplifications due to this change, supporting polling in
cpuidle on arm64 helps improve wakeup latency (needs a few cpuidle/acpi
patches):


  # perf stat -r 5 --cpu 4,5 -e task-clock,cycles,instructions,sched:sched_wake_idle_without_ipi \
  perf bench sched pipe -l 1000000 -c 4

  # No haltpoll (and, no TIF_POLLING_NRFLAG):

  Performance counter stats for 'CPU(s) 4,5' (5 runs):

         25,229.57 msec task-clock                       #    2.000 CPUs utilized               ( +-  7.75% )
    45,821,250,284      cycles                           #    1.816 GHz                         ( +- 10.07% )
    26,557,496,665      instructions                     #    0.58  insn per cycle              ( +-  0.21% )
                 0      sched:sched_wake_idle_without_ipi #    0.000 /sec

       12.615 +- 0.977 seconds time elapsed  ( +-  7.75% )


  # Haltpoll:

  Performance counter stats for 'CPU(s) 4,5' (5 runs):

         15,131.58 msec task-clock                       #    2.000 CPUs utilized               ( +- 10.00% )
    34,158,188,839      cycles                           #    2.257 GHz                         ( +-  6.91% )
    20,824,950,916      instructions                     #    0.61  insn per cycle              ( +-  0.09% )
         1,983,822      sched:sched_wake_idle_without_ipi #  131.105 K/sec                       ( +-  0.78% )

        7.566 +- 0.756 seconds time elapsed  ( +- 10.00% )

  We get improved latency because we don't switch in and out of a
  deeper sleep state or from the hypervisor. This also causes us to
  execute ~20% fewer instructions.

Haris Okanovic also saw improvement in real workloads due to the cpuidle
changes: "observed 4-6% improvements in memcahed, cassandra, mysql, and
postgresql under certain loads.  Other applications likely benefit too."
[1]


This patch (of 14):

Add smp_cond_load_relaxed_timeout(), which extends smp_cond_load_relaxed()
to allow waiting for a duration.

We loop around waiting for the condition variable to change while
peridically doing a time-check.  The loop uses cpu_poll_relax() to slow
down the busy-wait, which, unless overridden by the architecture code,
amounts to a cpu_relax().

Note that there are two ways for the time-check to fail: the timeout case
or, @time_expr_ns returning an invalid value (negative or zero).  The
second failure mode allows for clocks attached to the clock-domain of
@cond_expr -- which might cease to operate meaningfully once some state
internal to @cond_expr has changed -- to fail.

Evaluation of @time_expr_ns: in the fastpath we want to keep the
performance close to smp_cond_load_relaxed().  So defer evaluation of the
potentially costly @time_expr_ns to the slowpath.

This also means that there will always be some hardware dependent duration
that has passed in cpu_poll_relax() iterations at the time of first
evaluation.  Additionally cpu_poll_relax() is not guaranteed to return at
timeout boundary.  In sum, expect timeout overshoot when we exit due to
expiration of the timeout.

The number of spin iterations before time-check, SMP_TIMEOUT_POLL_COUNT is
chosen to be 200 by default.  With a cpu_poll_relax() iteration taking
~20-30 cycles (measured on a variety of x86 platforms), we expect a
time-check every ~4000-6000 cycles.

The outer limit of the overshoot is double that when working with the
parameters above.  This might be higher or lower depending on the
implementation of cpu_poll_relax() across architectures.

Lastly, config option ARCH_HAS_CPU_RELAX indicates availability of a
cpu_poll_relax() that is cheaper than polling.  This might be relevant for
cases with a long timeout.

Link: https://lore.kernel.org/20260408122538.3610871-1-ankur.a.arora@oracle.com
Link: https://lore.kernel.org/20260408122538.3610871-2-ankur.a.arora@oracle.com
Link: https://lore.kernel.org/lkml/c6f3c8d3f1f2e89a9dc7ae22482973b5a51b08cb.camel@amazon.com/ [1]
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
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
Cc: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/barrier.h |   69 ++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

--- a/include/asm-generic/barrier.h~asm-generic-barrier-add-smp_cond_load_relaxed_timeout
+++ a/include/asm-generic/barrier.h
@@ -274,6 +274,75 @@ do {									\
 #endif
 
 /*
+ * Number of times we iterate in the loop before doing the time check.
+ * Note that the iteration count assumes that the loop condition is
+ * relatively cheap.
+ */
+#ifndef SMP_TIMEOUT_POLL_COUNT
+#define SMP_TIMEOUT_POLL_COUNT		200
+#endif
+
+/*
+ * Platforms with ARCH_HAS_CPU_RELAX have a cpu_poll_relax() implementation
+ * that is expected to be cheaper (lower power) than pure polling.
+ */
+#ifndef cpu_poll_relax
+#define cpu_poll_relax(ptr, val, timeout_ns)	cpu_relax()
+#endif
+
+/**
+ * smp_cond_load_relaxed_timeout() - (Spin) wait for cond with no ordering
+ * guarantees until a timeout expires.
+ * @ptr: pointer to the variable to wait on.
+ * @cond_expr: boolean expression to wait for.
+ * @time_expr_ns: expression that evaluates to monotonic time (in ns) or,
+ *  on failure, returns a negative value.
+ * @timeout_ns: timeout value in ns
+ * Both of the above are assumed to be compatible with s64; the signed
+ * value is used to handle the failure case in @time_expr_ns.
+ *
+ * Equivalent to using READ_ONCE() on the condition variable.
+ *
+ * Callers that expect to wait for prolonged durations might want
+ * to take into account the availability of ARCH_HAS_CPU_RELAX.
+ *
+ * Note that @ptr is expected to point to a memory address. Using this
+ * interface with MMIO will be slower (since SMP_TIMEOUT_POLL_COUNT is
+ * tuned for memory) and might also break in interesting architecture
+ * dependent ways.
+ */
+#ifndef smp_cond_load_relaxed_timeout
+#define smp_cond_load_relaxed_timeout(ptr, cond_expr,			\
+				      time_expr_ns, timeout_ns)		\
+({									\
+	typeof(ptr) __PTR = (ptr);					\
+	__unqual_scalar_typeof(*ptr) VAL;				\
+	u32 __n = 0, __spin = SMP_TIMEOUT_POLL_COUNT;			\
+	s64 __timeout = (s64)timeout_ns;				\
+	s64 __time_now, __time_end = 0;					\
+									\
+	for (;;) {							\
+		VAL = READ_ONCE(*__PTR);				\
+		if (cond_expr)						\
+			break;						\
+		cpu_poll_relax(__PTR, VAL, (u64)__timeout);		\
+		if (++__n < __spin)					\
+			continue;					\
+		__time_now = (s64)(time_expr_ns);			\
+		if (unlikely(__time_end == 0))				\
+			__time_end = __time_now + __timeout;		\
+		__timeout = __time_end - __time_now;			\
+		if (__time_now <= 0 || __timeout <= 0) {		\
+			VAL = READ_ONCE(*__PTR);			\
+			break;						\
+		}							\
+		__n = 0;						\
+	}								\
+	(typeof(*ptr))VAL;						\
+})
+#endif
+
+/*
  * pmem_wmb() ensures that all stores for which the modification
  * are written to persistent storage by preceding instructions have
  * updated persistent storage before any data  access or data transfer
_

Patches currently in -mm which might be from ankur.a.arora@oracle.com are

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

