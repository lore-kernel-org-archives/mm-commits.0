Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718BD27FB28
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966015; cv=none; b=i5mDw/JMilbXcvP6yGlcmjKTaBpT22FMI4I+yUYiWmCA9eFKSZN9Zk43obd+5Jl2BEbW6d8Z/+aPVAGTZUPztgKTZzYwfaNgQoYrxbLuvOFH7iujlG/Zq9Gsaz3BLtE5IzGGxVEcrO1udLsrrtDfUTWbxc186EH3mcZ1J8df4QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966015; c=relaxed/simple;
	bh=ch89I1zO7E9FhTh5lRbGmMTgKTmBzaC6yca5gExaOiM=;
	h=Date:To:From:Subject:Message-Id; b=QPpm79BcSU2zJbjqamP2sx2Vwf6h/OQ6ZCTqbRxNC77osDZj/5kn70UXzigcubN1Sa9qGyKsYN9+JsE2fsP+ql1eQxubqWCjDpQu5aQ4M2n7qSRqKWYsuko1CfkqGYiRCrTQM0Q4x+kQD3q332YPcHjhK3VI6SaqT5Pk+BDLOCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HcPzzEZh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HcPzzEZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2D7C16AAE;
	Wed, 21 Jan 2026 03:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966015;
	bh=ch89I1zO7E9FhTh5lRbGmMTgKTmBzaC6yca5gExaOiM=;
	h=Date:To:From:Subject:From;
	b=HcPzzEZh0g88elHgnuIQA1nJ6CLEYFL+UDzEZVX1Gtz+7U4v7XJX/dRqLqoDIy3FG
	 0f4CulMDQadQXG73SRCgre5gRDwcgpLzdP6e05tC3ODoWYKSGLnPEefxGoKKFCH1Si
	 5sBYxidU8Y5lxcqt9Un8UXuubDOK8iG47XvbSrKA=
Date: Tue, 20 Jan 2026 19:26:54 -0800
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,will@kernel.org,venkat88@linux.ibm.com,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,ritesh.list@gmail.com,peterz@infradead.org,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jgross@suse.com,jannh@google.com,hpa@zytor.com,dwmw2@infradead.org,david@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,boris.ostrovsky@oracle.com,anshuman.khandual@arm.com,andreas@gaisler.com,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-basic-tests-for-lazy_mmu.patch removed from -mm tree
Message-Id: <20260121032654.DA2D7C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add basic tests for lazy_mmu
has been removed from the -mm tree.  Its filename was
     mm-add-basic-tests-for-lazy_mmu.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: mm: add basic tests for lazy_mmu
Date: Mon, 15 Dec 2025 15:03:23 +0000

Add basic KUnit tests for the generic aspects of the lazy MMU mode: ensure
that it appears active when it should, depending on how enable/disable and
pause/resume pairs are nested.

[akpm@linux-foundation.org: export ppc64_tlb_batch and __flush_tlb_pending to modules]
[ritesh.list@gmail.com: use EXPORT_SYMBOL_IF_KUNIT()]
  Link: https://lkml.kernel.org/r/87a4zhkt6h.ritesh.list@gmail.com
[kevin.brodsky@arm.com: move MODULE_IMPORT_NS(), add comment]
  Link: https://lkml.kernel.org/r/20251217163812.2633648-2-kevin.brodsky@arm.com
Link: https://lkml.kernel.org/r/20251215150323.2218608-15-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David S. Miller <davem@davemloft.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Juegren Gross <jgross@suse.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/book3s64/hash_tlb.c |    4 +
 mm/Kconfig                          |   12 ++++
 mm/Makefile                         |    1 
 mm/tests/lazy_mmu_mode_kunit.c      |   74 ++++++++++++++++++++++++++
 4 files changed, 90 insertions(+), 1 deletion(-)

--- a/arch/powerpc/mm/book3s64/hash_tlb.c~mm-add-basic-tests-for-lazy_mmu
+++ a/arch/powerpc/mm/book3s64/hash_tlb.c
@@ -25,11 +25,12 @@
 #include <asm/tlb.h>
 #include <asm/bug.h>
 #include <asm/pte-walk.h>
-
+#include <kunit/visibility.h>
 
 #include <trace/events/thp.h>
 
 DEFINE_PER_CPU(struct ppc64_tlb_batch, ppc64_tlb_batch);
