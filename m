Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EFD9178367
	for <mm-commits@vger.kernel.org>; Tue, 28 May 2024 20:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716928782; cv=none; b=j5FE2qzsO1nXl5Tw9eHIi1WsYvLDfDa1J5VNgBYyp2YPkZ8s0EyQLSGpcpYryUkYj8+Mew6YBRsuyvIvxU5qX4OnVxY6P/vtwGd87inDpbKEhisP26iMgxJxlXRUdl7iBlsXxhtKPVAX1o39Da2XEnFiVwH9CNPl41NpCBXRCiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716928782; c=relaxed/simple;
	bh=jItQlo208hGFHtXxYQ+0k1EN+bn8/SIcDyy+fPr6Yj0=;
	h=Date:To:From:Subject:Message-Id; b=AG2RFzJ4qvbOxdvtV+BXDAXyfLrXHG7Iht4bLobc1CTkW00ERWiWJEiYoQbfW5YsMOhqQaP7LDTzcU2WWlFHPgoQIDiAmuOPVgUEslB37kMVj6sqWwR7Ffby/EBqGo8odUoTMF49mpjiu/z/fA8ewuFeONd0MUHjdBuczXFtmaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K6HSWBAm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K6HSWBAm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F44CC3277B;
	Tue, 28 May 2024 20:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716928782;
	bh=jItQlo208hGFHtXxYQ+0k1EN+bn8/SIcDyy+fPr6Yj0=;
	h=Date:To:From:Subject:From;
	b=K6HSWBAm/tnMnHIW3V2Zf6XDlrP5xLmJnYIKWkyhTxFuKqEDhD8u4X2PYqX/SUAJF
	 NfE+MexHiOBGFv19bruo0S0t4rXqIfkG3dujMa7mXM9URErxzIKEQYxPbCESImGnSj
	 IT6k1gy0NMY3LmhIuxcqqFiHmP0sWyCXRQ9LRjCc=
Date: Tue, 28 May 2024 13:39:41 -0700
To: mm-commits@vger.kernel.org,yury.norov@nvidia.com,viresh.kumar@linaro.org,vincent.guittot@linaro.org,ulf.hansson@linaro.org,tj@kernel.org,tglx@linutronix.de,rafael@kernel.org,peterz@infradead.org,paulmck@kernel.org,mathieu.desnoyers@efficios.com,linux@rasmusvillemoes.dk,keescook@chromium.org,juri.lelli@redhat.com,hannes@cmpxchg.org,frederic@kernel.org,dennis@kernel.org,daniel.lezcano@linaro.org,cl@linux.com,anna-maria@linutronix.de,amit.kachhap@gmail.com,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + cpumask-cleanup-core-headers-inclusion.patch added to mm-nonmm-unstable branch
Message-Id: <20240528203942.5F44CC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: cpumask: cleanup core headers inclusion
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     cpumask-cleanup-core-headers-inclusion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cpumask-cleanup-core-headers-inclusion.patch

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

gcc-disable-warray-bounds-for-gcc-9.patch
maintainers-add-linux-nodemask_typesh-to-bitmap-api.patch
sched-avoid-using-ilog2-in-schedh.patch
sched-drop-schedh-dependency-on-cpumask.patch
cpumask-cleanup-core-headers-inclusion.patch
cpumask-make-core-headers-including-cpumask_typesh-where-possible.patch

