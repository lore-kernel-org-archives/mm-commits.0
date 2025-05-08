Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF9021A931
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 06:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746686444; cv=none; b=FoOZ3NoF9Lex/K/peET2wAzCBSXCiR9WyIsuvCu88W9fnfqlBqdBXi74LXcWUZZkRthwkMLiyQFNGb1zTuOe0kPhdNDujBf09iPiOBLd/Gaw20AZlVtP5YpQIXhkA3dozGF2t/LAULXuRfT54fQ0H/coXYWSygcjNK5QW3KWbak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746686444; c=relaxed/simple;
	bh=SCmgHRCoKsavsbRiFnLqypfd8ZBx++K/ewNoF9JmBks=;
	h=Date:To:From:Subject:Message-Id; b=a/jkUOhEF2aNcNjemKuuQJ9sSY1BpGV0FX7fFC1mqxh759KiZyZrUYaOfhDsheire1a3n3VeQ/rqPmy6Yysm+YTD+A2HGV2IZQMzj42l09ysdqdF9fqcicUnnHjjUp/gtLnS0xNqtXzAebxs3U1WdEDwJXCcc4EGHjP1GiiAlb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VSo7p7kY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VSo7p7kY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB2DC4CEEF;
	Thu,  8 May 2025 06:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746686443;
	bh=SCmgHRCoKsavsbRiFnLqypfd8ZBx++K/ewNoF9JmBks=;
	h=Date:To:From:Subject:From;
	b=VSo7p7kYWzRcODenrxpzYn6nTUhYm/+5pryPGCa35EBETEUniCUtmmv4q0krm9U4a
	 A28ucZPUcZUNFKmvetHEomNFz30yp9eZgZF3oWmtTE4cv1BLJH7Fj5/bK+Yeb1idS0
	 vei5AsJBz3ELIwd6LWe3RGiHwLh1WkMZtg41DRrA=
Date: Wed, 07 May 2025 23:40:42 -0700
To: mm-commits@vger.kernel.org,x86@kernel.org,vincenzo.frascino@arm.com,torvalds@linux-foundation.org,tglx@linutronix.de,ryabinin.a.a@gmail.com,mingo@redhat.com,hpa@zytor.com,glider@google.com,dvyukov@google.com,bp@alien8.de,andreyknvl@gmail.com,linux@roeck-us.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] x86-disable-image-size-check-for-test-builds.patch removed from -mm tree
Message-Id: <20250508064043.5AB2DC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86: disable image size check for test builds
has been removed from the -mm tree.  Its filename was
     x86-disable-image-size-check-for-test-builds.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org: add comment, fix nearby typo (sink->sync)]
[akpm@linux-foundation.org: fix comment snafu
  Link: https://lore.kernel.org/oe-kbuild-all/202504191813.4r9H6Glt-lkp@intel.com/
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

 arch/x86/kernel/vmlinux.lds.S |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/vmlinux.lds.S~x86-disable-image-size-check-for-test-builds
+++ a/arch/x86/kernel/vmlinux.lds.S
@@ -466,10 +466,18 @@ SECTIONS
 }
 
 /*
- * The ASSERT() sink to . is intentional, for binutils 2.14 compatibility:
+ * COMPILE_TEST kernels can be large - CONFIG_KASAN, for example, can cause
+ * this.  Let's assume that nobody will be running a COMPILE_TEST kernel and
+ * let's assert that fuller build coverage is more valuable than being able to
+ * run a COMPILE_TEST kernel.
+ */
+#ifndef CONFIG_COMPILE_TEST
+/*
+ * The ASSERT() sync to . is intentional, for binutils 2.14 compatibility:
  */
 . = ASSERT((_end - LOAD_OFFSET <= KERNEL_IMAGE_SIZE),
 	   "kernel image bigger than KERNEL_IMAGE_SIZE");
+#endif
 
 /* needed for Clang - see arch/x86/entry/entry.S */
 PROVIDE(__ref_stack_chk_guard = __stack_chk_guard);
_

Patches currently in -mm which might be from linux@roeck-us.net are


