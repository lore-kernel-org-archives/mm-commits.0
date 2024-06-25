Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A968233C0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293183; cv=none; b=u/oUi5BQ4MMbfUp8wxB+oPEY0W4Sp3ggTKoP6nhwnrdtAoMcDaGV30DxFQ79uPYK+ZQHGZhmC1kb2GIZTEhsDgGDs0p6khRyTVXGxD0IqzgyWTfmrWnp4XBl64BxHnAezDUx7aqMgbwwFdV0D/VvE/oqTrpep5dOfD5aBbH3+CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293183; c=relaxed/simple;
	bh=zs0SaIftRK/wIYAAVzwhXl+TXfhjfXhjxjaO0a2DBxw=;
	h=Date:To:From:Subject:Message-Id; b=bFww9YpHFjH39yi8YmPPlPQ64HXQk1JQI3ojLT+lve+Z5JQ469BL9bnNZTwwsOBvS2IzaMAHQLLcGme25ER+ipsZ2Hj2VR5fkwWcTpD36O0Y4kVzkqkO5aUweiHks8r2EPPCLF5X816RUcmQNIfzL6lmnP7z8y5espx4dlz5UCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CGYXYWYQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CGYXYWYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DDB7C32782;
	Tue, 25 Jun 2024 05:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293183;
	bh=zs0SaIftRK/wIYAAVzwhXl+TXfhjfXhjxjaO0a2DBxw=;
	h=Date:To:From:Subject:From;
	b=CGYXYWYQnbFtxu4UIgBDCZBlA/SE+supkENrTLXpmAkc/SGe23OvA1kBQXq4b5mUo
	 zzGtsdjhKM3kQUGC7d7Fh7TuRypat7iSMONUMFJ2yFHfXW6eUvreY6tcHkD4g7BU6w
	 NpdIU0T0e10GqOUWTr/PNFPIWHxLYJymhYkBxBOk=
Date: Mon, 24 Jun 2024 22:26:23 -0700
To: mm-commits@vger.kernel.org,yury.norov@nvidia.com,viresh.kumar@linaro.org,vincent.guittot@linaro.org,ulf.hansson@linaro.org,tj@kernel.org,tglx@linutronix.de,rafael@kernel.org,peterz@infradead.org,paulmck@kernel.org,mathieu.desnoyers@efficios.com,linux@rasmusvillemoes.dk,keescook@chromium.org,juri.lelli@redhat.com,hannes@cmpxchg.org,frederic@kernel.org,dennis@kernel.org,daniel.lezcano@linaro.org,cl@linux.com,anna-maria@linutronix.de,amit.kachhap@gmail.com,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] sched-drop-schedh-dependency-on-cpumask.patch removed from -mm tree
Message-Id: <20240625052623.7DDB7C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sched: drop sched.h dependency on cpumask
has been removed from the -mm tree.  Its filename was
     sched-drop-schedh-dependency-on-cpumask.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


