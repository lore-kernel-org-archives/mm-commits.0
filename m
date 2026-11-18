Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794969133;
	b=Ux4x/aZrp9ZkKGOZjE5DQGIH4qshHn4zyu6ICUB8i4rC2vCtLsNq6TlMaIfM7QTJlm+B
	 bHlEmO2ZU4S1aPRdqCBr+kifAu6+9NntR+jX3qeovwyPbodBbEwHJIcp3zKt/e6uVC4Fg
	 0OVaokn5oowMz3Pr17fQMwmPmXjdigBuwL3zrq25cQEv69fcLDmmO1taZPJ1QPN17tDDs
	 QhMcH922z3fKwF7kPz+D9YQ1BLIaq0hq6bZoxqwIk819Y++eB+D/dGSh+aLZhHkwjv8tu
	 VhbkXsu+gPS7dX5Nbww/Xa3rYdKfn8HNm4co1ULc7VYbhpSkIZz+NYtQG7Fi1xOBAbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794969133;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=OeMocPJIUiuQssCV79R0Zp27Ambmk/omE7rhs/zZbWI=;
	b=szAX+dO1fLiU1uGymY3BzIrBtsXlaBRaBbHyvDOD/j2XtpE3C8uzeNq+UBN8nYXj4s0e
	 ZLLGt9MZxaVwrZbQdgojZjBm4E2H0dxQqmq/G0wlKJao5BeXSaaJR9y1WFBVO7h3qSTtJ
	 cRIoiRya4SS30K91JYWW5dml9wTIsp/rjVHVCwsfwqoZEqMyMyxk3DUTdpeJw5DgYx/X1
	 ji2zRLe1zpKCIbvczwwp6P1Qzm++y/3sp8DgtnmTUH+TGT1A3HM1/FXrvHC7S92SWp1ik
	 D1YKPGIK8CUeHakTSSAjy5KfIq6JXEYyjK9zDm27Zky07zih0K0KzwamAtAd3cnh2rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=kH3So3Tj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4F0606A31C
	for <mm-commits@vger.kernel.org>; Wed, 18 Nov 2026 02:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=kH3So3Tj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 175B21F000C4;
	Wed, 18 Nov 2026 02:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794969133;
	bh=OeMocPJIUiuQssCV79R0Zp27Ambmk/omE7rhs/zZbWI=;
	h=Date:To:From:Subject;
	b=kH3So3TjQrYz1Rr6ebNUQ5y8VplE5Rr9ISB6QBsjSBBvz7cPb0cJa/a4wO1nBFFmU
	 ycSYVOTKzhM1AZISprAi8YAOrarVZ8d4J9yxmcjuSw+hAIec6a3PdLUx93g5zFC66Q
	 yM1deriHxNhFA/Ppt/ZIlkWo1rxEA2FGYxFXbkVQ=
Date: Tue, 17 Nov 2026 18:32:12 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,rdunlap@infradead.org,
	ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,lkp@intel.com,
	lienze@kylinos.cn,justinstitt@google.com,david@kernel.org,
	jm5905938@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-add-kunit-tests-for-addr_unit-conversion-fix.patch added to mm-unstable branch
Message-Id: <20261118023213.175B21F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/paddr: avoid truncation warning in high-address KUnit test
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-paddr-add-kunit-tests-for-addr_unit-conversion-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-add-kunit-tests-for-addr_unit-conversion-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Aveline Noir <jm5905938@gmail.com>
Subject: mm/damon/paddr: avoid truncation warning in high-address KUnit test
Date: Wed, 18 Nov 2026 04:04:33 +1100

When phys_addr_t is 32-bit, Sparse warns about truncating the u64 address
passed to damon_pa_core_addr() in damon_test_pa_addr_over_4g().  The
runtime kunit_skip() does not prevent Sparse from checking that
conversion.

Compile the high-address assertions only with CONFIG_PHYS_ADDR_T_64BIT,
and keep the test skipped otherwise.

Link: https://lore.kernel.org/20261118-fix-damon-paddr-sparse-20261118-v1-1-3a0e943406d5@gmail.com
Fixes: 7a983cc1b573 ("mm/damon/paddr: add KUnit tests for addr_unit conversion")
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/20261117170155.fEdeuuhm-lkp@intel.com/
Cc: SJ Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Enze Li <lienze@kylinos.cn>
Cc: Randy Dunlap <rdunlap@infradead.org>

 mm/damon/tests/paddr-kunit.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/damon/tests/paddr-kunit.h~mm-damon-paddr-add-kunit-tests-for-addr_unit-conversion-fix
+++ a/mm/damon/tests/paddr-kunit.h
@@ -26,15 +26,16 @@ static void damon_test_pa_core_addr(stru
 
 static void damon_test_pa_addr_over_4g(struct kunit *test)
 {
+#ifdef CONFIG_PHYS_ADDR_T_64BIT
 	unsigned long addr = 0xffffffffUL;
 	unsigned long addr_unit = 0x1000;
 	u64 pa = 0xffffffff000ULL;
 
-	if (!IS_ENABLED(CONFIG_PHYS_ADDR_T_64BIT))
-		kunit_skip(test, "phys_addr_t is 32-bit");
-
 	KUNIT_EXPECT_EQ(test, damon_pa_phys_addr(addr, addr_unit), pa);
 	KUNIT_EXPECT_EQ(test, damon_pa_core_addr(pa, addr_unit), addr);
+#else
+	kunit_skip(test, "phys_addr_t is 32-bit");
+#endif
 }
 
 static struct kunit_case damon_paddr_test_cases[] = {
_

Patches currently in -mm which might be from jm5905938@gmail.com are

mm-damon-ops-common-align-mmu-notifier-range-when-clearing-pmd-young-bit.patch
mm-damon-stat-avoid-32-bit-overflow-in-idle-percentiles.patch
mm-damon-pvaddr-skip-folios-already-on-the-migration-target-node.patch
docs-admin-guide-mm-damon-start-fix-grammar.patch
docs-admin-guide-mm-damon-stat-fix-pronoun-agreement.patch
docs-admin-guide-mm-damon-usage-fix-grammar.patch
docs-admin-guide-mm-damon-lru_sort-fix-remaining-grammar.patch
docs-mm-damon-design-fix-grammar-and-typos.patch
docs-mm-damon-api-fix-verb-form.patch
docs-mm-damon-maintainer-profile-fix-subject-verb-agreement.patch
docs-mm-damon-monitoring_intervals_tuning_example-fix-grammar-and-typos.patch
mm-damon-paddr-add-kunit-tests-for-addr_unit-conversion.patch
mm-damon-paddr-add-kunit-tests-for-addr_unit-conversion-fix.patch

