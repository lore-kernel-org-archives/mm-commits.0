Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700F533C0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293182; cv=none; b=cwwmYroCgVo8HMaQc6UISxUxdebfMCtxNTH+W0NuQFR4VBoRzyfwzNno7ZO/Oa+AD3WviyEx5viNrdxcFhXwLDJORe8I8gYwZ/1N54pRSTgWrbQgaxXZj9VJ402z6oJJ0/SWWomAcizjo/PFw/FXXSWNFGrnJXjWKZqsZ1L86Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293182; c=relaxed/simple;
	bh=tHM5yWHNlyrc6KIUPRNTQQ4KjZXCrVfFFXRXNmtz+kY=;
	h=Date:To:From:Subject:Message-Id; b=WmXajwLcoy5G60T48ypjPS16Gwq7LdOAlKk/B4eLdfJzPZAfcEtJhBZnnI3jc0NQ+x9HkyrSGgI8GeAYG0jeAsl4D/DHfqJe3L6PnvrCMFub5JXBXbAn39vqs4sQqAFxkwPSWVXWSW/l6BClvfYer92JPKonN4ovoV2z9WvCBKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vd81ziGR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vd81ziGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444DFC32782;
	Tue, 25 Jun 2024 05:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293182;
	bh=tHM5yWHNlyrc6KIUPRNTQQ4KjZXCrVfFFXRXNmtz+kY=;
	h=Date:To:From:Subject:From;
	b=vd81ziGRA/8XvO4yf6CMVf/ciuhXvpAPwqg3QdL2rWE3fiLrVfxK26qJsGgjZ9peo
	 XDKV/huo3acecFaaiMoIhBzbAOoz9T+Gc9c6qNc14UfmH2wp8DwU86DkthO2JXGgLz
	 v8NtgBz8JSbY52sqhv35zbv0SnEMCxHPD4ZiD4d0=
Date: Mon, 24 Jun 2024 22:26:21 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,viresh.kumar@linaro.org,vincent.guittot@linaro.org,ulf.hansson@linaro.org,tj@kernel.org,tglx@linutronix.de,rafael@kernel.org,peterz@infradead.org,paulmck@kernel.org,mathieu.desnoyers@efficios.com,linux@rasmusvillemoes.dk,keescook@chromium.org,juri.lelli@redhat.com,hannes@cmpxchg.org,frederic@kernel.org,dennis@kernel.org,daniel.lezcano@linaro.org,cl@linux.com,anna-maria@linutronix.de,amit.kachhap@gmail.com,yury.norov@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] cpumask-split-out-include-linux-cpumask_typesh.patch removed from -mm tree
Message-Id: <20240625052622.444DFC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: cpumask: split out include/linux/cpumask_types.h
has been removed from the -mm tree.  Its filename was
     cpumask-split-out-include-linux-cpumask_typesh.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yury Norov <yury.norov@nvidia.com>
Subject: cpumask: split out include/linux/cpumask_types.h
Date: Mon, 27 May 2024 17:56:45 -0700

Many core headers, like sched.h, include cpumask.h mostly for struct
cpumask and cpumask_var_t.  Those are frequently used headers and
shouldn't pull more than the bare minimum.

Link: https://lkml.kernel.org/r/20240528005648.182376-4-yury.norov@gmail.com
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                   |    1 
 include/linux/cpumask.h       |   56 ---------------------------
 include/linux/cpumask_types.h |   66 ++++++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+), 55 deletions(-)

--- a/include/linux/cpumask.h~cpumask-split-out-include-linux-cpumask_typesh
+++ a/include/linux/cpumask.h
@@ -9,25 +9,13 @@
  */
 #include <linux/cleanup.h>
 #include <linux/kernel.h>
-#include <linux/threads.h>
 #include <linux/bitmap.h>
+#include <linux/cpumask_types.h>
 #include <linux/atomic.h>
 #include <linux/bug.h>
 #include <linux/gfp_types.h>
 #include <linux/numa.h>
 
-/* Don't assign or return these: may not be this big! */
-typedef struct cpumask { DECLARE_BITMAP(bits, NR_CPUS); } cpumask_t;
-
-/**
- * cpumask_bits - get the bits in a cpumask
- * @maskp: the struct cpumask *
- *
- * You should only assume nr_cpu_ids bits of this mask are valid.  This is
- * a macro so it's const-correct.
- */
-#define cpumask_bits(maskp) ((maskp)->bits)
-
 /**
  * cpumask_pr_args - printf args to output a cpumask
  * @maskp: cpumask to be printed
@@ -922,48 +910,7 @@ static inline unsigned int cpumask_size(
 	return bitmap_size(large_cpumask_bits);
 }
 
-/*
- * cpumask_var_t: struct cpumask for stack usage.
- *
- * Oh, the wicked games we play!  In order to make kernel coding a
- * little more difficult, we typedef cpumask_var_t to an array or a
- * pointer: doing &mask on an array is a noop, so it still works.
- *
- * i.e.
- *	cpumask_var_t tmpmask;
- *	if (!alloc_cpumask_var(&tmpmask, GFP_KERNEL))
- *		return -ENOMEM;
- *
- *	  ... use 'tmpmask' like a normal struct cpumask * ...
- *
- *	free_cpumask_var(tmpmask);
- *
- *
- * However, one notable exception is there. alloc_cpumask_var() allocates
- * only nr_cpumask_bits bits (in the other hand, real cpumask_t always has
- * NR_CPUS bits). Therefore you don't have to dereference cpumask_var_t.
- *
- *	cpumask_var_t tmpmask;
- *	if (!alloc_cpumask_var(&tmpmask, GFP_KERNEL))
- *		return -ENOMEM;
- *
- *	var = *tmpmask;
- *
- * This code makes NR_CPUS length memcopy and brings to a memory corruption.
- * cpumask_copy() provide safe copy functionality.
- *
- * Note that there is another evil here: If you define a cpumask_var_t
- * as a percpu variable then the way to obtain the address of the cpumask
- * structure differently influences what this_cpu_* operation needs to be
- * used. Please use this_cpu_cpumask_var_t in those cases. The direct use
- * of this_cpu_ptr() or this_cpu_read() will lead to failures when the
- * other type of cpumask_var_t implementation is configured.
- *
- * Please also note that __cpumask_var_read_mostly can be used to declare
- * a cpumask_var_t variable itself (not its content) as read mostly.
- */
 #ifdef CONFIG_CPUMASK_OFFSTACK
