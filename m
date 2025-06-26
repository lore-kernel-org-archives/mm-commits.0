Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F1E1DE3DC
	for <mm-commits@vger.kernel.org>; Thu, 26 Jun 2025 22:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750976567; cv=none; b=IYp7mtxgD/KlnHl8WbQsXDnAZf6mqroHpQGFaUkvHbjI/UDBWDyFE/sP3aZ6NrLUawZmAmsDZ+qZ24m5Ocozx6Gggxj6SdjFeLpyAE6pHRsGFMjOJXYLS5Ah5as5OW9rstRmUTVMTG9mzltsrcjQedc9kQWLwsDbRbTHA+sjpXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750976567; c=relaxed/simple;
	bh=YUMqihef0jBaYv3aoL3K/yU0WyRJF2sTAfnW1k2Kj/A=;
	h=Date:To:From:Subject:Message-Id; b=kTPU26OOH3/BIz4YIAxStLfZSWyH7PIAPO+zZGMqCfH50pw2tIvhU+AGc6fE+YhCpSUQQIpsgN1hg2gpYYZ2IMQlUF8avZMJMaIo1DPNA6ZItyl27BlJ4sxu5GSRbhRiXrZGEVZxrvkDDKEUNAEGOnw+3KZtmgnA/Da0+CGC54k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2dLLKN+N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2dLLKN+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A30C4CEEB;
	Thu, 26 Jun 2025 22:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750976566;
	bh=YUMqihef0jBaYv3aoL3K/yU0WyRJF2sTAfnW1k2Kj/A=;
	h=Date:To:From:Subject:From;
	b=2dLLKN+Nt1MQWmzDbr7kZhn2z7B2H1ujSIhO6AyLiRmyD0IHaumBZDBd5EPB1HiL6
	 Jdv2QL8JVWT8aW2GKP8aiDnTNPvon2lF3/Lta50WjJWHMD2MKdEC9/7Mo4d5t6tU1K
	 4YaaFC/t+Y9YbQrzuMFqoGsIkV+pQ9bjYyAwwpvk=
Date: Thu, 26 Jun 2025 15:22:46 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-powerpc-call-kasan_init_generic-in-kasan_init.patch added to mm-new branch
Message-Id: <20250626222246.B6A30C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan/powerpc: call kasan_init_generic in kasan_init
has been added to the -mm mm-new branch.  Its filename is
     kasan-powerpc-call-kasan_init_generic-in-kasan_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-powerpc-call-kasan_init_generic-in-kasan_init.patch

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
Subject: kasan/powerpc: call kasan_init_generic in kasan_init
Date: Thu, 26 Jun 2025 20:31:45 +0500

Call kasan_init_generic() which enables the static flag to mark generic
KASAN initialized, otherwise it's an inline stub.  Also prints the banner
from the single place.

Link: https://lkml.kernel.org/r/20250626153147.145312-10-snovitoll@gmail.com
Fixes: 55d77bae7342 ("kasan: fix Oops due to missing calls to kasan_arch_is_ready()")
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218315
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/kasan.h       |   13 -------------
 arch/powerpc/mm/kasan/init_32.c        |    2 +-
 arch/powerpc/mm/kasan/init_book3e_64.c |    2 +-
 arch/powerpc/mm/kasan/init_book3s_64.c |    6 +-----
 4 files changed, 3 insertions(+), 20 deletions(-)

--- a/arch/powerpc/include/asm/kasan.h~kasan-powerpc-call-kasan_init_generic-in-kasan_init
+++ a/arch/powerpc/include/asm/kasan.h
@@ -53,19 +53,6 @@
 #endif
 
 #ifdef CONFIG_KASAN
-#ifdef CONFIG_PPC_BOOK3S_64
-DECLARE_STATIC_KEY_FALSE(powerpc_kasan_enabled_key);
-
-static __always_inline bool kasan_arch_is_ready(void)
-{
-	if (static_branch_likely(&powerpc_kasan_enabled_key))
-		return true;
-	return false;
-}
-
-#define kasan_arch_is_ready kasan_arch_is_ready
-#endif
-
 void kasan_early_init(void);
 void kasan_mmu_init(void);
 void kasan_init(void);
--- a/arch/powerpc/mm/kasan/init_32.c~kasan-powerpc-call-kasan_init_generic-in-kasan_init
+++ a/arch/powerpc/mm/kasan/init_32.c
@@ -165,7 +165,7 @@ void __init kasan_init(void)
 
 	/* At this point kasan is fully initialized. Enable error messages */
 	init_task.kasan_depth = 0;
-	pr_info("KASAN init done\n");
+	kasan_init_generic();
 }
 
 void __init kasan_late_init(void)
--- a/arch/powerpc/mm/kasan/init_book3e_64.c~kasan-powerpc-call-kasan_init_generic-in-kasan_init
+++ a/arch/powerpc/mm/kasan/init_book3e_64.c
@@ -127,7 +127,7 @@ void __init kasan_init(void)
 
 	/* Enable error messages */
 	init_task.kasan_depth = 0;
-	pr_info("KASAN init done\n");
+	kasan_init_generic();
 }
 
 void __init kasan_late_init(void) { }
--- a/arch/powerpc/mm/kasan/init_book3s_64.c~kasan-powerpc-call-kasan_init_generic-in-kasan_init
+++ a/arch/powerpc/mm/kasan/init_book3s_64.c
@@ -19,8 +19,6 @@
 #include <linux/memblock.h>
 #include <asm/pgalloc.h>
 
-DEFINE_STATIC_KEY_FALSE(powerpc_kasan_enabled_key);
-
 static void __init kasan_init_phys_region(void *start, void *end)
 {
 	unsigned long k_start, k_end, k_cur;
@@ -92,11 +90,9 @@ void __init kasan_init(void)
 	 */
 	memset(kasan_early_shadow_page, 0, PAGE_SIZE);
 
-	static_branch_inc(&powerpc_kasan_enabled_key);
-
 	/* Enable error messages */
 	init_task.kasan_depth = 0;
-	pr_info("KASAN init done\n");
+	kasan_init_generic();
 }
 
 void __init kasan_early_init(void) { }
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

