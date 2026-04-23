Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604E43A6B9E
	for <mm-commits@vger.kernel.org>; Thu, 23 Apr 2026 17:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776964656; cv=none; b=LqeVG8eDbZczJj8o9iBczc7dK0BGklftyc/wl2X94gUEnkNAp5qWN87QESsOmlXudEd9QzY+TqmOfs2esVZLSi/ycGBOMxBQyZr0/FqcWgTJU72fCWKfWjPDHAent7aWHt6AEXXb3fCUlECfqRDNnCpZDoDtXHY9nVBSXorOMDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776964656; c=relaxed/simple;
	bh=Nv53s639FaSbhr1vvTuCiVU2D40Kf7iqlTAQbHqpdRI=;
	h=Date:To:From:Subject:Message-Id; b=SE+2BsnXPq9zoN8t9E4Vy5HRGbBPmWE7QY/Oj2dLZ9y8E/4ELV6fEMoVO5W4d9PJyLMDLadQMJZGWjOyKSGG+QIOeEighbaC3BLrRUI8aZt6NQ6CmY6eYfPHUBqslSbRqiXOe4kTEN5alL7XnmePHBj4eFmn7xuKFtubmXyP880=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eKeZmIsd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eKeZmIsd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232D9C2BCB3;
	Thu, 23 Apr 2026 17:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776964656;
	bh=Nv53s639FaSbhr1vvTuCiVU2D40Kf7iqlTAQbHqpdRI=;
	h=Date:To:From:Subject:From;
	b=eKeZmIsdTkLyZCWBwQO5hj0oLpF8yzDIr3943n7LNMmUeOUgCfldz8cbdRQ1w5dch
	 ZH0yOpdhty5lXuyqxiWb4PEAZgMtvY2vlxr/nKEfbcDhXD6o1EQ1JmZV9kCJiBb7uT
	 wmd+ZmfaXOr6Qb4h6LTGjmVtFV8sXDqMvFFMkUbo=
Date: Thu, 23 Apr 2026 10:17:35 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,rafael@kernel.org,peterz@infradead.org,mingo@kernel.org,memxor@gmail.com,mark.rutland@arm.com,konradybcio@kernel.org,harisokn@amazon.com,gary@garyguo.net,davidgow@google.com,daniel.lezcano@linaro.org,cl@linux.com,catalin.marinas@arm.com,boqun@kernel.org,boqun.feng@gmail.com,ast@kernel.org,arnd@arndb.de,andersson@kernel.org,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bpf-rqspinlock-switch-check_timeout-to-a-clock-interface.patch added to mm-new branch
Message-Id: <20260423171736.232D9C2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: bpf/rqspinlock: switch check_timeout() to a clock interface
has been added to the -mm mm-new branch.  Its filename is
     bpf-rqspinlock-switch-check_timeout-to-a-clock-interface.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bpf-rqspinlock-switch-check_timeout-to-a-clock-interface.patch

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
Subject: bpf/rqspinlock: switch check_timeout() to a clock interface
Date: Wed, 8 Apr 2026 17:55:33 +0530

check_timeout() gets the current time value and depending on how much time
has passed, checks for deadlock or times out, returning 0 or -errno on
deadlock or timeout.

Switch this out to a clock style interface, where it functions as a clock
in the "lock-domain", returning the current time until a deadlock or
timeout occurs.  Once a deadlock or timeout has occurred, it stops
functioning as a clock and returns error.

Also adjust the RES_CHECK_TIMEOUT macro to discard the clock value when
updating the explicit return status.

Link: https://lore.kernel.org/20260408122538.3610871-10-ankur.a.arora@oracle.com
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Boqun Feng <boqun@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: David Gow <davidgow@google.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: Haris Okanovic <harisokn@amazon.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Konrad Dybcio <konradybcio@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/bpf/rqspinlock.c |   45 +++++++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 15 deletions(-)

--- a/kernel/bpf/rqspinlock.c~bpf-rqspinlock-switch-check_timeout-to-a-clock-interface
+++ a/kernel/bpf/rqspinlock.c
@@ -196,8 +196,12 @@ static noinline int check_deadlock_ABBA(
 	return 0;
 }
 
