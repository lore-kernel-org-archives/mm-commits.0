Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7C41E521A
	for <mm-commits@vger.kernel.org>; Thu, 17 Apr 2025 23:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744930987; cv=none; b=iCuVZqOGCungwtnDOEhK/+f/Ebp8+i+5oq0qnRab2ehjpGRuJDW5sJ8Wi+W/GMjq3AN5dw6SKFFS85mjRxaTMDBobVusHiBU7YstfwAAeYWbv0w4FlEX+fuyh6fPKBK+AsItMUJTDtHF9/PaDJCgbfFRjilvEc4A958CLJshATw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744930987; c=relaxed/simple;
	bh=5eMEvVzm3HPlsTekIBO2pDfqHOIKHP0KIsgOExifPoQ=;
	h=Date:To:From:Subject:Message-Id; b=bMf0og/E5cJ2pquraFWsqxIdZvDIZW4mevLBKGcb/NwzYZhpjtm87w58ynhOa/uVkAlXdBcxz8xHwSyaAefvWeBxj34xOL6LORxdprZ1On8jwwBms6Qj9IuITNZfk7ncVfUgnmBV53t8yJ7ut1FcqeJjdIzzsN4ynKWtU2WpZmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GK1pFvj2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GK1pFvj2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D630C4CEE4;
	Thu, 17 Apr 2025 23:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744930986;
	bh=5eMEvVzm3HPlsTekIBO2pDfqHOIKHP0KIsgOExifPoQ=;
	h=Date:To:From:Subject:From;
	b=GK1pFvj2Is+WC2hQDlDLg5oRmhIuaerYpVxoq4GRisYtgboNvuMPT37bgEKy5l0CH
	 6NrMV76VVp0J8AAYuSqdCc5KiK/trEZ8J/POYhCTw3zNzyQi8TgePQBnDXe8V/klN+
	 sOkcuQGHlWTo1RqRXjxKq8L/GuKwNxd0SIt9k208=
Date: Thu, 17 Apr 2025 16:03:05 -0700
To: mm-commits@vger.kernel.org,x86@kernel.org,vincenzo.frascino@arm.com,torvalds@linux-foundation.org,tglx@linutronix.de,ryabinin.a.a@gmail.com,mingo@redhat.com,hpa@zytor.com,glider@google.com,dvyukov@google.com,bp@alien8.de,andreyknvl@gmail.com,linux@roeck-us.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-disable-image-size-check-for-test-builds.patch added to mm-hotfixes-unstable branch
Message-Id: <20250417230306.5D630C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86: disable image size check for test builds
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     x86-disable-image-size-check-for-test-builds.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-disable-image-size-check-for-test-builds.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Guenter Roeck <linux@roeck-us.net>
Subject: x86: disable image size check for test builds
Date: Wed, 16 Apr 2025 18:09:50 -0700

64-bit allyesconfig builds fail with

x86_64-linux-ld: kernel image bigger than KERNEL_IMAGE_SIZE

Bisect points to commit 6f110a5e4f99 ("Disable SLUB_TINY for build
testing") as the responsible commit.  Reverting that patch does indeed fix
the problem.  Further analysis shows that disabling SLUB_TINY enables
KASAN, and that KASAN is responsible for the image size increase.

Solve the build problem by disabling the image size check for test
builds.

Link: https://lkml.kernel.org/r/20250417010950.2203847-1-linux@roeck-us.net
Fixes: 6f110a5e4f99 ("Disable SLUB_TINY for build testing")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <x86@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/vmlinux.lds.S |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kernel/vmlinux.lds.S~x86-disable-image-size-check-for-test-builds
+++ a/arch/x86/kernel/vmlinux.lds.S
@@ -468,8 +468,10 @@ SECTIONS
 /*
  * The ASSERT() sink to . is intentional, for binutils 2.14 compatibility:
  */
+#ifndef CONFIG_COMPILE_TEST
 . = ASSERT((_end - LOAD_OFFSET <= KERNEL_IMAGE_SIZE),
 	   "kernel image bigger than KERNEL_IMAGE_SIZE");
+#endif
 
 /* needed for Clang - see arch/x86/entry/entry.S */
 PROVIDE(__ref_stack_chk_guard = __stack_chk_guard);
_

Patches currently in -mm which might be from linux@roeck-us.net are

x86-disable-image-size-check-for-test-builds.patch
bug-kunit-core-support-for-suppressing-warning-backtraces.patch
kunit-bug-count-suppressed-warning-backtraces.patch
kunit-add-test-cases-for-backtrace-warning-suppression.patch
kunit-add-documentation-for-warning-backtrace-suppression-api.patch
drm-suppress-intentional-warning-backtraces-in-scaling-unit-tests.patch
x86-add-support-for-suppressing-warning-backtraces.patch
arm64-add-support-for-suppressing-warning-backtraces.patch
loongarch-add-support-for-suppressing-warning-backtraces.patch
parisc-add-support-for-suppressing-warning-backtraces.patch
s390-add-support-for-suppressing-warning-backtraces.patch
sh-add-support-for-suppressing-warning-backtraces.patch
sh-move-defines-needed-for-suppressing-warning-backtraces.patch
riscv-add-support-for-suppressing-warning-backtraces.patch
powerpc-add-support-for-suppressing-warning-backtraces.patch

