Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250671D554
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 03:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739850856; cv=none; b=AyE6tK3YPqwuZkwrxNjhZQ1THgR7BKaUpsV53pObuixFfzwod+SsSw4XlHt1fYv7vnBTFSLvBusl9BvTx+3m2tbxe07cn1oAn044hJ4JEHtTCpbgOwUL4Rz20ew/73RSWABtlY8LinuGG/lbNukr8+dST6aDODbRqkiMk8DJh68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739850856; c=relaxed/simple;
	bh=9Y6rmkN4zT1ar1WX+UmqI4h7ip7rrJ7+3eOikQr/9rU=;
	h=Date:To:From:Subject:Message-Id; b=fBmfrTnOMT+ub/cNAFtoh+jIqSm5kNDKXzmIGvFCXlHrptjsQH1oYNtYWbNznH2t51HiVwq+ky5GSthFOSg9hT1bMlI+8o1waYzwn5FdtxwNXuD6Eka7qDKvqFKzjtiPLZ+nyoJjKVq3jeNAXPKVNR4V3sFCFLIlCNCKM3/nUHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E3O5Hka/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E3O5Hka/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A70C4CEE6;
	Tue, 18 Feb 2025 03:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739850855;
	bh=9Y6rmkN4zT1ar1WX+UmqI4h7ip7rrJ7+3eOikQr/9rU=;
	h=Date:To:From:Subject:From;
	b=E3O5Hka/7upKpH4F01epfDOkXsu3AOwsq7cItvUXz5iWCu3Ne9SvVjCASTD2UUfkA
	 HQ+rzdBYx/iHMpxEoaC4wSndHpaPcD/8WDj4Pgcx0rLHif91EDWD/+44QNt7ZfHxbg
	 +MLe3uxa0Vx8SiSzaceqWET7QLtW5wtvQTLl7OLk=
Date: Mon, 17 Feb 2025 19:54:15 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,steven.price@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,maddy@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,corbet@lwn.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + configs-drop-generic_ptdump-from-debugconfig.patch added to mm-unstable branch
Message-Id: <20250218035415.A9A70C4CEE6@smtp.kernel.org>
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
Date: Mon, 17 Feb 2025 09:52:16 +0530

Patch series "mm: Rework generic PTDUMP configs", v2.

The series reworks generic PTDUMP configs before eventually renaming them
after some basic clean ups first.  This is derived after splitting changes
from the following patch:
https://lore.kernel.org/all/20250205050039.1506377-1-anshuman.khandual@arm.com/


This patch (of 5):

The platforms that support GENERIC_PTDUMP select the config explicitly. 
But enabling this feature on platforms that don't really support - does
nothing or might cause a build failure.  Hence just drop GENERIC_PTDUMP
from generic debug.config

Link: https://lkml.kernel.org/r/20250217042220.32920-1-anshuman.khandual@arm.com
Link: https://lkml.kernel.org/r/20250217042220.32920-2-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Steven Price <steven.price@arm.com>
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

