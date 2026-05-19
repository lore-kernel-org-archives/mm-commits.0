Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80866407CD6
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 16:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779208168; cv=none; b=QzoOEvyinBs8nHTssrEsjjTD7g9e+2ft7WSclAA+BSQvVqAuQBGyjgDgRkGLEH2Gw959pNGS/a2Ab0EfLL/MakCxjG0Fk91WGGlDOH4VrzQfxKHcTfCozS1gGf4ov+jSMVZfqxQ2bPQTiO30WrUD/Qx4GmhuUBBIuxKOjseOPC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779208168; c=relaxed/simple;
	bh=RHnjTcbyP41LJSdzLOAUjnX1zBlbX2q4+r3JyinCaa4=;
	h=Date:To:From:Subject:Message-Id; b=K6wDKR1s5RSSgfr3zMqJ/Ps45Re+SJnTyGYup7m2RMjOxZbwKbOkkWgC+W5iNZvHvk+Z0JbXXbL4iYEPxH9A50vmkba0Wc0CcnWsrbLtidomR+iicOhhcnoN2zyq47LTiN2wJjNXUKL3DmVPPBeWfhdTyu1XetH2EswdsJXISm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g38CWad3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g38CWad3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22AFBC2BCB3;
	Tue, 19 May 2026 16:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779208168;
	bh=RHnjTcbyP41LJSdzLOAUjnX1zBlbX2q4+r3JyinCaa4=;
	h=Date:To:From:Subject:From;
	b=g38CWad3lPeKnyGjm4hENPd+cHF8YQ7dT1FAvOPB3EmKN4tstHoUAWAwu5+SjnJOL
	 tOPUUvoCGOrYKkbFz5g8w/Jqu6r/5lQ+R40DlLW5HdmDwCmLs4R0ntln9HdAH3uRB1
	 e/NFTqwV642utRUM2KLvDPYhUsjmpvXnRRDfuy40=
Date: Tue, 19 May 2026 09:29:27 -0700
To: mm-commits@vger.kernel.org,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] sched-add-need-resched-timed-wait-interface.patch removed from -mm tree
Message-Id: <20260519162928.22AFBC2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sched: add need-resched timed wait interface
has been removed from the -mm tree.  Its filename was
     sched-add-need-resched-timed-wait-interface.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Ankur Arora <ankur.a.arora@oracle.com>
Subject: sched: add need-resched timed wait interface
Date: Wed, 8 Apr 2026 17:55:35 +0530

Add tif_bitset_relaxed_wait() (and tif_need_resched_relaxed_wait() which
wraps it) which takes the thread_info bit and timeout duration as
parameters and waits until the bit is set or for the expiration of the
timeout.

The wait is implemented via smp_cond_load_relaxed_timeout().

smp_cond_load_relaxed_timeout() essentially provides the pattern used in
poll_idle() where we spin in a loop waiting for the flag to change until a
timeout occurs.

tif_need_resched_relaxed_wait() allows us to abstract out the internals
of waiting, scheduler specific details etc.

Placed in linux/sched/idle.h instead of linux/thread_info.h to work
around recursive include hell.

Link: https://lore.kernel.org/20260408122538.3610871-12-ankur.a.arora@oracle.com
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Boqun Feng <boqun@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Gow <davidgow@google.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: Haris Okanovic <harisokn@amazon.com>
Cc: Konrad Dybcio <konradybcio@kernel.org>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/idle.h |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- a/include/linux/sched/idle.h~sched-add-need-resched-timed-wait-interface
+++ a/include/linux/sched/idle.h
@@ -3,6 +3,7 @@
 #define _LINUX_SCHED_IDLE_H
 
 #include <linux/sched.h>
+#include <linux/sched/clock.h>
 
 enum cpu_idle_type {
 	__CPU_NOT_IDLE = 0,
@@ -113,4 +114,32 @@ static __always_inline void current_clr_
 }
 #endif
 
+/*
+ * Caller needs to make sure that the thread context cannot be preempted
+ * or migrated, so current_thread_info() cannot change from under us.
+ *
+ * This also allows us to safely stay in the local_clock domain.
+ */
+static __always_inline bool tif_bitset_relaxed_wait(int tif, u64 timeout_ns)
+{
+	unsigned long flags;
+
+	flags = smp_cond_load_relaxed_timeout(&current_thread_info()->flags,
+					      (VAL & BIT(tif)),
+					      local_clock_noinstr(),
+					      timeout_ns);
+	return flags & BIT(tif);
+}
+
+/**
+ * tif_need_resched_relaxed_wait() - Wait for need-resched being set
+ * with no ordering guarantees until a timeout expires.
+ *
+ * @timeout_ns: timeout value.
+ */
+static __always_inline bool tif_need_resched_relaxed_wait(u64 timeout_ns)
+{
+	return tif_bitset_relaxed_wait(TIF_NEED_RESCHED, timeout_ns);
+}
+
 #endif /* _LINUX_SCHED_IDLE_H */
_

Patches currently in -mm which might be from ankur.a.arora@oracle.com are

cpuidle-poll_state-wait-for-need-resched-via-tif_need_resched_relaxed_wait.patch
kunit-enable-testing-smp_cond_load_relaxed_timeout.patch
kunit-add-tests-for-smp_cond_load_relaxed_timeout.patch

