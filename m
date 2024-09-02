Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3036F2F3
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247765; cv=none; b=BMIsaSpmIgocPOBkpjUJ+7YKMBQzzDowbSbj+TD5T2qf0hCaAylmcTZfIonpNVuBbKqx0MFRskbfdlXmKUEdv1JpXGEdNJOUVLHEHAztqpy+0CY6/EsEZAOg+PdE/tgITzDazR7VlzWn2lwfOO6o/c6nHoN3H9R1b951KF57Af4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247765; c=relaxed/simple;
	bh=ONetgZwF5xhNi8EMqV8fIRLj9YoYFDZgvWLcwIzFRfk=;
	h=Date:To:From:Subject:Message-Id; b=NqHvwOq4Y+GtWaiXLhKt14C+/6Wn3Irl6xo699DWGONrwYlCGqnlPxEhdQLLUiHdQTM8e+AtRDL7lodV8BYFnfkeZJa2DwxlR6PDww1QRvT0IKtxYfOZKvEezqW/oiwzzgO2ogn1jiXVMCBsMpi4TJPGIYHliEPPNkB4UPdZeB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GYFt15xC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GYFt15xC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C249BC4CEC2;
	Mon,  2 Sep 2024 03:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247763;
	bh=ONetgZwF5xhNi8EMqV8fIRLj9YoYFDZgvWLcwIzFRfk=;
	h=Date:To:From:Subject:From;
	b=GYFt15xCqnga84Z1vzumQaxCEwpRyvVUqy9PLq04QvlqraY3UzRQH4STTXv4rixNF
	 wSVUltry3eAOdHbjFV19xeTaDNzdZwpFZMw+9IXCSHI2TMokhaouUSK/QozM0nb04i
	 x8Wm4Cd0Z1IOTHoE5Bzg82kB9Sc/8TsB+Fm+/a9w=
Date: Sun, 01 Sep 2024 20:29:23 -0700
To: mm-commits@vger.kernel.org,jannh@google.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,elver@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kfence-introduce-burst-mode.patch removed from -mm tree
Message-Id: <20240902032923.C249BC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kfence: introduce burst mode
has been removed from the -mm tree.  Its filename was
     kfence-introduce-burst-mode.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kfence: introduce burst mode
Date: Mon, 5 Aug 2024 14:39:39 +0200

Introduce burst mode, which can be configured with kfence.burst=$count,
where the burst count denotes the additional successive slab allocations
to be allocated through KFENCE for each sample interval.

The idea is that this can give developers an additional knob to make
KFENCE more aggressive when debugging specific issues of systems where
either rebooting or recompiling the kernel with KASAN is not possible.

Experiment: To assess the effectiveness of the new option, we randomly
picked a recent out-of-bounds [1] and use-after-free bug [2], each with a
reproducer provided by syzbot, that initially detected these bugs with
KASAN.  We then tried to reproduce the bugs with KFENCE below.

[1] Fixed by: 7c55b78818cf ("jfs: xattr: fix buffer overflow for invalid xattr")
    https://syzkaller.appspot.com/bug?id=9d1b59d4718239da6f6069d3891863c25f9f24a2
[2] Fixed by: f8ad00f3fb2a ("l2tp: fix possible UAF when cleaning up tunnels")
    https://syzkaller.appspot.com/bug?id=4f34adc84f4a3b080187c390eeef60611fd450e1

The following KFENCE configs were compared. A pool size of 1023 objects
was used for all configurations.

	Baseline
		kfence.sample_interval=100
		kfence.skip_covered_thresh=75
		kfence.burst=0

	Aggressive
		kfence.sample_interval=1
		kfence.skip_covered_thresh=10
		kfence.burst=0

	AggressiveBurst
		kfence.sample_interval=1
		kfence.skip_covered_thresh=10
		kfence.burst=1000

Each reproducer was run 10 times (after a fresh reboot), with the
following detection counts for each KFENCE config:

                    | Detection Count out of 10 |
                    |    OOB [1]  |    UAF [2]  |
  ------------------+-------------+-------------+
  Default           |     0/10    |     0/10    |
  Aggressive        |     0/10    |     0/10    |
  AggressiveBurst   |     8/10    |     8/10    |

With the Default and even the Aggressive configs the results are
unsurprising, given KFENCE has not been designed for deterministic bug
detection of small test cases.

However, when enabling burst mode with relatively large burst count,
KFENCE can start to detect heap memory-safety bugs even in simpler test
cases with high probability (in the above cases with ~80% probability).

