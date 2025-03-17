Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CB521858D
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188491; cv=none; b=LGP5aHTh0YQPM5MTlhjkn8tJnZbPTRQd94xH4LBcuygYhcGJ2sKY4AFLWwpsj7fcwP/pnPA/0Y+aljYgQV6wT7MuAbc12lJfo5y4kaXEPxwKoK4M7CBHTkHT/TPWnp+FZZHfr/fmGGMG7qafgmt/MhSsFbBUz3pNPe7ppOPHsPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188491; c=relaxed/simple;
	bh=TBXD4Mb8ik9Fv5sVaHqEaYaF0nT7uBN+XCZLhiIGqSI=;
	h=Date:To:From:Subject:Message-Id; b=OaC35s9oG5ipcBCb7SZwtltrYQvTzT4Ndz9oeQmdIuNngl1OWqcAieDnEbLwgshPjnJx8ez7St8mQnBMDIe8xYjETmCPHrW6E4cxN/VrpMTbXlo9HO/GI2XsBJxq1IhptJUD4Q9MZvJ5hVa6rWTVsvkykYOrJ/RXahLXS9UHp34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qcy1S3qh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qcy1S3qh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4A6C4CEEC;
	Mon, 17 Mar 2025 05:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188491;
	bh=TBXD4Mb8ik9Fv5sVaHqEaYaF0nT7uBN+XCZLhiIGqSI=;
	h=Date:To:From:Subject:From;
	b=Qcy1S3qhj4e7lBpsQGe80zXXI/KnycuAaOGlQyR5+RIgUPc7uA3MgZXJfp3GNOC3D
	 3n5X2PZ4AgFIADZkwJFvijfmu3kL0LZX/Ro4pF5EaifHTfiR7iTHkhsvrzRIu9UfdC
	 0PJec+B2c9lABOlKDsAV4oXpULTXKIzEE+z422PI=
Date: Sun, 16 Mar 2025 22:14:51 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,steven.price@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,maddy@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,corbet@lwn.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arch-powerpc-drop-generic_ptdump-from-mpc885_ads_defconfig.patch removed from -mm tree
Message-Id: <20250317051451.AC4A6C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arch/powerpc: drop GENERIC_PTDUMP from mpc885_ads_defconfig
has been removed from the -mm tree.  Its filename was
     arch-powerpc-drop-generic_ptdump-from-mpc885_ads_defconfig.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: arch/powerpc: drop GENERIC_PTDUMP from mpc885_ads_defconfig
Date: Wed, 26 Feb 2025 17:54:01 +0530

GENERIC_PTDUMP gets selected on powerpc explicitly and hence can be
dropped off from mpc885_ads_defconfig.  Replace with CONFIG_PTDUMP_DEBUGFS
instead.

Link: https://lkml.kernel.org/r/20250226122404.1927473-3-anshuman.khandual@arm.com
Fixes: e084728393a5 ("powerpc/ptdump: Convert powerpc to GENERIC_PTDUMP")
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Suggested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
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

 arch/powerpc/configs/mpc885_ads_defconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/configs/mpc885_ads_defconfig~arch-powerpc-drop-generic_ptdump-from-mpc885_ads_defconfig
+++ a/arch/powerpc/configs/mpc885_ads_defconfig
@@ -78,4 +78,4 @@ CONFIG_DEBUG_VM_PGTABLE=y
 CONFIG_DETECT_HUNG_TASK=y
 CONFIG_BDI_SWITCH=y
 CONFIG_PPC_EARLY_DEBUG=y
-CONFIG_GENERIC_PTDUMP=y
+CONFIG_PTDUMP_DEBUGFS=y
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are


