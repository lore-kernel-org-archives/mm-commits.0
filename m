Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E3C42D742
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 18:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784139655; cv=none; b=uEPGUlCmoE1APVTZE+6FN0SevHEQnvO2c0uvhW+Vx8j5FJdOiukXqjU1eELyg0fTCSwoUXzhoHd3jI8VLYu3SPDoURblLxen+a1ICxXAiJwxP802J5RNnZDysaoLCqvVEX5/DMmXJ7OLAO9G3taYFTGoCXwq53O1GP382smJrMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784139655; c=relaxed/simple;
	bh=lp+LuUH8BJ8U+q/0chItJQS7VSeX/8MzAf3TcW+y8dw=;
	h=Date:To:From:Subject:Message-Id; b=YH17w06r4NWmaANSOJwWNE0aKZx3reFDq0Fd8EVS4txgGUHnwP5C+eS5Ak176d/heHo5pdPt0ja5duK2zXApyPM9G11PWtjqIDQci0pEYoD1yBLniUdfC2PossSMRYeQL82Qm6IZUhnYTtjQRMvp9N1T6gZMfiPt7iF95YCTkxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=klVx1sZY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="klVx1sZY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40131F00A3A;
	Wed, 15 Jul 2026 18:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784139647;
	bh=dWuYLfEyUzhaDHrG3Kkr8UnPtXvFxZun1ItDIQ5pr50=;
	h=Date:To:From:Subject;
	b=klVx1sZY5ungckLt7gEVT3bCznib3BSpR7q1F9bTD0Pw+4bY4p021+tWN+B+8s8xj
	 ykCLg2P1tlJIrfHYMEKKYR30RcsZYDGn2eVScx4RFGm0r8CbKAIzkocw7aKLM4R2Ge
	 mfBcgsmAhKbrosQj6BQqk7tbLJPMiR6ralgAzTwI=
Date: Wed, 15 Jul 2026 11:20:47 -0700
To: mm-commits@vger.kernel.org,ebiggers@kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xor-improve-the-runtime-selection-benchmark.patch added to mm-nonmm-unstable branch
Message-Id: <20260715182047.D40131F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xor: improve the runtime selection benchmark
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xor-improve-the-runtime-selection-benchmark.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xor-improve-the-runtime-selection-benchmark.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: xor: improve the runtime selection benchmark
Date: Wed, 15 Jul 2026 16:47:33 +0200

Use plain ktime_get_ns for the timing, use 4 + 1 disks for a realistic
load, and report the throughput on the data disks instead of the that on
the parity disk, which isn't all that useful.

Link: https://lore.kernel.org/20260715144825.95432-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/raid/xor/xor-core.c |   55 +++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 29 deletions(-)

--- a/lib/raid/xor/xor-core.c~xor-improve-the-runtime-selection-benchmark
+++ a/lib/raid/xor/xor-core.c
@@ -10,7 +10,6 @@
 #include <linux/gfp.h>
 #include <linux/slab.h>
 #include <linux/raid/xor.h>
-#include <linux/jiffies.h>
 #include <linux/preempt.h>
 #include <linux/static_call.h>
 #include "xor_impl.h"
@@ -73,59 +72,56 @@ void __init xor_force(struct xor_block_t
 	forced_template = tmpl;
 }
 
-#define BENCH_SIZE	4096
+#define BENCH_SIZE	SZ_4K
+#define NR_SRCS		4
 #define REPS		800U
 
