Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DCD178381
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 04:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723523799; cv=none; b=XkdnG4idWm0Bf5i9UHgys3Luy+2kB/B7jObNL6r7t3aDEIEpHpWkle/f3U6tgKhP3UaYQdxkmC65y5QgEPhOmTqZFNpj2uHCYXyq6taVK6qbqe6NpSYqDcZ58DGHihKZzT7c55BPSpOdvtfB/yQlwMUh/jg6rhyjYbwKKSZ3vXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723523799; c=relaxed/simple;
	bh=V17weZbTg5hVamEcgkisV/nARYgyiuA2DdpSUXivxSQ=;
	h=Date:To:From:Subject:Message-Id; b=bqKfEM39cNK2EQYA3UpBdiGIZTMUAbJEdOAzrPgOGme+LIFvU+g32dB59peHwMKq+qo7LvMsHiHEPYMtXNalGTkJaLjiEbXNAaRS1lnBnzCwST+BA6JvIB2AVoRcpqLwdMHwMmb9RuYY8DJfKBIABQB3jyDJz5CKeBPi/CmtXZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0C5YE6rV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0C5YE6rV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57C7C4AF0B;
	Tue, 13 Aug 2024 04:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723523798;
	bh=V17weZbTg5hVamEcgkisV/nARYgyiuA2DdpSUXivxSQ=;
	h=Date:To:From:Subject:From;
	b=0C5YE6rVSrfCWl0g7wWYR406OioZpVXv8/Ln/3Y15BpTJQzfv+FioGP0EEmw0r9B1
	 FWHadFUJXw5wPtB5dGInAxSqY09aTiOooyL0l6iGpfwGRb5c6hna/JeDg/uWAMZyAn
	 OZKXdg5Rl8C/pROgXBGsaoZChvxAWw5PN/EhWSJU=
Date: Mon, 12 Aug 2024 21:36:38 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vgoyal@redhat.com,thunder.leizhen@huawei.com,tglx@linutronix.de,tangyouling@kylinos.cn,robh@kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mingo@redhat.com,linux@armlinux.org.uk,linus.walleij@linaro.org,kernel@xen0n.name,javierm@redhat.com,hpa@zytor.com,hbathini@linux.ibm.com,gregkh@linuxfoundation.org,eric.devolder@oracle.com,dyoung@redhat.com,deller@gmx.de,dave.hansen@linux.intel.com,chenjiahao16@huawei.com,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,bhe@redhat.com,arnd@arndb.de,aou@eecs.berkeley.edu,afd@ti.com,ruanjinjie@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] crash-fix-x86_32-crash-memory-reserve-dead-loop-bug.patch removed from -mm tree
Message-Id: <20240813043638.D57C7C4AF0B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crash: fix x86_32 crash memory reserve dead loop bug
has been removed from the -mm tree.  Its filename was
     crash-fix-x86_32-crash-memory-reserve-dead-loop-bug.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Jinjie Ruan <ruanjinjie@huawei.com>
Subject: crash: fix x86_32 crash memory reserve dead loop bug
Date: Fri, 19 Jul 2024 17:57:33 +0800

Patch series "crash: Fix x86_32 memory reserve dead loop bug", v4.

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

Fix it by prevent crashkernel=,high from being parsed successfully on
32bit system with a architecture-defined macro.

After this patch, the 'crashkernel=,high' for 32bit system can't succeed,
and it has no chance to call reserve_crashkernel_generic(), therefore this
issue on x86_32 is solved.

Link: https://lkml.kernel.org/r/20240719095735.1912878-1-ruanjinjie@huawei.com
Link: https://lkml.kernel.org/r/20240719095735.1912878-2-ruanjinjie@huawei.com
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

 arch/arm64/include/asm/crash_reserve.h     |    2 ++
 arch/loongarch/include/asm/crash_reserve.h |    2 ++
 arch/riscv/include/asm/crash_reserve.h     |    4 ++++
 arch/x86/include/asm/crash_reserve.h       |    1 +
 kernel/crash_reserve.c                     |    2 +-
 5 files changed, 10 insertions(+), 1 deletion(-)

--- a/arch/arm64/include/asm/crash_reserve.h~crash-fix-x86_32-crash-memory-reserve-dead-loop-bug
+++ a/arch/arm64/include/asm/crash_reserve.h
@@ -7,4 +7,6 @@
 
 #define CRASH_ADDR_LOW_MAX              arm64_dma_phys_limit
 #define CRASH_ADDR_HIGH_MAX             (PHYS_MASK + 1)
+
+#define HAVE_ARCH_CRASHKERNEL_RESERVATION_HIGH
 #endif
--- a/arch/loongarch/include/asm/crash_reserve.h~crash-fix-x86_32-crash-memory-reserve-dead-loop-bug
+++ a/arch/loongarch/include/asm/crash_reserve.h
@@ -7,6 +7,8 @@
 #define CRASH_ADDR_LOW_MAX		SZ_4G
 #define CRASH_ADDR_HIGH_MAX		memblock_end_of_DRAM()
 
+#define HAVE_ARCH_CRASHKERNEL_RESERVATION_HIGH
+
 extern phys_addr_t memblock_end_of_DRAM(void);
 
 #endif
--- a/arch/riscv/include/asm/crash_reserve.h~crash-fix-x86_32-crash-memory-reserve-dead-loop-bug
+++ a/arch/riscv/include/asm/crash_reserve.h
@@ -7,5 +7,9 @@
 #define CRASH_ADDR_LOW_MAX		dma32_phys_limit
 #define CRASH_ADDR_HIGH_MAX		memblock_end_of_DRAM()
 
+#ifdef CONFIG_64BIT
+#define HAVE_ARCH_CRASHKERNEL_RESERVATION_HIGH
+#endif
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

crash-fix-riscv64-crash-memory-reserve-dead-loop-v2.patch
crash-fix-x86_32-crash-memory-reserve-dead-loop.patch
arm-use-generic-interface-to-simplify-crashkernel-reservation.patch
crash-fix-crash-memory-reserve-exceed-system-memory-bug.patch

