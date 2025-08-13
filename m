Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC13330276D
	for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2025 22:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755123898; cv=none; b=vE3ebb5qV/eBa2s7SekLm57UIlJ5eSu4Uwjsub0fTZ0c8uZnxPqLECI9+gqHd3SigHfI2tiXaK8LZJ8eFiAFWHpBCVmUPgKzeeLaXaMIZrLr+kIGP9Q0a6FLX7ID9GKFh4xqBk5gAdHzgTuVHbz2kSHIg7xjSm/1az09OM3B4q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755123898; c=relaxed/simple;
	bh=ua7Ui+uzGX2ixgknZwVXsl/pLEF+Yc+Ofa5QgJCyq6w=;
	h=Date:To:From:Subject:Message-Id; b=ZWTcxJAVO4P1d7v6SXbd5BeQ4VaLyz4g45sRche0iVu/qlcnXWhFylzTtW9mguztk4YEWj8mowq4S5cyNgQJP5B5REU+H0B9qgZ0fV3hC30li7THQYLmdBNNScYtJ+ZT21kDmGALOFq/9IZG3852d1QlYwqERIL/XYzeN0Y+01o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ILFYxymC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ILFYxymC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431CBC4CEEB;
	Wed, 13 Aug 2025 22:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755123897;
	bh=ua7Ui+uzGX2ixgknZwVXsl/pLEF+Yc+Ofa5QgJCyq6w=;
	h=Date:To:From:Subject:From;
	b=ILFYxymCD9gTAAMMnuFBqRVB+CopdUq0zlQIrENwq0lvOlg6W/ARpD50TpFdi/vhO
	 6u6keB3cuIb0R4gb/VukVAuUt43RAyL0iPbLCA96MwcJvJ2Fi0/j2yKptgVdIRbDkc
	 MU/D+Fsy3GiFQb5u36nUJx9yFKO/+LCWXdVOnabg=
Date: Wed, 13 Aug 2025 15:24:56 -0700
To: mm-commits@vger.kernel.org,yang@os.amperecomputing.com,will@kernel.org,vincenzo.frascino@arm.com,scott@os.amperecomputing.com,ryabinin.a.a@gmail.com,pankaj.gupta@amd.com,oliver.upton@linux.dev,maz@kernel.org,leitao@debian.org,kaleshsingh@google.com,jhubbard@nvidia.com,james.morse@arm.com,hardevsinh.palaniya@siliconsignals.io,glider@google.com,dvyukov@google.com,david@redhat.com,corbet@lwn.net,catalin.marinas@arm.com,broonie@kernel.org,ardb@kernel.org,andreyknvl@gmail.com,yeoreum.yun@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-hw-tags-introduce-kasanstore_only-option.patch added to mm-new branch
Message-Id: <20250813222457.431CBC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan/hw-tags: introduce kasan.store_only option
has been added to the -mm mm-new branch.  Its filename is
     kasan-hw-tags-introduce-kasanstore_only-option.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-hw-tags-introduce-kasanstore_only-option.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: kasan/hw-tags: introduce kasan.store_only option
Date: Wed, 13 Aug 2025 18:53:34 +0100

Patch series "introduce kasan.store_only option in hw-tags", v2.

Hardware tag based KASAN is implemented using the Memory Tagging Extension
(MTE) feature.

MTE is built on top of the ARMv8.0 virtual address tagging TBI (Top Byte
Ignore) feature and allows software to access a 4-bit allocation tag for
each 16-byte granule in the physical address space.  A logical tag is
derived from bits 59-56 of the virtual address used for the memory access.
A CPU with MTE enabled will compare the logical tag against the
allocation tag and potentially raise an tag check fault on mismatch,
subject to system registers configuration.

Since ARMv8.9, FEAT_MTE_STORE_ONLY can be used to restrict raise of tag
check fault on store operation only.

Using this feature (FEAT_MTE_STORE_ONLY), introduce KASAN store-only mode
which restricts KASAN check store operation only.  This mode omits KASAN
check for fetch/load operation.  Therefore, it might be used not only
debugging purpose but also in normal environment.


This patch (of 2):

Since Armv8.9, FEATURE_MTE_STORE_ONLY feature is introduced to restrict
raise of tag check fault on store operation only.  Introcude KASAN store
only mode based on this feature.

KASAN store only mode restricts KASAN checks operation for store only and
omits the checks for fetch/read operation when accessing memory.  So it
might be used not only debugging enviroment but also normal enviroment to
check memory safty.

This features can be controlled with "kasan.store_only" arguments.  When
"kasan.store_only=on", KASAN checks store only mode otherwise KASAN checks
all operations.

