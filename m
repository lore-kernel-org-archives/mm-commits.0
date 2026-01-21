Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AB3263C8C
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 17:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769015419; cv=none; b=thOv8xaoJqk2h719Pt9tzmRdJsu1lLwdkG4/G5lixiSmdq6/0T+aAcgYEbKxR1Ck6WfKmOckfcCEqUbgjQgrmxO5cQsd/15ZroczqGwg2HPINy7EeT75nenOKf/S5pa4wwDjAz5jYZ1q5QDjY7cW96m6Wa5dN373vJTp82qZxjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769015419; c=relaxed/simple;
	bh=xPFckh5/3SQBuYDo/vaJ0UvQ0fi+h9okpfbr6sh2PDU=;
	h=Date:To:From:Subject:Message-Id; b=l9FbTWtpPY2yMOzTCkojvvyeBzJ8j6wrqM60jcBqNXK8D0YvW4/ryyRNbyO2dV0vI5U9pU5+CkL21voMIhKwoSd/Bx9SmQTk0E5TJdPnk5iT+wM3KApbtCQOMGpCJ3taA8OZ2UgsOZnRdnPcNwhdc5HjWhndIdsQFR2PU7wmRSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jbWAGhwS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jbWAGhwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F808C116D0;
	Wed, 21 Jan 2026 17:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769015419;
	bh=xPFckh5/3SQBuYDo/vaJ0UvQ0fi+h9okpfbr6sh2PDU=;
	h=Date:To:From:Subject:From;
	b=jbWAGhwSkRMx8hV8qGOLiA7scBLVQucH1mzIgxIptAUscf0xtZpES549taaXMmHNV
	 RprqIg6tkmxFICkoFLc7BFNljg1Gd06A/3xTtO9j4ZerSnlFPhGogW6xzwfBVCq5m9
	 +kn+YNpB4JAusrm0jGa6wJPL0zVcZ0BRw2lHdAjM=
Date: Wed, 21 Jan 2026 09:10:18 -0800
To: mm-commits@vger.kernel.org,andreas@gaisler.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests.patch added to mm-unstable branch
Message-Id: <20260121171019.4F808C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sparc/mm: export symbols for lazy_mmu_mode KUnit tests
has been added to the -mm mm-unstable branch.  Its filename is
     sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests.patch

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
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: sparc/mm: export symbols for lazy_mmu_mode KUnit tests
Date: Thu, 18 Dec 2025 10:05:40 +0000

The lazy_mmu_mode KUnit tests call lazy_mmu_mode_{enable,disable}.  These
tests may be built as a module, and because of inlining this means that
arch_{enter,flush,leave}_lazy_mmu_mode need to be exported.

Link: https://lkml.kernel.org/r/20251218100541.2667405-1-kevin.brodsky@arm.com
Fixes: ee628d9cc8d5 ("mm: add basic tests for lazy_mmu")
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/tlb.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/sparc/mm/tlb.c~sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests
+++ a/arch/sparc/mm/tlb.c
@@ -11,6 +11,8 @@
 #include <linux/preempt.h>
 #include <linux/pagemap.h>
 
+#include <kunit/visibility.h>
+
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
 #include <asm/mmu_context.h>
@@ -54,6 +56,8 @@ void arch_enter_lazy_mmu_mode(void)
 {
 	preempt_disable();
 }
+/* For lazy_mmu_mode KUnit tests */
+EXPORT_SYMBOL_IF_KUNIT(arch_enter_lazy_mmu_mode);
 
 void arch_flush_lazy_mmu_mode(void)
 {
@@ -62,12 +66,14 @@ void arch_flush_lazy_mmu_mode(void)
 	if (tb->tlb_nr)
 		flush_tlb_pending();
 }
+EXPORT_SYMBOL_IF_KUNIT(arch_flush_lazy_mmu_mode);
 
 void arch_leave_lazy_mmu_mode(void)
 {
 	arch_flush_lazy_mmu_mode();
 	preempt_enable();
 }
+EXPORT_SYMBOL_IF_KUNIT(arch_leave_lazy_mmu_mode);
 
 static void tlb_batch_add_one(struct mm_struct *mm, unsigned long vaddr,
 			      bool exec, unsigned int hugepage_shift)
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests.patch
selftests-mm-default-kdir-to-build-directory.patch
selftests-mm-remove-flaky-header-check.patch
selftests-mm-pass-down-full-cc-and-cflags-to-check_configsh.patch
selftests-mm-fix-usage-of-force_read-in-cow-tests.patch
selftests-mm-introduce-helper-to-read-every-page-in-range.patch
selftests-mm-fix-faulting-in-code-in-pagemap_ioctl-test.patch
selftests-mm-fix-exit-code-in-pagemap_ioctl.patch
selftests-mm-report-skip-in-pfnmap-if-a-check-fails.patch

