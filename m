Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7644B19F420
	for <mm-commits@vger.kernel.org>; Wed,  6 Aug 2025 02:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754447558; cv=none; b=BafKOMhLcpf8vmrSoJAqNi61BOUJOFCJdkd1E2xORWj0oB1JfwdkWemSPsWDMo1PICRMD4QNC5cTnh52PHhfcLiEbEjiUyUbcrcGNdmzNO4GNr9Y3FPL+xUTOIZRF39rYGBRrlL5GyYWoF5mvwq3YJghj5KhVLU/2hbxEc6hH94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754447558; c=relaxed/simple;
	bh=6JDh8LqtcNrTwmUv3600xvzWpudtLyOTmcTuSdqZug8=;
	h=Date:To:From:Subject:Message-Id; b=t/X2K1hImSpZwwSPCcGp7qNTGdO2vNFqXZStXUyc2GWr0FSa3XvuAFSyOS+i0/7zd4yE3r4jMCPstOT43L9TBMSEWYmnLfV8Z0JPsF9RWQb88Rg31IOgEbxC9EWTV8Pe4fZWQ2FpeKYQgOqcHjORqawJBmKNsGuRfoQaYMh86j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eP4Wjp+d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eP4Wjp+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0677BC4CEF0;
	Wed,  6 Aug 2025 02:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754447558;
	bh=6JDh8LqtcNrTwmUv3600xvzWpudtLyOTmcTuSdqZug8=;
	h=Date:To:From:Subject:From;
	b=eP4Wjp+dgEMDkqleJ5tYQOEFV+vNEiVr7Q+kXZcblfRAnw4FSpjaBzjClUCtQsWOg
	 HfYv58V79+2/hyXz/3zilQ9nqZaFR0GHxV09FT2mCaKzUWGtXv5i+KP8gKEemCvZn5
	 XgtR1Yod212sfSiBNTLRHrxQqN+2y+z8++Ngm1GM=
Date: Tue, 05 Aug 2025 19:32:37 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kasan-dont-initialize-kasan-if-its-disabled.patch added to mm-new branch
Message-Id: <20250806023238.0677BC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kasan: don't initialize kasan if it's disabled
has been added to the -mm mm-new branch.  Its filename is
     mm-kasan-dont-initialize-kasan-if-its-disabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kasan-dont-initialize-kasan-if-its-disabled.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: mm/kasan: don't initialize kasan if it's disabled
Date: Tue, 5 Aug 2025 14:23:32 +0800

This is mainly done in all architectures which support kasan, and also
need be done in sw_tags init funciton kasan_init_sw_tags().

And also add code to enable kasan_flag_enabled, this is for later usage.

Link: https://lkml.kernel.org/r/20250805062333.121553-4-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/kasan_init.c               |    6 ++++++
 arch/arm64/mm/kasan_init.c             |    7 +++++++
 arch/loongarch/mm/kasan_init.c         |    5 +++++
 arch/powerpc/mm/kasan/init_32.c        |    8 +++++++-
 arch/powerpc/mm/kasan/init_book3e_64.c |    6 ++++++
 arch/powerpc/mm/kasan/init_book3s_64.c |    6 ++++++
 arch/riscv/mm/kasan_init.c             |    6 ++++++
 arch/um/kernel/mem.c                   |    6 ++++++
 arch/x86/mm/kasan_init_64.c            |    6 ++++++
 arch/xtensa/mm/kasan_init.c            |    6 ++++++
 mm/kasan/sw_tags.c                     |    6 ++++++
 11 files changed, 67 insertions(+), 1 deletion(-)