Link: https://lkml.kernel.org/r/20250813175335.3980268-1-yeoreum.yun@arm.com
Link: https://lkml.kernel.org/r/20250813175335.3980268-2-yeoreum.yun@arm.com
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Breno Leitao <leitao@debian.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: D Scott Phillips <scott@os.amperecomputing.com>
Cc: Hardevsinh Palaniya <hardevsinh.palaniya@siliconsignals.io>
Cc: James Morse <james.morse@arm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: levi.yun <yeoreum.yun@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst  |    3 +
 arch/arm64/include/asm/memory.h    |    1 
 arch/arm64/include/asm/mte-kasan.h |    6 ++
 arch/arm64/kernel/cpufeature.c     |    6 ++
 arch/arm64/kernel/mte.c            |   14 ++++
 include/linux/kasan.h              |    2 
 mm/kasan/hw_tags.c                 |   76 ++++++++++++++++++++++++++-
 mm/kasan/kasan.h                   |   10 +++
 8 files changed, 116 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/memory.h~kasan-hw-tags-introduce-kasanstore_only-option
+++ a/arch/arm64/include/asm/memory.h
@@ -308,6 +308,7 @@ static inline const void *__tag_set(cons
 #define arch_enable_tag_checks_sync()		mte_enable_kernel_sync()
 #define arch_enable_tag_checks_async()		mte_enable_kernel_async()
 #define arch_enable_tag_checks_asymm()		mte_enable_kernel_asymm()
+#define arch_enable_tag_checks_store_only()	mte_enable_kernel_store_only()
 #define arch_suppress_tag_checks_start()	mte_enable_tco()
 #define arch_suppress_tag_checks_stop()		mte_disable_tco()
 #define arch_force_async_tag_fault()		mte_check_tfsr_exit()
--- a/arch/arm64/include/asm/mte-kasan.h~kasan-hw-tags-introduce-kasanstore_only-option
+++ a/arch/arm64/include/asm/mte-kasan.h
@@ -200,6 +200,7 @@ static inline void mte_set_mem_tag_range
 void mte_enable_kernel_sync(void);
 void mte_enable_kernel_async(void);
 void mte_enable_kernel_asymm(void);
+int mte_enable_kernel_store_only(void);
 
 #else /* CONFIG_ARM64_MTE */
 
@@ -251,6 +252,11 @@ static inline void mte_enable_kernel_asy
 {
 }
 
+static inline int mte_enable_kenrel_store_only(void)
+{
+	return -EINVAL;
+}
+
 #endif /* CONFIG_ARM64_MTE */
 
 #endif /* __ASSEMBLY__ */
--- a/arch/arm64/kernel/cpufeature.c~kasan-hw-tags-introduce-kasanstore_only-option
+++ a/arch/arm64/kernel/cpufeature.c
@@ -2404,6 +2404,11 @@ static void cpu_enable_mte(struct arm64_
 
 	kasan_init_hw_tags_cpu();
 }
+
+static void cpu_enable_mte_store_only(struct arm64_cpu_capabilities const *cap)
+{
+	kasan_late_init_hw_tags_cpu();
+}
 #endif /* CONFIG_ARM64_MTE */
 
 static void user_feature_fixup(void)
@@ -2922,6 +2927,7 @@ static const struct arm64_cpu_capabiliti
 		.capability = ARM64_MTE_STORE_ONLY,
 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.matches = has_cpuid_feature,
+		.cpu_enable = cpu_enable_mte_store_only,
 		ARM64_CPUID_FIELDS(ID_AA64PFR2_EL1, MTESTOREONLY, IMP)
 	},
 #endif /* CONFIG_ARM64_MTE */
--- a/arch/arm64/kernel/mte.c~kasan-hw-tags-introduce-kasanstore_only-option
+++ a/arch/arm64/kernel/mte.c
@@ -157,6 +157,20 @@ void mte_enable_kernel_asymm(void)
 		mte_enable_kernel_sync();
 	}
 }
+
+int mte_enable_kernel_store_only(void)
+{
+	if (!cpus_have_cap(ARM64_MTE_STORE_ONLY))
+		return -EINVAL;
+
+	sysreg_clear_set(sctlr_el1, SCTLR_EL1_TCSO_MASK,
+			 SYS_FIELD_PREP(SCTLR_EL1, TCSO, 1));
+	isb();
+
+	pr_info_once("MTE: enabled stonly mode at EL1\n");
+
+	return 0;
+}
 #endif
 
 #ifdef CONFIG_KASAN_HW_TAGS
