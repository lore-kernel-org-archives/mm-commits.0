Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFF733C0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293184; cv=none; b=dYFa10NhzHXIsEJeN81dS4O34UPVljppoylFKKJHoOp4xDcbLFc3gobERRYBKgSX8+XUwgR3EdmtP5J8Gr6UiBFiWHI+0HSadNehNPUr1SZeo6H0wPcbgnDoC/b6oZ90meB5rcK7G1TesT3UiOaWkAjn+By6uLtNZWI38CcLfS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293184; c=relaxed/simple;
	bh=xBuB6O+PPiH8r8Cgs1cI1w4NJg31JBpKKdXhhqs+Azs=;
	h=Date:To:From:Subject:Message-Id; b=L5AI/iUhduVDaumcq4qQXjRkywbggdnt0xR+FvmBlqLPrEbcVpEIZRPxvdqv47o+600vJ3611xT0vcm2gI4YwchPOtn4h0GksnKHoWWYSXjKqhQ1TTS0NLIYh2uTxSI0I1GCj8T9NFcSOUHVOtp3fFaQcM1L1BKh3sqNEI9b2S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v/WgjftM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v/WgjftM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1595C32782;
	Tue, 25 Jun 2024 05:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293184;
	bh=xBuB6O+PPiH8r8Cgs1cI1w4NJg31JBpKKdXhhqs+Azs=;
	h=Date:To:From:Subject:From;
	b=v/WgjftMDAi22n+YzPamIN65nryi82DzXUx2VjeBt2oi7genRbtbRmRRwqJr5Tcsr
	 uQIJbrH81MqQDXn3j0QjPcnhoEvDpiz/tCmPtszLGIDRlo9acCpAEdlPZVLYDkg6DM
	 8zo4eFnUz39v1aQXk1wap6qk5+x+J+cI+7XZ/NUg=
Date: Mon, 24 Jun 2024 22:26:24 -0700
To: mm-commits@vger.kernel.org,yury.norov@nvidia.com,viresh.kumar@linaro.org,vincent.guittot@linaro.org,ulf.hansson@linaro.org,tj@kernel.org,tglx@linutronix.de,rafael@kernel.org,peterz@infradead.org,paulmck@kernel.org,mathieu.desnoyers@efficios.com,linux@rasmusvillemoes.dk,keescook@chromium.org,juri.lelli@redhat.com,hannes@cmpxchg.org,frederic@kernel.org,dennis@kernel.org,daniel.lezcano@linaro.org,cl@linux.com,anna-maria@linutronix.de,amit.kachhap@gmail.com,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] cpumask-cleanup-core-headers-inclusion.patch removed from -mm tree
Message-Id: <20240625052624.B1595C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: cpumask: cleanup core headers inclusion
has been removed from the -mm tree.  Its filename was
     cpumask-cleanup-core-headers-inclusion.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: cpumask: cleanup core headers inclusion
Date: Mon, 27 May 2024 17:56:47 -0700

Many core headers include cpumask.h for nothing. Drop it.

Link: https://lkml.kernel.org/r/20240528005648.182376-6-yury.norov@gmail.com
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

 include/linux/cgroup.h      |    1 -
 include/linux/cpu.h         |    1 -
 include/linux/cpu_cooling.h |    1 -
 include/linux/kernel_stat.h |    1 -
 include/linux/node.h        |    1 -
 include/linux/percpu.h      |    1 -
 include/linux/profile.h     |    1 -
 include/linux/rcupdate.h    |    1 -
 include/linux/seq_file.h    |    1 -
 include/linux/tracepoint.h  |    1 -
 10 files changed, 10 deletions(-)

--- a/include/linux/cgroup.h~cpumask-cleanup-core-headers-inclusion
+++ a/include/linux/cgroup.h
@@ -10,7 +10,6 @@
  */
 
 #include <linux/sched.h>
-#include <linux/cpumask.h>
 #include <linux/nodemask.h>
 #include <linux/rculist.h>
 #include <linux/cgroupstats.h>
--- a/include/linux/cpu_cooling.h~cpumask-cleanup-core-headers-inclusion
+++ a/include/linux/cpu_cooling.h
@@ -15,7 +15,6 @@
 
 #include <linux/of.h>
 #include <linux/thermal.h>
-#include <linux/cpumask.h>
 
 struct cpufreq_policy;
 
--- a/include/linux/cpu.h~cpumask-cleanup-core-headers-inclusion
+++ a/include/linux/cpu.h
@@ -16,7 +16,6 @@
 
 #include <linux/node.h>
 #include <linux/compiler.h>
-#include <linux/cpumask.h>
 #include <linux/cpuhotplug.h>
 #include <linux/cpu_smt.h>
 
--- a/include/linux/kernel_stat.h~cpumask-cleanup-core-headers-inclusion
+++ a/include/linux/kernel_stat.h
@@ -5,7 +5,6 @@
 #include <linux/smp.h>
 #include <linux/threads.h>
 #include <linux/percpu.h>
-#include <linux/cpumask.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
 #include <linux/vtime.h>
--- a/include/linux/node.h~cpumask-cleanup-core-headers-inclusion
+++ a/include/linux/node.h
@@ -16,7 +16,6 @@
 #define _LINUX_NODE_H_
 
 #include <linux/device.h>
-#include <linux/cpumask.h>
 #include <linux/list.h>
 
 /**
--- a/include/linux/percpu.h~cpumask-cleanup-core-headers-inclusion
+++ a/include/linux/percpu.h
@@ -6,7 +6,6 @@
 #include <linux/mmdebug.h>
 #include <linux/preempt.h>
 #include <linux/smp.h>
-#include <linux/cpumask.h>
 #include <linux/pfn.h>
 #include <linux/init.h>
 #include <linux/cleanup.h>
--- a/include/linux/profile.h~cpumask-cleanup-core-headers-inclusion
+++ a/include/linux/profile.h
@@ -4,7 +4,6 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/cpumask.h>
 #include <linux/cache.h>
 
 #include <asm/errno.h>
--- a/include/linux/rcupdate.h~cpumask-cleanup-core-headers-inclusion
+++ a/include/linux/rcupdate.h
@@ -29,7 +29,6 @@
 #include <linux/lockdep.h>
 #include <linux/cleanup.h>
 #include <asm/processor.h>
-#include <linux/cpumask.h>
 #include <linux/context_tracking_irq.h>
 
 #define ULONG_CMP_GE(a, b)	(ULONG_MAX / 2 >= (a) - (b))
--- a/include/linux/seq_file.h~cpumask-cleanup-core-headers-inclusion
+++ a/include/linux/seq_file.h
@@ -7,7 +7,6 @@
 #include <linux/string_helpers.h>
 #include <linux/bug.h>
 #include <linux/mutex.h>
-#include <linux/cpumask.h>
 #include <linux/nodemask.h>
 #include <linux/fs.h>
 #include <linux/cred.h>
--- a/include/linux/tracepoint.h~cpumask-cleanup-core-headers-inclusion
+++ a/include/linux/tracepoint.h
@@ -16,7 +16,6 @@
 #include <linux/srcu.h>
 #include <linux/errno.h>
 #include <linux/types.h>
-#include <linux/cpumask.h>
 #include <linux/rcupdate.h>
 #include <linux/tracepoint-defs.h>
 #include <linux/static_call.h>
_

Patches currently in -mm which might be from yury.norov@gmail.com are


