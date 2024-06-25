Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239D933C0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293186; cv=none; b=HIZnsT4/zjooQX1bV8NHmRqZOuCfKYfHPcY44g91XSAOcsVgD1XveLi1XaEfLSk8/zTZL6APxK0aerUZx8xro4TeBcVBgAL54Gn9c8aMSryCuw3kx8aZIplnXibNcRAd0aVs+MZdPj9+WfWlrtpwgqBb4n/iSiNGse2pGpOjtzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293186; c=relaxed/simple;
	bh=av1xEcnbwnpg8B8UC0HsDPjYZ+oL+jzRlt4O98jByeo=;
	h=Date:To:From:Subject:Message-Id; b=AUpmJgE1i2TGFD0fdDhj33vaMhkWBvGthHYg3rK7WQGG7AmL7Ot7Jik6onJaHgLOJtt/1qcMEiCK/4ygdNpG2loA509C/BBclNnvT30uREXWlRfx9ByU6M1AomjA840WGAT7g3BQ8Vai97TFWoeXh/xnJhlwocETHwYtmid71KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nzlzOeQd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nzlzOeQd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED649C32782;
	Tue, 25 Jun 2024 05:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293186;
	bh=av1xEcnbwnpg8B8UC0HsDPjYZ+oL+jzRlt4O98jByeo=;
	h=Date:To:From:Subject:From;
	b=nzlzOeQdk2RCDPRcEUr9/5fD16bK9lJeH7A+BKHzKKmZiDpjfocxnGnpM2exWTU9c
	 Zf6PqUuz3NBfqR4s23/DJpDeWiLcpBuwm3V3kaoqAtw0PCkwILWf3OMaiqVtM6uVu+
	 FVLfVHU6/pwhCiykSCEtaJkq6S/coADzGc4Ae8FM=
Date: Mon, 24 Jun 2024 22:26:25 -0700
To: mm-commits@vger.kernel.org,yury.norov@nvidia.com,viresh.kumar@linaro.org,vincent.guittot@linaro.org,ulf.hansson@linaro.org,tj@kernel.org,tglx@linutronix.de,rafael@kernel.org,peterz@infradead.org,paulmck@kernel.org,mathieu.desnoyers@efficios.com,linux@rasmusvillemoes.dk,keescook@chromium.org,juri.lelli@redhat.com,hannes@cmpxchg.org,frederic@kernel.org,dennis@kernel.org,daniel.lezcano@linaro.org,cl@linux.com,anna-maria@linutronix.de,amit.kachhap@gmail.com,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] cpumask-make-core-headers-including-cpumask_typesh-where-possible.patch removed from -mm tree
Message-Id: <20240625052625.ED649C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: cpumask: make core headers including cpumask_types.h where possible
has been removed from the -mm tree.  Its filename was
     cpumask-make-core-headers-including-cpumask_typesh-where-possible.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: cpumask: make core headers including cpumask_types.h where possible
Date: Mon, 27 May 2024 17:56:48 -0700

Now that cpumask types are split out to a separate smaller header, many
frequently included core headers may switch to using it.

Link: https://lkml.kernel.org/r/20240528005648.182376-7-yury.norov@gmail.com
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

 include/linux/cacheinfo.h                    |    2 +-
 include/linux/clockchips.h                   |    2 +-
 include/linux/cpu_rmap.h                     |    2 +-
 include/linux/interrupt.h                    |    2 +-
 include/linux/irqchip/irq-partition-percpu.h |    2 +-
 include/linux/msi.h                          |    2 +-
 include/linux/pm_domain.h                    |    2 +-
 include/linux/stop_machine.h                 |    2 +-
 include/linux/torture.h                      |    2 +-
 include/linux/workqueue.h                    |    2 +-
 10 files changed, 10 insertions(+), 10 deletions(-)

--- a/include/linux/cacheinfo.h~cpumask-make-core-headers-including-cpumask_typesh-where-possible
+++ a/include/linux/cacheinfo.h
@@ -3,7 +3,7 @@
 #define _LINUX_CACHEINFO_H
 
 #include <linux/bitops.h>
-#include <linux/cpumask.h>
+#include <linux/cpumask_types.h>
 #include <linux/smp.h>
 
 struct device_node;
