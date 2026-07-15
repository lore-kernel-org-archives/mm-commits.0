Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E15634AB19
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 18:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784139670; cv=none; b=uuj1MX58/cPrYVpdJH5QAnvuSZDYnztoKE2Mw2/oXZiIesElwitgUygT5XH63ZEFKlYWhlSzM3Loanos9khFn7PjLdZHGCOyRDhAuhLIFR1ZqXno4s76FsjX6nRrPcFMGsLuUm75skakU6jQ9zjxANZ+/P53QA2Hj5i5ld6NYkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784139670; c=relaxed/simple;
	bh=L4tnsmmHxzipi+Kd8tqCO+1+CndhCg83thdnUDD/8RQ=;
	h=Date:To:From:Subject:Message-Id; b=o1nlHndS9C+G+zNbbX6UFYHHwQok4aWfhP/6GAxvUGP5vq9zbEslLeCTKBtNpJnFT2M7zqu167LrYj1/FRq9RfvirrsyJWu0flPV17a3GpowGpGLKe7RCk6ybpkNNZLtC2j61NlfiQt3Cjf1jNvak6O+V4lOEo3DoLBiZfPsg7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SE0/qzTd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SE0/qzTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016F41F000E9;
	Wed, 15 Jul 2026 18:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784139658;
	bh=/sPAQHZTsqs+1TuhsdyI9SsjA7FaK+/tKpMSwnWCitQ=;
	h=Date:To:From:Subject;
	b=SE0/qzTdaVtKCZb7E/HNGhBm94J3GoizX/5a+1j/XS0ZhQT6CGIgqK4Hdqlue0OCO
	 kUt1i7Gk+5LC05oN0ysXkZGjbp0mxbkJtZXaBnUKFTGQLA+5B8G+V5mnxjxkRBuzZf
	 kD3HMH0d0HJL5+ZRJX+ZPz6DzGNbkGjRrjH7pGfE=
Date: Wed, 15 Jul 2026 11:20:57 -0700
To: mm-commits@vger.kernel.org,ebiggers@kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + raid6-improve-the-runtime-selection-benchmark.patch added to mm-nonmm-unstable branch
Message-Id: <20260715182058.016F41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: raid6: improve the runtime selection benchmark
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     raid6-improve-the-runtime-selection-benchmark.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/raid6-improve-the-runtime-selection-benchmark.patch

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
Subject: raid6: improve the runtime selection benchmark
Date: Wed, 15 Jul 2026 16:47:38 +0200

Use plain ktime_get_ns for the timing, use 8 + 2 disks for a realistic
load, and report the throughput on the data disks as that is what storage
systems are measured on.

Link: https://lore.kernel.org/20260715144825.95432-8-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/raid/raid6/algos.c |   77 +++++++++++++++++----------------------
 1 file changed, 35 insertions(+), 42 deletions(-)

--- a/lib/raid/raid6/algos.c~raid6-improve-the-runtime-selection-benchmark
+++ a/lib/raid/raid6/algos.c
@@ -152,40 +152,37 @@ void raid6_recov_datap(int disks, size_t
 }
 EXPORT_SYMBOL_GPL(raid6_recov_datap);
 
-#define RAID6_TIME_JIFFIES_LG2	4
-#define RAID6_TEST_DISKS	8
+#define BENCH_SIZE	SZ_4K
+#define NR_SRCS		8
+#define NR_DISKS	(NR_SRCS + 2)
+#define REPS		800U
 
