Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB9F2572;
	Wed, 24 Jul 2024 05:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721799450; cv=none; b=LaYMYv43c9wOvhbPJjwLckd6HZsunt6z7BsJpwFtVTxyfoq7UT/mOROEevOWA1hgghDATuJC5dM5xEzbm86bWpGZ0qk6i/i4OfPwUFWIqmqc7xl1A1Ee0JUEDnmix+iXjTNx7LZPk4ioKCFdd4ALaAUGG//JsH0XG0buwuNbMgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721799450; c=relaxed/simple;
	bh=MGKgHD/OE58tQ4rPCaykkKNJ9dxTuVo5pFk3AWkXGFw=;
	h=Date:To:From:Subject:Message-Id; b=FlDLszHLuBgolsPGnPLYgQkW414llWFDqVUfK3LzoR4vK61McEq+O4KT+F9S45Do5ZVJEnvQbinjmuVcevGQx0Q5fZoJKrf4q7Pl1ZiypQ1KqzY4dW3/VO1v9esYej3oZ/UREzxdGBTrqfZdMYqpsQqkK1Mqskvby9OtlOsJXCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oYv7Ocsj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oYv7Ocsj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E352C32782;
	Wed, 24 Jul 2024 05:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721799450;
	bh=MGKgHD/OE58tQ4rPCaykkKNJ9dxTuVo5pFk3AWkXGFw=;
	h=Date:To:From:Subject:From;
	b=oYv7OcsjhQf+XpJo7fse6wncENBPU6r8yiyXirFUUlgvp/CayIvUpTu3BOOQsKLqJ
	 k82Zj8GZ9V2jeSUVUk92R76/ql0g6hmfKXl4LnJRAD2am/4nrLkt5oUXQgBZmEhHQB
	 ojazt9QowBW97eRuBzJILAM84ln16V44jJ4BKNwk=
Date: Tue, 23 Jul 2024 22:37:30 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vgoyal@redhat.com,thunder.leizhen@huawei.com,tglx@linutronix.de,stable@vger.kernel.org,robh@kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mingo@redhat.com,linux@armlinux.org.uk,linus.walleij@linaro.org,javierm@redhat.com,hpa@zytor.com,hbathini@linux.ibm.com,gregkh@linuxfoundation.org,eric.devolder@oracle.com,dyoung@redhat.com,deller@gmx.de,dave.hansen@linux.intel.com,chenjiahao16@huawei.com,catalin.marinas@arm.com,bp@alien8.de,bhe@redhat.com,arnd@arndb.de,aou@eecs.berkeley.edu,afd@ti.com,ruanjinjie@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash-fix-x86_32-crash-memory-reserve-dead-loop-bug-at-high.patch added to mm-nonmm-unstable branch
Message-Id: <20240724053730.7E352C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash: fix x86_32 crash memory reserve dead loop bug at high
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash-fix-x86_32-crash-memory-reserve-dead-loop-bug-at-high.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash-fix-x86_32-crash-memory-reserve-dead-loop-bug-at-high.patch

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
Subject: crash: fix x86_32 crash memory reserve dead loop bug at high
Date: Thu, 18 Jul 2024 11:54:43 +0800

On x86_32 Qemu machine with 1GB memory, the cmdline "crashkernel=512M" will
also cause system stall as below:

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

After this patch, the retry dead loop is avoided and print below info:
	cannot allocate crashkernel (size:0x20000000)

And apply generic crashkernel reservation to 32bit system will be ready.

Link: https://lkml.kernel.org/r/20240718035444.2977105-3-ruanjinjie@huawei.com
Fixes: 9c08a2a139fe ("x86: kdump: use generic interface to simplify crashkernel reservation code")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Baoquan He <bhe@redhat.com>
Tested-by: Jinjie Ruan <ruanjinjie@huawei.com>
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
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_reserve.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/crash_reserve.c~crash-fix-x86_32-crash-memory-reserve-dead-loop-bug-at-high
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
crash-fix-x86_32-crash-memory-reserve-dead-loop-bug-at-high.patch
arm-use-generic-interface-to-simplify-crashkernel-reservation.patch

