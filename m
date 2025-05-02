Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B3E3234
	for <mm-commits@vger.kernel.org>; Fri,  2 May 2025 00:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746146617; cv=none; b=YlVLdEPDw4a7xOYq7FNZn+wP1IknERic/Igz+Te49ww/Ozay55DOs/L1tt+N8bMsffvUf3kVbvEordJbaHb/hv3UfubxLGNrIgj/onh5LONeWa0KLdYO5xusauaxqBStsEVf0UgGrVOKooQylzoD6h+upQPF7n8/brrws2bvcig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746146617; c=relaxed/simple;
	bh=FuIi0kjcmeEngzI0Cxm+PraDy8/C1dyBVF6kRK0pJh4=;
	h=Date:To:From:Subject:Message-Id; b=on1ZwPQMR5xeEcsi9MQaA9pHjsOmOOK4Gp3mWOxiiW4AOkTWQcAJfvctaiJs2b4Tpe9cO/PyKeVZNneBKIkGqbbTejcwKGYcpCyMqMDATuIylWav5J36Zr10+bb7xnGvHTjEl70mnoL6YRJRignsam4okwPNJXOsURYO242oZVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q54HfQhi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q54HfQhi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987EAC4CEE3;
	Fri,  2 May 2025 00:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746146617;
	bh=FuIi0kjcmeEngzI0Cxm+PraDy8/C1dyBVF6kRK0pJh4=;
	h=Date:To:From:Subject:From;
	b=Q54HfQhin8Nmj/yxdD6AZfJom/hFssJbXPWGsd8b/cSf2Bb16AqzqOIdSpYTSOg73
	 nIA25+rtHgVSxmDDS+ZRAPBQqGt4D29WW/o10jYucUjbdqR1F+0AnPmHsIeiUyjRij
	 EHr1bwAbg9K1Dx6oqbvA7sk/+oZ93FAYxA0vIbL4=
Date: Thu, 01 May 2025 17:43:37 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,changyuanl@google.com,graf@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-add-config-option-for-kho.patch added to mm-unstable branch
Message-Id: <20250502004337.987EAC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec: add config option for KHO
has been added to the -mm mm-unstable branch.  Its filename is
     kexec-add-config-option-for-kho.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-add-config-option-for-kho.patch

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
Subject: kexec: add config option for KHO
Date: Thu, 1 May 2025 15:54:16 -0700

We have all generic code in place now to support Kexec with KHO.  This
patch adds a config option that depends on architecture support to enable
KHO support.

Link: https://lkml.kernel.org/r/20250501225425.635167-10-changyuanl@google.com
Signed-off-by: Alexander Graf <graf@amazon.com>
Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Kconfig.kexec |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/kernel/Kconfig.kexec~kexec-add-config-option-for-kho
+++ a/kernel/Kconfig.kexec
@@ -95,6 +95,20 @@ config KEXEC_JUMP
 	  Jump between original kernel and kexeced kernel and invoke
 	  code in physical address mode via KEXEC
 
+config KEXEC_HANDOVER
+	bool "kexec handover"
+	depends on ARCH_SUPPORTS_KEXEC_HANDOVER && ARCH_SUPPORTS_KEXEC_FILE
+	select MEMBLOCK_KHO_SCRATCH
+	select KEXEC_FILE
+	select DEBUG_FS
+	select LIBFDT
+	select CMA
+	help
+	  Allow kexec to hand over state across kernels by generating and
+	  passing additional metadata to the target kernel. This is useful
+	  to keep data or state alive across the kexec. For this to work,
+	  both source and target kernels need to have this option enabled.
+
 config CRASH_DUMP
 	bool "kernel crash dumps"
 	default ARCH_DEFAULT_CRASH_DUMP
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

