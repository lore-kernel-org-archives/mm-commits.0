Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DD43EA961
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 16:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779208158; cv=none; b=JwE0w8dbxIvT7IKQCITdwboD3vmrRKGUlwyHsrrwzPzJPPKWBt4+2Hi0amhLxX7GyV2FsMW+UeV6LjyGIRdI65nEPTQNNehkXJkIJDo7smM5WtgXsLv0Z5H8pOPuC32ZQfihZzC7KL7C7v6I+/EkWbRP5ixgHBeApLxw6rC7T6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779208158; c=relaxed/simple;
	bh=/nj00SihEwFJId2Dep/nY2ZqvDr7gSm34kocGU3YjaQ=;
	h=Date:To:From:Subject:Message-Id; b=I4UcoEcQCZy298LS5QPrLN/XTMo9xuELvX+eIL+wXcNTiBvPXqMoQYLXzkbfc8YJe9zOYQHJny71RQMAnBYsY72zHLTmsWHldDu6ie48qvCtwmNydaqY2ZKoT4AWA+jsWbIlzCnw/e+b2e1EeftxmeIFyv2zXfq8onG6dfwlmUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sGNft0/2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sGNft0/2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84007C2BCB3;
	Tue, 19 May 2026 16:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779208158;
	bh=/nj00SihEwFJId2Dep/nY2ZqvDr7gSm34kocGU3YjaQ=;
	h=Date:To:From:Subject:From;
	b=sGNft0/2MxIAVgjN8zi6Coirggwvs0nX9kn3sLGD69hejm5dS2uGulZQNPFw+nPbU
	 RwXO66yBdVQo6KTNotxr70nL/f8GaT/zi+PoGujKFVcfr3Nm3mdXZs7LFj1mPlKKuR
	 feuP8+AQ4amHHQUFg+1Fr59nEwhKT6IPvO2hG+6Y=
Date: Tue, 19 May 2026 09:29:17 -0700
To: mm-commits@vger.kernel.org,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] arm64-support-wfet-in-smp_cond_load_relaxed_timeout.patch removed from -mm tree
Message-Id: <20260519162918.84007C2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: support WFET in smp_cond_load_relaxed_timeout()
has been removed from the -mm tree.  Its filename was
     arm64-support-wfet-in-smp_cond_load_relaxed_timeout.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Ankur Arora <ankur.a.arora@oracle.com>
Subject: arm64: support WFET in smp_cond_load_relaxed_timeout()
Date: Wed, 8 Apr 2026 17:55:28 +0530

To handle WFET use __cmpwait_timeout() similarly to __cmpwait().  These
call out to the respective __cmpwait_case_timeout_##sz(),
__cmpwait_case_##sz() functions.

Link: https://lore.kernel.org/20260408122538.3610871-5-ankur.a.arora@oracle.com
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Will Deacon <will@kernel.org>
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

 arch/arm64/include/asm/barrier.h |    8 ++-
 arch/arm64/include/asm/cmpxchg.h |   62 +++++++++++++++++++++++------
 2 files changed, 55 insertions(+), 15 deletions(-)

