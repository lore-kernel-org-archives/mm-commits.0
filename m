Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E1637DE80
	for <mm-commits@vger.kernel.org>; Thu, 23 Apr 2026 17:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776964649; cv=none; b=QkjOboih5x6b/LUQ6l4NxtNj92BLR7jPR9/dk1IXv+6GN65RZUeqFkw2LXc6TmNnBwf1YQgWczFvoKSnn17l8AbqwSahrwRm/NdyoszF0MDlfzgiGPOCQESN88IKtzgX8rfx5dfxk9SS6oJSjp7mZW7YCBH/l80YNmtxqGiuBNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776964649; c=relaxed/simple;
	bh=VvYAHypeqr1gf38cIVKDv4DKKd13x3Mxf/L4ATiOB9E=;
	h=Date:To:From:Subject:Message-Id; b=J+WHNROxmINmPdyHr5HYEFXH7vlL6Vhoe62xpFpi78AWfQrbUu4eQ9RfjJAFQPshvCPOEn5nNd7JD2Wobxw74v2sAFxKG+T8/8m7HKYbXS9xDC1LHwPxTyjY3PAJrscOdfAjWqnkAA1MGZJZavytB1yrSatrlpOZCAEnDWD/LmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OqkfWcNF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OqkfWcNF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5D2C2BCAF;
	Thu, 23 Apr 2026 17:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776964648;
	bh=VvYAHypeqr1gf38cIVKDv4DKKd13x3Mxf/L4ATiOB9E=;
	h=Date:To:From:Subject:From;
	b=OqkfWcNFz+ZYuvkrZAIt3UuJcwLfqUU8QYhKrXcbp7NlLrDokNg+owy2OaMFvYzOt
	 Rq/WtJj75vB1QJI7SHnxO6g9wQdviHHSMncwk1ha6MAX14pkco5057XbuCySfJr9hJ
	 JSmI/2FH2GQZ7J+LT5C0ya3uf3ni4K3eXtGwtOkE=
Date: Thu, 23 Apr 2026 10:17:27 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,rafael@kernel.org,peterz@infradead.org,mingo@kernel.org,memxor@gmail.com,mark.rutland@arm.com,konradybcio@kernel.org,harisokn@amazon.com,gary@garyguo.net,davidgow@google.com,daniel.lezcano@linaro.org,cl@linux.com,catalin.marinas@arm.com,boqun@kernel.org,boqun.feng@gmail.com,ast@kernel.org,arnd@arndb.de,andersson@kernel.org,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + asm-generic-barrier-add-smp_cond_load_acquire_timeout.patch added to mm-new branch
Message-Id: <20260423171728.7B5D2C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: asm-generic: barrier: add smp_cond_load_acquire_timeout()
has been added to the -mm mm-new branch.  Its filename is
     asm-generic-barrier-add-smp_cond_load_acquire_timeout.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/asm-generic-barrier-add-smp_cond_load_acquire_timeout.patch

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
Subject: asm-generic: barrier: add smp_cond_load_acquire_timeout()
Date: Wed, 8 Apr 2026 17:55:30 +0530

Add the acquire variant of smp_cond_load_relaxed_timeout().  This reuses
the relaxed variant, with additional LOAD->LOAD ordering.

Link: https://lore.kernel.org/20260408122538.3610871-7-ankur.a.arora@oracle.com
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Haris Okanovic <harisokn@amazon.com>
Tested-by: Haris Okanovic <harisokn@amazon.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Boqun Feng <boqun@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: David Gow <davidgow@google.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Konrad Dybcio <konradybcio@kernel.org>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/barrier.h |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- a/include/asm-generic/barrier.h~asm-generic-barrier-add-smp_cond_load_acquire_timeout
+++ a/include/asm-generic/barrier.h
@@ -342,6 +342,32 @@ do {									\
 })
 #endif
 
+/**
+ * smp_cond_load_acquire_timeout() - (Spin) wait for cond with ACQUIRE ordering
+ * until a timeout expires.
+ * @ptr: pointer to the variable to wait on.
+ * @cond_expr: boolean expression to wait for.
+ * @time_expr_ns: monotonic expression that evaluates to time in ns or,
+ *  on failure, returns a negative value.
+ * @timeout_ns: timeout value in ns
+ * (Both of the above are assumed to be compatible with s64.)
+ *
+ * Equivalent to using smp_cond_load_acquire() on the condition variable with
+ * a timeout.
+ */
+#ifndef smp_cond_load_acquire_timeout
+#define smp_cond_load_acquire_timeout(ptr, cond_expr,			\
+				      time_expr_ns, timeout_ns)		\
+({									\
+	__unqual_scalar_typeof(*ptr) _val;				\
+	_val = smp_cond_load_relaxed_timeout(ptr, cond_expr,		\
+					     time_expr_ns,		\
+					     timeout_ns);		\
+	smp_acquire__after_ctrl_dep();					\
+	(typeof(*ptr))_val;						\
+})
+#endif
+
 /*
  * pmem_wmb() ensures that all stores for which the modification
  * are written to persistent storage by preceding instructions have
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

