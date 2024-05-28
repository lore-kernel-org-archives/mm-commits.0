Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0995F224D1
	for <mm-commits@vger.kernel.org>; Tue, 28 May 2024 21:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716931109; cv=none; b=D1S/lfwzTcRZKcjR07tc3GAbVJQvIjrW1TsMmPaZVmFS1uIXiNf8rURkIveEuTS57OplC2kSC/xtzRJIFDnD4YD20bdp7co0LICrDKwtpv+/bqOPEH3UE528aC1zq8FYxyKEOnLWPpiz7XmZTY76P9vofeg8erFn2dwp/hYQUEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716931109; c=relaxed/simple;
	bh=aYfF+hfziXfg5oFvnYNHEXjkzvchR3hRbfMlQTe6TbA=;
	h=Date:To:From:Subject:Message-Id; b=R7qa887cAPOCga4eo3NZ4HcRTUWFwKeEPLNW7ssJ4UZpwUYsIp4oC9r0uX2Bi6EnDryCkZlRYH1+LaMv0d8eKs8d31h8y3zySRLv22hqIhh+2Uoj2uBookYu3fRy2YVVRtrL3XE4KxX0/ftvDYtp4f3ZuDZ9Up05Xuv4NI1xJJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bW1sGw5y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bW1sGw5y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E2BC3277B;
	Tue, 28 May 2024 21:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716931108;
	bh=aYfF+hfziXfg5oFvnYNHEXjkzvchR3hRbfMlQTe6TbA=;
	h=Date:To:From:Subject:From;
	b=bW1sGw5yRc/Ww+Bc5+K5MkkgUvnysOGuQddiDHThyxBqSU2U6MtKTU2ds+1j9B4BD
	 G19n0GxdaCZ2zp0UfpZIU10ott4w7PaDlSEx/SVLPpTRVOJahYHPLbR+6LG4qnB+ud
	 kp89k9srCfU9kNeld9TbYgtYLmT7qwyu9Xj1tMlA=
Date: Tue, 28 May 2024 14:18:27 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tj@kernel.org,hughd@google.com,dennis@kernel.org,mjguzik@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu_counter-add-a-cmpxchg-based-_add_batch-variant.patch added to mm-nonmm-unstable branch
Message-Id: <20240528211828.72E2BC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: percpu_counter: add a cmpxchg-based _add_batch variant
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     percpu_counter-add-a-cmpxchg-based-_add_batch-variant.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu_counter-add-a-cmpxchg-based-_add_batch-variant.patch

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
From: Mateusz Guzik <mjguzik@gmail.com>
Subject: percpu_counter: add a cmpxchg-based _add_batch variant
Date: Tue, 28 May 2024 22:42:57 +0200

Interrupt disable/enable trips are quite expensive on x86-64 compared to a
mere cmpxchg (note: no lock prefix!) and percpu counters are used quite
often.

With this change I get a bump of 1% ops/s for negative path lookups,
plugged into will-it-scale:

void testcase(unsigned long long *iterations, unsigned long nr)
{
        while (1) {
                int fd = open("/tmp/nonexistent", O_RDONLY);
                assert(fd == -1);

                (*iterations)++;
        }
}

The win would be higher if it was not for other slowdowns, but one has
to start somewhere.

Link: https://lkml.kernel.org/r/20240528204257.434817-1-mjguzik@gmail.com
Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Dennis Zhou <dennis@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/percpu_counter.c |   44 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 39 insertions(+), 5 deletions(-)

--- a/lib/percpu_counter.c~percpu_counter-add-a-cmpxchg-based-_add_batch-variant
+++ a/lib/percpu_counter.c
@@ -73,17 +73,50 @@ void percpu_counter_set(struct percpu_co
 EXPORT_SYMBOL(percpu_counter_set);
 
 /*
- * local_irq_save() is needed to make the function irq safe:
- * - The slow path would be ok as protected by an irq-safe spinlock.
- * - this_cpu_add would be ok as it is irq-safe by definition.
- * But:
- * The decision slow path/fast path and the actual update must be atomic, too.
+ * Add to a counter while respecting batch size.
+ *
+ * There are 2 implementations, both dealing with the following problem:
+ *
+ * The decision slow path/fast path and the actual update must be atomic.
  * Otherwise a call in process context could check the current values and
  * decide that the fast path can be used. If now an interrupt occurs before
  * the this_cpu_add(), and the interrupt updates this_cpu(*fbc->counters),
  * then the this_cpu_add() that is executed after the interrupt has completed
  * can produce values larger than "batch" or even overflows.
  */
+#ifdef CONFIG_HAVE_CMPXCHG_LOCAL
+/*
+ * Safety against interrupts is achieved in 2 ways:
+ * 1. the fast path uses local cmpxchg (note: no lock prefix)
+ * 2. the slow path operates with interrupts disabled
+ */
+void percpu_counter_add_batch(struct percpu_counter *fbc, s64 amount, s32 batch)
+{
+	s64 count;
+	unsigned long flags;
+
+	count = this_cpu_read(*fbc->counters);
+	do {
+		if (unlikely(abs(count + amount) >= batch)) {
+			raw_spin_lock_irqsave(&fbc->lock, flags);
+			/*
+			 * Note: by now we might have migrated to another CPU
+			 * or the value might have changed.
+			 */
+			count = __this_cpu_read(*fbc->counters);
+			fbc->count += count + amount;
+			__this_cpu_sub(*fbc->counters, count);
+			raw_spin_unlock_irqrestore(&fbc->lock, flags);
+			return;
+		}
+	} while (!this_cpu_try_cmpxchg(*fbc->counters, &count, count + amount));
+}
+#else
+/*
+ * local_irq_save() is used to make the function irq safe:
+ * - The slow path would be ok as protected by an irq-safe spinlock.
+ * - this_cpu_add would be ok as it is irq-safe by definition.
+ */
 void percpu_counter_add_batch(struct percpu_counter *fbc, s64 amount, s32 batch)
 {
 	s64 count;
@@ -101,6 +134,7 @@ void percpu_counter_add_batch(struct per
 	}
 	local_irq_restore(flags);
 }
+#endif
 EXPORT_SYMBOL(percpu_counter_add_batch);
 
 /*
_

Patches currently in -mm which might be from mjguzik@gmail.com are

mm-batch-unlink_file_vma-calls-in-free_pgd_range.patch
percpu_counter-add-a-cmpxchg-based-_add_batch-variant.patch

