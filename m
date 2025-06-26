Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABD51DE3DC
	for <mm-commits@vger.kernel.org>; Thu, 26 Jun 2025 22:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750976560; cv=none; b=aUyEJuZILqRDfpQuaqoyrmar6+G+60XCqbiE25v93UID40J1x6v+lqgxXKuLj3U+vk/45ulXxF6R0FjKhoYh4rv90LU/VfG3fPlF4TogtXHVHyx+feiQd0qD6RqWlxuAwneec0sBs6Z7+EsxCt0kZ9gA1v0YsUWg4SWFvAOAOPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750976560; c=relaxed/simple;
	bh=9kJnBarnNT0Qcm1eKAdEYwFPkEwORXZ46TjMUqpUPEg=;
	h=Date:To:From:Subject:Message-Id; b=NkJ1cmw8ei2tFI/oxlloKYBIstvisv1tXpFoinUx2qcndfNJO88NrKf2rG29TwutXb9ECPYVS4mRJgfOankSAMD+7X4dQOvKF9zMlw1Y5nZUS9QbgYDUyPBEHC+XkUBGiFz3htJb7QMGp/Jcx7ElsEK3k3OgRdzvbXkiMTl9Bfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VMABfW7e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VMABfW7e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D52C4CEEB;
	Thu, 26 Jun 2025 22:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750976559;
	bh=9kJnBarnNT0Qcm1eKAdEYwFPkEwORXZ46TjMUqpUPEg=;
	h=Date:To:From:Subject:From;
	b=VMABfW7eDdBtDPM8b/RM2iDGwxdPpe0xzgYpzJyJb4bnRuJyR8tHCe8rV8opYFlnY
	 C8tpybNsmdWUTkaiDASZfdEi87+T9WwJ7DGOjqIeU0Nphq/PS5BtQqX9n+qnT65wYp
	 kFJYJGc9HlTo8ot8+sUIhh0cZpLIeb5TlkcQmvJE=
Date: Thu, 26 Jun 2025 15:22:38 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-arm-call-kasan_init_generic-in-kasan_init.patch added to mm-new branch
Message-Id: <20250626222239.56D52C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan/arm: call kasan_init_generic in kasan_init
has been added to the -mm mm-new branch.  Its filename is
     kasan-arm-call-kasan_init_generic-in-kasan_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-arm-call-kasan_init_generic-in-kasan_init.patch

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
Subject: kasan/arm: call kasan_init_generic in kasan_init
Date: Thu, 26 Jun 2025 20:31:39 +0500

Call kasan_init_generic() which enables the static flag to mark KASAN
initialized in CONFIG_KASAN_GENERIC mode, otherwise it's an inline stub.

Link: https://lkml.kernel.org/r/20250626153147.145312-4-snovitoll@gmail.com
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218315
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/kasan_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mm/kasan_init.c~kasan-arm-call-kasan_init_generic-in-kasan_init
+++ a/arch/arm/mm/kasan_init.c
@@ -300,6 +300,6 @@ void __init kasan_init(void)
 	local_flush_tlb_all();
 
 	memset(kasan_early_shadow_page, 0, PAGE_SIZE);
-	pr_info("Kernel address sanitizer initialized\n");
 	init_task.kasan_depth = 0;
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

