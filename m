Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E03390CA3
	for <mm-commits@vger.kernel.org>; Thu, 27 Aug 2026 03:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787802676; cv=none; b=cYYWOmXXwYGSdt+N72kNen6m9AwhNHm6zmcsao/kfnlpnHOI31sSdTWYVNq1pt0WBrDnmBveDj8Yu7ZQWn9ihtUx3Fv5bUGJixFAvSMZ1FyEQa4Gb8343nenQjmv6Mx8FLU2cZeZJJ+YMsEs9IUV1G0Na9XdTYSsvrFxVO1M2j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787802676; c=relaxed/simple;
	bh=a7eA4RjhoFZETfm+mVHW2HRyyapHz7pfHHd+AmjoCVc=;
	h=Date:To:From:Subject:Message-Id; b=fdUrHmNtbGLj91WZCmseSlkQm3AIjB9ou0B55csvL7lHGDSxCoRAcI6Uv94/UIed7wXVfZiAgIp1HP3zhCBIP/LFlyUJ73f/FvgssoeSh0NJQwvWI6xzrdspVnoMYzjk0v4dxsMxlNuDEYAfOEVUtvmnAX9A9X+0ibyXfFOYNcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nlqPkvhn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nlqPkvhn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390FF1F000E9;
	Thu, 27 Aug 2026 03:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787802674;
	bh=jVp+UyaBPxe6vG2UfC8zXdh70d1HAw8SVEnsBsN+xEY=;
	h=Date:To:From:Subject;
	b=nlqPkvhnuS9KlvcOINSafoG9C18FRHT7htakU/poUGQJhOcULWoof4dzO5Kq431CE
	 qqY4HUeFcodQ+XbR9EYQ0pr94DtzfPu0OzQr1jF4PpTsZgcg489o64kt+GsMkYPanr
	 tfcnoGO+m/9J55G3woaMz3IRkbH/h8vqrxGSBjVU=
Date: Wed, 26 Aug 2026 20:51:13 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,ebiggers@kernel.org,ardb@kernel.org,geert@linux-m68k.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + raid-kunit-enable-raid6-pq-and-xor-benchmarks-if-kunit_all_tests=m.patch added to mm-nonmm-unstable branch
Message-Id: <20260827035114.390FF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: raid/kunit: enable RAID6 PQ and XOR benchmarks if KUNIT_ALL_TESTS=m
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     raid-kunit-enable-raid6-pq-and-xor-benchmarks-if-kunit_all_tests=m.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/raid-kunit-enable-raid6-pq-and-xor-benchmarks-if-kunit_all_tests=m.patch

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
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: raid/kunit: enable RAID6 PQ and XOR benchmarks if KUNIT_ALL_TESTS=m
Date: Mon, 24 Aug 2026 17:14:01 +0200

Enabling the (possibly long-running benchmarks) by default may cause a big
delay in boot time in case of built-in tests.  However, they can still
safely be enabled by default if all tests are modular, as they would only
run when requested explicitly by the system administrator.

Link: https://lore.kernel.org/64c6e0191bd8ccef0074ffbb09bd0584680d710b.1787584360.git.geert@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

raid-kunit-enable-raid6-pq-and-xor-benchmarks-if-kunit_all_tests=m.patch