-typedef struct cpumask *cpumask_var_t;
 
 #define this_cpu_cpumask_var_ptr(x)	this_cpu_read(x)
 #define __cpumask_var_read_mostly	__read_mostly
@@ -1010,7 +957,6 @@ static inline bool cpumask_available(cpu
 }
 
 #else
-typedef struct cpumask cpumask_var_t[1];
 
 #define this_cpu_cpumask_var_ptr(x) this_cpu_ptr(x)
 #define __cpumask_var_read_mostly
--- /dev/null
+++ a/include/linux/cpumask_types.h
@@ -0,0 +1,66 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __LINUX_CPUMASK_TYPES_H
+#define __LINUX_CPUMASK_TYPES_H
+
+#include <linux/bitops.h>
+#include <linux/threads.h>
+
+/* Don't assign or return these: may not be this big! */
+typedef struct cpumask { DECLARE_BITMAP(bits, NR_CPUS); } cpumask_t;
+
+/**
+ * cpumask_bits - get the bits in a cpumask
+ * @maskp: the struct cpumask *
+ *
+ * You should only assume nr_cpu_ids bits of this mask are valid.  This is
+ * a macro so it's const-correct.
+ */
+#define cpumask_bits(maskp) ((maskp)->bits)
+
+/*
+ * cpumask_var_t: struct cpumask for stack usage.
+ *
+ * Oh, the wicked games we play!  In order to make kernel coding a
+ * little more difficult, we typedef cpumask_var_t to an array or a
+ * pointer: doing &mask on an array is a noop, so it still works.
+ *
+ * i.e.
+ *	cpumask_var_t tmpmask;
+ *	if (!alloc_cpumask_var(&tmpmask, GFP_KERNEL))
+ *		return -ENOMEM;
+ *
+ *	  ... use 'tmpmask' like a normal struct cpumask * ...
+ *
+ *	free_cpumask_var(tmpmask);
+ *
+ *
+ * However, one notable exception is there. alloc_cpumask_var() allocates
+ * only nr_cpumask_bits bits (in the other hand, real cpumask_t always has
+ * NR_CPUS bits). Therefore you don't have to dereference cpumask_var_t.
+ *
+ *	cpumask_var_t tmpmask;
+ *	if (!alloc_cpumask_var(&tmpmask, GFP_KERNEL))
+ *		return -ENOMEM;
+ *
+ *	var = *tmpmask;
+ *
+ * This code makes NR_CPUS length memcopy and brings to a memory corruption.
+ * cpumask_copy() provide safe copy functionality.
+ *
+ * Note that there is another evil here: If you define a cpumask_var_t
+ * as a percpu variable then the way to obtain the address of the cpumask
+ * structure differently influences what this_cpu_* operation needs to be
+ * used. Please use this_cpu_cpumask_var_t in those cases. The direct use
+ * of this_cpu_ptr() or this_cpu_read() will lead to failures when the
+ * other type of cpumask_var_t implementation is configured.
+ *
+ * Please also note that __cpumask_var_read_mostly can be used to declare
+ * a cpumask_var_t variable itself (not its content) as read mostly.
+ */
+#ifdef CONFIG_CPUMASK_OFFSTACK
+typedef struct cpumask *cpumask_var_t;
+#else
+typedef struct cpumask cpumask_var_t[1];
+#endif /* CONFIG_CPUMASK_OFFSTACK */
+
+#endif /* __LINUX_CPUMASK_TYPES_H */
--- a/MAINTAINERS~cpumask-split-out-include-linux-cpumask_typesh
+++ a/MAINTAINERS
@@ -3730,6 +3730,7 @@ F:	include/linux/bitmap-str.h
 F:	include/linux/bitmap.h
 F:	include/linux/bits.h
 F:	include/linux/cpumask.h
+F:	include/linux/cpumask_types.h
 F:	include/linux/find.h
 F:	include/linux/nodemask.h
 F:	include/linux/nodemask_types.h
_

Patches currently in -mm which might be from yury.norov@nvidia.com are


