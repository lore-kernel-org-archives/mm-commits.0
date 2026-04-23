Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750F73A75B2
	for <mm-commits@vger.kernel.org>; Thu, 23 Apr 2026 17:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776964663; cv=none; b=ptIJDH4jtQvJvW7WS3rvkIghL1Pcs8F+0MXv7wT8tq1hY0EXU3Un/ix9azqcTMRzMyo9qbrkmlJwdqDdvmlK4nSi+HFguOzrn3yfqOr9duODOtDOPZiwhqXnaNohcj8PkwpNSa9foAsWQE3rblWIAuFSTQhNON2/DQeArDtGt7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776964663; c=relaxed/simple;
	bh=g2N2WHb5Auj6cSlsM/kt5paB2HVzWy/dq46rmqLS0Ao=;
	h=Date:To:From:Subject:Message-Id; b=D23cJCwyCO4NklKBSyPL+eE5a7jphUt3AYp0A8zB2sUYKezqKTroDjk8nOBcYCu96XqTpLRho2+Fv3+yIL4lrfkPE2uOIEl856FzUbjxEMI3jLpUaz49CFpELPQN3iDAecNQKKz4WIRglAlT7wtgxWjTZDgTsMMIQg9Qicyn6zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ff07n/Ao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ff07n/Ao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B5AC2BCAF;
	Thu, 23 Apr 2026 17:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776964663;
	bh=g2N2WHb5Auj6cSlsM/kt5paB2HVzWy/dq46rmqLS0Ao=;
	h=Date:To:From:Subject:From;
	b=ff07n/AoCX0cUEpBNtlkJrP3c1JdjQ+Ar9G0E05sU7S8+/qO5oX8o6xKUsDGPSM2n
	 XX+h67tB+Z7dev+g24zqjJ6bV3pSZ2i3532LjVYg5scQbW2XRavmLNRW3xJT1AcezZ
	 eIRIsLUvudxJ/ne9I/ju5JIm7GEy+D3L05PpwnWo=
Date: Thu, 23 Apr 2026 10:17:42 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,rafael@kernel.org,peterz@infradead.org,mingo@kernel.org,memxor@gmail.com,mark.rutland@arm.com,konradybcio@kernel.org,harisokn@amazon.com,gary@garyguo.net,davidgow@google.com,daniel.lezcano@linaro.org,cl@linux.com,catalin.marinas@arm.com,boqun@kernel.org,boqun.feng@gmail.com,ast@kernel.org,arnd@arndb.de,andersson@kernel.org,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + cpuidle-poll_state-wait-for-need-resched-via-tif_need_resched_relaxed_wait.patch added to mm-new branch
Message-Id: <20260423171743.17B5AC2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: cpuidle/poll_state: wait for need-resched via tif_need_resched_relaxed_wait()
has been added to the -mm mm-new branch.  Its filename is
     cpuidle-poll_state-wait-for-need-resched-via-tif_need_resched_relaxed_wait.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cpuidle-poll_state-wait-for-need-resched-via-tif_need_resched_relaxed_wait.patch

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
Subject: cpuidle/poll_state: wait for need-resched via tif_need_resched_relaxed_wait()
Date: Wed, 8 Apr 2026 17:55:36 +0530

The inner loop in poll_idle() polls over the thread_info flags, waiting to
see if the thread has TIF_NEED_RESCHED set.  The loop exits once the
condition is met, or if the poll time limit has been exceeded.

To minimize the number of instructions executed in each iteration, the
time check is rate-limited.  In addition, each loop iteration executes
cpu_relax() which on certain platforms provides a hint to the pipeline
that the loop busy-waits, allowing the processor to reduce power
consumption.

Switch over to tif_need_resched_relaxed_wait() instead, since that
provides exactly that.

However, since we want to minimize power consumption in idle, building of
cpuidle/poll_state.c continues to depend on CONFIG_ARCH_HAS_CPU_RELAX as
that serves as an indicator that the platform supports an optimized
version of tif_need_resched_relaxed_wait() (via
smp_cond_load_acquire_timeout()).

Link: https://lore.kernel.org/20260408122538.3610871-13-ankur.a.arora@oracle.com
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Suggested-by: Rafael J. Wysocki <rafael@kernel.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Tested-by: Haris Okanovic <harisokn@amazon.com>
Cc: Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Gow <davidgow@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Konrad Dybcio <konradybcio@kernel.org>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/poll_state.c |   21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

--- a/drivers/cpuidle/poll_state.c~cpuidle-poll_state-wait-for-need-resched-via-tif_need_resched_relaxed_wait
+++ a/drivers/cpuidle/poll_state.c
@@ -6,41 +6,22 @@
 #include <linux/cpuidle.h>
 #include <linux/export.h>
 #include <linux/irqflags.h>
-#include <linux/sched.h>
-#include <linux/sched/clock.h>
 #include <linux/sched/idle.h>
 #include <linux/sprintf.h>
 #include <linux/types.h>
 
-#define POLL_IDLE_RELAX_COUNT	200
-
 static int __cpuidle poll_idle(struct cpuidle_device *dev,
 			       struct cpuidle_driver *drv, int index)
 {
-	u64 time_start;
-
-	time_start = local_clock_noinstr();
-
 	dev->poll_time_limit = false;
 
 	raw_local_irq_enable();
 	if (!current_set_polling_and_test()) {
-		unsigned int loop_count = 0;
 		u64 limit;
 
 		limit = cpuidle_poll_time(drv, dev);
 
-		while (!need_resched()) {
-			cpu_relax();
-			if (loop_count++ < POLL_IDLE_RELAX_COUNT)
-				continue;
-
-			loop_count = 0;
-			if (local_clock_noinstr() - time_start > limit) {
-				dev->poll_time_limit = true;
-				break;
-			}
-		}
+		dev->poll_time_limit = !tif_need_resched_relaxed_wait(limit);
 	}
 	raw_local_irq_disable();
 
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