--- a/include/linux/clockchips.h~cpumask-make-core-headers-including-cpumask_typesh-where-possible
+++ a/include/linux/clockchips.h
@@ -12,7 +12,7 @@
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 
 # include <linux/clocksource.h>
-# include <linux/cpumask.h>
+# include <linux/cpumask_types.h>
 # include <linux/ktime.h>
 # include <linux/notifier.h>
 
--- a/include/linux/cpu_rmap.h~cpumask-make-core-headers-including-cpumask_typesh-where-possible
+++ a/include/linux/cpu_rmap.h
@@ -7,7 +7,7 @@
  * Copyright 2011 Solarflare Communications Inc.
  */
 
-#include <linux/cpumask.h>
+#include <linux/cpumask_types.h>
 #include <linux/gfp.h>
 #include <linux/slab.h>
 #include <linux/kref.h>
--- a/include/linux/interrupt.h~cpumask-make-core-headers-including-cpumask_typesh-where-possible
+++ a/include/linux/interrupt.h
@@ -5,13 +5,13 @@
 
 #include <linux/kernel.h>
 #include <linux/bitops.h>
-#include <linux/cpumask.h>
 #include <linux/irqreturn.h>
 #include <linux/irqnr.h>
 #include <linux/hardirq.h>
 #include <linux/irqflags.h>
 #include <linux/hrtimer.h>
 #include <linux/kref.h>
+#include <linux/cpumask_types.h>
 #include <linux/workqueue.h>
 #include <linux/jump_label.h>
 
--- a/include/linux/irqchip/irq-partition-percpu.h~cpumask-make-core-headers-including-cpumask_typesh-where-possible
+++ a/include/linux/irqchip/irq-partition-percpu.h
@@ -8,7 +8,7 @@
 #define __LINUX_IRQCHIP_IRQ_PARTITION_PERCPU_H
 
 #include <linux/fwnode.h>
-#include <linux/cpumask.h>
+#include <linux/cpumask_types.h>
 #include <linux/irqdomain.h>
 
 struct partition_affinity {
--- a/include/linux/msi.h~cpumask-make-core-headers-including-cpumask_typesh-where-possible
+++ a/include/linux/msi.h
@@ -19,7 +19,7 @@
  */
 
 #include <linux/irqdomain_defs.h>
-#include <linux/cpumask.h>
+#include <linux/cpumask_types.h>
 #include <linux/msi_api.h>
 #include <linux/xarray.h>
 #include <linux/mutex.h>
--- a/include/linux/pm_domain.h~cpumask-make-core-headers-including-cpumask_typesh-where-possible
+++ a/include/linux/pm_domain.h
@@ -16,7 +16,7 @@
 #include <linux/of.h>
 #include <linux/notifier.h>
 #include <linux/spinlock.h>
-#include <linux/cpumask.h>
+#include <linux/cpumask_types.h>
 #include <linux/time64.h>
 
 /*
--- a/include/linux/stop_machine.h~cpumask-make-core-headers-including-cpumask_typesh-where-possible
+++ a/include/linux/stop_machine.h
@@ -3,7 +3,7 @@
 #define _LINUX_STOP_MACHINE
 
 #include <linux/cpu.h>
-#include <linux/cpumask.h>
+#include <linux/cpumask_types.h>
 #include <linux/smp.h>
 #include <linux/list.h>
 
--- a/include/linux/torture.h~cpumask-make-core-headers-including-cpumask_typesh-where-possible
+++ a/include/linux/torture.h
@@ -14,7 +14,7 @@
 #include <linux/cache.h>
 #include <linux/spinlock.h>
 #include <linux/threads.h>
-#include <linux/cpumask.h>
+#include <linux/cpumask_types.h>
 #include <linux/seqlock.h>
 #include <linux/lockdep.h>
 #include <linux/completion.h>
--- a/include/linux/workqueue.h~cpumask-make-core-headers-including-cpumask_typesh-where-possible
+++ a/include/linux/workqueue.h
@@ -12,7 +12,7 @@
 #include <linux/lockdep.h>
 #include <linux/threads.h>
 #include <linux/atomic.h>
-#include <linux/cpumask.h>
+#include <linux/cpumask_types.h>
 #include <linux/rcupdate.h>
 #include <linux/workqueue_types.h>
 
_

Patches currently in -mm which might be from yury.norov@gmail.com are


