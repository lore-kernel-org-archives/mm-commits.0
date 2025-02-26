Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1902B25CC7D
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 22:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740608745; cv=none; b=Ad+bXfuwXKGpSbbjEhPqWXyrrethnjLDqhLGjNX5f6tEi4cNnKATIDT/gwk/sIIqHsouGmefcqb2PK1YOcbaKG8VZSFvb3DdPqZoLLXt5rt4/hOPrLwduyhgjh/zEr8uXFlniqBudMGppt/rkjUlCRyI07G8OaoL/xJfFp6Noss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740608745; c=relaxed/simple;
	bh=8CN88pvXf6zC/DRJ0wrjKIAqEc5BFjZb5bhCty6DN9Q=;
	h=Date:To:From:Subject:Message-Id; b=O1s+X1BnbCtY30d/Pp3IgwA70Rp/Z9i7ESy0j1qKpsgvc5iCaVB8twInxHvccUFG4QpoXxtw+i/h4+p7WqBnSz0GmiycyV9dIG8v9TZCu2Sa3BbMMSreWiUROfo4iJqMKSRgn7pDDREpC3JQR3wrasFVqpDORhHQ1+YVoqC4V5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xs3eZDpV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xs3eZDpV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F46EC4CEE7;
	Wed, 26 Feb 2025 22:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740608744;
	bh=8CN88pvXf6zC/DRJ0wrjKIAqEc5BFjZb5bhCty6DN9Q=;
	h=Date:To:From:Subject:From;
	b=xs3eZDpVKPpvejhOSYtKkm+J+ezgsengsCcKYgZxuny3BJpgpqqQ5aheAasqssx7z
	 Dlf5bfIze+OS5L+3oQo+MaFD9MQvyPu5HKPMT8XI8t4U0GJG4+jeH84PgAtO6f0oyT
	 Mrqt4t8lhg9yNCkynNwYz2Qqy6lxREZmRfgy6qTw=
Date: Wed, 26 Feb 2025 14:25:43 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,steven.price@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,maddy@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,corbet@lwn.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arch-powerpc-drop-generic_ptdump-from-mpc885_ads_defconfig.patch added to mm-unstable branch
Message-Id: <20250226222544.6F46EC4CEE7@smtp.kernel.org>
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

configs-drop-generic_ptdump-from-debugconfig.patch
arch-powerpc-drop-generic_ptdump-from-mpc885_ads_defconfig.patch
docs-arm64-drop-ptdump-config-options-from-ptdumprst.patch
mm-make-debug_wx-depdendent-on-generic_ptdump.patch
mm-rename-generic_ptdump-and-ptdump_core.patch