Link: https://lkml.kernel.org/r/20240805124203.2692278-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kfence.rst |    7 +++++++
 include/linux/kfence.h             |    2 +-
 mm/kfence/core.c                   |   14 ++++++++++----
 3 files changed, 18 insertions(+), 5 deletions(-)

--- a/Documentation/dev-tools/kfence.rst~kfence-introduce-burst-mode
+++ a/Documentation/dev-tools/kfence.rst
@@ -53,6 +53,13 @@ configurable via the Kconfig option ``CO
    The KUnit test suite is very likely to fail when using a deferrable timer
    since it currently causes very unpredictable sample intervals.
 
+By default KFENCE will only sample 1 heap allocation within each sample
+interval. *Burst mode* allows to sample successive heap allocations, where the
+kernel boot parameter ``kfence.burst`` can be set to a non-zero value which
+denotes the *additional* successive allocations within a sample interval;
+setting ``kfence.burst=N`` means that ``1 + N`` successive allocations are
+attempted through KFENCE for each sample interval.
+
 The KFENCE memory pool is of fixed size, and if the pool is exhausted, no
 further KFENCE allocations occur. With ``CONFIG_KFENCE_NUM_OBJECTS`` (default
 255), the number of available guarded objects can be controlled. Each object
--- a/include/linux/kfence.h~kfence-introduce-burst-mode
+++ a/include/linux/kfence.h
@@ -124,7 +124,7 @@ static __always_inline void *kfence_allo
 	if (!static_branch_likely(&kfence_allocation_key))
 		return NULL;
 #endif
-	if (likely(atomic_read(&kfence_allocation_gate)))
+	if (likely(atomic_read(&kfence_allocation_gate) > 0))
 		return NULL;
 	return __kfence_alloc(s, size, flags);
 }
--- a/mm/kfence/core.c~kfence-introduce-burst-mode
+++ a/mm/kfence/core.c
@@ -99,6 +99,10 @@ module_param_cb(sample_interval, &sample
 static unsigned long kfence_skip_covered_thresh __read_mostly = 75;
 module_param_named(skip_covered_thresh, kfence_skip_covered_thresh, ulong, 0644);
 
+/* Allocation burst count: number of excess KFENCE allocations per sample. */
+static unsigned int kfence_burst __read_mostly;
+module_param_named(burst, kfence_burst, uint, 0644);
+
 /* If true, use a deferrable timer. */
 static bool kfence_deferrable __read_mostly = IS_ENABLED(CONFIG_KFENCE_DEFERRABLE);
 module_param_named(deferrable, kfence_deferrable, bool, 0444);
@@ -827,12 +831,12 @@ static void toggle_allocation_gate(struc
 	if (!READ_ONCE(kfence_enabled))
 		return;
 
-	atomic_set(&kfence_allocation_gate, 0);
+	atomic_set(&kfence_allocation_gate, -kfence_burst);
 #ifdef CONFIG_KFENCE_STATIC_KEYS
 	/* Enable static key, and await allocation to happen. */
 	static_branch_enable(&kfence_allocation_key);
 
-	wait_event_idle(allocation_wait, atomic_read(&kfence_allocation_gate));
+	wait_event_idle(allocation_wait, atomic_read(&kfence_allocation_gate) > 0);
 
 	/* Disable static key and reset timer. */
 	static_branch_disable(&kfence_allocation_key);
@@ -1052,6 +1056,7 @@ void *__kfence_alloc(struct kmem_cache *
 	unsigned long stack_entries[KFENCE_STACK_DEPTH];
 	size_t num_stack_entries;
 	u32 alloc_stack_hash;
+	int allocation_gate;
 
 	/*
 	 * Perform size check before switching kfence_allocation_gate, so that
@@ -1080,14 +1085,15 @@ void *__kfence_alloc(struct kmem_cache *
 	if (s->flags & SLAB_SKIP_KFENCE)
 		return NULL;
 
-	if (atomic_inc_return(&kfence_allocation_gate) > 1)
+	allocation_gate = atomic_inc_return(&kfence_allocation_gate);
+	if (allocation_gate > 1)
 		return NULL;
 #ifdef CONFIG_KFENCE_STATIC_KEYS
 	/*
 	 * waitqueue_active() is fully ordered after the update of
 	 * kfence_allocation_gate per atomic_inc_return().
 	 */
-	if (waitqueue_active(&allocation_wait)) {
+	if (allocation_gate == 1 && waitqueue_active(&allocation_wait)) {
 		/*
 		 * Calling wake_up() here may deadlock when allocations happen
 		 * from within timer code. Use an irq_work to defer it.
_

Patches currently in -mm which might be from elver@google.com are


