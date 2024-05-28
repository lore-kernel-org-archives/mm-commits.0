Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC529178367
	for <mm-commits@vger.kernel.org>; Tue, 28 May 2024 20:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716928780; cv=none; b=IVBMgxQYSn33I2SmhuWtG0N1nu4s4JPIAT0wRKSOQbR/2PVofzokA7caTq9unwAeHp7anY8GPDC8/Hz3OZcqlSsw+eUH+v7J0WcsvXQhjVxsPfR8H1r/M7kZOcGqgtO6DpHgs2XAwwYFIAOyxZiwUQNvRk227gpvdFjA+KTfpP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716928780; c=relaxed/simple;
	bh=ZjVknUtduTdc6PckYNXhKFfxKo8SbwmYBIEzbbtwavI=;
	h=Date:To:From:Subject:Message-Id; b=pCVMIqFORX6qWJpgln55ieuwZNgq/o2mjYOTpsiuusrTPeSh48yDMk1JfwZttRezjPBhzRBxOxXLjCKIX0e8D3oFtJfcCPHkRMQ0/+RddNOtdOIeGlAIYPPAApb280/JUv9+p0H/mVv92B3CzBG1o0W8BOiXao04bWhntbRyR1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N5P44bu9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N5P44bu9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598A3C3277B;
	Tue, 28 May 2024 20:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716928780;
	bh=ZjVknUtduTdc6PckYNXhKFfxKo8SbwmYBIEzbbtwavI=;
	h=Date:To:From:Subject:From;
	b=N5P44bu9NfY/VEwZaZ7I7OC4M8coallB8jc5NR4IxaX+h1emRs2YBBcXE7rghdvm4
	 e/ExEIm2wOf602BpwIH9yAtY79LYpq6f+WoKKsmFmRTuk8ftMnXsMcgHJUTdxbDUs4
	 BN+5XwpYDUvcSL1khdr9Lpt5jKZ4HvnFPoVzE2+c=
Date: Tue, 28 May 2024 13:39:39 -0700
To: mm-commits@vger.kernel.org,yury.norov@nvidia.com,viresh.kumar@linaro.org,vincent.guittot@linaro.org,ulf.hansson@linaro.org,tj@kernel.org,tglx@linutronix.de,rafael@kernel.org,peterz@infradead.org,paulmck@kernel.org,mathieu.desnoyers@efficios.com,linux@rasmusvillemoes.dk,keescook@chromium.org,juri.lelli@redhat.com,hannes@cmpxchg.org,frederic@kernel.org,dennis@kernel.org,daniel.lezcano@linaro.org,cl@linux.com,anna-maria@linutronix.de,amit.kachhap@gmail.com,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sched-drop-schedh-dependency-on-cpumask.patch added to mm-nonmm-unstable branch
Message-Id: <20240528203940.598A3C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sched: drop sched.h dependency on cpumask
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     sched-drop-schedh-dependency-on-cpumask.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sched-drop-schedh-dependency-on-cpumask.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: sched: drop sched.h dependency on cpumask
Date: Mon, 27 May 2024 17:56:46 -0700

sched.h needs cpumask.h mostly for types declaration.  Now that we have
cpumask_types.h, which is a significantly smaller header, we can rely on
it.

The only exception is UP stub for set_cpus_allowed_ptr().  The function
needs to test bit #0 in a @new_mask, which can be trivially opencoded.

Link: https://lkml.kernel.org/r/20240528005648.182376-5-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Cc: Amit Daniel Kachhap <amit.kachhap@gmail.com>
Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Yury Norov <yury.norov@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/include/linux/sched.h~sched-drop-schedh-dependency-on-cpumask
+++ a/include/linux/sched.h
@@ -13,7 +13,7 @@
 #include <asm/processor.h>
 #include <linux/thread_info.h>
 #include <linux/preempt.h>
-#include <linux/cpumask.h>
+#include <linux/cpumask_types.h>
 
 #include <linux/cache.h>
 #include <linux/irqflags_types.h>
@@ -1778,7 +1778,8 @@ static inline void do_set_cpus_allowed(s
 }
 static inline int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 {
-	if (!cpumask_test_cpu(0, new_mask))
+	/* Opencoded cpumask_test_cpu(0, new_mask) to avoid dependency on cpumask.h */
+	if ((*cpumask_bits(new_mask) & 1) == 0)
 		return -EINVAL;
 	return 0;
 }
_

Patches currently in -mm which might be from yury.norov@gmail.com are

gcc-disable-warray-bounds-for-gcc-9.patch
maintainers-add-linux-nodemask_typesh-to-bitmap-api.patch
sched-avoid-using-ilog2-in-schedh.patch
sched-drop-schedh-dependency-on-cpumask.patch
cpumask-cleanup-core-headers-inclusion.patch
cpumask-make-core-headers-including-cpumask_typesh-where-possible.patch

