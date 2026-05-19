Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C530248034C
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 16:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779208169; cv=none; b=bh3TbMPNbtYlrUEzJ8THGlnHN6obN4WF9YItmjD4hcUEzGcjBGdca9rbd/IVRb3aVmICj6gF4rgZOLguKPKoLHp3crJ+iTdTB49ZdxtEV0axZ/wOis76KPBDIH5lXsVI6qiO8bPY1MvS1ra56P4zqUHNJ7LTOt5YqFoBZiaHGd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779208169; c=relaxed/simple;
	bh=tGUfRXER+sV4vaydbCvXGwWOcLjOHrPr2ODaji4PauA=;
	h=Date:To:From:Subject:Message-Id; b=kXZ9YKEz5fEJC7qbFJ2uNRkj3OrsXOuhL4JxXgIQUiPHRjcW3piam8vJOZigP/f5H8rDmLT8qRK02XSilsXoF2OmU9zQUGngHPMkHul6blqzodNApN9p8XX/7yKYOyVv1ME/rnLOFoRnGavVtgAZuR8esDTatSzUrirMYpkIQfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vk8CFyvB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vk8CFyvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD78C2BCB3;
	Tue, 19 May 2026 16:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779208169;
	bh=tGUfRXER+sV4vaydbCvXGwWOcLjOHrPr2ODaji4PauA=;
	h=Date:To:From:Subject:From;
	b=vk8CFyvBSFP+ae5vCpYDy9YHTN932uPsuBC6kcu+dr5+j3efIGpbUd/DJ4sjd3Yh9
	 OUC0bU2liVZkcksXvGr5I7ANMTs/RYX1ssbNibz7+fXGx0Lb036ICYX6L4ksyRGh1/
	 RpQlVtx3GFVQ8rcdFGvrHX4r+ibfBwby5r4gfqxg=
Date: Tue, 19 May 2026 09:29:29 -0700
To: mm-commits@vger.kernel.org,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] cpuidle-poll_state-wait-for-need-resched-via-tif_need_resched_relaxed_wait.patch removed from -mm tree
Message-Id: <20260519162929.7DD78C2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: cpuidle/poll_state: wait for need-resched via tif_need_resched_relaxed_wait()
has been removed from the -mm tree.  Its filename was
     cpuidle-poll_state-wait-for-need-resched-via-tif_need_resched_relaxed_wait.patch

This patch was dropped because an updated version will be issued

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

kunit-enable-testing-smp_cond_load_relaxed_timeout.patch
kunit-add-tests-for-smp_cond_load_relaxed_timeout.patch

