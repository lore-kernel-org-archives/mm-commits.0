Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CF32185AC
	for <mm-commits@vger.kernel.org>; Thu, 26 Jun 2025 22:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750976562; cv=none; b=oqO6ZOmC3s1e5lD7E27z1jhrMk04uek/ajukZqeAk+e2N93sOAypUT7RDbdnkjwG9hS/YThK/siXvTbUqSiBM2EHJZ/Dl3NTjSfSJ/shoPzdAJdMyGm+/l1mSbHlaI1ww7/DZ39gwuMgNBzx24oQLXd5cO/dyutKC2MueTKvNF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750976562; c=relaxed/simple;
	bh=d7Vt37gDFxNhVcQQmPRZ6KssVTXWgeTAGkoSp9lfiZU=;
	h=Date:To:From:Subject:Message-Id; b=GXi3C4GGivbQ2IVLJ5AP5P7b3RQsK0Rgd00oulzTsEpkg6zhmkao9EE0dyiEPS4NYOcg33spdEW1D33euGmuoQEja2mdrzWRZg54Xcw20J61EsTDuMqkF7XZ9z+7UxzhdFkE18bh2VwMoNDIhID0uiEp+9jd25J8TrbcHSJOJoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gMgvwpKK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gMgvwpKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BACA0C4CEEB;
	Thu, 26 Jun 2025 22:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750976561;
	bh=d7Vt37gDFxNhVcQQmPRZ6KssVTXWgeTAGkoSp9lfiZU=;
	h=Date:To:From:Subject:From;
	b=gMgvwpKKxrsTiovEMzXOznWSt88+rbR9ySQJt8gXjhpcLzLuFmwIeQnQu42n17gkd
	 By8/LcLHMz1CfieKkkp8o+5cbfKyk7KmLIDj+5PNX0LdWFH27U3q7OSPIXFN9zQASp
	 xBFIef7rq8qjMK3zaIxrqfZMLU6/m7+sLMr3XLTI=
Date: Thu, 26 Jun 2025 15:22:41 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-loongarch-call-kasan_init_generic-in-kasan_init.patch added to mm-new branch
Message-Id: <20250626222241.BACA0C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan/loongarch: call kasan_init_generic in kasan_init
has been added to the -mm mm-new branch.  Its filename is
     kasan-loongarch-call-kasan_init_generic-in-kasan_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-loongarch-call-kasan_init_generic-in-kasan_init.patch

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
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Subject: kasan/loongarch: call kasan_init_generic in kasan_init
Date: Thu, 26 Jun 2025 20:31:41 +0500

Call kasan_init_generic() which enables the static flag to mark generic
KASAN initialized, otherwise it's an inline stub.

Replace `kasan_arch_is_ready` with `kasan_enabled`.  Delete the flag
`kasan_early_stage` in favor of the global static key enabled via
kasan_enabled().

printk banner is printed earlier right where `kasan_early_stage` was
flipped, just to keep the same flow.

Note that `init_task.kasan_depth = 0;` is called after
`kasan_init_generic()`, which is different than in other arch
`kasan_init()`.  I've left this unchanged as I can't test it.  Defer to
loongarch maintainers.

Link: https://lkml.kernel.org/r/20250626153147.145312-6-snovitoll@gmail.com
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218315
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/include/asm/kasan.h |    7 -------
 arch/loongarch/mm/kasan_init.c     |    7 ++-----
 2 files changed, 2 insertions(+), 12 deletions(-)

--- a/arch/loongarch/include/asm/kasan.h~kasan-loongarch-call-kasan_init_generic-in-kasan_init
+++ a/arch/loongarch/include/asm/kasan.h
@@ -66,7 +66,6 @@
 #define XKPRANGE_WC_SHADOW_OFFSET	(KASAN_SHADOW_START + XKPRANGE_WC_KASAN_OFFSET)
 #define XKVRANGE_VC_SHADOW_OFFSET	(KASAN_SHADOW_START + XKVRANGE_VC_KASAN_OFFSET)
 
-extern bool kasan_early_stage;
 extern unsigned char kasan_early_shadow_page[PAGE_SIZE];
 
 #define kasan_mem_to_shadow kasan_mem_to_shadow
@@ -75,12 +74,6 @@ void *kasan_mem_to_shadow(const void *ad
 #define kasan_shadow_to_mem kasan_shadow_to_mem
 const void *kasan_shadow_to_mem(const void *shadow_addr);
 
-#define kasan_arch_is_ready kasan_arch_is_ready
-static __always_inline bool kasan_arch_is_ready(void)
-{
-	return !kasan_early_stage;
-}
-
 #define addr_has_metadata addr_has_metadata
 static __always_inline bool addr_has_metadata(const void *addr)
 {
--- a/arch/loongarch/mm/kasan_init.c~kasan-loongarch-call-kasan_init_generic-in-kasan_init
+++ a/arch/loongarch/mm/kasan_init.c
@@ -40,11 +40,9 @@ static pgd_t kasan_pg_dir[PTRS_PER_PGD]
 #define __pte_none(early, pte) (early ? pte_none(pte) : \
 ((pte_val(pte) & _PFN_MASK) == (unsigned long)__pa(kasan_early_shadow_page)))
 
-bool kasan_early_stage = true;
-
 void *kasan_mem_to_shadow(const void *addr)
 {
-	if (!kasan_arch_is_ready()) {
+	if (!kasan_enabled()) {
 		return (void *)(kasan_early_shadow_page);
 	} else {
 		unsigned long maddr = (unsigned long)addr;
@@ -298,7 +296,7 @@ void __init kasan_init(void)
 	kasan_populate_early_shadow(kasan_mem_to_shadow((void *)VMALLOC_START),
 					kasan_mem_to_shadow((void *)KFENCE_AREA_END));
 
-	kasan_early_stage = false;
+	kasan_init_generic();
 
 	/* Populate the linear mapping */
 	for_each_mem_range(i, &pa_start, &pa_end) {
@@ -329,5 +327,4 @@ void __init kasan_init(void)
 
 	/* At this point kasan is fully initialized. Enable error messages */
 	init_task.kasan_depth = 0;
-	pr_info("KernelAddressSanitizer initialized.\n");
 }
_

Patches currently in -mm which might be from snovitoll@gmail.com are

mm-unexport-globally-copy_to_kernel_nofault.patch
mm-unexport-globally-copy_to_kernel_nofault-v2.patch
kasan-unify-static-kasan_flag_enabled-across-modes.patch
kasan-arm64-call-kasan_init_generic-in-kasan_init.patch
kasan-arm-call-kasan_init_generic-in-kasan_init.patch
kasan-xtensa-call-kasan_init_generic-in-kasan_init.patch
kasan-loongarch-call-kasan_init_generic-in-kasan_init.patch
kasan-um-call-kasan_init_generic-in-kasan_init.patch
kasan-x86-call-kasan_init_generic-in-kasan_init.patch
kasan-s390-call-kasan_init_generic-in-kasan_init.patch
kasan-powerpc-call-kasan_init_generic-in-kasan_init.patch
kasan-riscv-call-kasan_init_generic-in-kasan_init.patch
kasan-replace-kasan_arch_is_ready-with-kasan_enabled.patch

