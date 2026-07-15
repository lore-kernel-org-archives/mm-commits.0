Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE1E4C6F19
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 18:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784139674; cv=none; b=DBZ95f/nnnf06VC2OrJyeKb1FOZ1h9hgPKChXX2KK/SLQRc7h5GOIHIFVPEGdrukzu13ddcsKNmh14X308mxQtrWNUQfnkkzPiO9KV2r4cfVMO9PH99BMVCEbkp8CAn+3O5mw1PDkwDHBZqDc/n8THUTkFjjLaFHkyhm1zPQxQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784139674; c=relaxed/simple;
	bh=zy1JlMtA9wOqnN5xAEpq6KjqpLo3mr9AktUzyZNyE34=;
	h=Date:To:From:Subject:Message-Id; b=HYnq6rnaG46rgz1ZRm06mtICM3e87YIyiP+WHm3uTtdn4p1dDIOKmM4QTIo+UfuYFjx324FNas3FkGnWG5tKbZy3P6WXTvT7h/XF/L+kOsxye6sAnHX+nXYLrkAA8dYio6mv6aARJ7v7NpqqHmtVnN0GRvTe5m51WWTKsc8hRxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NME97zSq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NME97zSq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D4AB1F00AC4;
	Wed, 15 Jul 2026 18:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784139660;
	bh=PJZHS28GgNRtX1ULDdzj1zrTRAmxcNC1MJtR75W6PJo=;
	h=Date:To:From:Subject;
	b=NME97zSqdAkMX179UekUGR2B8Q1vdQR9CcRBzeYvAK1+nQZSKe1X2UmzEIH4MycoT
	 3pcp5Qko7KxJ2mIKszvWR52MRLsKbusmpxxBbrCw7GUDfBs5Gd6orxTpQyM7hXT9cR
	 xaN3/Uu4eas8ZixzqePtw1n/GPg/HPkOoJdMaZRQ=
Date: Wed, 15 Jul 2026 11:20:59 -0700
To: mm-commits@vger.kernel.org,ebiggers@kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + raid6-kunit-add-a-benchmark.patch added to mm-nonmm-unstable branch
Message-Id: <20260715182100.0D4AB1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: raid6/kunit: add a benchmark
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     raid6-kunit-add-a-benchmark.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/raid6-kunit-add-a-benchmark.patch

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
Subject: raid6/kunit: add a benchmark
Date: Wed, 15 Jul 2026 16:47:39 +0200

Add a benchmark to test the RAID 6 P/Q functions for more representative
block sizes and numbers of disks.  This splits the maximum alloc size used
for the benchmark from the max size for the kunit test because recovery is
currently limited to a single page at a time.  Hopefully this will be
fixed soon.

The runtime numbers are reported in GB/s as the numbers of modern
implementations are basically unreadable as MB/s.  This means
retro-architectures could report 0, but that is an easy tradeoff.

Link: https://lore.kernel.org/20260715144825.95432-9-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/raid/Kconfig                   |    6 ++
 lib/raid/raid6/tests/raid6_kunit.c |   66 ++++++++++++++++++++++++++-
 2 files changed, 71 insertions(+), 1 deletion(-)

--- a/lib/raid/Kconfig~raid6-kunit-add-a-benchmark
+++ a/lib/raid/Kconfig
@@ -60,6 +60,12 @@ config RAID6_PQ_KUNIT_TEST
 	  This is intended to help people writing architecture-specific
 	  optimized versions.  If unsure, say N.
 
+config RAID6_PQ_KUNIT_BENCHMARK
+	bool "Benchmark for RAID6 PQ"
+	depends on RAID6_PQ_KUNIT_TEST
+	help
+	  Include benchmarks in the KUnit test suite for raid P/Q generation.
+
 config RAID6_PQ_BENCHMARK
 	bool "Automatically choose fastest RAID6 PQ functions"
 	depends on RAID6_PQ
--- a/lib/raid/raid6/tests/raid6_kunit.c~raid6-kunit-add-a-benchmark
+++ a/lib/raid/raid6/tests/raid6_kunit.c
@@ -18,6 +18,7 @@ MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TES
 #define RAID6_KUNIT_MAX_BUFFERS		64 /* Including P and Q */
 #define RAID6_KUNIT_MAX_FAILURES	2
 #define RAID6_KUNIT_MAX_BYTES		PAGE_SIZE
