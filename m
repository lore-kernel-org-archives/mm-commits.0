Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2117F17A930
	for <mm-commits@vger.kernel.org>; Tue, 28 May 2024 20:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716928788; cv=none; b=EPkF/E0jebs/vtLDfxvv+DGZW+cXumRGy7S7oN4bf3/eIJxmq/0bRamG4VriByBvopmUXfwnv8O3p2RZfn+yCUKVI4mnYUG/PHiwUEXfOe7QkbRULfFm1IKd4miNZmy2h8NKxkEr+7xZtujdD6X/wuHwePFEg7mhEVd6w8BrPpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716928788; c=relaxed/simple;
	bh=SfALgIO2ltEWmo+Z5kog5KrWJwDH8VJ/gSOQzzM35kk=;
	h=Date:To:From:Subject:Message-Id; b=BM3al97S6c4YgQdRWduCfzVySHjE6ykAtVB6w/3mBuu0KkJdSVrgXE1aMqn1Yu23NJimDDMjCVflogdRMXytY41zJIX6sTVFp8IKdL76w4E4YzuTrAKQZoL3vaooVe17wYkUxA7TAeAD621U29NAqzcZPV6Pm0NgOIbzCB6cm4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zCRVuVmv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zCRVuVmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE55C3277B;
	Tue, 28 May 2024 20:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716928787;
	bh=SfALgIO2ltEWmo+Z5kog5KrWJwDH8VJ/gSOQzzM35kk=;
	h=Date:To:From:Subject:From;
	b=zCRVuVmvEevsfYrFIAsTidyqlis4mnPTLny1gPc0/GBnOIymos3fu2luhG/vXHI6S
	 HTTxyKyrCsyXFq0KTFpWQmbUygs2lpJ6dK0VUxA8ZJidOi32h8U8yjLlB4FsYRoEYk
	 vSZICxfQRARPG68SUBFaglfOCBOEpDfEx9tE26Vg=
Date: Tue, 28 May 2024 13:39:47 -0700
To: mm-commits@vger.kernel.org,yury.norov@nvidia.com,viresh.kumar@linaro.org,vincent.guittot@linaro.org,ulf.hansson@linaro.org,tj@kernel.org,tglx@linutronix.de,rafael@kernel.org,peterz@infradead.org,paulmck@kernel.org,mathieu.desnoyers@efficios.com,linux@rasmusvillemoes.dk,keescook@chromium.org,juri.lelli@redhat.com,hannes@cmpxchg.org,frederic@kernel.org,dennis@kernel.org,daniel.lezcano@linaro.org,cl@linux.com,anna-maria@linutronix.de,amit.kachhap@gmail.com,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + cpumask-make-core-headers-including-cpumask_typesh-where-possible.patch added to mm-nonmm-unstable branch
Message-Id: <20240528203947.9EE55C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: cpumask: make core headers including cpumask_types.h where possible
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     cpumask-make-core-headers-including-cpumask_typesh-where-possible.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cpumask-make-core-headers-including-cpumask_typesh-where-possible.patch

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
@@ -5,7 +5,7 @@
 
 #include <linux/kernel.h>
 #include <linux/bitops.h>
-#include <linux/cpumask.h>
+#include <linux/cpumask_types.h>
 #include <linux/irqreturn.h>
 #include <linux/irqnr.h>
 #include <linux/hardirq.h>
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

gcc-disable-warray-bounds-for-gcc-9.patch
maintainers-add-linux-nodemask_typesh-to-bitmap-api.patch
sched-avoid-using-ilog2-in-schedh.patch
sched-drop-schedh-dependency-on-cpumask.patch
cpumask-cleanup-core-headers-inclusion.patch
cpumask-make-core-headers-including-cpumask_typesh-where-possible.patch

