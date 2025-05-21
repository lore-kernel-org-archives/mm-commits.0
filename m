Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B0932C85;
	Wed, 21 May 2025 05:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747806607; cv=none; b=nkNU4OT9c2aOFA6MJTo3XvbiaUJ6bSG6RgIDtd0NgchhZo7nihRDOUYmr5883G5wYWK2aYyEEoZrxeqgkmpU5qcJV03CB6lzswwy9Jt8PmpPYco1QZi0hkr82JvIwJ1PiUhJkkn1r8sXQgtUNkI1jwVnOKxMVON0A0LH6txeXm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747806607; c=relaxed/simple;
	bh=EFmnDPRWmHTBUBaRYDRiICbXdWNSB1+AEE1/C/WzVtI=;
	h=Date:To:From:Subject:Message-Id; b=Exl6FeDY/AYtpzMxBSY77XmGo5nV2nBDmWmUeWHwpZXHsxV5PD7H0kCimfnKUttW2Ph9LSHe3XGNb3aYRBJggNrKU8diPy772JtHycFmXP60eisK09erR0/ybSWQC5oAu3a1n6S1hFqJmNk7Sd8othrcsK/kHGl34Tx4BE9s5+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ay1NaLye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ay1NaLye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4497AC4CEE4;
	Wed, 21 May 2025 05:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747806606;
	bh=EFmnDPRWmHTBUBaRYDRiICbXdWNSB1+AEE1/C/WzVtI=;
	h=Date:To:From:Subject:From;
	b=ay1NaLye4I2MK77eP2xnV3DRxtGwSpdji8SenB4gmo2fDEzxDdUFVEItoPp/loklE
	 oKA5gtGCEwMcDvo5FQ+73n/KRRFVnHj7bXRM1PIkzSQGV31W7h78SEeecVCMJgKo/r
	 WFb7FR6iS8Ue0aadQgpXwjEQdFVObgaaEGhbslDI=
Date: Tue, 20 May 2025 22:50:05 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,thiago.bauermann@linaro.org,tglx@linutronix.de,stable@vger.kernel.org,mingo@redhat.com,jackmanb@google.com,hpa@zytor.com,catalin.marinas@arm.com,broonie@kernel.org,bp@alien8.de,revest@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-vm_uffd_minor-==-vm_shadow_stack-on-userfaultfd=y-arm64_gcs=y.patch removed from -mm tree
Message-Id: <20250521055006.4497AC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix VM_UFFD_MINOR == VM_SHADOW_STACK on USERFAULTFD=y && ARM64_GCS=y
has been removed from the -mm tree.  Its filename was
     mm-fix-vm_uffd_minor-==-vm_shadow_stack-on-userfaultfd=y-arm64_gcs=y.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


