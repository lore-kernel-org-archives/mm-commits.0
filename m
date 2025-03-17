Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9CB217F55
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188495; cv=none; b=OUylNbvqMVpzNF1OFRutVNg4PmhZA/hzSjmr6VrVntuOBU+fVcnKLqS9WEfGb32FjgEhSrZx95UCMnTAPjRWYpB0x/kzW/aWw3jovtq68OUyg6oPiO+sP9Z92anY2r2Flvt10W/TCNWR8t2PY9f2VtIvX8OQFXVgB0EDYWZepRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188495; c=relaxed/simple;
	bh=MoidloJ0/FYh++CsBhXA+RimwUcuWlAh/J0EvktW6fM=;
	h=Date:To:From:Subject:Message-Id; b=jVyg0ELjNTE6hUgH1y3kK60Ue1UGT1D/sZj2nyb4dfuiYlmLe3V5V0UpZDV/1vMFars6arXsSbIkLknbrJGr/Gz4e+DKI2ohn6oJLIQWAaBk3AD7AtjLg0UY4LX/gLwqj7nIFWH6BIGog+cDa67fmooaq9Iy7ZJ0LjNIrizp4DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G3+lIw8o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G3+lIw8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D9BC4CEEC;
	Mon, 17 Mar 2025 05:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188494;
	bh=MoidloJ0/FYh++CsBhXA+RimwUcuWlAh/J0EvktW6fM=;
	h=Date:To:From:Subject:From;
	b=G3+lIw8oNBw92oDB5HdCP7axS2zicgnvK9Ukdh0vm9c+pZOKXu3cLXiUvmrfz6oI8
	 0lW0V+dZrA+8lM/TppxqC8LI8EDzzqe2TmCgNlVYe0XfkO9oYVj+CZhD+kyKVeCjQH
	 XbQxQMU5Ccl2bOJRthZYwY1OMOZ6z6j8a5arZ0lk=
Date: Sun, 16 Mar 2025 22:14:54 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,steven.price@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,maddy@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,corbet@lwn.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-debug_wx-depdendent-on-generic_ptdump.patch removed from -mm tree
Message-Id: <20250317051454.B0D9BC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: make DEBUG_WX depdendent on GENERIC_PTDUMP
has been removed from the -mm tree.  Its filename was
     mm-make-debug_wx-depdendent-on-generic_ptdump.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm: make DEBUG_WX depdendent on GENERIC_PTDUMP
Date: Wed, 26 Feb 2025 17:54:03 +0530

DEBUG_WX selects PTDUMP_CORE without even ensuring that the given platform
implements GENERIC_PTDUMP.  This problem has been latent until now, as all
the platforms subscribing ARCH_HAS_DEBUG_WX also subscribe GENERIC_PTDUMP.

Link: https://lkml.kernel.org/r/20250226122404.1927473-5-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Catalin Marinas <catalin.marinas@arm.com>
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