-static noinline int check_timeout(rqspinlock_t *lock, u32 mask,
-				  struct rqspinlock_timeout *ts)
+/*
+ * Returns current monotonic time in ns on success or, negative errno
+ * value on failure due to timeout expiration or detection of deadlock.
+ */
+static noinline s64 clock_deadlock(rqspinlock_t *lock, u32 mask,
+				   struct rqspinlock_timeout *ts)
 {
 	u64 prev = ts->cur;
 	u64 time;
@@ -207,7 +211,7 @@ static noinline int check_timeout(rqspin
 			return -EDEADLK;
 		ts->cur = ktime_get_mono_fast_ns();
 		ts->timeout_end = ts->cur + ts->duration;
-		return 0;
+		return (s64)ts->cur;
 	}
 
 	time = ktime_get_mono_fast_ns();
@@ -219,11 +223,15 @@ static noinline int check_timeout(rqspin
 	 * checks.
 	 */
 	if (prev + NSEC_PER_MSEC < time) {
+		int ret;
 		ts->cur = time;
-		return check_deadlock_ABBA(lock, mask);
+		ret = check_deadlock_ABBA(lock, mask);
+		if (ret)
+			return ret;
+
 	}
 
-	return 0;
+	return (s64)time;
 }
 
 /*
@@ -231,15 +239,22 @@ static noinline int check_timeout(rqspin
  * as the macro does internal amortization for us.
  */
 #ifndef res_smp_cond_load_acquire
-#define RES_CHECK_TIMEOUT(ts, ret, mask)                              \
-	({                                                            \
-		if (!(ts).spin++)                                     \
-			(ret) = check_timeout((lock), (mask), &(ts)); \
-		(ret);                                                \
+#define RES_CHECK_TIMEOUT(ts, ret, mask)					\
+	({									\
+		s64 __timeval_err = 0;						\
+		if (!(ts).spin++)						\
+			__timeval_err = clock_deadlock((lock), (mask), &(ts));	\
+		(ret) = __timeval_err < 0 ? __timeval_err : 0;			\
+		__timeval_err;							\
 	})
 #else
-#define RES_CHECK_TIMEOUT(ts, ret, mask)			      \
-	({ (ret) = check_timeout((lock), (mask), &(ts)); })
+#define RES_CHECK_TIMEOUT(ts, ret, mask)					\
+	({									\
+		s64 __timeval_err;						\
+		__timeval_err = clock_deadlock((lock), (mask), &(ts));		\
+		(ret) = __timeval_err < 0 ? __timeval_err : 0;			\
+		__timeval_err;							\
+	})
 #endif
 
 /*
@@ -281,7 +296,7 @@ retry:
 	val = atomic_read(&lock->val);
 
 	if (val || !atomic_try_cmpxchg(&lock->val, &val, 1)) {
-		if (RES_CHECK_TIMEOUT(ts, ret, ~0u))
+		if (RES_CHECK_TIMEOUT(ts, ret, ~0u) < 0)
 			goto out;
 		cpu_relax();
 		goto retry;
@@ -406,7 +421,7 @@ int __lockfunc resilient_queued_spin_loc
 	 */
 	if (val & _Q_LOCKED_MASK) {
 		RES_RESET_TIMEOUT(ts, RES_DEF_TIMEOUT);
-		res_smp_cond_load_acquire(&lock->locked, !VAL || RES_CHECK_TIMEOUT(ts, ret, _Q_LOCKED_MASK));
+		res_smp_cond_load_acquire(&lock->locked, !VAL || RES_CHECK_TIMEOUT(ts, ret, _Q_LOCKED_MASK) < 0);
 	}
 
 	if (ret) {
@@ -568,7 +583,7 @@ queue:
 	 */
 	RES_RESET_TIMEOUT(ts, RES_DEF_TIMEOUT * 2);
 	val = res_atomic_cond_read_acquire(&lock->val, !(VAL & _Q_LOCKED_PENDING_MASK) ||
-					   RES_CHECK_TIMEOUT(ts, ret, _Q_LOCKED_PENDING_MASK));
+					   RES_CHECK_TIMEOUT(ts, ret, _Q_LOCKED_PENDING_MASK) < 0);
 
 	/* Disable queue destruction when we detect deadlocks. */
 	if (ret == -EDEADLK) {
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