+EXPORT_SYMBOL_IF_KUNIT(ppc64_tlb_batch);
 
 /*
  * A linux PTE was changed and the corresponding hash table entry
@@ -154,6 +155,7 @@ void __flush_tlb_pending(struct ppc64_tl
 		flush_hash_range(i, local);
 	batch->index = 0;
 }
+EXPORT_SYMBOL_IF_KUNIT(__flush_tlb_pending);
 
 void hash__tlb_flush(struct mmu_gather *tlb)
 {
--- a/mm/Kconfig~mm-add-basic-tests-for-lazy_mmu
+++ a/mm/Kconfig
@@ -1475,6 +1475,18 @@ config ARCH_HAS_LAZY_MMU_MODE
 	  MMU-related architectural state to be deferred until the mode is
 	  exited. See <linux/pgtable.h> for details.
 
+config LAZY_MMU_MODE_KUNIT_TEST
+	tristate "KUnit tests for the lazy MMU mode" if !KUNIT_ALL_TESTS
+	depends on ARCH_HAS_LAZY_MMU_MODE
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Enable this option to check that the lazy MMU mode interface behaves
+	  as expected. Only tests for the generic interface are included (not
+	  architecture-specific behaviours).
+
+	  If unsure, say N.
+
 source "mm/damon/Kconfig"
 
 endmenu
--- a/mm/Makefile~mm-add-basic-tests-for-lazy_mmu
+++ a/mm/Makefile
@@ -147,3 +147,4 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker
 obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_PT_RECLAIM) += pt_reclaim.o
+obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
diff --git a/mm/tests/lazy_mmu_mode_kunit.c a/mm/tests/lazy_mmu_mode_kunit.c
new file mode 100644
--- /dev/null
+++ a/mm/tests/lazy_mmu_mode_kunit.c
@@ -0,0 +1,74 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <kunit/test.h>
+#include <linux/pgtable.h>
+
+/* For some symbols referenced by arch_{enter,leave}_lazy_mmu_mode on powerpc */
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
+
+static void expect_not_active(struct kunit *test)
+{
+	KUNIT_EXPECT_FALSE(test, is_lazy_mmu_mode_active());
+}
+
+static void expect_active(struct kunit *test)
+{
+	KUNIT_EXPECT_TRUE(test, is_lazy_mmu_mode_active());
+}
+
+static void lazy_mmu_mode_active(struct kunit *test)
+{
+	expect_not_active(test);
+
+	lazy_mmu_mode_enable();
+	expect_active(test);
+
+	{
+		/* Nested section */
+		lazy_mmu_mode_enable();
+		expect_active(test);
+
+		lazy_mmu_mode_disable();
+		expect_active(test);
+	}
+
+	{
+		/* Paused section */
+		lazy_mmu_mode_pause();
+		expect_not_active(test);
+
+		{
+			/* No effect (paused) */
+			lazy_mmu_mode_enable();
+			expect_not_active(test);
+
+			lazy_mmu_mode_disable();
+			expect_not_active(test);
+
+			lazy_mmu_mode_pause();
+			expect_not_active(test);
+
+			lazy_mmu_mode_resume();
+			expect_not_active(test);
+		}
+
+		lazy_mmu_mode_resume();
+		expect_active(test);
+	}
+
+	lazy_mmu_mode_disable();
+	expect_not_active(test);
+}
+
+static struct kunit_case lazy_mmu_mode_test_cases[] = {
+	KUNIT_CASE(lazy_mmu_mode_active),
+	{}
+};
+
+static struct kunit_suite lazy_mmu_mode_test_suite = {
+	.name = "lazy_mmu_mode",
+	.test_cases = lazy_mmu_mode_test_cases,
+};
+kunit_test_suite(lazy_mmu_mode_test_suite);
+
+MODULE_DESCRIPTION("Tests for the lazy MMU mode");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

selftests-mm-default-kdir-to-build-directory.patch
selftests-mm-remove-flaky-header-check.patch
selftests-mm-pass-down-full-cc-and-cflags-to-check_configsh.patch
selftests-mm-fix-usage-of-force_read-in-cow-tests.patch
selftests-mm-introduce-helper-to-read-every-page-in-range.patch
selftests-mm-fix-faulting-in-code-in-pagemap_ioctl-test.patch
selftests-mm-fix-exit-code-in-pagemap_ioctl.patch
selftests-mm-report-skip-in-pfnmap-if-a-check-fails.patch

