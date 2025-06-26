Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECAC263C9E
	for <mm-commits@vger.kernel.org>; Thu, 26 Jun 2025 22:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750976560; cv=none; b=UHuoSAcVpu/TeuzayqEV5TuUFZw8s+qTsoZ170Q56qqijoX0N8Pj9CY1JwymQmVWUru/ZQHqIw86eMP8vJ44M5zvyBQ8tYuvIEkfPAFFe3F+LIfqoAryE90JW95oAa0+DY6172znmyzTbDmrNUceWWTIdbzj4gKuUzBgG+7+5tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750976560; c=relaxed/simple;
	bh=PTfuZ7kg3HXB6MLar3shqJUYEymQ/7eZmlt6vH0zixY=;
	h=Date:To:From:Subject:Message-Id; b=DY6kbFdR7u/5ATPL+EcNhXpgXBqqT88AnVS9XYLdry7iNPIjzrreCDGG6kQj3wsJNy0MgR+9x8b8zr9wH616jnAgc3EXrI+GO4spSQpeWXC44mF9AnvpACzUfGPUXwmQc277dqpXWO1cQYeg6H+ZcjPCuV5HB8l3ZT1wvGMnxNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l/wMANkY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l/wMANkY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88640C4CEEB;
	Thu, 26 Jun 2025 22:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750976560;
	bh=PTfuZ7kg3HXB6MLar3shqJUYEymQ/7eZmlt6vH0zixY=;
	h=Date:To:From:Subject:From;
	b=l/wMANkYN7e3SP48+g/PuhAiyIHvUxIZR/YzZiCRA5fOO5i50UvQnDVXeHQfaQOGD
	 k1tAPAz3O81TNqx+a4LvyW2bBQXMZXEDuuI+uusxx6lX8dX9xvUBpR3B223FNyARIq
	 NFMK0RZ8bP4wMb67FVdb0tVOutuHie/CWiqfe7nM=
Date: Thu, 26 Jun 2025 15:22:40 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-xtensa-call-kasan_init_generic-in-kasan_init.patch added to mm-new branch
Message-Id: <20250626222240.88640C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan/xtensa: call kasan_init_generic in kasan_init
has been added to the -mm mm-new branch.  Its filename is
     kasan-xtensa-call-kasan_init_generic-in-kasan_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-xtensa-call-kasan_init_generic-in-kasan_init.patch

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
Subject: kasan/xtensa: call kasan_init_generic in kasan_init
Date: Thu, 26 Jun 2025 20:31:40 +0500

Call kasan_init_generic() which enables the static flag to mark generic
KASAN initialized, otherwise it's an inline stub.

Note that arch/xtensa still uses "current" instead of "init_task" pointer
in `current->kasan_depth = 0;` to enable error messages.  I haven't
changed this because I can't test the change.

Link: https://lkml.kernel.org/r/20250626153147.145312-5-snovitoll@gmail.com
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218315
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/mm/kasan_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/xtensa/mm/kasan_init.c~kasan-xtensa-call-kasan_init_generic-in-kasan_init
+++ a/arch/xtensa/mm/kasan_init.c
@@ -94,5 +94,5 @@ void __init kasan_init(void)
 
 	/* At this point kasan is fully initialized. Enable error messages. */
 	current->kasan_depth = 0;
-	pr_info("KernelAddressSanitizer initialized\n");
+	kasan_init_generic();
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

