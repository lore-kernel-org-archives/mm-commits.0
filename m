Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E042185AC
	for <mm-commits@vger.kernel.org>; Thu, 26 Jun 2025 22:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750976564; cv=none; b=Zyhw2j0HAI6RY8DlqINkGVW3eCnmZ087NqEvHVir0fdOYlgDUZGxllfLLQqihDn4rnmozInWOZbMnYDDB224LbuVDInPFKBP+/wyrVpOZjBnFPyraCF8xiqAk4qdu+V0+iqT9xZ9RB9jbwSyjqrYBjWl2oWT4eEQRNvmc8SNsgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750976564; c=relaxed/simple;
	bh=cmbTe9/sSE3HdHCiSTl3rL9c2DQi3elPoTzV5Sy29sw=;
	h=Date:To:From:Subject:Message-Id; b=Wd9IrV0SUwQw6ijYGblI1plw7rXYL2fL5yZhlqMPeieT5BgZdgCiqV7romdVv8c6+2PR5XNl/hWOpARDfGmAYbao+zfDI5eMZ9lOvxN7rz39OhOX35IyyUbl/Esxar+/VJ3LorA1E1c2sAtGMFybdIr+4Snl1O/kBxjXod6Mngw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1I4GSn6P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1I4GSn6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15EF6C4CEEB;
	Thu, 26 Jun 2025 22:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750976563;
	bh=cmbTe9/sSE3HdHCiSTl3rL9c2DQi3elPoTzV5Sy29sw=;
	h=Date:To:From:Subject:From;
	b=1I4GSn6PJzLyuD7c38sKsKQRItKYjjNGCXVBL0hRnq23V5ldaQaBLdBPiCVhVcB18
	 uqjLNmQOHTk2AJR8SX/cZwKjP4sNExGQl1z5LLlsgJ7jRjMVmRyMLPNIKFlJ0lYZ4N
	 rhr23ntn9HQw9y67KRLA8jKLMXaaexCWx/Izp+aE=
Date: Thu, 26 Jun 2025 15:22:42 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-um-call-kasan_init_generic-in-kasan_init.patch added to mm-new branch
Message-Id: <20250626222243.15EF6C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan/um: call kasan_init_generic in kasan_init
has been added to the -mm mm-new branch.  Its filename is
     kasan-um-call-kasan_init_generic-in-kasan_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-um-call-kasan_init_generic-in-kasan_init.patch

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
Subject: kasan/um: call kasan_init_generic in kasan_init
Date: Thu, 26 Jun 2025 20:31:42 +0500

Call kasan_init_generic() which enables the static flag to mark generic
KASAN initialized, otherwise it's an inline stub.

Delete the key `kasan_um_is_ready` in favor of the global static flag in
linux/kasan-enabled.h which is enabled with kasan_init_generic().

Note that "kasan_init_generic" has __init macro, which is called by
kasan_init() which is not marked with __init in arch/um code.

Link: https://lkml.kernel.org/r/20250626153147.145312-7-snovitoll@gmail.com
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218315
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/asm/kasan.h |    5 -----
 arch/um/kernel/mem.c        |    4 ++--
 2 files changed, 2 insertions(+), 7 deletions(-)

--- a/arch/um/include/asm/kasan.h~kasan-um-call-kasan_init_generic-in-kasan_init
+++ a/arch/um/include/asm/kasan.h
@@ -24,11 +24,6 @@
 
 #ifdef CONFIG_KASAN
 void kasan_init(void);
-extern int kasan_um_is_ready;
-
-#ifdef CONFIG_STATIC_LINK
-#define kasan_arch_is_ready() (kasan_um_is_ready)
-#endif
 #else
 static inline void kasan_init(void) { }
 #endif /* CONFIG_KASAN */
--- a/arch/um/kernel/mem.c~kasan-um-call-kasan_init_generic-in-kasan_init
+++ a/arch/um/kernel/mem.c
@@ -21,9 +21,9 @@
 #include <os.h>
 #include <um_malloc.h>
 #include <linux/sched/task.h>
+#include <linux/kasan.h>
 
 #ifdef CONFIG_KASAN
-int kasan_um_is_ready;
 void kasan_init(void)
 {
 	/*
@@ -32,7 +32,7 @@ void kasan_init(void)
 	 */
 	kasan_map_memory((void *)KASAN_SHADOW_START, KASAN_SHADOW_SIZE);
 	init_task.kasan_depth = 0;
-	kasan_um_is_ready = true;
+	kasan_init_generic();
 }
 
 static void (*kasan_init_ptr)(void)
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

