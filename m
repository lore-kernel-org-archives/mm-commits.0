Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE1E256C87
	for <mm-commits@vger.kernel.org>; Thu,  7 Aug 2025 22:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754605785; cv=none; b=lKrJ6PVD9C3g54xdZApYsEYKMf4XQtlnLMjwjS8Mk0Gll7BDswIU8ZomyV3i5ngHcRaSWOO//ARiVZ0t5wu976izc0Y45gTxAfR0xUy2yBseeGGaniwD/ZnMba7VD7qInkKXc5WwA5ULcIRRvK2qku7i79jhKk++9hLzpWMNWb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754605785; c=relaxed/simple;
	bh=ccYmsownLrLv+aECtmsZmVSLimlhRGjV4ObVS2sEQy8=;
	h=Date:To:From:Subject:Message-Id; b=P5X9KmUx0dGzVPGwMDK7RtyKwiOvfWJCuU5nwPtnVYvzcvz87oLHbcYK/F6mONp9YT/cGrRpeg59B+locX2gww6MGW1QSKM5KtwSjdmtoIH3cKAbQSRtXnlckHjUWBi20IwsDSSYttu4FYL7+278bjqnEcrpPkNhyIN2J9z/7ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hji1Vo+I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hji1Vo+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E0AC4CEEB;
	Thu,  7 Aug 2025 22:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754605785;
	bh=ccYmsownLrLv+aECtmsZmVSLimlhRGjV4ObVS2sEQy8=;
	h=Date:To:From:Subject:From;
	b=Hji1Vo+I0IzKQdCwGDaf0WgiG4V9Ney6l1VaIlUo8g0Ohpu+qSJqr4932pTYyqBUg
	 f9hMXYid3zKV82Pl8MlAs2PC3woLJmd/fcanwwDNnE9Y+7Q1xzFrknrAIppOk/lYYc
	 N7QI3G8STiIRijAyCEymWV227LhpLiSgPtD2SnVk=
Date: Thu, 07 Aug 2025 15:29:44 -0700
To: mm-commits@vger.kernel.org,zhangqing@loongson.cn,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,hca@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,christophe.leroy@csgroup.eu,chenhuacai@loongson.cn,bhe@redhat.com,andreyknvl@gmail.com,alexghiti@rivosinc.com,alex@ghiti.fr,agordeev@linux.ibm.com,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-call-kasan_init_generic-in-kasan_init.patch added to mm-new branch
Message-Id: <20250807222945.61E0AC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: call kasan_init_generic in kasan_init
has been added to the -mm mm-new branch.  Its filename is
     kasan-call-kasan_init_generic-in-kasan_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-call-kasan_init_generic-in-kasan_init.patch

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
Subject: kasan: call kasan_init_generic in kasan_init
Date: Fri, 8 Aug 2025 00:40:12 +0500

Call kasan_init_generic() which handles Generic KASAN initialization.  For
architectures that do not select ARCH_DEFER_KASAN, this will be a no-op
for the runtime flag but will print the initialization banner.

For SW_TAGS and HW_TAGS modes, their respective init functions will handle
the flag enabling, if they are enabled/implemented.

Link: https://lkml.kernel.org/r/20250807194012.631367-3-snovitoll@gmail.com
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217049
Tested-by: Alexandre Ghiti <alexghiti@rivosinc.com> # riscv
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com> # s390
Cc: Alexander Potapenko <glider@google.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@loongson.cn>
Cc: Marco Elver <elver@google.com>
Cc: Qing Zhang <zhangqing@loongson.cn>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/kasan_init.c    |    2 +-
 arch/arm64/mm/kasan_init.c  |    4 +---
 arch/riscv/mm/kasan_init.c  |    1 +
 arch/s390/kernel/early.c    |    3 ++-
 arch/x86/mm/kasan_init_64.c |    2 +-
 arch/xtensa/mm/kasan_init.c |    2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

--- a/arch/arm64/mm/kasan_init.c~kasan-call-kasan_init_generic-in-kasan_init
+++ a/arch/arm64/mm/kasan_init.c
@@ -399,14 +399,12 @@ void __init kasan_init(void)
 {
 	kasan_init_shadow();
 	kasan_init_depth();
-#if defined(CONFIG_KASAN_GENERIC)
+	kasan_init_generic();
 	/*
 	 * Generic KASAN is now fully initialized.
 	 * Software and Hardware Tag-Based modes still require
 	 * kasan_init_sw_tags() and kasan_init_hw_tags() correspondingly.
 	 */
-	pr_info("KernelAddressSanitizer initialized (generic)\n");
-#endif
 }
 
 #endif /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
--- a/arch/arm/mm/kasan_init.c~kasan-call-kasan_init_generic-in-kasan_init
+++ a/arch/arm/mm/kasan_init.c
@@ -300,6 +300,6 @@ void __init kasan_init(void)
 	local_flush_tlb_all();
 
 	memset(kasan_early_shadow_page, 0, PAGE_SIZE);
-	pr_info("Kernel address sanitizer initialized\n");
 	init_task.kasan_depth = 0;
+	kasan_init_generic();
 }
--- a/arch/riscv/mm/kasan_init.c~kasan-call-kasan_init_generic-in-kasan_init
+++ a/arch/riscv/mm/kasan_init.c
@@ -530,6 +530,7 @@ void __init kasan_init(void)
 
 	memset(kasan_early_shadow_page, KASAN_SHADOW_INIT, PAGE_SIZE);
 	init_task.kasan_depth = 0;
+	kasan_init_generic();
 
 	csr_write(CSR_SATP, PFN_DOWN(__pa(swapper_pg_dir)) | satp_mode);
 	local_flush_tlb_all();
--- a/arch/s390/kernel/early.c~kasan-call-kasan_init_generic-in-kasan_init
+++ a/arch/s390/kernel/early.c
@@ -21,6 +21,7 @@
 #include <linux/kernel.h>
 #include <asm/asm-extable.h>
 #include <linux/memblock.h>
+#include <linux/kasan.h>
 #include <asm/access-regs.h>
 #include <asm/asm-offsets.h>
 #include <asm/machine.h>
@@ -65,7 +66,7 @@ static void __init kasan_early_init(void
 {
 #ifdef CONFIG_KASAN
 	init_task.kasan_depth = 0;
-	pr_info("KernelAddressSanitizer initialized\n");
+	kasan_init_generic();
 #endif
 }
 
--- a/arch/x86/mm/kasan_init_64.c~kasan-call-kasan_init_generic-in-kasan_init
+++ a/arch/x86/mm/kasan_init_64.c
@@ -451,5 +451,5 @@ void __init kasan_init(void)
 	__flush_tlb_all();
 
 	init_task.kasan_depth = 0;
-	pr_info("KernelAddressSanitizer initialized\n");
+	kasan_init_generic();
 }
--- a/arch/xtensa/mm/kasan_init.c~kasan-call-kasan_init_generic-in-kasan_init
+++ a/arch/xtensa/mm/kasan_init.c
@@ -94,5 +94,5 @@ void __init kasan_init(void)
 
 	/* At this point kasan is fully initialized. Enable error messages. */
 	current->kasan_depth = 0;
-	pr_info("KernelAddressSanitizer initialized\n");
+	kasan_init_generic();
 }
_

Patches currently in -mm which might be from snovitoll@gmail.com are

kasan-introduce-arch_defer_kasan-and-unify-static-key-across-modes.patch
kasan-call-kasan_init_generic-in-kasan_init.patch