--- a/arch/arm64/mm/kasan_init.c~mm-kasan-dont-initialize-kasan-if-its-disabled
+++ a/arch/arm64/mm/kasan_init.c
@@ -384,6 +384,9 @@ void __init kasan_populate_early_vm_area
 {
 	unsigned long shadow_start, shadow_end;
 
+	if (!kasan_enabled())
+		return;
+
 	if (!is_vmalloc_or_module_addr(start))
 		return;
 
@@ -397,6 +400,9 @@ void __init kasan_populate_early_vm_area
 
 void __init kasan_init(void)
 {
+	if (kasan_arg_disabled)
+		return;
+
 	kasan_init_shadow();
 	kasan_init_depth();
 #if defined(CONFIG_KASAN_GENERIC)
@@ -405,6 +411,7 @@ void __init kasan_init(void)
 	 * Software and Hardware Tag-Based modes still require
 	 * kasan_init_sw_tags() and kasan_init_hw_tags() correspondingly.
 	 */
+	static_branch_enable(&kasan_flag_enabled);
 	pr_info("KernelAddressSanitizer initialized (generic)\n");
 #endif
 }
--- a/arch/arm/mm/kasan_init.c~mm-kasan-dont-initialize-kasan-if-its-disabled
+++ a/arch/arm/mm/kasan_init.c
@@ -212,6 +212,8 @@ void __init kasan_init(void)
 	phys_addr_t pa_start, pa_end;
 	u64 i;
 
+	if (kasan_arg_disabled)
+		return;
 	/*
 	 * We are going to perform proper setup of shadow memory.
 	 *
@@ -300,6 +302,10 @@ void __init kasan_init(void)
 	local_flush_tlb_all();
 
 	memset(kasan_early_shadow_page, 0, PAGE_SIZE);
+
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	pr_info("Kernel address sanitizer initialized\n");
 	init_task.kasan_depth = 0;
 }
--- a/arch/loongarch/mm/kasan_init.c~mm-kasan-dont-initialize-kasan-if-its-disabled
+++ a/arch/loongarch/mm/kasan_init.c
@@ -267,6 +267,8 @@ void __init kasan_init(void)
 	u64 i;
 	phys_addr_t pa_start, pa_end;
 
+	if (kasan_arg_disabled)
+		return;
 	/*
 	 * If PGDIR_SIZE is too large for cpu_vabits, KASAN_SHADOW_END will
 	 * overflow UINTPTR_MAX and then looks like a user space address.
@@ -327,6 +329,9 @@ void __init kasan_init(void)
 	csr_write64(__pa_symbol(swapper_pg_dir), LOONGARCH_CSR_PGDH);
 	local_flush_tlb_all();
 
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	/* At this point kasan is fully initialized. Enable error messages */
 	init_task.kasan_depth = 0;
 	pr_info("KernelAddressSanitizer initialized.\n");
--- a/arch/powerpc/mm/kasan/init_32.c~mm-kasan-dont-initialize-kasan-if-its-disabled
+++ a/arch/powerpc/mm/kasan/init_32.c
@@ -141,6 +141,9 @@ void __init kasan_init(void)
 	u64 i;
 	int ret;
 
+	if (kasan_arg_disabled)
+		return;
+
 	for_each_mem_range(i, &base, &end) {
 		phys_addr_t top = min(end, total_lowmem);
 
@@ -163,6 +166,9 @@ void __init kasan_init(void)
 
 	clear_page(kasan_early_shadow_page);
 
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	/* At this point kasan is fully initialized. Enable error messages */
 	init_task.kasan_depth = 0;
 	pr_info("KASAN init done\n");
@@ -170,7 +176,7 @@ void __init kasan_init(void)
 
 void __init kasan_late_init(void)
 {
-	if (IS_ENABLED(CONFIG_KASAN_VMALLOC))
+	if (IS_ENABLED(CONFIG_KASAN_VMALLOC) && kasan_enabled())
 		kasan_unmap_early_shadow_vmalloc();
 }
 
--- a/arch/powerpc/mm/kasan/init_book3e_64.c~mm-kasan-dont-initialize-kasan-if-its-disabled
+++ a/arch/powerpc/mm/kasan/init_book3e_64.c
@@ -111,6 +111,9 @@ void __init kasan_init(void)
 	u64 i;
 	pte_t zero_pte = pfn_pte(virt_to_pfn(kasan_early_shadow_page), PAGE_KERNEL_RO);
 
+	if (kasan_arg_disabled)
+		return;
+
 	for_each_mem_range(i, &start, &end)
 		kasan_init_phys_region(phys_to_virt(start), phys_to_virt(end));
 
@@ -125,6 +128,9 @@ void __init kasan_init(void)
 
 	memset(kasan_early_shadow_page, 0, PAGE_SIZE);
 
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	/* Enable error messages */
 	init_task.kasan_depth = 0;
 	pr_info("KASAN init done\n");
--- a/arch/powerpc/mm/kasan/init_book3s_64.c~mm-kasan-dont-initialize-kasan-if-its-disabled
+++ a/arch/powerpc/mm/kasan/init_book3s_64.c
@@ -56,6 +56,9 @@ void __init kasan_init(void)
 	u64 i;
 	pte_t zero_pte = pfn_pte(virt_to_pfn(kasan_early_shadow_page), PAGE_KERNEL);
 
+	if (kasan_arg_disabled)
+		return;
+
 	if (!early_radix_enabled()) {
 		pr_warn("KASAN not enabled as it requires radix!");
 		return;
@@ -94,6 +97,9 @@ void __init kasan_init(void)
 
 	static_branch_inc(&powerpc_kasan_enabled_key);
 
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	/* Enable error messages */
 	init_task.kasan_depth = 0;
 	pr_info("KASAN init done\n");
--- a/arch/riscv/mm/kasan_init.c~mm-kasan-dont-initialize-kasan-if-its-disabled
+++ a/arch/riscv/mm/kasan_init.c
@@ -485,6 +485,9 @@ void __init kasan_init(void)
 	phys_addr_t p_start, p_end;
 	u64 i;
 
+	if (kasan_arg_disabled)
+		return;
+
 	create_tmp_mapping();
 	csr_write(CSR_SATP, PFN_DOWN(__pa(tmp_pg_dir)) | satp_mode);
 
@@ -531,6 +534,9 @@ void __init kasan_init(void)
 	memset(kasan_early_shadow_page, KASAN_SHADOW_INIT, PAGE_SIZE);
 	init_task.kasan_depth = 0;
 
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	csr_write(CSR_SATP, PFN_DOWN(__pa(swapper_pg_dir)) | satp_mode);
 	local_flush_tlb_all();
 }
--- a/arch/um/kernel/mem.c~mm-kasan-dont-initialize-kasan-if-its-disabled
+++ a/arch/um/kernel/mem.c
@@ -26,6 +26,9 @@
 int kasan_um_is_ready;
 void kasan_init(void)
 {
+
+	if (kasan_arg_disabled)
+		return;
 	/*
 	 * kasan_map_memory will map all of the required address space and
 	 * the host machine will allocate physical memory as necessary.
@@ -33,6 +36,9 @@ void kasan_init(void)
 	kasan_map_memory((void *)KASAN_SHADOW_START, KASAN_SHADOW_SIZE);
 	init_task.kasan_depth = 0;
 	kasan_um_is_ready = true;
+
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
 }
 
 static void (*kasan_init_ptr)(void)
--- a/arch/x86/mm/kasan_init_64.c~mm-kasan-dont-initialize-kasan-if-its-disabled
+++ a/arch/x86/mm/kasan_init_64.c
@@ -343,6 +343,9 @@ void __init kasan_init(void)
 	unsigned long shadow_cea_begin, shadow_cea_per_cpu_begin, shadow_cea_end;
 	int i;
 
+	if (kasan_arg_disabled)
+		return;
+
 	memcpy(early_top_pgt, init_top_pgt, sizeof(early_top_pgt));
 
 	/*
@@ -450,6 +453,9 @@ void __init kasan_init(void)
 	/* Flush TLBs again to be sure that write protection applied. */
 	__flush_tlb_all();
 
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	init_task.kasan_depth = 0;
 	pr_info("KernelAddressSanitizer initialized\n");
 }
--- a/arch/xtensa/mm/kasan_init.c~mm-kasan-dont-initialize-kasan-if-its-disabled
+++ a/arch/xtensa/mm/kasan_init.c
@@ -70,6 +70,9 @@ void __init kasan_init(void)
 {
 	int i;
 
+	if (kasan_arg_disabled)
+		return;
+
 	BUILD_BUG_ON(KASAN_SHADOW_OFFSET != KASAN_SHADOW_START -
 		     (KASAN_START_VADDR >> KASAN_SHADOW_SCALE_SHIFT));
 	BUILD_BUG_ON(VMALLOC_START < KASAN_START_VADDR);
@@ -92,6 +95,9 @@ void __init kasan_init(void)
 	local_flush_tlb_all();
 	memset(kasan_early_shadow_page, 0, PAGE_SIZE);
 
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	/* At this point kasan is fully initialized. Enable error messages. */
 	current->kasan_depth = 0;
 	pr_info("KernelAddressSanitizer initialized\n");
--- a/mm/kasan/sw_tags.c~mm-kasan-dont-initialize-kasan-if-its-disabled
+++ a/mm/kasan/sw_tags.c
@@ -40,11 +40,17 @@ void __init kasan_init_sw_tags(void)
 {
 	int cpu;
 
+	if (kasan_arg_disabled)
+		return;
+
 	for_each_possible_cpu(cpu)
 		per_cpu(prng_state, cpu) = (u32)get_cycles();
 
 	kasan_init_tags();
 
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	pr_info("KernelAddressSanitizer initialized (sw-tags, stacktrace=%s)\n",
 		str_on_off(kasan_stack_collection_enabled()));
 }
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-kasan-add-conditional-checks-in-functions-to-return-directly-if-kasan-is-disabled.patch
mm-kasan-move-kasan=-code-to-common-place.patch
mm-kasan-dont-initialize-kasan-if-its-disabled.patch
mm-kasan-make-kasan=onoff-take-effect-for-all-three-modes.patch

