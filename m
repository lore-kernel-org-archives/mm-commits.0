Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DED3A7599
	for <mm-commits@vger.kernel.org>; Thu, 23 Apr 2026 17:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776964653; cv=none; b=jFMv0X6+aVRKfKd5mTkCyOhCP+EbT7v4C6Vas4WYjx6bKyi+1elxxRPdjpT1JfLqpA8Qdeom4297z+VWKKTvUjiL66xCh2nZotvVCEMo5NSl1iraCtni25CA9uWG5x/nR+mySX+vZfE0vtfAY69rRdWSUNAZHZ1klCLHw779/5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776964653; c=relaxed/simple;
	bh=t8pkyoBVUZRb+KgIDnhCdtAlUT77sww5E6rQBUWhMVw=;
	h=Date:To:From:Subject:Message-Id; b=SbAJ15laqijkhiIRhTKuXEuDUi62nesYWWJIxPoSZdvQ79aOYFIRPVBLlAvse4KojYSUCoYyqaItIAriN2nhjrrjWusL+8KlQigVcvMY9Sso7BZhUNTb2sFs58k8wF6kWHGIvCRM0vMRIZ0Ai3W1mG91CN0LpbBTcNmWKBIenZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y5W1p3hz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y5W1p3hz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622D3C2BCAF;
	Thu, 23 Apr 2026 17:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776964653;
	bh=t8pkyoBVUZRb+KgIDnhCdtAlUT77sww5E6rQBUWhMVw=;
	h=Date:To:From:Subject:From;
	b=Y5W1p3hzcq8TXrrPI8QppVD5tAIRRKS7ppeoPbWSlFFsBOoV2V8eagoP0KfKKwjnJ
	 YCRcG2HLg0ZNEqWifjfMsDtVgE2KeBGxI3jl2ga/Ck+0krFyFwplO3Gf6KHuPP96q9
	 fRHa2B4IFxWWZMd6LiCir723vlXTKZOQB3wASHW0=
Date: Thu, 23 Apr 2026 10:17:32 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,rafael@kernel.org,peterz@infradead.org,mingo@kernel.org,memxor@gmail.com,mark.rutland@arm.com,konradybcio@kernel.org,harisokn@amazon.com,gary@garyguo.net,davidgow@google.com,daniel.lezcano@linaro.org,cl@linux.com,catalin.marinas@arm.com,boqun@kernel.org,boqun.feng@gmail.com,ast@kernel.org,arnd@arndb.de,andersson@kernel.org,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + locking-atomic-scripts-build-atomic_long_cond_read__timeout.patch added to mm-new branch
Message-Id: <20260423171733.622D3C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: locking/atomic: scripts: build atomic_long_cond_read_*_timeout()
has been added to the -mm mm-new branch.  Its filename is
     locking-atomic-scripts-build-atomic_long_cond_read__timeout.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/locking-atomic-scripts-build-atomic_long_cond_read__timeout.patch

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
Subject: locking/atomic: scripts: build atomic_long_cond_read_*_timeout()
Date: Wed, 8 Apr 2026 17:55:32 +0530

Add the atomic long wrappers for the cond-load timeout interfaces.

Link: https://lore.kernel.org/20260408122538.3610871-9-ankur.a.arora@oracle.com
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Bjorn Andersson <andersson@kernel.org>
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

 include/linux/atomic/atomic-long.h |   18 +++++++++++-------
 scripts/atomic/gen-atomic-long.sh  |   16 ++++++++++------
 2 files changed, 21 insertions(+), 13 deletions(-)

--- a/include/linux/atomic/atomic-long.h~locking-atomic-scripts-build-atomic_long_cond_read__timeout
+++ a/include/linux/atomic/atomic-long.h
@@ -11,14 +11,18 @@
 
 #ifdef CONFIG_64BIT
 typedef atomic64_t atomic_long_t;
-#define ATOMIC_LONG_INIT(i)		ATOMIC64_INIT(i)
-#define atomic_long_cond_read_acquire	atomic64_cond_read_acquire
-#define atomic_long_cond_read_relaxed	atomic64_cond_read_relaxed
+#define ATOMIC_LONG_INIT(i)			ATOMIC64_INIT(i)
+#define atomic_long_cond_read_acquire		atomic64_cond_read_acquire
+#define atomic_long_cond_read_relaxed		atomic64_cond_read_relaxed
+#define atomic_long_cond_read_acquire_timeout	atomic64_cond_read_acquire_timeout
+#define atomic_long_cond_read_relaxed_timeout	atomic64_cond_read_relaxed_timeout
 #else
 typedef atomic_t atomic_long_t;
-#define ATOMIC_LONG_INIT(i)		ATOMIC_INIT(i)
-#define atomic_long_cond_read_acquire	atomic_cond_read_acquire
-#define atomic_long_cond_read_relaxed	atomic_cond_read_relaxed
+#define ATOMIC_LONG_INIT(i)			ATOMIC_INIT(i)
+#define atomic_long_cond_read_acquire		atomic_cond_read_acquire
+#define atomic_long_cond_read_relaxed		atomic_cond_read_relaxed
+#define atomic_long_cond_read_acquire_timeout	atomic_cond_read_acquire_timeout
+#define atomic_long_cond_read_relaxed_timeout	atomic_cond_read_relaxed_timeout
 #endif
 
 /**
@@ -1809,4 +1813,4 @@ raw_atomic_long_dec_if_positive(atomic_l
 }
 
 #endif /* _LINUX_ATOMIC_LONG_H */
-// 4b882bf19018602c10816c52f8b4ae280adc887b
+// 79c1f4acb5774376ceed559843d5d9ed1348df99
--- a/scripts/atomic/gen-atomic-long.sh~locking-atomic-scripts-build-atomic_long_cond_read__timeout
+++ a/scripts/atomic/gen-atomic-long.sh
@@ -79,14 +79,18 @@ cat << EOF
 
 #ifdef CONFIG_64BIT
 typedef atomic64_t atomic_long_t;
-#define ATOMIC_LONG_INIT(i)		ATOMIC64_INIT(i)
-#define atomic_long_cond_read_acquire	atomic64_cond_read_acquire
-#define atomic_long_cond_read_relaxed	atomic64_cond_read_relaxed
+#define ATOMIC_LONG_INIT(i)			ATOMIC64_INIT(i)
+#define atomic_long_cond_read_acquire		atomic64_cond_read_acquire
+#define atomic_long_cond_read_relaxed		atomic64_cond_read_relaxed
+#define atomic_long_cond_read_acquire_timeout	atomic64_cond_read_acquire_timeout
+#define atomic_long_cond_read_relaxed_timeout	atomic64_cond_read_relaxed_timeout
 #else
 typedef atomic_t atomic_long_t;
-#define ATOMIC_LONG_INIT(i)		ATOMIC_INIT(i)
-#define atomic_long_cond_read_acquire	atomic_cond_read_acquire
-#define atomic_long_cond_read_relaxed	atomic_cond_read_relaxed
+#define ATOMIC_LONG_INIT(i)			ATOMIC_INIT(i)
+#define atomic_long_cond_read_acquire		atomic_cond_read_acquire
+#define atomic_long_cond_read_relaxed		atomic_cond_read_relaxed
+#define atomic_long_cond_read_acquire_timeout	atomic_cond_read_acquire_timeout
+#define atomic_long_cond_read_relaxed_timeout	atomic_cond_read_relaxed_timeout
 #endif
 
 EOF
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

