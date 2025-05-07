Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A08E291151;
	Wed,  7 May 2025 22:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746658292; cv=none; b=ZH9cX9yDetxufA30bCP4sPCzq68SILSMnYDi2qUNzMepjiGFdZMqEjxLFyBnoRmMWe0MlbXjcmO87on6PUA/iMPYMMMhcwSF3KCU5oyTUpgZ2fPQoO4+4YB5Seog3BR4CQNHEdsNIVPVHilNz5uv4SbDe53Y/GaT1Sp6wI2Pnyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746658292; c=relaxed/simple;
	bh=b77iVLjFOjNJ9Sm5dXZjoLc3qo67x+SCpqORvfgYg2g=;
	h=Date:To:From:Subject:Message-Id; b=WexsMkaf/ZsyZIsdnW8hy9OQcJ3PWJzTn2OMNGnGXyGbSZaEm9xBMIBRXD/t5ChV9/PKN4CJhF92d6LtEjIYMF2jiWcMjhupgP6uSXeflm6i5t9H4a0m4fd5ohDsE+F1VAITkfxN6oDOYQ0fRKrax1QwER9RgpuIBFjMgMamVdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=stNZ234L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="stNZ234L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D833CC4CEE2;
	Wed,  7 May 2025 22:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746658292;
	bh=b77iVLjFOjNJ9Sm5dXZjoLc3qo67x+SCpqORvfgYg2g=;
	h=Date:To:From:Subject:From;
	b=stNZ234LigqJJk6S4DSxVUuIYwcUzi3UvywiNy/QFlUwRxR6O4qZr03IuAt5bWAGV
	 cLynDsUxx4AI7C+wFyenngj72d9Ly5vMm8/aCM2uCBwEdfKxWvJpgOS3DoIueSYSiA
	 V7Cs41oN1FJ+sozZVqwau9IG1VbxNTWQKNkG1e3c=
Date: Wed, 07 May 2025 15:51:31 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,thiago.bauermann@linaro.org,tglx@linutronix.de,stable@vger.kernel.org,mingo@redhat.com,jackmanb@google.com,hpa@zytor.com,catalin.marinas@arm.com,broonie@kernel.org,bp@alien8.de,revest@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-vm_uffd_minor-==-vm_shadow_stack-on-userfaultfd=y-arm64_gcs=y.patch added to mm-hotfixes-unstable branch
Message-Id: <20250507225131.D833CC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix VM_UFFD_MINOR == VM_SHADOW_STACK on USERFAULTFD=y && ARM64_GCS=y
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-vm_uffd_minor-==-vm_shadow_stack-on-userfaultfd=y-arm64_gcs=y.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-vm_uffd_minor-==-vm_shadow_stack-on-userfaultfd=y-arm64_gcs=y.patch

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
From: Florent Revest <revest@chromium.org>
Subject: mm: fix VM_UFFD_MINOR == VM_SHADOW_STACK on USERFAULTFD=y && ARM64_GCS=y
Date: Wed, 7 May 2025 15:09:57 +0200

On configs with CONFIG_ARM64_GCS=y, VM_SHADOW_STACK is bit 38.  On configs
with CONFIG_HAVE_ARCH_USERFAULTFD_MINOR=y (selected by CONFIG_ARM64 when
CONFIG_USERFAULTFD=y), VM_UFFD_MINOR is _also_ bit 38.

This bit being shared by two different VMA flags could lead to all sorts
of unintended behaviors.  Presumably, a process could maybe call into
userfaultfd in a way that disables the shadow stack vma flag.  I can't
think of any attack where this would help (presumably, if an attacker
tries to disable shadow stacks, they are trying to hijack control flow so
can't arbitrarily call into userfaultfd yet anyway) but this still feels
somewhat scary.

Link: https://lkml.kernel.org/r/20250507131000.1204175-2-revest@chromium.org
Fixes: ae80e1629aea ("mm: Define VM_SHADOW_STACK for arm64 when we support GCS")
Signed-off-by: Florent Revest <revest@chromium.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Florent Revest <revest@chromium.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-fix-vm_uffd_minor-==-vm_shadow_stack-on-userfaultfd=y-arm64_gcs=y
+++ a/include/linux/mm.h
@@ -385,7 +385,7 @@ extern unsigned int kobjsize(const void
 #endif
 
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
-# define VM_UFFD_MINOR_BIT	38
+# define VM_UFFD_MINOR_BIT	41
 # define VM_UFFD_MINOR		BIT(VM_UFFD_MINOR_BIT)	/* UFFD minor faults */
 #else /* !CONFIG_HAVE_ARCH_USERFAULTFD_MINOR */
 # define VM_UFFD_MINOR		VM_NONE
_

Patches currently in -mm which might be from revest@chromium.org are

mm-fix-vm_uffd_minor-==-vm_shadow_stack-on-userfaultfd=y-arm64_gcs=y.patch

