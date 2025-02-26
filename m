Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCAB25CC7D
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 22:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740608743; cv=none; b=Y0eEmtM9zjbwO7YhfuomRuLCmGx714XM8d8hAKUkKpkLCCW4S8FlZTVX97uQWnBK2T5wJJLut5nO6B8ZLUHanisSSU2gaVxR0andtCB9f7OEacPP5WrJIAZZ/tOd7eAKFAe5C8CwLi3JZI3ZB5LkJSjgfAkl6E3gse69VwoQJ8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740608743; c=relaxed/simple;
	bh=g07XWywNWK/simN19l5lr9H3RQ0zQaaF2k85IoZ/ChE=;
	h=Date:To:From:Subject:Message-Id; b=ni1QxOK9RQD87EsHc59BJumnNJR+dGKcJYJvM90MZk6zPPxJMBzFG0w1/5fDxZntKRkV4WEjFACvdWj4oGSWhreOEKl/GZwutM0xZpqTPJlAoQlmm1kg2oYaYucIwVV+ijjoym+VTGaLIWFVY/8zXWnQPXnpvxZp9RSMGxPV5GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B5W6KAnw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B5W6KAnw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3A4C4CED6;
	Wed, 26 Feb 2025 22:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740608743;
	bh=g07XWywNWK/simN19l5lr9H3RQ0zQaaF2k85IoZ/ChE=;
	h=Date:To:From:Subject:From;
	b=B5W6KAnwrJ72JdrkkE28aOdgbr/aRFgD8JqN4s/72tmM1Pm/q68xZRwnyPaXLxjk/
	 bEkMFdgaEwu/9hyA4/OEoyOloOHipUT7w68NdgjAso2L1cspBhV+EMMZjxv0AnYvPV
	 CpxVvxBIbXKI8aaPsU5mhgKRC7JUe/Vo6dLGU00M=
Date: Wed, 26 Feb 2025 14:25:42 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,steven.price@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,maddy@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,corbet@lwn.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + configs-drop-generic_ptdump-from-debugconfig.patch added to mm-unstable branch
Message-Id: <20250226222543.3B3A4C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: configs: drop GENERIC_PTDUMP from debug.config
has been added to the -mm mm-unstable branch.  Its filename is
     configs-drop-generic_ptdump-from-debugconfig.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/configs-drop-generic_ptdump-from-debugconfig.patch

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
Subject: configs: drop GENERIC_PTDUMP from debug.config
Date: Wed, 26 Feb 2025 17:54:00 +0530

Patch series "mm: Rework generic PTDUMP configs", v3.

The series reworks generic PTDUMP configs before eventually renaming them
after some basic cleanups first.


This patch (of 5):

The platforms that support GENERIC_PTDUMP select the config explicitly. 
But enabling this feature on platforms that don't really support - does
nothing or might cause a build failure.  Hence just drop GENERIC_PTDUMP
from generic debug.config

Link: https://lkml.kernel.org/r/20250226122404.1927473-1-anshuman.khandual@arm.com
Link: https://lkml.kernel.org/r/20250226122404.1927473-2-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/configs/debug.config |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/configs/debug.config~configs-drop-generic_ptdump-from-debugconfig
+++ a/kernel/configs/debug.config
@@ -73,7 +73,6 @@ CONFIG_DEBUG_VM=y
 CONFIG_DEBUG_VM_PGFLAGS=y
 CONFIG_DEBUG_VM_RB=y
 CONFIG_DEBUG_VM_VMACACHE=y
-CONFIG_GENERIC_PTDUMP=y
 CONFIG_KASAN=y
 CONFIG_KASAN_GENERIC=y
 CONFIG_KASAN_INLINE=y
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

configs-drop-generic_ptdump-from-debugconfig.patch
arch-powerpc-drop-generic_ptdump-from-mpc885_ads_defconfig.patch
docs-arm64-drop-ptdump-config-options-from-ptdumprst.patch
mm-make-debug_wx-depdendent-on-generic_ptdump.patch
mm-rename-generic_ptdump-and-ptdump_core.patch

