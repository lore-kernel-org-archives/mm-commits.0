Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05101DE3DC
	for <mm-commits@vger.kernel.org>; Thu, 26 Jun 2025 22:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750976569; cv=none; b=MwICZrnJrR6FZ5pKJlaJ9PE76f64KfH7nOFswhXe30aWMPXHZPr3GkcnJsP6uYYIaNATzoM6Pwv7UjVQmIY3ZhYK+ymDr8F0vmyoLlhIBi1WiE0rE6WDopwBPvVXDn8wH8zKQv5LrnE7H6+ul3YuM2pW+5zYanSIIcR43EJeXzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750976569; c=relaxed/simple;
	bh=tfiM40Zq9tCRsrBTFXFpZ9T5d5WdrYQNNzNvdaoaHck=;
	h=Date:To:From:Subject:Message-Id; b=MebIoat/uneOUbLF9+X4abK+1a5xpY45fVehomlfzgjcmrFBv/43ldqVj0NGpLmXS/Onb92Dsm3aNNpGLDsAvZ5WifUWSqKO8OvJtN5GWhq3jGkUlSvcRTQyPO3pZfzoIPzKXFj10zVwo0HpxRLXmH77uOnnDB+ifIbIOvjyFPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x+AbUyTn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x+AbUyTn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607ECC4CEEB;
	Thu, 26 Jun 2025 22:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750976568;
	bh=tfiM40Zq9tCRsrBTFXFpZ9T5d5WdrYQNNzNvdaoaHck=;
	h=Date:To:From:Subject:From;
	b=x+AbUyTn61c/wgYaKmtQIdJ/cTN6iz3z2XLPp9fFoI82n2iX45ZBVkWlVl+aKU9pI
	 IROfGVkJBxoKQe28o3FeMqpA0ov56yGign8vKyQL0cQe+GYtW9iTskEOwxCeCJTUuN
	 2w4APymIWwzCOtF9pgZcEjkgym+YelXh646oNmuI=
Date: Thu, 26 Jun 2025 15:22:47 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-riscv-call-kasan_init_generic-in-kasan_init.patch added to mm-new branch
Message-Id: <20250626222248.607ECC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan/riscv: call kasan_init_generic in kasan_init
has been added to the -mm mm-new branch.  Its filename is
     kasan-riscv-call-kasan_init_generic-in-kasan_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-riscv-call-kasan_init_generic-in-kasan_init.patch

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
Subject: kasan/riscv: call kasan_init_generic in kasan_init
Date: Thu, 26 Jun 2025 20:31:46 +0500

Call kasan_init_generic() which enables the static flag to mark generic
KASAN initialized, otherwise it's an inline stub.  Also prints the banner
from the single place.

Link: https://lkml.kernel.org/r/20250626153147.145312-11-snovitoll@gmail.com
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218315
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/mm/kasan_init.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/riscv/mm/kasan_init.c~kasan-riscv-call-kasan_init_generic-in-kasan_init
+++ a/arch/riscv/mm/kasan_init.c
@@ -530,6 +530,7 @@ void __init kasan_init(void)
 
 	memset(kasan_early_shadow_page, KASAN_SHADOW_INIT, PAGE_SIZE);
 	init_task.kasan_depth = 0;
+	kasan_init_generic();
 
 	csr_write(CSR_SATP, PFN_DOWN(__pa(swapper_pg_dir)) | satp_mode);
 	local_flush_tlb_all();
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