--- a/arch/arm64/include/asm/barrier.h~arm64-support-wfet-in-smp_cond_load_relaxed_timeout
+++ a/arch/arm64/include/asm/barrier.h
@@ -224,8 +224,8 @@ do {									\
 extern bool arch_timer_evtstrm_available(void);
 
 /*
- * In the common case, cpu_poll_relax() sits waiting in __cmpwait_relaxed()
- * for the ptr value to change.
+ * In the common case, cpu_poll_relax() sits waiting in __cmpwait_relaxed()/
+ * __cmpwait_relaxed_timeout() for the ptr value to change.
  *
  * Since this period is reasonably long, choose SMP_TIMEOUT_POLL_COUNT
  * to be 1, so smp_cond_load_{relaxed,acquire}_timeout() does a
@@ -234,7 +234,9 @@ extern bool arch_timer_evtstrm_available
 #define SMP_TIMEOUT_POLL_COUNT	1
 
 #define cpu_poll_relax(ptr, val, timeout_ns) do {			\
-	if (arch_timer_evtstrm_available())				\
+	if (alternative_has_cap_unlikely(ARM64_HAS_WFXT))		\
+		__cmpwait_relaxed_timeout(ptr, val, timeout_ns);	\
+	else if (arch_timer_evtstrm_available())			\
 		__cmpwait_relaxed(ptr, val);				\
 	else								\
 		cpu_relax();						\
--- a/arch/arm64/include/asm/cmpxchg.h~arm64-support-wfet-in-smp_cond_load_relaxed_timeout
+++ a/arch/arm64/include/asm/cmpxchg.h
@@ -12,6 +12,7 @@
 
 #include <asm/barrier.h>
 #include <asm/lse.h>
+#include <asm/delay-const.h>
 
 /*
  * We need separate acquire parameters for ll/sc and lse, since the full
@@ -212,7 +213,8 @@ __CMPXCHG_GEN(_mb)
 
 #define __CMPWAIT_CASE(w, sfx, sz)					\
 static inline void __cmpwait_case_##sz(volatile void *ptr,		\
-				       unsigned long val)		\
+				       unsigned long val,		\
+				       u64 __maybe_unused timeout_ns)	\
 {									\
 	unsigned long tmp;						\
 									\
@@ -235,20 +237,52 @@ __CMPWAIT_CASE( ,  , 64);
 
 #undef __CMPWAIT_CASE
 
-#define __CMPWAIT_GEN(sfx)						\
-static __always_inline void __cmpwait##sfx(volatile void *ptr,		\
-				  unsigned long val,			\
-				  int size)				\
+#define __CMPWAIT_TIMEOUT_CASE(w, sfx, sz)				\
+static inline void __cmpwait_case_timeout_##sz(volatile void *ptr,	\
+					       unsigned long val,	\
+					       u64 timeout_ns)		\
+{									\
+	unsigned long tmp;						\
+	u64 ecycles = __delay_cycles() +				\
+			NSECS_TO_CYCLES(timeout_ns);			\
+	asm volatile(							\
+	"	sevl\n"							\
+	"	wfe\n"							\
+	"	ldxr" #sfx "\t%" #w "[tmp], %[v]\n"			\
+	"	eor	%" #w "[tmp], %" #w "[tmp], %" #w "[val]\n"	\
+	"	cbnz	%" #w "[tmp], 2f\n"				\
+	"	msr s0_3_c1_c0_0, %[ecycles]\n"				\
+	"2:"								\
+	: [tmp] "=&r" (tmp), [v] "+Q" (*(u##sz *)ptr)			\
+	: [val] "r" (val), [ecycles] "r" (ecycles));			\
+}
+
+__CMPWAIT_TIMEOUT_CASE(w, b, 8);
+__CMPWAIT_TIMEOUT_CASE(w, h, 16);
+__CMPWAIT_TIMEOUT_CASE(w,  , 32);
+__CMPWAIT_TIMEOUT_CASE( ,  , 64);
+
+#undef __CMPWAIT_TIMEOUT_CASE
+
+#define __CMPWAIT_GEN(timeout, sfx)					\
+static __always_inline void __cmpwait##timeout##sfx(volatile void *ptr,	\
+						    unsigned long val,	\
+						    u64 timeout_ns,	\
+						    int size)		\
 {									\
 	switch (size) {							\
 	case 1:								\
-		return __cmpwait_case##sfx##_8(ptr, (u8)val);		\
+		return __cmpwait_case##timeout##sfx##_8(ptr, (u8)val,	\
+							timeout_ns);	\
 	case 2:								\
-		return __cmpwait_case##sfx##_16(ptr, (u16)val);		\
+		return __cmpwait_case##timeout##sfx##_16(ptr, (u16)val,	\
+							 timeout_ns);	\
 	case 4:								\
-		return __cmpwait_case##sfx##_32(ptr, val);		\
+		return __cmpwait_case##timeout##sfx##_32(ptr, val,	\
+							 timeout_ns);	\
 	case 8:								\
-		return __cmpwait_case##sfx##_64(ptr, val);		\
+		return __cmpwait_case##timeout##sfx##_64(ptr, val,	\
+							 timeout_ns);	\
 	default:							\
 		BUILD_BUG();						\
 	}								\
@@ -256,11 +290,15 @@ static __always_inline void __cmpwait##s
 	unreachable();							\
 }
 
-__CMPWAIT_GEN()
+__CMPWAIT_GEN(        , )
+__CMPWAIT_GEN(_timeout, )
 
 #undef __CMPWAIT_GEN
 
-#define __cmpwait_relaxed(ptr, val) \
-	__cmpwait((ptr), (unsigned long)(val), sizeof(*(ptr)))
+#define __cmpwait_relaxed_timeout(ptr, val, timeout_ns)			\
+	__cmpwait_timeout((ptr), (unsigned long)(val), timeout_ns, sizeof(*(ptr)))
+
+#define __cmpwait_relaxed(ptr, val)					\
+	__cmpwait((ptr), (unsigned long)(val), 0, sizeof(*(ptr)))
 
 #endif	/* __ASM_CMPXCHG_H */
_

Patches currently in -mm which might be from ankur.a.arora@oracle.com are

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

