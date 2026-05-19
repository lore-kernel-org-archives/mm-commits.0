Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7149346AF1E
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 16:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779208161; cv=none; b=IzNAS3gKBg1UWlehMx8+4KLq0iPput7aLihT9+dsS2KkTtel4XKlGxd9pXOclSZOx4kZgFPoWKkQbcFh680K5UcQ20vVnnYM/f7k9V3VkrpnXJ1f2dfFHEjPKcybkH7YUwoxlfJxUoopN7wxR/t8Nlo4202iGn0n8NBglBe91Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779208161; c=relaxed/simple;
	bh=BtlGbxpx6IyWsOLOZxC+VFTqeL9huDAPRJZ2cSmLONg=;
	h=Date:To:From:Subject:Message-Id; b=ZcprLWuToYzHKiBo/+vkPLQicebAqsI8UK+78tXPILrZu26TGuwGblPFq8gWC5/dmDGgcG1mFrZ3mc047pfZf6xJieFQf9n5JsCS2J088K2zm3AnKxxi9u+DlIYLRS60Fo9OTomo/vS8Nj6ml/TZgrEZ+WHMYlvwIzb9NeYOcCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jXJKQqvP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jXJKQqvP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B73C2BCB3;
	Tue, 19 May 2026 16:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779208161;
	bh=BtlGbxpx6IyWsOLOZxC+VFTqeL9huDAPRJZ2cSmLONg=;
	h=Date:To:From:Subject:From;
	b=jXJKQqvP8qCJH0vFsg8IhIQwQ3m5suFrHa0/hcSZedLVyCPNesZ58FHS0G3fajyxp
	 xmZbd6PhdBwvbOTivQ20i3jd1k49vVBzWKJ9SUuO11rbOw8mqjKoAGfQShCNKtcB5l
	 FXI8i0U5B9MCu3OaBdIsKtGxCkzOTZoQfgvEaXKY=
Date: Tue, 19 May 2026 09:29:20 -0700
To: mm-commits@vger.kernel.org,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] asm-generic-barrier-add-smp_cond_load_acquire_timeout.patch removed from -mm tree
Message-Id: <20260519162921.39B73C2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: asm-generic: barrier: add smp_cond_load_acquire_timeout()
has been removed from the -mm tree.  Its filename was
     asm-generic-barrier-add-smp_cond_load_acquire_timeout.patch

This patch was dropped because an updated version will be issued

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

atomic-add-atomic_cond_read__timeout.patch
locking-atomic-scripts-build-atomic_long_cond_read__timeout.patch
bpf-rqspinlock-switch-check_timeout-to-a-clock-interface.patch
bpf-rqspinlock-use-smp_cond_load_acquire_timeout.patch
sched-add-need-resched-timed-wait-interface.patch
cpuidle-poll_state-wait-for-need-resched-via-tif_need_resched_relaxed_wait.patch
kunit-enable-testing-smp_cond_load_relaxed_timeout.patch
kunit-add-tests-for-smp_cond_load_relaxed_timeout.patch

