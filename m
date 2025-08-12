Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F622DCF50
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 02:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754964140; cv=none; b=Rno8p+HUeGynfJwmTlcWCR2Uo97B9Lj/pS4/WqX4HwIDetkrINQJNSWNEJuPT64znYylhr4cgYno7tfA1TwWAUqVOxALukIDJAPW7MnBMgNJjg6iVmgwJKoEsaDVbchQdwtN7Rr8nTsIxaM/poh37kBuzf3ZZ8wND4FnJMtVIJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754964140; c=relaxed/simple;
	bh=m87fIxxTKKzj+7MKmSCHIVkMWNTrYeNn4cVSUPpafDk=;
	h=Date:To:From:Subject:Message-Id; b=HRLMvtEXWydicBXGfc1frcZOVq/QubtGwNHfBoMrJ18p7xXSSpopShi0ia0whYiTTmIZ+YW+5V09913epXO0R6oSIpcpxlGzQPNsV8uLoaq2FeidzB9Ghs6T2wTyupw6h0S4q39C3yRdnLaugCNRDlavT3PHDW1JqcbFJS8VUXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=elfCbvWt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="elfCbvWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DCEAC4CEF6;
	Tue, 12 Aug 2025 02:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754964137;
	bh=m87fIxxTKKzj+7MKmSCHIVkMWNTrYeNn4cVSUPpafDk=;
	h=Date:To:From:Subject:From;
	b=elfCbvWt9tE22xzh69GZif7YPQKCXjEu12sv0wEnprxML39b2cXTutSbtkNcc3Uyb
	 hBN9NhLwpcrrHGbzoF/15AlnznyIMBR/GLpUaptPkOe2uQV+QMCuvYuk4UntSMmF2E
	 lkzKjpsdHmt9/Aqmk/53RAzow66JSVLLYS+JX8GA=
Date: Mon, 11 Aug 2025 19:02:16 -0700
To: mm-commits@vger.kernel.org,zhangqing@loongson.cn,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,hca@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,davidgow@google.com,christophe.leroy@csgroup.eu,chenhuacai@loongson.cn,bhe@redhat.com,andreyknvl@gmail.com,alexghiti@rivosinc.com,alex@ghiti.fr,agordeev@linux.ibm.com,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-call-kasan_init_generic-in-kasan_init.patch added to mm-unstable branch
Message-Id: <20250812020217.4DCEAC4CEF6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: call kasan_init_generic in kasan_init
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-call-kasan_init_generic-in-kasan_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-call-kasan_init_generic-in-kasan_init.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Date: Sun, 10 Aug 2025 17:57:46 +0500

Call kasan_init_generic() which handles Generic KASAN initialization.  For
architectures that do not select ARCH_DEFER_KASAN, this will be a no-op
for the runtime flag but will print the initialization banner.

For SW_TAGS and HW_TAGS modes, their respective init functions will handle
the flag enabling, if they are enabled/implemented.

Link: https://lkml.kernel.org/r/20250810125746.1105476-3-snovitoll@gmail.com
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217049
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Tested-by: Alexandre Ghiti <alexghiti@rivosinc.com>	[riscv]
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>	[s390]
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Alexander Potapenko <glider@google.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: David Gow <davidgow@google.com>
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
@@ -533,4 +533,5 @@ void __init kasan_init(void)
 
 	csr_write(CSR_SATP, PFN_DOWN(__pa(swapper_pg_dir)) | satp_mode);
 	local_flush_tlb_all();
+	kasan_init_generic();
 }
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

