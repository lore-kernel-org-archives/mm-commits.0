Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D0440861D
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816335; cv=none; b=o2NayV850+m9LESec3/BdSQ7p27v96qVISVSJsuqaC5R8lkOse2pqObbd/yNPYMVaLPJtc9X0JKBMnOrJ6qgffku01WuFz3wjlIazJoTtMB78OsKcrnIQtv+T4T9PT9pu35brjPwLCj/TbZdyiaz0cE3dxg7zXnT4lgO9cnLUR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816335; c=relaxed/simple;
	bh=mEhNSEmpEsOQ2m8wNFinGqH08bqHGyrvrFVpec8Hrgo=;
	h=Date:To:From:Subject:Message-Id; b=VkEhIA0MX7wWSG1o7l6YwS3eD4jtcpC5fWr1Ra6jeaOmWx2ySiVkA4bNtZOXt0FI9vaDPAv4wVMJ/55VApxQXYI06JlGPwbotKguCkKSUKlHjQeCgcxjEf9DVCt7iKxd/JTVqK2800WgkzoE4su78pgqSew2y+KtVO9dk6ApqVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Dxhe6Ep7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Dxhe6Ep7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797ED1F00A3E;
	Tue,  4 Aug 2026 04:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816334;
	bh=mXcgWE9mgtK4Fiu/3+d10vWGOFeui6cuS9hiqsQvvho=;
	h=Date:To:From:Subject;
	b=Dxhe6Ep7/j2Om8zAaUsbnX5iVbShZiEEV/siIVTnaEa0UkeBPoNtvklCRCMrQjDaO
	 zMgr0z6uFfcigPnWmPim9aPIHiZB0cp2EDGaCD+81+jLjjfdoGNn1T2NxvazmzDOqv
	 /XVi3Ozit1xZkSTwGzvUV6ar1U6ZrqengWSuisao=
Date: Mon, 03 Aug 2026 21:05:34 -0700
To: mm-commits@vger.kernel.org,ebiggers@kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] xor-kunit-add-a-benchmark.patch removed from -mm tree
Message-Id: <20260804040534.797ED1F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xor/kunit: add a benchmark
has been removed from the -mm tree.  Its filename was
     xor-kunit-add-a-benchmark.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

