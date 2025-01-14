Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CFF42A83
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 02:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736821484; cv=none; b=W9gTsI3dtev8asKnmjVvAYQOipjaRTp7AbuQKZ5n989LjqdQL8kLT5OUBrSzE22Yj3u+HqRUDFonOwDFzEUqf6dzwOC/njQ82wwbCM6outXytH9YyPs9JtgmBnFLxpemmQ2LSBN1yIqkFCBC+wBVI6fW6KvKXDeDOncqv9lGd80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736821484; c=relaxed/simple;
	bh=mAlezV2b+8LzZn/wHT7bZeRSmsBzbIrRi+i5m/kImzo=;
	h=Date:To:From:Subject:Message-Id; b=V4IMXwEawAgG8QU6450tPwkJdljWdnAfpDaLVl4Zb5f3dwGO5hKQo34f5ag2qbY+zGDDdoPS30oAqKLOdN5ZhTN42aUrJggoFIEsdbYXNHKqCIOk+OzHYiL+TZhRURpm8JlcC1TH7JjyZgB9z+8zoPsq6BoiGwzUYD04sidwmZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G7jr7dli; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G7jr7dli"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC934C4CED6;
	Tue, 14 Jan 2025 02:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736821484;
	bh=mAlezV2b+8LzZn/wHT7bZeRSmsBzbIrRi+i5m/kImzo=;
	h=Date:To:From:Subject:From;
	b=G7jr7dli3kSaE87Fn+1m7abPgJsfGmz22eoWwVueACYDtwYmTNngP0YB4ClbZR/E1
	 eO1k5yM4nDvcURzk3gnAcu8M8eQkwjt6mAjy/kSpcI0LPWFzOPqHf1OWTBBRzS+0xe
	 P5IRIInc2bD/2DAAOAXXVMpHLhNLwFqEHxu2k3HQ=
Date: Mon, 13 Jan 2025 18:24:43 -0800
To: mm-commits@vger.kernel.org,ville.syrjala@linux.intel.com,rppt@kernel.org,mingo@redhat.com,bp@alien8.de,peterz@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-disable-execmem_rox-support.patch added to mm-hotfixes-unstable branch
Message-Id: <20250114022443.DC934C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86: disable EXECMEM_ROX support
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     x86-disable-execmem_rox-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-disable-execmem_rox-support.patch

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
From: Peter Zijlstra <peterz@infradead.org>
Subject: x86: disable EXECMEM_ROX support
Date: Mon, 13 Jan 2025 12:29:34 +0100

module_writable_address() made a mess of alternative.c, and it still
contains bugs -- notably some of the CFI variants crash and burn.

Mike has been working on patches to clean all this up again, but given the
current state of things, this stuff just isn't ready.

Disable for now, lets try again next cycle.

Link: https://lkml.kernel.org/r/20250113112934.GA8385@noisy.programming.kicks-ass.net
Fixes: 5185e7f9f3bd ("x86/module: enable ROX caches for module text on 64 bit")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Ville Syrjl <ville.syrjala@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/x86/Kconfig~x86-disable-execmem_rox-support
+++ a/arch/x86/Kconfig
@@ -83,7 +83,6 @@ config X86
 	select ARCH_HAS_DMA_OPS			if GART_IOMMU || XEN
 	select ARCH_HAS_EARLY_DEBUG		if KGDB
 	select ARCH_HAS_ELF_RANDOMIZE
-	select ARCH_HAS_EXECMEM_ROX		if X86_64
 	select ARCH_HAS_FAST_MULTIPLIER
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_GCOV_PROFILE_ALL
_

Patches currently in -mm which might be from peterz@infradead.org are

x86-disable-execmem_rox-support.patch
kasan-make-kasan_record_aux_stack_noalloc-the-default-behaviour.patch

