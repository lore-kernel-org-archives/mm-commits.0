Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8986D33C0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293192; cv=none; b=cgsQ+hkwtbNSN2l29fEePf6461XLoxHMsQGARzThK0NrX/r/SDSa9X1WYI5JmGyzcdMTfqcYJ1hLLPlLeSHqFdJDpueSfyl/oRSe6lE2SS0WvNlEWMJS8gBdCFl8TbKmmr5g/ewmnUDJfgbd5R+cZrtJTYTTBBX25myavZhl2ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293192; c=relaxed/simple;
	bh=FJpIHbvO9n4BlZ6pNyOUF/d+s7M2g5ry0jutDcES29A=;
	h=Date:To:From:Subject:Message-Id; b=dx6haBkLEqqIIR0KOB4f2nsJQqbLZZ7aGyf52M5wA86LbK1UJZFMO2/M175Q67yibeZsAfb3vDgKSJgE3h8XHpGGsVjXG3BhzZ0MJ9oFyxDXNuyd7irVvGLaC0YHH9wlGpBy9aJyGspBEfkLT6L6ya5U8OyPJ6S69b3dyHXZq44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HAzeg0Xk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HAzeg0Xk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4C8C32782;
	Tue, 25 Jun 2024 05:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293192;
	bh=FJpIHbvO9n4BlZ6pNyOUF/d+s7M2g5ry0jutDcES29A=;
	h=Date:To:From:Subject:From;
	b=HAzeg0Xkw/luKtNkaVfjXZEat5KFz+mGCO1eUzPaAekDCxSB3iJaAF+ULmuap0y6U
	 2ltCRBhhx5UGZUv8LxMYG04VCc/YasUQljivZIyybVBAPmsuDriWK24oIaNo/Oo6N4
	 VKyTVyVJWgSgVozgh2qCnBZc8MRu4JFk3duIzCDI=
Date: Mon, 24 Jun 2024 22:26:31 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tj@kernel.org,hughd@google.com,dennis@kernel.org,mjguzik@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] percpu_counter-add-a-cmpxchg-based-_add_batch-variant.patch removed from -mm tree
Message-Id: <20240625052632.5D4C8C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: percpu_counter: add a cmpxchg-based _add_batch variant
has been removed from the -mm tree.  Its filename was
     percpu_counter-add-a-cmpxchg-based-_add_batch-variant.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


