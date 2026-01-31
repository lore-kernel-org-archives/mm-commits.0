Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420E720CCDC
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898302; cv=none; b=JMwWDzX5ankCntf0Mwk4sDIHFKPERw3fVuvzupH37ZhZgUGoffy69apDmS+zLhSqwtSyVXTuBdpzyioT/boLgZQF2xM0KrMAVP3pmD7VSZjh5EDlIEFlk/Ub9D2RQGob7MalkMekAklaL6pCm9iB3z9gPhaigG5xo4+8/RCbubY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898302; c=relaxed/simple;
	bh=VJMnqZWS/M7cepMef0hCqh6B7F1YByuP6b96UTEpaJM=;
	h=Date:To:From:Subject:Message-Id; b=V7zmtahI4YaBEJ4veuTYOu413AX0wClT5zEIFHWdnzt+uvLz4F/pXXn1dKoqZKPDGYzDfr8/eIvnp1MCeaxUkoSxymcK2bLeeE9Lc7+54oVhYbpssfGVQXi54xx0DRei+UoEUGDpkCuaAxei+Tgd6AZHKu+nmtr5TF7HQmlVWzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bG4nLzhI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bG4nLzhI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1270AC4CEF1;
	Sat, 31 Jan 2026 22:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898302;
	bh=VJMnqZWS/M7cepMef0hCqh6B7F1YByuP6b96UTEpaJM=;
	h=Date:To:From:Subject:From;
	b=bG4nLzhIsscBxnjlMkE3/RKWcPDO4q+ORNHjr+NHherIWBLP0KKZvJexoTrT4ugAx
	 M4m3T7B0SFOHMhXfI3a0H4q8AlfVHyybLvN/vSHa4WmlHMLvLq+JdENk0isJkaiSNk
	 nIzqSeg/UNrHAFRNPorK9Y3C2LOVKA9JX/gJUs/4=
Date: Sat, 31 Jan 2026 14:25:01 -0800
To: mm-commits@vger.kernel.org,andreas@gaisler.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests.patch removed from -mm tree
Message-Id: <20260131222502.1270AC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sparc/mm: export symbols for lazy_mmu_mode KUnit tests
has been removed from the -mm tree.  Its filename was
     sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: sparc/mm: export symbols for lazy_mmu_mode KUnit tests
Date: Thu, 18 Dec 2025 10:05:40 +0000

The lazy_mmu_mode KUnit tests call lazy_mmu_mode_{enable,disable}.  These
tests may be built as a module, and because of inlining this means that
arch_{enter,flush,leave}_lazy_mmu_mode need to be exported.

[akpm@linux-foundation.org: remove mm/tests/lazy_mmu_mode_kunit.c comment, per Kevin]
Link: https://lkml.kernel.org/r/20251218100541.2667405-1-kevin.brodsky@arm.com
Fixes: ee628d9cc8d5 ("mm: add basic tests for lazy_mmu")
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/tlb.c            |    6 ++++++
 mm/tests/lazy_mmu_mode_kunit.c |    1 -
 2 files changed, 6 insertions(+), 1 deletion(-)

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
--- a/mm/tests/lazy_mmu_mode_kunit.c~sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests
+++ a/mm/tests/lazy_mmu_mode_kunit.c
@@ -2,7 +2,6 @@
 #include <kunit/test.h>
 #include <linux/pgtable.h>
 
-/* For some symbols referenced by arch_{enter,leave}_lazy_mmu_mode on powerpc */
 MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
 
 static void expect_not_active(struct kunit *test)
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are