--- a/Documentation/dev-tools/kasan.rst~kasan-hw-tags-introduce-kasanstore_only-option
+++ a/Documentation/dev-tools/kasan.rst
@@ -143,6 +143,9 @@ disabling KASAN altogether or controllin
   Asymmetric mode: a bad access is detected synchronously on reads and
   asynchronously on writes.
 
+- ``kasan.store_only=off`` or ``kasan.store_only=on`` controls whether KASAN
+  checks the store (write) accesses only or all accesses (default: ``off``)
+
 - ``kasan.vmalloc=off`` or ``=on`` disables or enables tagging of vmalloc
   allocations (default: ``on``).
 
--- a/include/linux/kasan.h~kasan-hw-tags-introduce-kasanstore_only-option
+++ a/include/linux/kasan.h
@@ -558,9 +558,11 @@ static inline void kasan_init_sw_tags(vo
 #ifdef CONFIG_KASAN_HW_TAGS
 void kasan_init_hw_tags_cpu(void);
 void __init kasan_init_hw_tags(void);
+void kasan_late_init_hw_tags_cpu(void);
 #else
 static inline void kasan_init_hw_tags_cpu(void) { }
 static inline void kasan_init_hw_tags(void) { }
+static inline void kasan_late_init_hw_tags_cpu(void) { }
 #endif
 
 #ifdef CONFIG_KASAN_VMALLOC
--- a/mm/kasan/hw_tags.c~kasan-hw-tags-introduce-kasanstore_only-option
+++ a/mm/kasan/hw_tags.c
@@ -41,9 +41,16 @@ enum kasan_arg_vmalloc {
 	KASAN_ARG_VMALLOC_ON,
 };
 
+enum kasan_arg_store_only {
+	KASAN_ARG_STORE_ONLY_DEFAULT,
+	KASAN_ARG_STORE_ONLY_OFF,
+	KASAN_ARG_STORE_ONLY_ON,
+};
+
 static enum kasan_arg kasan_arg __ro_after_init;
 static enum kasan_arg_mode kasan_arg_mode __ro_after_init;
 static enum kasan_arg_vmalloc kasan_arg_vmalloc __initdata;
+static enum kasan_arg_store_only kasan_arg_store_only __ro_after_init;
 
 /*
  * Whether the selected mode is synchronous, asynchronous, or asymmetric.
@@ -60,6 +67,9 @@ DEFINE_STATIC_KEY_FALSE(kasan_flag_vmall
 #endif
 EXPORT_SYMBOL_GPL(kasan_flag_vmalloc);
 
+DEFINE_STATIC_KEY_FALSE(kasan_flag_store_only);
+EXPORT_SYMBOL_GPL(kasan_flag_store_only);
+
 #define PAGE_ALLOC_SAMPLE_DEFAULT	1
 #define PAGE_ALLOC_SAMPLE_ORDER_DEFAULT	3
 
@@ -134,6 +144,23 @@ static int __init early_kasan_flag_vmall
 }
 early_param("kasan.vmalloc", early_kasan_flag_vmalloc);
 
+/* kasan.store_only=off/on */
+static int __init early_kasan_flag_store_only(char *arg)
+{
+	if (!arg)
+		return -EINVAL;
+
+	if (!strcmp(arg, "off"))
+		kasan_arg_store_only = KASAN_ARG_STORE_ONLY_OFF;
+	else if (!strcmp(arg, "on"))
+		kasan_arg_store_only = KASAN_ARG_STORE_ONLY_ON;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+early_param("kasan.store_only", early_kasan_flag_store_only);
+
 static inline const char *kasan_mode_info(void)
 {
 	if (kasan_mode == KASAN_MODE_ASYNC)
@@ -212,6 +239,20 @@ void kasan_init_hw_tags_cpu(void)
 	kasan_enable_hw_tags();
 }
 
+/*
+ * kasan_late_init_hw_tags_cpu_post() is called for each CPU after
+ * all cpus are bring-up at boot.
+ * Not marked as __init as a CPU can be hot-plugged after boot.
+ */
+void kasan_late_init_hw_tags_cpu(void)
+{
+	/*
+	 * Enable stonly mode only when explicitly requested through the command line.
+	 * If system doesn't support, kasan checks all operation.
+	 */
+	kasan_enable_store_only();
+}
+
 /* kasan_init_hw_tags() is called once on boot CPU. */
 void __init kasan_init_hw_tags(void)
 {
@@ -250,15 +291,28 @@ void __init kasan_init_hw_tags(void)
 		break;
 	}
 
+	switch (kasan_arg_store_only) {
+	case KASAN_ARG_STORE_ONLY_DEFAULT:
+		/* Default is specified by kasan_flag_store_only definition. */
+		break;
+	case KASAN_ARG_STORE_ONLY_OFF:
+		static_branch_disable(&kasan_flag_store_only);
+		break;
+	case KASAN_ARG_STORE_ONLY_ON:
+		static_branch_enable(&kasan_flag_store_only);
+		break;
+	}
+
 	kasan_init_tags();
 
 	/* KASAN is now initialized, enable it. */
 	kasan_enable();
 
-	pr_info("KernelAddressSanitizer initialized (hw-tags, mode=%s, vmalloc=%s, stacktrace=%s)\n",
+	pr_info("KernelAddressSanitizer initialized (hw-tags, mode=%s, vmalloc=%s, stacktrace=%s store_only=%s\n",
 		kasan_mode_info(),
 		str_on_off(kasan_vmalloc_enabled()),
-		str_on_off(kasan_stack_collection_enabled()));
+		str_on_off(kasan_stack_collection_enabled()),
+		str_on_off(kasan_store_only_enabled()));
 }
 
 #ifdef CONFIG_KASAN_VMALLOC
@@ -387,6 +441,22 @@ void kasan_enable_hw_tags(void)
 		hw_enable_tag_checks_sync();
 }
 
