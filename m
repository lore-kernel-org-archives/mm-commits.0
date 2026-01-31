Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9BD376479
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 21:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769896475; cv=none; b=UXoiM2qCAIHm01Q+8vIh55NZL1XEvl1TP5oD6brccVzCWdDRTMpxuR25Wh78FuGDo0UDU5YO/qAIFfGL3u59lFWpkOIQmTCZG95sVs/0Ua7k7YW1I+RbHgdFmEvlAv7bB5mqRaJZy61EV+jG5KU4KhB17E8muyKPjL1hAHCaOI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769896475; c=relaxed/simple;
	bh=7f20Th8hGIrCabUBbCMVkOxaKOh/NjLFT0d9nhPY/pg=;
	h=Date:To:From:Subject:Message-Id; b=LTw+KKgDg6sdW7koL/5bnRLp2eGJ4tfZXNQGhFcx57o//pT6vH808KEV5sEK1in1zCw71L2TGILpozepmjGI62u2lOm+w/TwN8PY0fmvpFrPjPpHw2LIMw4j9n7i9FT+riuKWgBjmwHJaO3naSxyAQ7R4K9FxHyCVS56UXlSYqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o2hLIqoU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o2hLIqoU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F358C4CEF1;
	Sat, 31 Jan 2026 21:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769896475;
	bh=7f20Th8hGIrCabUBbCMVkOxaKOh/NjLFT0d9nhPY/pg=;
	h=Date:To:From:Subject:From;
	b=o2hLIqoU+SB0+TE6Ksm3xvgqZ7AQRHd6DiLaTBw3SO1LD5sV9Gm+BuQVlL2zl2QuS
	 tMfckTJyvHtlUwI/BGnSW+RUpcRl0fnQyPd2xxy7JdKzLMj3jtZ3CztWBwElXdZ/S2
	 m7zFV/5BQZTbaBbqBwVI9mHfDRPHrC6rMT24Gz/4=
Date: Sat, 31 Jan 2026 13:54:34 -0800
To: mm-commits@vger.kernel.org,kevin.brodsky@arm.com,andreas@gaisler.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests-fix.patch removed from -mm tree
Message-Id: <20260131215435.2F358C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests-fix
has been removed from the -mm tree.  Its filename was
     sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests-fix.patch

This patch was dropped because it was folded into sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests-fix
Date: Wed Jan 21 09:06:56 AM PST 2026

remove mm/tests/lazy_mmu_mode_kunit.c comment, per Kevin

Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/tests/lazy_mmu_mode_kunit.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/tests/lazy_mmu_mode_kunit.c~sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests-fix
+++ a/mm/tests/lazy_mmu_mode_kunit.c
@@ -2,7 +2,6 @@
 #include <kunit/test.h>
 #include <linux/pgtable.h>
 
-/* For some symbols referenced by arch_{enter,leave}_lazy_mmu_mode on powerpc */
 MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
 
 static void expect_not_active(struct kunit *test)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

procfs-avoid-fetching-build-id-while-holding-vma-lock-fix.patch
sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests.patch
mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment-fix.patch
mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns-fix.patch
mm-pagewalk-use-min-to-simplify-the-code-fix.patch
mm-relocate-the-page-table-ceiling-and-floor-definitions-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
liveupdate-luo_file-remember-retrieve-status-fix.patch

