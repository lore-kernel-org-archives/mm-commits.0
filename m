Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D6E221577
	for <mm-commits@vger.kernel.org>; Thu, 17 Apr 2025 23:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744931067; cv=none; b=FIYFmGvAApcQ69NT/QJlW6mE2q5Ij6SjE2b2BP0vo1woxKuHti5DpSpjc6KDZ1uj9uA9d5xO/riZL1ggpzzWzqoyXdFXXRfRNFqySAQeQ03EUZjcIKoMjAa8HltdBumhmEjxbHdaAkQB+H7gKUw1K9Q5Kom4YqdPwBZcFVgp9kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744931067; c=relaxed/simple;
	bh=gv6v6mMrYzWFDkDTuk+UceHPyuc21Wzoq1IqXs+/RfA=;
	h=Date:To:From:Subject:Message-Id; b=k7zKIzqOfL7umscI3eNSJhuvnHhTqE8fp4VFGRQYvrLGOtcoeREzUu+Ky1aSPHjnvOtTJeYg5oRePfC6AHYwo+CdDp28jAqVPo7ZuuZ3dEZ84hGWydJtMcqYJA4gXA+63i+TGKxhiDFA3xSHqMTa65dAsZfVkHmqn7ydI6SH9W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eZz8AX5m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eZz8AX5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA502C4CEEA;
	Thu, 17 Apr 2025 23:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744931066;
	bh=gv6v6mMrYzWFDkDTuk+UceHPyuc21Wzoq1IqXs+/RfA=;
	h=Date:To:From:Subject:From;
	b=eZz8AX5m/uu/t7fPymz4HZEVAj5jwW7RyiDaN/vk8KG3+UCZlNTzFp4PsBgFIvTG2
	 pgCzhQtkY6vz4FrqCHSKWSGrNDX68IQEzPpAsAb5x2wD6auYZux1JgvbEjVLIdGjti
	 P9LDp86+7odLQqNKLWbf5mROAbq2FcB4SIFRMcK4=
Date: Thu, 17 Apr 2025 16:04:26 -0700
To: mm-commits@vger.kernel.org,x86@kernel.org,vincenzo.frascino@arm.com,torvalds@linux-foundation.org,tglx@linutronix.de,ryabinin.a.a@gmail.com,mingo@redhat.com,linux@roeck-us.net,hpa@zytor.com,glider@google.com,dvyukov@google.com,bp@alien8.de,andreyknvl@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-disable-image-size-check-for-test-builds-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20250417230426.AA502C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86-disable-image-size-check-for-test-builds-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     x86-disable-image-size-check-for-test-builds-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-disable-image-size-check-for-test-builds-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: x86-disable-image-size-check-for-test-builds-fix
Date: Wed Apr 16 06:11:50 PM PDT 2025

add comment, fix nearby typo (sink->sync)

Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <x86@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/vmlinux.lds.S |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/vmlinux.lds.S~x86-disable-image-size-check-for-test-builds-fix
+++ a/arch/x86/kernel/vmlinux.lds.S
@@ -466,9 +466,16 @@ SECTIONS
 }
 
 /*
- * The ASSERT() sink to . is intentional, for binutils 2.14 compatibility:
+ * COMPILE_TEST kernels can be large - CONFIG_KASAN, for example, can cause
+ * this.  Let's assume that nobody will be running a COMPILE_TEST kernel and
+ * let's assert that fuller build coverage is more valuable than being able to
+ * run a COMPILE_TEST kernel.
  */
 #ifndef CONFIG_COMPILE_TEST
+/*
+/*
+ * The ASSERT() sync to . is intentional, for binutils 2.14 compatibility:
+ */
 . = ASSERT((_end - LOAD_OFFSET <= KERNEL_IMAGE_SIZE),
 	   "kernel image bigger than KERNEL_IMAGE_SIZE");
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

x86-disable-image-size-check-for-test-builds-fix.patch
mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch
vmalloc-switch-to-for_each_vmap_node-helper-fix.patch
mm-add-zblock-allocator-fix.patch