+#define RAID6_KUNIT_ALLOC_BYTES		SZ_16K
 
 static struct rnd_state rng;
 static void *test_buffers[RAID6_KUNIT_MAX_BUFFERS];
@@ -229,6 +230,68 @@ static void raid6_test(struct kunit *tes
 		raid6_test_one(test);
 }
 
+static void raid6_benchmark(struct kunit *test)
+{
+	static const unsigned int nr_to_test[] = {
+		4, 5, 6, 7, 8, 10, 12, 15, 16, 32,
+	};
+	static const unsigned int len_to_test[] = {
+		SZ_4K, SZ_16K,
+	};
+	unsigned int i, j, l;
+	u64 t;
+
+	if (!IS_ENABLED(CONFIG_RAID6_PQ_KUNIT_BENCHMARK))
+		kunit_skip(test, "not enabled");
+
+	/* warm-up */
+	for (i = 0; i < ARRAY_SIZE(nr_to_test); i++) {
+		for (j = 0; j < ARRAY_SIZE(len_to_test); j++) {
+			for (l = 0; l < 10; l++) {
+				raid6_gen_syndrome(nr_to_test[i],
+						len_to_test[j], test_buffers);
+			}
+		}
+	}
+
+	/*
+	 * Preferably this would be a loop over len_to_test, but the kunit
+	 * logging always adds a newline to each logged format string.
+	 */
+	static_assert(ARRAY_SIZE(len_to_test) == 2);
+	kunit_info(test, "          \t%5u bytes\t%5u bytes\n",
+			len_to_test[0], len_to_test[1]);
+
+	for (i = 0; i < ARRAY_SIZE(nr_to_test); i++) {
+		unsigned int nr = nr_to_test[i];
+		u64 speed[ARRAY_SIZE(len_to_test)];
+
+		KUNIT_ASSERT_LE(test, nr, RAID6_KUNIT_MAX_BUFFERS);
+
+		for (j = 0; j < ARRAY_SIZE(len_to_test); j++) {
+			unsigned int len = len_to_test[j];
+			const unsigned long num_iters = 1000;
+
+			KUNIT_ASSERT_GT(test, len, 0);
+			KUNIT_ASSERT_LE(test, len, RAID6_KUNIT_ALLOC_BYTES);
+
+			preempt_disable();
+			t = ktime_get_ns();
+			for (l = 0; l < num_iters; l++)
+				raid6_gen_syndrome(nr_to_test[i],
+						len_to_test[j], test_buffers);
+			t = max(ktime_get_ns() - t, 1);
+			preempt_enable();
+
+			speed[j] = div64_u64((u64)len * num_iters * nr, t);
+		}
+
+		static_assert(ARRAY_SIZE(len_to_test) == 2);
+		kunit_info(test, "%3u disks:\t%5llu  GB/s\t%5llu  GB/s\n",
+				nr, speed[0], speed[1]);
+	}
+}
+
 static const void *raid6_gen_params(struct kunit *test, const void *prev,
 		char *desc)
 {
@@ -256,6 +319,7 @@ next_algo:
 
 static struct kunit_case raid6_test_cases[] = {
 	KUNIT_CASE_PARAM(raid6_test, raid6_gen_params),
+	KUNIT_CASE(raid6_benchmark),
 	{},
 };
 
@@ -270,7 +334,7 @@ static int raid6_suite_init(struct kunit
 	 * so that it is immediately followed by a guard page.  This allows
 	 * buffer overreads to be detected, even in assembly code.
 	 */
-	test_buflen = round_up(RAID6_KUNIT_MAX_BYTES, PAGE_SIZE);
+	test_buflen = round_up(RAID6_KUNIT_ALLOC_BYTES, PAGE_SIZE);
 	for (i = 0; i < RAID6_KUNIT_MAX_FAILURES; i++) {
 		test_recov_buffers[i] = vmalloc(test_buflen);
 		if (!test_recov_buffers[i])
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