+void kasan_enable_store_only(void)
+{
+	if (kasan_arg_store_only == KASAN_ARG_STORE_ONLY_ON) {
+		if (hw_enable_tag_checks_store_only()) {
+			static_branch_disable(&kasan_flag_store_only);
+			kasan_arg_store_only = KASAN_ARG_STORE_ONLY_OFF;
+			pr_warn_once("KernelAddressSanitizer: store only mode isn't supported (hw-tags)\n");
+		}
+	}
+}
+
+bool kasan_store_only_enabled(void)
+{
+	return static_branch_unlikely(&kasan_flag_store_only);
+}
+
 #if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
 
 EXPORT_SYMBOL_IF_KUNIT(kasan_enable_hw_tags);
@@ -397,4 +467,6 @@ VISIBLE_IF_KUNIT void kasan_force_async_
 }
 EXPORT_SYMBOL_IF_KUNIT(kasan_force_async_fault);
 
+EXPORT_SYMBOL_IF_KUNIT(kasan_store_only_enabled);
+
 #endif
--- a/mm/kasan/kasan.h~kasan-hw-tags-introduce-kasanstore_only-option
+++ a/mm/kasan/kasan.h
@@ -33,6 +33,7 @@ static inline bool kasan_stack_collectio
 #include "../slab.h"
 
 DECLARE_STATIC_KEY_TRUE(kasan_flag_vmalloc);
+DECLARE_STATIC_KEY_FALSE(kasan_flag_stonly);
 
 enum kasan_mode {
 	KASAN_MODE_SYNC,
@@ -434,6 +435,7 @@ static inline const void *arch_kasan_set
 #define hw_enable_tag_checks_sync()		arch_enable_tag_checks_sync()
 #define hw_enable_tag_checks_async()		arch_enable_tag_checks_async()
 #define hw_enable_tag_checks_asymm()		arch_enable_tag_checks_asymm()
+#define hw_enable_tag_checks_store_only()	arch_enable_tag_checks_store_only()
 #define hw_suppress_tag_checks_start()		arch_suppress_tag_checks_start()
 #define hw_suppress_tag_checks_stop()		arch_suppress_tag_checks_stop()
 #define hw_force_async_tag_fault()		arch_force_async_tag_fault()
@@ -443,10 +445,18 @@ static inline const void *arch_kasan_set
 			arch_set_mem_tag_range((addr), (size), (tag), (init))
 
 void kasan_enable_hw_tags(void);
+void kasan_enable_store_only(void);
+bool kasan_store_only_enabled(void);
 
 #else /* CONFIG_KASAN_HW_TAGS */
 
 static inline void kasan_enable_hw_tags(void) { }
+static inline void kasan_enable_store_only(void) { }
+
+static inline bool kasan_store_only_enabled(void)
+{
+	return false;
+}
 
 #endif /* CONFIG_KASAN_HW_TAGS */
 
_

Patches currently in -mm which might be from yeoreum.yun@arm.com are

kunit-kasan_test-disable-fortify-string-checker-on-kasan_strings-test.patch
kasan-hw-tags-introduce-kasanstore_only-option.patch
kasan-apply-store-only-mode-in-kasan-kunit-testcases.patch

