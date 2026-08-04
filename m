Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB773AD51A
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816333; cv=none; b=OSYONCQOWoDl0PoWpDH136ECSHZ73SlsZVT7N31AjmlMd0Xa9qyiZpuRGaUd2EzBQLhanmPy4JdAhtHAZDrp17pdQjj5neDtA9egwNzxHnZnYrvhxoD/CcHq3veziQVBnR7XYpB+gPSIr9VDDuMegR+WOUHi2huTuHBEVucrpN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816333; c=relaxed/simple;
	bh=OTvdId0I0/zG1lrDExwBA81i8fW4zd2htp4BDZy/iZM=;
	h=Date:To:From:Subject:Message-Id; b=gon3cjR9RZO/1EGvlNXpkNPxbv1vPcu2Zql5xmIjG9uYC9rIpwM78io97qUFW8ULtkcnGVpqBMo20KHH69Ij90+B/HD8wRZdkGK/ED0ug1/1qQYhueGW+ilWj3UxJhXojKaH6wBY7nzwlK784plZhibLxeRxl6liob+XCBCoclg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0M7vQJGs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0M7vQJGs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B1F1F00A3E;
	Tue,  4 Aug 2026 04:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816332;
	bh=5FH9Y9bBLcsnOIN0aXnQdG36qKL5tflrJ0fRI68f5Hs=;
	h=Date:To:From:Subject;
	b=0M7vQJGsgmPedde8dgMIn5V0SyBjkwoqOmzfXbO4I37cvP1cy8OZIuEzapt6o2m6b
	 lEmYHCVtDcYwE5WDMmqly1wW2hio8FyQ3EVNraA2NnPnHE+erk5YYGK6vIwwCUKaVn
	 WC+0qWkGqjhillFeTC4/IWUDUyMIsPfJvAu4+HuA=
Date: Mon, 03 Aug 2026 21:05:31 -0700
To: mm-commits@vger.kernel.org,ebiggers@kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] xor-improve-the-runtime-selection-benchmark.patch removed from -mm tree
Message-Id: <20260804040532.51B1F1F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xor: improve the runtime selection benchmark
has been removed from the -mm tree.  Its filename was
     xor-improve-the-runtime-selection-benchmark.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

