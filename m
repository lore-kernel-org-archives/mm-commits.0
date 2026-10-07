Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B622931EF
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338644; cv=none; b=fKL1ijkAO8ey35hyEeJ5F6zpVt8cJ85T44VC3qCER9Z9cWOi+HDDshhhVmVY/+hufdrf8UZauwG6DwhN0sVV4/47lSIIvxPgdMkmyI3u0+51GUwNNlcAK5fmqK2jq3gymz3ZrrGIdM06lOoIe+OyCmEbD0r/bL5CQeHXvfaGIwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338644; c=relaxed/simple;
	bh=3x6du8UjDXs+vZ/l5uvoplKuNekVZkKrYdTgVazqI48=;
	h=Date:To:From:Subject:Message-Id; b=mzwD1YyogHdhDTiWWgyJ1luPipdqStUM0zUjg9ZQxaG+hLKkVQ5ZN7gA9m/Ik4y2CCuCVxkBkoCTv4twznZrUnOu7FbzHNfdrfb5ic7Qu5WYV0aixQky/wMyPHoeYuNcyAO/Tb04gkEhsFbA4w01Nhvg8kh4pEwVzmJRKLS+9/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jz6i6Iq3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jz6i6Iq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40BF71F0089C;
	Wed,  7 Oct 2026 02:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338643;
	bh=FoxrtoRKjVekorehaAdSq5fJOGrnFjpan3gyfZfGNtg=;
	h=Date:To:From:Subject;
	b=jz6i6Iq3pPxwOaEwcfFzeO16ViTu8G5dC4K/pQfC088tVF2bk/rzQcdJcaWpVwfXw
	 hn+9jtca8n8hx/NARb23hwwOgOQpL1u6ByrpRXbMUbAzzAuVD5KZ/Wc/xxGbYN0P9V
	 VC5+1z1CTIhL5yHLSq5mOp7BET9Z3uhK4gqyrvTg=
Date: Tue, 06 Oct 2026 19:04:02 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,ebiggers@kernel.org,ardb@kernel.org,geert@linux-m68k.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] raid-kunit-enable-raid6-pq-and-xor-benchmarks-if-kunit_all_tests=m.patch removed from -mm tree
Message-Id: <20261007020403.40BF71F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: raid/kunit: enable RAID6 PQ and XOR benchmarks if KUNIT_ALL_TESTS=m
has been removed from the -mm tree.  Its filename was
     raid-kunit-enable-raid6-pq-and-xor-benchmarks-if-kunit_all_tests=m.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: raid/kunit: enable RAID6 PQ and XOR benchmarks if KUNIT_ALL_TESTS=m
Date: Mon, 24 Aug 2026 17:14:01 +0200

Enabling the (possibly long-running benchmarks) by default may cause a big
delay in boot time in case of built-in tests.  However, they can still
safely be enabled by default if all tests are modular, as they would only
run when requested explicitly by the system administrator.

Link: https://lore.kernel.org/64c6e0191bd8ccef0074ffbb09bd0584680d710b.1787584360.git.geert@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>
---

 lib/raid/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/raid/Kconfig~raid-kunit-enable-raid6-pq-and-xor-benchmarks-if-kunit_all_tests=m
+++ a/lib/raid/Kconfig
@@ -32,6 +32,7 @@ config XOR_KUNIT_TEST
 config XOR_BENCHMARK
 	bool "Benchmark for xor_gen"
 	depends on XOR_KUNIT_TEST
+	default y if KUNIT_ALL_TESTS=m
 	help
 	  Include benchmarks in the KUnit test suite for xor_gen.
 
@@ -63,6 +64,7 @@ config RAID6_PQ_KUNIT_TEST
 config RAID6_PQ_KUNIT_BENCHMARK
 	bool "Benchmark for RAID6 PQ"
 	depends on RAID6_PQ_KUNIT_TEST
+	default y if KUNIT_ALL_TESTS=m
 	help
 	  Include benchmarks in the KUnit test suite for raid P/Q generation.
 
_

Patches currently in -mm which might be from geert@linux-m68k.org are


