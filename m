Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9719F320A20
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 16:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769012913; cv=none; b=ur/LtAlxPihzD8INhno4nsiIV6d4PeFqyDObVoPgnJ+8sJxdYi8nxZrAnR0JbtIqoWNjtTyNkvT2L9nBtNxOn7fzJL1E77PsYESwzYz6baThDjmy/n25eurCY3GZ/NAkUetK3hW2i4tWqy6OTLn461BdyKR/HvIGOU4UB/Ufy68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769012913; c=relaxed/simple;
	bh=WDSsQ6RF6yt2eAzZcvONue7uC6vVwrj3gwKmv3V9r0g=;
	h=Date:To:From:Subject:Message-Id; b=dYelEaXgg0pwUSsixhr0tYLFKG1LqCE2EUkWzhHqDc2YCEP1t73t7fyeGLLl0EnF4DLY4jFWTKo7LA1lZiSsrFmf+MFPWLwrN8qmV6rIRf1OaCGGGLX9YnZRuiCKF03LaR7ykdHbCsUS+IiORICa2CwXGbwb5CI0678oO8s9R0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tf9hX6QR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tf9hX6QR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A88FC4CEF1;
	Wed, 21 Jan 2026 16:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769012912;
	bh=WDSsQ6RF6yt2eAzZcvONue7uC6vVwrj3gwKmv3V9r0g=;
	h=Date:To:From:Subject:From;
	b=Tf9hX6QRIH54bNphN01yvHxqfrzLu+DBPC9Mxi9d94naQgfEBePQtzSUE4K7Csreu
	 sDsi+boEVZFwz/6u1V6Hsa9/P4AVA+EwF1Pd5gJT4lpF/fVhf1KB5eqCluaJPcWEav
	 ljw/VAwEt+v0U2loNm5Q28LpNmKJOAnLZ8CyNwn8=
Date: Wed, 21 Jan 2026 08:28:31 -0800
To: mm-commits@vger.kernel.org,andreas@gaisler.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests.patch added to mm-unstable branch
Message-Id: <20260121162832.1A88FC4CEF1@smtp.kernel.org>
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

Upcoming KUnit tests will call lazy_mmu_mode_{enable,disable}.  These
tests may be built as a module, and because of inlining this means that
arch_{enter,flush,leave}_lazy_mmu_mode need to be exported.

Link: https://lkml.kernel.org/r/20251218100541.2667405-1-kevin.brodsky@arm.com
Fixes: 442bf488b9e8 ("sparc/mm: implement arch_flush_lazy_mmu_mode()")
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