-static int raid6_choose_gen(void *(*const dptrs)[RAID6_TEST_DISKS],
-		const int disks)
+static int raid6_choose_gen(void *dptrs[NR_DISKS], const int disks)
 {
-	/* work on the second half of the disks */
-	int start = (disks >> 1) - 1, stop = disks - 3;
 	const struct raid6_calls *best = NULL;
 	unsigned long bestgenperf = 0;
 	unsigned int i;
 
 	for (i = 0; i < raid6_nr_algos; i++) {
 		const struct raid6_calls *algo = raid6_algos[i];
-		unsigned long perf = 0, j0, j1;
+		unsigned long perf = 0;
+		u64 t;
+		int i;
 
 		preempt_disable();
-		j0 = jiffies;
-		while ((j1 = jiffies) == j0)
-			cpu_relax();
-		while (time_before(jiffies,
-				    j1 + (1<<RAID6_TIME_JIFFIES_LG2))) {
-			algo->gen_syndrome(disks, PAGE_SIZE, *dptrs);
-			perf++;
-		}
+		t = ktime_get_ns();
+		for (i = 0; i < REPS; i++)
+			algo->gen_syndrome(disks, BENCH_SIZE, dptrs);
+		t = max(ktime_get_ns() - t, 1);
 		preempt_enable();
 
+		/* bytes/ns == GB/s, multiply by 1000 to get MB/s [not MiB/s] */
+		perf = div64_u64((u64)BENCH_SIZE * REPS * NR_SRCS * 1000, t);
 		if (perf > bestgenperf) {
 			bestgenperf = perf;
 			best = algo;
 		}
-		pr_info("raid6: %-8s gen() %5ld MB/s\n", algo->name,
-			(perf * HZ * (disks-2)) >>
-			(20 - PAGE_SHIFT + RAID6_TIME_JIFFIES_LG2));
+		pr_info("raid6: %-8s gen() %5lu MB/s\n", algo->name, perf);
 	}
 
 	if (!best) {
@@ -197,28 +194,24 @@ static int raid6_choose_gen(void *(*cons
 	static_call_update(raid6_xor_syndrome_impl, best->xor_syndrome);
 
 	pr_info("raid6: using algorithm %s gen() %ld MB/s\n",
-		best->name,
-		(bestgenperf * HZ * (disks - 2)) >>
-		(20 - PAGE_SHIFT + RAID6_TIME_JIFFIES_LG2));
+		best->name, bestgenperf);
 
 	if (best->xor_syndrome) {
-		unsigned long perf = 0, j0, j1;
+		/* work on the second half of the disks */
+		int start = (disks / 2) - 1, stop = disks - 3;
+		u64 t;
 
 		preempt_disable();
-		j0 = jiffies;
-		while ((j1 = jiffies) == j0)
-			cpu_relax();
-		while (time_before(jiffies,
-				   j1 + (1 << RAID6_TIME_JIFFIES_LG2))) {
-			best->xor_syndrome(disks, start, stop,
-					   PAGE_SIZE, *dptrs);
-			perf++;
-		}
+		t = ktime_get_ns();
+		for (i = 0; i < REPS; i++)
+			best->xor_syndrome(disks, start, stop, BENCH_SIZE,
+				dptrs);
+		t = max(ktime_get_ns() - t, 1);
 		preempt_enable();
 
-		pr_info("raid6: .... xor() %ld MB/s, rmw enabled\n",
-			(perf * HZ * (disks - 2)) >>
-			(20 - PAGE_SHIFT + RAID6_TIME_JIFFIES_LG2 + 1));
+		pr_info("raid6: .... xor() %llu MB/s, rmw enabled\n",
+			div64_u64((u64)BENCH_SIZE * REPS * NR_SRCS / 2 * 1000,
+				t));
 	}
 
 	return 0;
@@ -230,9 +223,9 @@ static int raid6_choose_gen(void *(*cons
 
 static int __init raid6_select_algo(void)
 {
-	const int disks = RAID6_TEST_DISKS;
+	const int disks = NR_DISKS;
+	void *dptrs[NR_DISKS];
 	char *disk_ptr, *p;
-	void *dptrs[RAID6_TEST_DISKS];
 	int i, cycle;
 	int error;
 
@@ -243,7 +236,7 @@ static int __init raid6_select_algo(void
 	}
 
 	/* prepare the buffer and fill it circularly with gfmul table */
-	disk_ptr = kmalloc(PAGE_SIZE * RAID6_TEST_DISKS, GFP_KERNEL);
+	disk_ptr = kmalloc_array(NR_DISKS, BENCH_SIZE, GFP_KERNEL);
 	if (!disk_ptr) {
 		pr_err("raid6: Yikes!  No memory available.\n");
 		return -ENOMEM;
@@ -251,19 +244,19 @@ static int __init raid6_select_algo(void
 
 	p = disk_ptr;
 	for (i = 0; i < disks; i++)
-		dptrs[i] = p + PAGE_SIZE * i;
+		dptrs[i] = p + BENCH_SIZE * i;
 
-	cycle = ((disks - 2) * PAGE_SIZE) / 65536;
+	cycle = ((disks - 2) * BENCH_SIZE) / 65536;
 	for (i = 0; i < cycle; i++) {
 		memcpy(p, raid6_gfmul, 65536);
 		p += 65536;
 	}
 
-	if ((disks - 2) * PAGE_SIZE % 65536)
-		memcpy(p, raid6_gfmul, (disks - 2) * PAGE_SIZE % 65536);
+	if ((disks - 2) * BENCH_SIZE % 65536)
+		memcpy(p, raid6_gfmul, (disks - 2) * BENCH_SIZE % 65536);
 
 	/* select raid gen_syndrome function */
-	error = raid6_choose_gen(&dptrs, disks);
+	error = raid6_choose_gen(dptrs, disks);
 
 	kfree(disk_ptr);
 
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

