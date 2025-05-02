Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F24B3234
	for <mm-commits@vger.kernel.org>; Fri,  2 May 2025 00:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746146632; cv=none; b=ERAijSVtfGauQ+WlPLvS2tXm9wMghPuMVUhUnaQmvi/9HwPbcvKV8whf7KNwVQS8kbGHol9pnhdRaUhY6xP7iu5USzf+leUFfGRFjMmY+DBP/FanLSIvzFShXz4RIr/9HP5+CDEl0QbF6ydB4Cds+kQ02vKq+wncf3PEd27fuic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746146632; c=relaxed/simple;
	bh=XsKvVhacMxahlgRTsvODfKVR7tDFOfT25kR1WZIaE/w=;
	h=Date:To:From:Subject:Message-Id; b=OUX6K4rreCGppp9RlYz3OG+5dI16v+CFe5z/ADuw1jcOAoLk/xiCgWhV4ZUbMuLd5nHk5cPx4z1HVXhU96nN2+LZeGpYec40WU3X6jeFsgdUId4HINVGGskqpBCqMAWdthO/rQDwQ1kWsSr6LS3qiLgTA33q1lsZUFxKwBL6h4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xo7A3SP+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xo7A3SP+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F20C4CEE3;
	Fri,  2 May 2025 00:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746146632;
	bh=XsKvVhacMxahlgRTsvODfKVR7tDFOfT25kR1WZIaE/w=;
	h=Date:To:From:Subject:From;
	b=Xo7A3SP+4XeZ8dKrs57gKpF+gppjOKyccLuxf8nGmugEP/bmvzZg+joSCLixEmhXx
	 k0nZjkgm1udMr3e4pdgSfvqAruRAfQSbG5UxIZtk9eLk9MZBpdwNL3+IHCuFd03q/v
	 GkpzBgvL/SCVUlquHIeLtCWxNEkj4on5BedPW3gY=
Date: Thu, 01 May 2025 17:43:51 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,changyuanl@google.com,graf@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-kconfig-enable-kexec-handover-for-64-bits.patch added to mm-unstable branch
Message-Id: <20250502004352.02F20C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/Kconfig: enable kexec handover for 64 bits
has been added to the -mm mm-unstable branch.  Its filename is
     x86-kconfig-enable-kexec-handover-for-64-bits.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-kconfig-enable-kexec-handover-for-64-bits.patch

This patch will later appear in the mm-unstable branch at
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
From: Alexander Graf <graf@amazon.com>
Subject: x86/Kconfig: enable kexec handover for 64 bits
Date: Thu, 1 May 2025 15:54:22 -0700

Add ARCH_SUPPORTS_KEXEC_HANDOVER for 64 bits to allow enabling of
KEXEC_HANDOVER configuration option.

Link: https://lkml.kernel.org/r/20250501225425.635167-16-changyuanl@google.com
Signed-off-by: Alexander Graf <graf@amazon.com>
Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Co-developed-by: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/Kconfig~x86-kconfig-enable-kexec-handover-for-64-bits
+++ a/arch/x86/Kconfig
@@ -2029,6 +2029,9 @@ config ARCH_SUPPORTS_KEXEC_BZIMAGE_VERIF
 config ARCH_SUPPORTS_KEXEC_JUMP
 	def_bool y
 
+config ARCH_SUPPORTS_KEXEC_HANDOVER
+	def_bool X86_64
+
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool X86_64 || (X86_32 && HIGHMEM)
 
_

Patches currently in -mm which might be from graf@amazon.com are

memblock-add-support-for-scratch-memory.patch
kexec-add-kexec-handover-kho-generation-helpers.patch
kexec-add-kho-parsing-support.patch
kexec-add-kho-support-to-kexec-file-loads.patch
kexec-add-config-option-for-kho.patch
arm64-add-kho-support.patch
x86-kexec-add-support-for-passing-kexec-handover-kho-data.patch
x86-e820-temporarily-enable-kho-scratch-for-memory-below-1m.patch
x86-boot-make-sure-kaslr-does-not-step-over-kho-preserved-memory.patch
x86-kconfig-enable-kexec-handover-for-64-bits.patch
memblock-add-kho-support-for-reserve_mem.patch
documentation-add-documentation-for-kho.patch

