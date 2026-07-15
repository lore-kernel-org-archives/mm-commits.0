Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69303443E5C
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 18:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784139663; cv=none; b=H71jScOuBFxOfehVFmh+SQ/pXthjxct8w0pS/gDATtV2umphSF7tU2nR1mvXDxICH8nSNmoZY/NFP4x4tScrNz7vfAt/XhAi8ssolEh14V+5HfUl241ETbJcidbYU6YBfbOFsZwIRtpyaLaNyEw1rEaE8wN1g8l9+1fHFmM1WIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784139663; c=relaxed/simple;
	bh=6jj2FZsSKRTsCPN1hNDAgDLYbZGjP7oYrJYqgSpdgIU=;
	h=Date:To:From:Subject:Message-Id; b=V6Pf3crPp2CGaujqUJX4rYVD0fmK0HcbH7CB4pPMr0zKVXSafJDaDPiiUrSiBRk5eRQhHm3FqqSOb5phww09Lm52xk1N0cEahwmRNO9K8zK05L9B5sjF+NY6d9ONZMHWheoQp679Yv1n9NWPnYMxS6so9PRY9nXff4tK6FYjmPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i0H2GXrD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i0H2GXrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B551F00A3E;
	Wed, 15 Jul 2026 18:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784139651;
	bh=wOsbcVuIMsM2IpNGfKK2uTBOj+Ks/BJ2sF5SL7lHEqE=;
	h=Date:To:From:Subject;
	b=i0H2GXrDqh8wuukrJ0eaW3i4SAiG6tVOkiRL6ezCEcG2UHjtQ/rlKlxsD1m6+jzbs
	 Ui6vVLSa3iA8joYuLQUqOvlUmdEj3QKEMF/AcYk/wRdAqbDY8uD7eCjr1PTsqEvF3w
	 Qo5nQFpYR6YryZE204yZ3X263w6NV4fmW1RWSXr8=
Date: Wed, 15 Jul 2026 11:20:51 -0700
To: mm-commits@vger.kernel.org,ebiggers@kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xor-kunit-add-a-benchmark.patch added to mm-nonmm-unstable branch
Message-Id: <20260715182051.B7B551F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xor/kunit: add a benchmark
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xor-kunit-add-a-benchmark.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xor-kunit-add-a-benchmark.patch

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
Subject: xor/kunit: add a benchmark
Date: Wed, 15 Jul 2026 16:47:35 +0200

Add a benchmark to test the XOR functions for more representative block
sizes and numbers of disks.  Including 64k would be useful here, but
increasing the test buffer size increases the runtime of the functional
kunit test too much unfortunately.

The runtime numbers are reported in GB/s as the numbers of modern
implementations are basically unreadable as MB/s.  This means
retro-architectures could report 0, but that is an easy tradeoff.

Link: https://lore.kernel.org/20260715144825.95432-5-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/raid/Kconfig               |    6 +++
 lib/raid/xor/tests/xor_kunit.c |   62 +++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

--- a/lib/raid/Kconfig~xor-kunit-add-a-benchmark
+++ a/lib/raid/Kconfig
@@ -29,6 +29,12 @@ config XOR_KUNIT_TEST
 	  This is intended to help people writing architecture-specific
 	  optimized versions.  If unsure, say N.
 
+config XOR_BENCHMARK
+	bool "Benchmark for xor_gen"
+	depends on XOR_KUNIT_TEST
+	help
+	  Include benchmarks in the KUnit test suite for xor_gen.
+
 config RAID6_PQ
 	tristate
 
--- a/lib/raid/xor/tests/xor_kunit.c~xor-kunit-add-a-benchmark
+++ a/lib/raid/xor/tests/xor_kunit.c
@@ -125,8 +125,70 @@ static void xor_test(struct kunit *test)
 	}
 }
 
+static void xor_benchmark(struct kunit *test)
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
+	if (!IS_ENABLED(CONFIG_XOR_BENCHMARK))
+		kunit_skip(test, "not enabled");
+
+	/* warm-up */
+	for (i = 0; i < ARRAY_SIZE(nr_to_test); i++) {
+		for (j = 0; j < ARRAY_SIZE(len_to_test); j++) {
+			for (l = 0; l < 10; l++) {
+				xor_gen(test_dest, test_buffers, nr_to_test[i],
+						len_to_test[j]);
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
+		KUNIT_ASSERT_LE(test, nr, XOR_KUNIT_MAX_BUFFERS);
+
+		for (j = 0; j < ARRAY_SIZE(len_to_test); j++) {
+			unsigned int len = len_to_test[j];
+			const unsigned long num_iters = 1000;
+
+			KUNIT_ASSERT_GT(test, len, 0);
+			KUNIT_ASSERT_LE(test, len, XOR_KUNIT_MAX_BYTES);
+
+			preempt_disable();
+			t = ktime_get_ns();
+			for (l = 0; l < num_iters; l++)
+				xor_gen(test_dest, test_buffers, nr, len);
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
 static struct kunit_case xor_test_cases[] = {
 	KUNIT_CASE(xor_test),
+	KUNIT_CASE(xor_benchmark),
 	{},
 };
 
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

