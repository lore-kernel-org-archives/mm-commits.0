Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FE91D554
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 03:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739850860; cv=none; b=pUlKlhgD5CZrggem7k4fc7FugSBHnzt1IMpnTicGAcWLIdJ4e/6TBvylEm8OGeT6sTk29XmsvKggCQ5YOO5NoXL1OujRbUMjFd03x2aQwt4TAxY7MHmY5BRoDjDlkeqY5/5a7BrwT4w2KKSDHzpNA2dy24rhGFebdQ+NSQoaWlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739850860; c=relaxed/simple;
	bh=LPa/XAGseyKyUj+qEyGegV0VIh0obe1DrP1Q6PMccb0=;
	h=Date:To:From:Subject:Message-Id; b=aTR3p+SysWqdbEyBgONOIwNucgMBKrAD9N0bKdTPEAIzAVHQ/pOZAUSe0O4tXsj4slPER6YeKGD1QbCFafD7eZCPsCEwm/VJtVSCQsXvMakieCayRiRHODSrovEafaOnB8+kCXDO3+NM46/0nqU33q9LtrhZ06/kJtFfShU+eTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uvLXHHaA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uvLXHHaA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4743C4CEE6;
	Tue, 18 Feb 2025 03:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739850859;
	bh=LPa/XAGseyKyUj+qEyGegV0VIh0obe1DrP1Q6PMccb0=;
	h=Date:To:From:Subject:From;
	b=uvLXHHaAjvyE34qIhHqQ9FSwREeR05+G3q5yN6arY8x9A+oG9mYJhlzJWwiFXL1g3
	 ko2ew+AoNPtfdJSMa34bQ1Bo6T0DjVwj1m35tYfpx/7GoQTv1mkM4jfx+JIEffo7Op
	 FSpwCfzLVFETbrixmfP07YIG6UwHHcHJfJKzgXtc=
Date: Mon, 17 Feb 2025 19:54:19 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,steven.price@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,maddy@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,corbet@lwn.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-arm64-drop-ptdump-config-options-from-ptdumprst.patch added to mm-unstable branch
Message-Id: <20250218035419.A4743C4CEE6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs: arm64: drop PTDUMP config options from ptdump.rst
has been added to the -mm mm-unstable branch.  Its filename is
     docs-arm64-drop-ptdump-config-options-from-ptdumprst.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-arm64-drop-ptdump-config-options-from-ptdumprst.patch

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
Subject: docs: arm64: drop PTDUMP config options from ptdump.rst
Date: Mon, 17 Feb 2025 09:52:18 +0530

Both GENERIC_PTDUMP and PTDUMP_CORE are not user selectable config
options.  Just drop these from documentation.

Link: https://lkml.kernel.org/r/20250217042220.32920-4-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Suggested-by: Steven Price <steven.price@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/arch/arm64/ptdump.rst |    2 --
 1 file changed, 2 deletions(-)

--- a/Documentation/arch/arm64/ptdump.rst~docs-arm64-drop-ptdump-config-options-from-ptdumprst
+++ a/Documentation/arch/arm64/ptdump.rst
@@ -22,8 +22,6 @@ offlining of memory being accessed by th
 In order to dump the kernel page tables, enable the following
 configurations and mount debugfs::
 
- CONFIG_GENERIC_PTDUMP=y
- CONFIG_PTDUMP_CORE=y
  CONFIG_PTDUMP_DEBUGFS=y
 
  mount -t debugfs nodev /sys/kernel/debug
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

configs-drop-generic_ptdump-from-debugconfig.patch
arch-powerpc-drop-generic_ptdump-from-mpc885_ads_defconfig.patch
docs-arm64-drop-ptdump-config-options-from-ptdumprst.patch
mm-make-debug_wx-depdendent-on-generic_ptdump.patch
mm-rename-generic_ptdump-and-ptdump_core.patch

