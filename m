Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82AF45948
	for <mm-commits@vger.kernel.org>; Sun, 11 May 2025 04:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746938901; cv=none; b=dOEv+6QI6wEp/HtqoXAy6JeAHjpjY+sVMrIrunumQ5Q0x1BvaTJ2/0OOnAruMhlZD05A4gcAgYNzq3SqQa0IdvDwk4Fs0T5zNz76Q3zNWEdErZ4H4lnFFYFio1nDFNPzW+0B9IR3lzMdi8XYvN3+QNCorlK+PbS8P3l7iUZq/7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746938901; c=relaxed/simple;
	bh=vjrfMUm8IsSoEjQiXG2gT2NboVozZdk66MBPduNnQjs=;
	h=Date:To:From:Subject:Message-Id; b=o6Yh7goj9q85MzlGkMUIn7B27w1QNuxgKpx/vw7ja3DPPbGxE26nk1vETYTUjTi8nChTjAU9juXT5oYGfkabknoGi9vZZFiR+md3d5bkAa7m7zGq5/azRo+sWpt0HdOsD4dFyEw4m5heqcXkNE2N5431Hhi0dn2YI4zBpUxq4dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yv/pXDsh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yv/pXDsh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142FEC4CEE4;
	Sun, 11 May 2025 04:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746938901;
	bh=vjrfMUm8IsSoEjQiXG2gT2NboVozZdk66MBPduNnQjs=;
	h=Date:To:From:Subject:From;
	b=yv/pXDshy6Tg3G6iCCkI8c58A9nksgPN5bby1W7zZiz340s7a5xgXNTgpd7qTQvFf
	 bCe8UpEt3QFJOksuEzdi6mlb/TpLsz/L/FprZs5GqiHqmflqZBmPDVAocMF1GnwE0c
	 jTw5RE3Vx/Q/4U1h3ITqbHJ/lapAhII6KiL1bEMU=
Date: Sat, 10 May 2025 21:48:20 -0700
To: mm-commits@vger.kernel.org,Marc.Herbert@linux.intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] compiler_typesh-fix-unused-variable-in-__compiletime_assert-fix.patch removed from -mm tree
Message-Id: <20250511044821.142FEC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: compiler_typesh-fix-unused-variable-in-__compiletime_assert-fix
has been removed from the -mm tree.  Its filename was
     compiler_typesh-fix-unused-variable-in-__compiletime_assert-fix.patch

This patch was dropped because it was folded into compiler_typesh-fix-unused-variable-in-__compiletime_assert.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: compiler_typesh-fix-unused-variable-in-__compiletime_assert-fix
Date: Thu Apr 24 02:53:15 PM PDT 2025

regularize comment layout, reflow comment

Cc: Marc Herbert <Marc.Herbert@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler_types.h |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/include/linux/compiler_types.h~compiler_typesh-fix-unused-variable-in-__compiletime_assert-fix
+++ a/include/linux/compiler_types.h
@@ -525,10 +525,11 @@ struct ftrace_likely_data {
 	 sizeof(t) == sizeof(int) || sizeof(t) == sizeof(long))
 
 #ifdef __OPTIMIZE__
-/* #ifdef __OPTIMIZE__ is only a good approximation; for instance "make
- * CFLAGS_foo.o=-Og" defines __OPTIMIZE__, does not elide the
- * conditional code and can break compilation with wrong error
- * message(s). Combine with -U__OPTIMIZE__ when needed.
+/*
+ * #ifdef __OPTIMIZE__ is only a good approximation; for instance "make
+ * CFLAGS_foo.o=-Og" defines __OPTIMIZE__, does not elide the conditional code
+ * and can break compilation with wrong error message(s). Combine with
+ * -U__OPTIMIZE__ when needed.
  */
 # define __compiletime_assert(condition, msg, prefix, suffix)		\
 	do {								\
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only-update-fix.patch
mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain-checkpatch-fixes.patch
jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-2.patch
mm-hugetlbc-__unmap_hugepage_range-comment-cleanup.patch
mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality-fix.patch
mm-perform-vma-allocation-freeing-duplication-in-mm-fix.patch
filemap-do-not-use-folio_contains-for-swap-cache-folios-fix.patch
memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat-fix.patch
mm-add-zblock-allocator-fix.patch
mm-add-zblock-allocator-fix-2.patch
mm-add-zblock-allocator-fix-3.patch
mm-zblock-avoid-failing-the-build-fix.patch
compiler_typesh-fix-unused-variable-in-__compiletime_assert.patch
revert-x86-mm-remove-unused-__set_memory_prot-fix.patch