-static void __init
-do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2)
+static void __init do_xor_speed(struct xor_block_template *tmpl, void *dest,
+		void *srcs[NR_SRCS])
 {
-	int speed;
-	unsigned long reps;
-	ktime_t min, start, t0;
-	void *srcs[1] = { b2 };
+	u64 t;
+	int i;
 
 	preempt_disable();
-
-	reps = 0;
-	t0 = ktime_get();
-	/* delay start until time has advanced */
-	while ((start = ktime_get()) == t0)
-		cpu_relax();
-	do {
+	t = ktime_get_ns();
+	for (i = 0; i < REPS; i++) {
 		mb(); /* prevent loop optimization */
-		tmpl->xor_gen(b1, srcs, 1, BENCH_SIZE);
+		tmpl->xor_gen(dest, srcs, NR_SRCS, BENCH_SIZE);
 		mb();
-	} while (reps++ < REPS || (t0 = ktime_get()) == start);
-	min = ktime_sub(t0, start);
-
+	}
+	t = max(ktime_get_ns() - t, 1);
 	preempt_enable();
 
-	// bytes/ns == GB/s, multiply by 1000 to get MB/s [not MiB/s]
-	speed = (1000 * reps * BENCH_SIZE) / (unsigned int)ktime_to_ns(min);
-	tmpl->speed = speed;
+	/* bytes/ns == GB/s, multiply by 1000 to get MB/s [not MiB/s] */
+	tmpl->speed = div64_u64((u64)BENCH_SIZE * REPS * NR_SRCS * 1000, t);
 
-	pr_info("   %-16s: %5d MB/sec\n", tmpl->name, speed);
+	pr_info("   %-16s: %5d MB/sec\n", tmpl->name, tmpl->speed);
 }
 
 static int __init calibrate_xor_blocks(void)
 {
-	void *b1, *b2;
 	struct xor_block_template *f, *fastest;
+	void *srcs[NR_SRCS];
+	void *buf, *dest;
+	int i;
 
 	if (forced_template)
 		return 0;
 
-	b1 = kmalloc(PAGE_SIZE * 4, GFP_KERNEL);
-	if (!b1) {
+	buf = kmalloc(BENCH_SIZE * (NR_SRCS + 1), GFP_KERNEL);
+	if (!buf) {
 		pr_warn("xor: Yikes!  No memory available.\n");
 		return -ENOMEM;
 	}
-	b2 = b1 + 2*PAGE_SIZE + BENCH_SIZE;
+	get_random_bytes(buf, BENCH_SIZE * (NR_SRCS + 1));
+	dest = buf;
+	for (i = 0; i < NR_SRCS; i++)
+		srcs[i] = buf + (i + 1) * BENCH_SIZE;
 
 	pr_info("xor: measuring software checksum speed\n");
 	fastest = template_list;
 	for (f = template_list; f; f = f->next) {
-		do_xor_speed(f, b1, b2);
+		do_xor_speed(f, dest, srcs);
 		if (f->speed > fastest->speed)
 			fastest = f;
 	}
@@ -133,9 +129,10 @@ static int __init calibrate_xor_blocks(v
 	pr_info("xor: using function: %s (%d MB/sec)\n",
 	       fastest->name, fastest->speed);
 
-	kfree(b1);
+	kfree(buf);
 	return 0;
 }
+#undef NR_SRCS
 
 #ifdef CONFIG_XOR_BLOCKS_ARCH
 #include "xor_arch.h" /* $SRCARCH/xor_arch.h */
_

Patches currently in -mm which might be from hch@lst.de are

mm-remove-wb_writeout_inc.patch
shmem-provide-a-shmem_write_folio-wrapper.patch
mm-swap-introduce-struct-swap_io_ctx.patch
mm-swap-also-use-struct-swap_iocb-for-block-i-o.patch
mm-swap-remove-count_swpout_vm_event.patch
mm-swap-use-swap_ops-to-register-swap-devices-methods.patch
mm-swap-remove-swp_fs_ops.patch
mm-vmstat-add-nrswpinout-counters.patch
xor-enable-lock-context-analysis.patch
xor-improve-the-runtime-selection-benchmark.patch
xor-kunit-fix-a-spelling-error.patch
xor-kunit-add-a-benchmark.patch
raid6-enable-lock-context-analysis.patch
raid6-defer-implementation-selection-when-built-in.patch
raid6-improve-the-runtime-selection-benchmark.patch
raid6-kunit-add-a-benchmark.patch

