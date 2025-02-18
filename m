Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DADC1D554
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 03:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739850862; cv=none; b=jg6mqQF6mQA0lipoqi/1x8pP8In+0NZdo6pEuwdS8PTziBvTmbQ1BJuT1xkuufq5CGun7+6nRtz5pfCC9fViXpFcPxb7LiQxSa1O0EpuQJf/ltAnJUqwQSW9JefIPNb0+SR51zTV1V4xqpvJ0xCKr4VtpyS/SIreRTyDqNFP6FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739850862; c=relaxed/simple;
	bh=dEnL/YFZXsIBjW8jQTXH2IGR8SUZ+tbBcjwAhG/I/Yw=;
	h=Date:To:From:Subject:Message-Id; b=l74X1T2ABabGl/Xe0bb0ypRUj6jmmkUmMI4iaInHdcGMrAiAbzcPmDEuYFU6NouZuLUnWhx18RmYsnu/5U4LYW+ZCyqnst97i4OvU2I0jSlwMuMtZvtBkz5atV5NjLmQj4Aj6EspX3JugGAjptMD4NzxB3fDEnyMI1WONFFpoH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ybq8b2J4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ybq8b2J4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9784FC4CEE6;
	Tue, 18 Feb 2025 03:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739850861;
	bh=dEnL/YFZXsIBjW8jQTXH2IGR8SUZ+tbBcjwAhG/I/Yw=;
	h=Date:To:From:Subject:From;
	b=ybq8b2J43RDVAa+MIn606dz27y0XIu+Jluvj5o6QtHWb7UjlU8S2oXqGbzjVCHBG7
	 IHl0YVCyvvjvhCh6ivn0m3HLuP4rJNToYX938gjExTpT8t6WA6YMDi7k4RzRZO/pOr
	 H1Erx27pRKvLFEKdmte0VCEktGQf7P50yNvALAy4=
Date: Mon, 17 Feb 2025 19:54:21 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,steven.price@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,maddy@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,corbet@lwn.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-debug_wx-depdendent-on-generic_ptdump.patch added to mm-unstable branch
Message-Id: <20250218035421.9784FC4CEE6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: make DEBUG_WX depdendent on GENERIC_PTDUMP
has been added to the -mm mm-unstable branch.  Its filename is
     mm-make-debug_wx-depdendent-on-generic_ptdump.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-debug_wx-depdendent-on-generic_ptdump.patch

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
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm: make DEBUG_WX depdendent on GENERIC_PTDUMP
Date: Mon, 17 Feb 2025 09:52:19 +0530

DEBUG_WX selects PTDUMP_CORE without even ensuring that the given platform
implements GENERIC_PTDUMP.  This problem has been latent until now, as all
the platforms subscribing ARCH_HAS_DEBUG_WX also subscribe GENERIC_PTDUMP.

Link: https://lkml.kernel.org/r/20250217042220.32920-5-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/Kconfig.debug~mm-make-debug_wx-depdendent-on-generic_ptdump
+++ a/mm/Kconfig.debug
@@ -186,6 +186,7 @@ config ARCH_HAS_DEBUG_WX
 config DEBUG_WX
 	bool "Warn on W+X mappings at boot"
 	depends on ARCH_HAS_DEBUG_WX
+	depends on GENERIC_PTDUMP
 	depends on MMU
 	select PTDUMP_CORE
 	help
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

configs-drop-generic_ptdump-from-debugconfig.patch
arch-powerpc-drop-generic_ptdump-from-mpc885_ads_defconfig.patch
docs-arm64-drop-ptdump-config-options-from-ptdumprst.patch
mm-make-debug_wx-depdendent-on-generic_ptdump.patch
mm-rename-generic_ptdump-and-ptdump_core.patch

