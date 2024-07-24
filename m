Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73162572;
	Wed, 24 Jul 2024 05:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721799447; cv=none; b=M9Ei4i/HWXDhzWy3HVC8LeEDd5UeMjTdpfGJpVCBiJtMpvVs7lXCzNW6RcjGGT0IYK8+AwCpnReA1lCch24aw+9oiRa7seO9WqiSsR+MvbPGSiCg8NUt1dX5Yyy4lpeYUdgGrjUCmzvtpPXGAsPuUpiq6mHCLWWXGy7YWBWntvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721799447; c=relaxed/simple;
	bh=ta8HIUpyF8zmGHCwOhHHL/4hWk6E+FsW9tJFhANgekw=;
	h=Date:To:From:Subject:Message-Id; b=sD/l8z5bdnCypzZkTgXqYR17xykMm0W48FOpFy0nUy/wV2+jnw1AVuXUYGby1M69RcEbcYVeVEp0kQmJK19ntdowYo7LIOk0xKXl8eQBEZp+6Tf1PoyHloyjvAZ7YhYzlHVUszN/m4tBT9XL/SW53jp5oE17ROlk7/V0YkveXqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IXR/tXo9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IXR/tXo9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28397C32782;
	Wed, 24 Jul 2024 05:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721799447;
	bh=ta8HIUpyF8zmGHCwOhHHL/4hWk6E+FsW9tJFhANgekw=;
	h=Date:To:From:Subject:From;
	b=IXR/tXo9ygnoBH5ov3ZmriCXd+bKUAdz6Vq/kZE5cxPOQ5eX3LkGlJfJbw+EH2aor
	 cqYdW0p9wfBJ3y6h6qOZScXub1ShGs0oVoV3RNvJwI1VsogHXFlfBA9LFQH3YC3VnW
	 XfSay2s/QRNvRzXrAwyVA6IwhXXiBTpjvuhJaND8=
Date: Tue, 23 Jul 2024 22:37:26 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vgoyal@redhat.com,thunder.leizhen@huawei.com,tglx@linutronix.de,stable@vger.kernel.org,robh@kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mingo@redhat.com,linux@armlinux.org.uk,linus.walleij@linaro.org,javierm@redhat.com,hpa@zytor.com,hbathini@linux.ibm.com,gregkh@linuxfoundation.org,eric.devolder@oracle.com,dyoung@redhat.com,deller@gmx.de,dave.hansen@linux.intel.com,chenjiahao16@huawei.com,catalin.marinas@arm.com,bp@alien8.de,bhe@redhat.com,arnd@arndb.de,aou@eecs.berkeley.edu,afd@ti.com,ruanjinjie@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash-fix-x86_32-crash-memory-reserve-dead-loop-bug.patch added to mm-nonmm-unstable branch
Message-Id: <20240724053727.28397C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash: fix x86_32 crash memory reserve dead loop bug
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash-fix-x86_32-crash-memory-reserve-dead-loop-bug.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash-fix-x86_32-crash-memory-reserve-dead-loop-bug.patch

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
Subject: crash: fix x86_32 crash memory reserve dead loop bug
Date: Thu, 18 Jul 2024 11:54:42 +0800

Patch series "crash: Fix x86_32 memory reserve dead loop bug", v3.

Fix two bugs for x86_32 crash memory reserve, and prepare to apply generic
crashkernel reservation to 32bit system.  Then use generic interface to
simplify crashkernel reservation for ARM32.


This patch (of 3):

On x86_32 Qemu machine with 1GB memory, the cmdline "crashkernel=1G,high"
will cause system stall as below:

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
on x86_32, the first high crash kernel memory reservation will fail, then
go into the "retry" loop and never came out as below.

-> reserve_crashkernel_generic() and high is true
 -> alloc at [CRASH_ADDR_LOW_MAX, CRASH_ADDR_HIGH_MAX] fail
    -> alloc at [0, CRASH_ADDR_LOW_MAX] fail and repeatedly
       (because CRASH_ADDR_LOW_MAX = CRASH_ADDR_HIGH_MAX).

Fix it by prevent crashkernel=,high from being parsed successfully on 32bit
system with a architecture-defined macro.

After this patch, the 'crashkernel=,high' for 32bit system can't succeed,
and it has no chance to call reserve_crashkernel_generic(), therefore this
issue on x86_32 is solved.

Link: https://lkml.kernel.org/r/20240718035444.2977105-1-ruanjinjie@huawei.com
Link: https://lkml.kernel.org/r/20240718035444.2977105-2-ruanjinjie@huawei.com
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

 arch/arm64/include/asm/crash_reserve.h |    2 ++
 arch/riscv/include/asm/crash_reserve.h |    2 ++
 arch/x86/include/asm/crash_reserve.h   |    1 +
 kernel/crash_reserve.c                 |    2 +-
 4 files changed, 6 insertions(+), 1 deletion(-)

--- a/arch/arm64/include/asm/crash_reserve.h~crash-fix-x86_32-crash-memory-reserve-dead-loop-bug
+++ a/arch/arm64/include/asm/crash_reserve.h
@@ -7,4 +7,6 @@
 
 #define CRASH_ADDR_LOW_MAX              arm64_dma_phys_limit
 #define CRASH_ADDR_HIGH_MAX             (PHYS_MASK + 1)
+
+#define HAVE_ARCH_CRASHKERNEL_RESERVATION_HIGH
 #endif
--- a/arch/riscv/include/asm/crash_reserve.h~crash-fix-x86_32-crash-memory-reserve-dead-loop-bug
+++ a/arch/riscv/include/asm/crash_reserve.h
@@ -7,5 +7,7 @@
 #define CRASH_ADDR_LOW_MAX		dma32_phys_limit
 #define CRASH_ADDR_HIGH_MAX		memblock_end_of_DRAM()
 
+#define HAVE_ARCH_CRASHKERNEL_RESERVATION_HIGH
+
 extern phys_addr_t memblock_end_of_DRAM(void);
 #endif
--- a/arch/x86/include/asm/crash_reserve.h~crash-fix-x86_32-crash-memory-reserve-dead-loop-bug
+++ a/arch/x86/include/asm/crash_reserve.h
@@ -26,6 +26,7 @@ extern unsigned long swiotlb_size_or_def
 #else
 # define CRASH_ADDR_LOW_MAX     SZ_4G
 # define CRASH_ADDR_HIGH_MAX    SZ_64T
+#define HAVE_ARCH_CRASHKERNEL_RESERVATION_HIGH
 #endif
 
 # define DEFAULT_CRASH_KERNEL_LOW_SIZE crash_low_size_default()
--- a/kernel/crash_reserve.c~crash-fix-x86_32-crash-memory-reserve-dead-loop-bug
+++ a/kernel/crash_reserve.c
@@ -305,7 +305,7 @@ int __init parse_crashkernel(char *cmdli
 	/* crashkernel=X[@offset] */
 	ret = __parse_crashkernel(cmdline, system_ram, crash_size,
 				crash_base, NULL);
-#ifdef CONFIG_ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
+#ifdef HAVE_ARCH_CRASHKERNEL_RESERVATION_HIGH
 	/*
 	 * If non-NULL 'high' passed in and no normal crashkernel
 	 * setting detected, try parsing crashkernel=,high|low.
_

Patches currently in -mm which might be from ruanjinjie@huawei.com are

crash-fix-x86_32-crash-memory-reserve-dead-loop-bug.patch
crash-fix-x86_32-crash-memory-reserve-dead-loop-bug-at-high.patch
arm-use-generic-interface-to-simplify-crashkernel-reservation.patch

