Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A00C1DE3DC
	for <mm-commits@vger.kernel.org>; Thu, 26 Jun 2025 22:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750976558; cv=none; b=lR0hKkVjpvyHR82qV7nxEqnHo3pIjWQYOb9i2wQv0EtAHHdMvJiNoQ3GXiQh2x6cEf2NZ8sqoWR/dvKfoKFp7Ay3TBb2RTfAyaVc+pHiVreoVMpGAOpQfUtZdfvIg4kWX6M5zdDahyApOosPWSwESuO3t3w9FqVD8RFFe890+fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750976558; c=relaxed/simple;
	bh=HY1sxJDabjF+PQqwZdi2cfXwLSwSqsK+VVn0jIhNUZQ=;
	h=Date:To:From:Subject:Message-Id; b=SW5bq1986hL+gzFNe/oE+UuRj/ZBJv9rIVlkxn07r5Ln5d5BScDw+tmqBMBwN9iZRql37reZvbLeuFl+L1Wd4ipgurbCPzLqLFu9XrTt7FMZ0FIg5edZV43OTU3EacYb7CGicosAdvCDiFC+F73id20P012NiMbhmSdonZSr/QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FZKOn1Am; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FZKOn1Am"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC95BC4CEEB;
	Thu, 26 Jun 2025 22:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750976558;
	bh=HY1sxJDabjF+PQqwZdi2cfXwLSwSqsK+VVn0jIhNUZQ=;
	h=Date:To:From:Subject:From;
	b=FZKOn1Amr9WZTd/h+u2qksVSpmhkbl8JpgKdn/55PN2xBavXxG4GMkcrzmgTGAd3D
	 55xDL2MDSmaeIOViuXRbEhNBxK9mo1aqysSN7M4nBgmJhm1LuzQd8WWYo8uglzTzAG
	 zM+P7VNNeorNBDJqVspiX7QgCSkl6sZ0CRnys0O4=
Date: Thu, 26 Jun 2025 15:22:37 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-arm64-call-kasan_init_generic-in-kasan_init.patch added to mm-new branch
Message-Id: <20250626222237.EC95BC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan/arm64: call kasan_init_generic in kasan_init
has been added to the -mm mm-new branch.  Its filename is
     kasan-arm64-call-kasan_init_generic-in-kasan_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-arm64-call-kasan_init_generic-in-kasan_init.patch

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
Subject: kasan/arm64: call kasan_init_generic in kasan_init
Date: Thu, 26 Jun 2025 20:31:38 +0500

Call kasan_init_generic() which enables the static flag to mark KASAN
initialized in CONFIG_KASAN_GENERIC mode, otherwise it's an inline stub,
and the flag is enabled in kasan_init_sw_tags() or kasan_init_hw_tags().

Link: https://lkml.kernel.org/r/20250626153147.145312-3-snovitoll@gmail.com
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218315
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/kasan_init.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/arm64/mm/kasan_init.c~kasan-arm64-call-kasan_init_generic-in-kasan_init
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

