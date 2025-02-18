Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455EA1D554
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 03:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739850859; cv=none; b=de/cqHEcoBumsdrNqJ2cRcQg3B4BCL7QJGbH5dSVXP9kZRq0eF2amIc2EqEIbnJ3xjnyjeLt7INZPwpbcch/elpLKPNBTYL7fmtwOVdFpaugSI/WTnaLs2JUxGS1l7dAIuYXUEH4MVgMo6bImFuvTffv4mW/KFmjDSwsbwiGdI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739850859; c=relaxed/simple;
	bh=OErPelLnMe9bpsyT6n3SbRj85mcJYBOrlQ1NcIhFaiA=;
	h=Date:To:From:Subject:Message-Id; b=oSpi3R8UiV3bhY9nC7SmNWbUacJskkOO84nULdL0qNz9MQhhxnZKi1wgog8KB6g5oh5hvGtqMfKSltyMHriQOkhsYFM8V68q7LZ71+M+YotFmxqbUazhtgpYV2647+UMXbB/rIXm1P5Tqbhyv86VcVpssIzXoVt8hB+Zz7YERpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WUlpAnhw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WUlpAnhw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85A2C4CEE6;
	Tue, 18 Feb 2025 03:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739850857;
	bh=OErPelLnMe9bpsyT6n3SbRj85mcJYBOrlQ1NcIhFaiA=;
	h=Date:To:From:Subject:From;
	b=WUlpAnhwZQXHBT+OFdk/Depy9qLtNFMVSQa4oPZNSeOxc1DHjfqnZ8MPyM9KF3aIv
	 lhA9QDN8bLwO+1YkmlPlceBX5pEanq0QWZU1qh4NHyG0HKktEmUFswi2B2Y1j2XT2d
	 1efPpDmgIDnQJyEd34uHk+3l1dBH3r5825fOQiFY=
Date: Mon, 17 Feb 2025 19:54:17 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,steven.price@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,maddy@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,corbet@lwn.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arch-powerpc-drop-generic_ptdump-from-mpc885_ads_defconfig.patch added to mm-unstable branch
Message-Id: <20250218035417.A85A2C4CEE6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arch/powerpc: drop GENERIC_PTDUMP from mpc885_ads_defconfig
has been added to the -mm mm-unstable branch.  Its filename is
     arch-powerpc-drop-generic_ptdump-from-mpc885_ads_defconfig.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arch-powerpc-drop-generic_ptdump-from-mpc885_ads_defconfig.patch

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
Subject: arch/powerpc: drop GENERIC_PTDUMP from mpc885_ads_defconfig
Date: Mon, 17 Feb 2025 09:52:17 +0530

GENERIC_PTDUMP gets selected on powerpc explicitly and hence can be
dropped off from mpc885_ads_defconfig.

Link: https://lkml.kernel.org/r/20250217042220.32920-3-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/configs/mpc885_ads_defconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/powerpc/configs/mpc885_ads_defconfig~arch-powerpc-drop-generic_ptdump-from-mpc885_ads_defconfig
+++ a/arch/powerpc/configs/mpc885_ads_defconfig
@@ -78,4 +78,3 @@ CONFIG_DEBUG_VM_PGTABLE=y
 CONFIG_DETECT_HUNG_TASK=y
 CONFIG_BDI_SWITCH=y
 CONFIG_PPC_EARLY_DEBUG=y
-CONFIG_GENERIC_PTDUMP=y
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

configs-drop-generic_ptdump-from-debugconfig.patch
arch-powerpc-drop-generic_ptdump-from-mpc885_ads_defconfig.patch
docs-arm64-drop-ptdump-config-options-from-ptdumprst.patch
mm-make-debug_wx-depdendent-on-generic_ptdump.patch
mm-rename-generic_ptdump-and-ptdump_core.patch

