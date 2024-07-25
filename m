Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527AB210F8
	for <mm-commits@vger.kernel.org>; Thu, 25 Jul 2024 21:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721944195; cv=none; b=PEDcNYRMRcPnRARDXHY7BEOwMZUlrv6o4wPCvWqf/0MhgZqVGEyZzw/9TozEsBnMtW5k3FuRsSTqFmDU2GgxN3SLS4f8Gs2PiCilO1uxSJXgvm599yGnigALJgU5tgCUrR4xrHSqNUA/C7++wjEDLQNgNig3L2YWAMzLnJ/GrU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721944195; c=relaxed/simple;
	bh=OWnhN3G+ounNTGrs2g7PfzLUiicEhOAWxhnzwRRlB64=;
	h=Date:To:From:Subject:Message-Id; b=VxedEVEqaeu/Y4Ay3ofxz9wQiOyyxFTLSOJ6dPU/B5jCVeOWwXDu58xX76UFi5DwQfRE79tr/l4Ng6K+ASYIQj+95JtGsOcS/i1Weo3izbSRHSMlVrWvjF3YgWfzhaQ8yQ/h7RaSIcg/8EQSCF3pPXGCsTMhRPOVEJyMqXzuoAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=18YDbUh5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="18YDbUh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5492C116B1;
	Thu, 25 Jul 2024 21:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721944194;
	bh=OWnhN3G+ounNTGrs2g7PfzLUiicEhOAWxhnzwRRlB64=;
	h=Date:To:From:Subject:From;
	b=18YDbUh5RGe2ROrihPSB6a7dHJYdZOc6JLtDjsarolewWJHdJVRijxu82wWJzBiSf
	 PTqE32zSHlWLwJlQMSfIg/IS0831c9qivL6+mNwp5mOmhgH2DcZVTh4wTYI2GWMwQp
	 Ll6LzcUmLLdFx4ybE0DVVsWLaurxZa46vHr/dpjY=
Date: Thu, 25 Jul 2024 14:49:54 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vgoyal@redhat.com,thunder.leizhen@huawei.com,tglx@linutronix.de,tangyouling@kylinos.cn,robh@kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mingo@redhat.com,linux@armlinux.org.uk,linus.walleij@linaro.org,kernel@xen0n.name,javierm@redhat.com,hpa@zytor.com,hbathini@linux.ibm.com,gregkh@linuxfoundation.org,eric.devolder@oracle.com,dyoung@redhat.com,deller@gmx.de,dave.hansen@linux.intel.com,chenjiahao16@huawei.com,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,bhe@redhat.com,arnd@arndb.de,aou@eecs.berkeley.edu,afd@ti.com,ruanjinjie@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash-fix-x86_32-crash-memory-reserve-dead-loop.patch added to mm-nonmm-unstable branch
Message-Id: <20240725214954.B5492C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash: fix x86_32 crash memory reserve dead loop
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash-fix-x86_32-crash-memory-reserve-dead-loop.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash-fix-x86_32-crash-memory-reserve-dead-loop.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Jinjie Ruan <ruanjinjie@huawei.com>
Subject: crash: fix x86_32 crash memory reserve dead loop
Date: Fri, 19 Jul 2024 17:57:34 +0800

On x86_32 Qemu machine with 1GB memory, the cmdline "crashkernel=512M"
will also cause system stall as below:

	ACPI: Reserving FACP table memory at [mem 0x3ffe18b8-0x3ffe192b]
	ACPI: Reserving DSDT table memory at [mem 0x3ffe0040-0x3ffe18b7]
	ACPI: Reserving FACS table memory at [mem 0x3ffe0000-0x3ffe003f]
	ACPI: Reserving APIC table memory at [mem 0x3ffe192c-0x3ffe19bb]
	ACPI: Reserving HPET table memory at [mem 0x3ffe19bc-0x3ffe19f3]
	ACPI: Reserving WAET table memory at [mem 0x3ffe19f4-0x3ffe1a1b]
	143MB HIGHMEM available.
	879MB LOWMEM available.
	  mapped low ram: 0 - 36ffe000
	  low ram: 0 - 36ffe000
	  (stall here)

The reason is that the CRASH_ADDR_LOW_MAX is equal to CRASH_ADDR_HIGH_MAX
on x86_32, the first "low" crash kernel memory reservation for 512M fails,
then it go into the "retry" loop and never came out as below (consider
CRASH_ADDR_LOW_MAX = CRASH_ADDR_HIGH_MAX = 512M):

-> reserve_crashkernel_generic() and high is false
   -> alloc at [0, 0x20000000] fail
      -> alloc at [0x20000000, 0x20000000] fail and repeatedly
      (because CRASH_ADDR_LOW_MAX = CRASH_ADDR_HIGH_MAX).

Fix it by skipping meaningless calls of memblock_phys_alloc_range() with
`start = end`

After this patch, the retry dead loop is avoided and we print the below info:
	cannot allocate crashkernel (size:0x20000000)

And we will be ready to apply the generic crashkernel reservation to
32bit systems.

Link: https://lkml.kernel.org/r/20240719095735.1912878-3-ruanjinjie@huawei.com
Fixes: 9c08a2a139fe ("x86: kdump: use generic interface to simplify crashkernel reservation code")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Suggested-by: Baoquan He <bhe@redhat.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Andrew Davis <afd@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen Jiahao <chenjiahao16@huawei.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Eric DeVolder <eric.devolder@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Rob Herring (Arm) <robh@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Cc: Youling Tang <tangyouling@kylinos.cn>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_reserve.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/crash_reserve.c~crash-fix-x86_32-crash-memory-reserve-dead-loop
+++ a/kernel/crash_reserve.c
@@ -413,7 +413,8 @@ retry:
 			search_end = CRASH_ADDR_HIGH_MAX;
 			search_base = CRASH_ADDR_LOW_MAX;
 			crash_low_size = DEFAULT_CRASH_KERNEL_LOW_SIZE;
-			goto retry;
+			if (search_base != search_end)
+				goto retry;
 		}
 
 		/*
_

Patches currently in -mm which might be from ruanjinjie@huawei.com are

crash-fix-x86_32-crash-memory-reserve-dead-loop-bug.patch
crash-fix-x86_32-crash-memory-reserve-dead-loop.patch
arm-use-generic-interface-to-simplify-crashkernel-reservation.patch

