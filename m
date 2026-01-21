Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EBA30F542
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 01:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768960054; cv=none; b=ROuANXSVVHW8Y9V9f0oKfKsMkk2DqLI6YSxcCvUlA68itCygz9rzBJ5MRFmdafEcdYL1WLlrFFbe26nBX11R/bTAbhxFJmv5LCVdfbpHM1/PhP6Ht6cX/OMc0RmrQN8IpAY92XZKLvT5lGEf3X1JowPzHwTv5CMJeFBp2sJ0Bn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768960054; c=relaxed/simple;
	bh=UTERicCzU2QfMpVVHeMmDmWBuKCbiT7iqf7jxEWHFmo=;
	h=Date:To:From:Subject:Message-Id; b=q4FWYztfbzEirLyJWJ/ArXu+vT4q0A4BIkzlpTKrhPpjPDEWJEm/Qa4CEmV1e1Hjfy5ZA6AIhqfKbrRzrLfWFrib7klRnDd9wDJScoHDPc5qTwCwEsRmuNL5fN7twsJqA0dQUYBAFAJC/G7pKknrL6tP60+J42UUxerYSx4xHGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z+KpMHkf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z+KpMHkf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE21C19423;
	Wed, 21 Jan 2026 01:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768960053;
	bh=UTERicCzU2QfMpVVHeMmDmWBuKCbiT7iqf7jxEWHFmo=;
	h=Date:To:From:Subject:From;
	b=Z+KpMHkfW8EOkm6DvNZIEX+N1St46kpJItUmJu/m+4sSkNieyn/icFmzwfDOUps88
	 DXiAo7tQBD81rHRwV1K+HhkIN7nfmz5//Hr4xpIBMEgnTI1n7XWQ799RR6W0+XmWxN
	 5z2ak+35Y+vi3e5Y/uAze5bMJzHnUer9DXWrPq/A=
Date: Tue, 20 Jan 2026 17:47:32 -0800
To: mm-commits@vger.kernel.org,ritesh.list@gmail.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-basic-tests-for-lazy_mmu-fix-fix-fix.patch removed from -mm tree
Message-Id: <20260121014732.EBE21C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-add-basic-tests-for-lazy_mmu-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-add-basic-tests-for-lazy_mmu-fix-fix-fix.patch

This patch was dropped because it was folded into mm-add-basic-tests-for-lazy_mmu-fix.patch

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: mm-add-basic-tests-for-lazy_mmu-fix-fix-fix
Date: Wed, 17 Dec 2025 16:38:12 +0000

move MODULE_IMPORT_NS(), add comment

Link: https://lkml.kernel.org/r/20251217163812.2633648-2-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/tests/lazy_mmu_mode_kunit.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/tests/lazy_mmu_mode_kunit.c~mm-add-basic-tests-for-lazy_mmu-fix-fix-fix
+++ a/mm/tests/lazy_mmu_mode_kunit.c
@@ -2,6 +2,9 @@
 #include <kunit/test.h>
 #include <linux/pgtable.h>
 
+/* For some symbols referenced by arch_{enter,leave}_lazy_mmu_mode on powerpc */
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
+
 static void expect_not_active(struct kunit *test)
 {
 	KUNIT_EXPECT_FALSE(test, is_lazy_mmu_mode_active());
@@ -69,4 +72,3 @@ kunit_test_suite(lazy_mmu_mode_test_suit
 
 MODULE_DESCRIPTION("Tests for the lazy MMU mode");
 MODULE_LICENSE("GPL");
-MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

x86-xen-simplify-flush_lazy_mmu.patch
powerpc-mm-implement-arch_flush_lazy_mmu_mode.patch
sparc-mm-implement-arch_flush_lazy_mmu_mode.patch
mm-clarify-lazy_mmu-sleeping-constraints.patch
mm-introduce-config_arch_has_lazy_mmu_mode.patch
mm-introduce-generic-lazy_mmu-helpers.patch
mm-bail-out-of-lazy_mmu_mode_-in-interrupt-context.patch
mm-enable-lazy_mmu-sections-to-nest.patch
arm64-mm-replace-tif_lazy_mmu-with-is_lazy_mmu_mode_active.patch
powerpc-mm-replace-batch-active-with-is_lazy_mmu_mode_active.patch
sparc-mm-replace-batch-active-with-is_lazy_mmu_mode_active.patch
x86-xen-use-lazy_mmu_state-when-context-switching.patch
mm-add-basic-tests-for-lazy_mmu.patch
mm-add-basic-tests-for-lazy_mmu-fix.patch
selftests-mm-default-kdir-to-build-directory.patch
selftests-mm-remove-flaky-header-check.patch
selftests-mm-pass-down-full-cc-and-cflags-to-check_configsh.patch
selftests-mm-fix-usage-of-force_read-in-cow-tests.patch
selftests-mm-introduce-helper-to-read-every-page-in-range.patch
selftests-mm-fix-faulting-in-code-in-pagemap_ioctl-test.patch
selftests-mm-fix-exit-code-in-pagemap_ioctl.patch
selftests-mm-report-skip-in-pfnmap-if-a-check-fails.patch

