Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCC52D030;
	Wed, 24 Jul 2024 06:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721803461; cv=none; b=OBkSvbKsqH7nw7ChCHscJPV6DTOFM4ukUfokySmEIQ4vin5ajSr37xi6lX/1sBPzc/XqDEmiRGbH1fWItiNLySs3Vp1JNxSo6YtWrHjVpeDQFy5wOcNrso2DAZFUHzx+1OrzF6052e3fz2Ps/X7mDfrMM0lWqmsn59AKOSppz9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721803461; c=relaxed/simple;
	bh=R8ZYgkfN7SOS0zuMxrlYUYT78BQBgHfKcQ0wc5czGtc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=eiU9jB3dPCHbvFe2/33j9t9sGFWXerR/QcWAmdqXcEo4YGsSSt+ILmKJ2sANDDFNw7Nzd7kqkwiM0XuYqJ1DR6YS6+SH0+KELqZumf/Ex6HhUrqqL+86FjIJe8mSEK3yqnkeQ4nSWDzBBHRq2O/kUlg3ft/oDZrFjMWrVxRmzJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4WTPX34KwXzQml8;
	Wed, 24 Jul 2024 14:40:03 +0800 (CST)
Received: from kwepemi100008.china.huawei.com (unknown [7.221.188.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 9ACF914035E;
	Wed, 24 Jul 2024 14:44:14 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 kwepemi100008.china.huawei.com (7.221.188.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 24 Jul 2024 14:44:13 +0800
Message-ID: <7898c0c5-45b6-9795-74a0-f70904dd077c@huawei.com>
Date: Wed, 24 Jul 2024 14:44:12 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: + crash-fix-x86_32-crash-memory-reserve-dead-loop-bug.patch added
 to mm-nonmm-unstable branch
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>, <mm-commits@vger.kernel.org>,
	<will@kernel.org>, <vgoyal@redhat.com>, <thunder.leizhen@huawei.com>,
	<tglx@linutronix.de>, <stable@vger.kernel.org>, <robh@kernel.org>,
	<paul.walmsley@sifive.com>, <palmer@dabbelt.com>, <mingo@redhat.com>,
	<linux@armlinux.org.uk>, <linus.walleij@linaro.org>, <javierm@redhat.com>,
	<hpa@zytor.com>, <hbathini@linux.ibm.com>, <gregkh@linuxfoundation.org>,
	<eric.devolder@oracle.com>, <dyoung@redhat.com>, <deller@gmx.de>,
	<dave.hansen@linux.intel.com>, <chenjiahao16@huawei.com>,
	<catalin.marinas@arm.com>, <bp@alien8.de>, <bhe@redhat.com>, <arnd@arndb.de>,
	<aou@eecs.berkeley.edu>, <afd@ti.com>
References: <20240724053727.28397C32782@smtp.kernel.org>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <20240724053727.28397C32782@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi100008.china.huawei.com (7.221.188.57)



On 2024/7/24 13:37, Andrew Morton wrote:
> 
> The patch titled
>      Subject: crash: fix x86_32 crash memory reserve dead loop bug
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      crash-fix-x86_32-crash-memory-reserve-dead-loop-bug.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash-fix-x86_32-crash-memory-reserve-dead-loop-bug.patch
> 
> This patch will later appear in the mm-nonmm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Jinjie Ruan <ruanjinjie@huawei.com>
> Subject: crash: fix x86_32 crash memory reserve dead loop bug
> Date: Thu, 18 Jul 2024 11:54:42 +0800
> 
> Patch series "crash: Fix x86_32 memory reserve dead loop bug", v3.

It seems that the newest is v4, and the loongarch is missing.

> 
> Fix two bugs for x86_32 crash memory reserve, and prepare to apply generic
> crashkernel reservation to 32bit system.  Then use generic interface to
> simplify crashkernel reservation for ARM32.
> 
> 
> This patch (of 3):
> 
> On x86_32 Qemu machine with 1GB memory, the cmdline "crashkernel=1G,high"
> will cause system stall as below:
> 
> 	ACPI: Reserving FACP table memory at [mem 0x3ffe18b8-0x3ffe192b]
> 	ACPI: Reserving DSDT table memory at [mem 0x3ffe0040-0x3ffe18b7]
> 	ACPI: Reserving FACS table memory at [mem 0x3ffe0000-0x3ffe003f]
> 	ACPI: Reserving APIC table memory at [mem 0x3ffe192c-0x3ffe19bb]
> 	ACPI: Reserving HPET table memory at [mem 0x3ffe19bc-0x3ffe19f3]
> 	ACPI: Reserving WAET table memory at [mem 0x3ffe19f4-0x3ffe1a1b]
> 	143MB HIGHMEM available.
> 	879MB LOWMEM available.
> 	  mapped low ram: 0 - 36ffe000
> 	  low ram: 0 - 36ffe000
> 	 (stall here)
> 
> The reason is that the CRASH_ADDR_LOW_MAX is equal to CRASH_ADDR_HIGH_MAX
> on x86_32, the first high crash kernel memory reservation will fail, then
> go into the "retry" loop and never came out as below.
> 
> -> reserve_crashkernel_generic() and high is true
>  -> alloc at [CRASH_ADDR_LOW_MAX, CRASH_ADDR_HIGH_MAX] fail
>     -> alloc at [0, CRASH_ADDR_LOW_MAX] fail and repeatedly
>        (because CRASH_ADDR_LOW_MAX = CRASH_ADDR_HIGH_MAX).
> 
> Fix it by prevent crashkernel=,high from being parsed successfully on 32bit
> system with a architecture-defined macro.
> 
> After this patch, the 'crashkernel=,high' for 32bit system can't succeed,
> and it has no chance to call reserve_crashkernel_generic(), therefore this
> issue on x86_32 is solved.
> 
> Link: https://lkml.kernel.org/r/20240718035444.2977105-1-ruanjinjie@huawei.com
> Link: https://lkml.kernel.org/r/20240718035444.2977105-2-ruanjinjie@huawei.com
> Fixes: 9c08a2a139fe ("x86: kdump: use generic interface to simplify crashkernel reservation code")
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
> Signed-off-by: Baoquan He <bhe@redhat.com>
> Tested-by: Jinjie Ruan <ruanjinjie@huawei.com>
> Cc: Albert Ou <aou@eecs.berkeley.edu>
> Cc: Andrew Davis <afd@ti.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Chen Jiahao <chenjiahao16@huawei.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Dave Young <dyoung@redhat.com>
> Cc: Eric DeVolder <eric.devolder@oracle.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Hari Bathini <hbathini@linux.ibm.com>
> Cc: Helge Deller <deller@gmx.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Javier Martinez Canillas <javierm@redhat.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Palmer Dabbelt <palmer@dabbelt.com>
> Cc: Paul Walmsley <paul.walmsley@sifive.com>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Zhen Lei <thunder.leizhen@huawei.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/arm64/include/asm/crash_reserve.h |    2 ++
>  arch/riscv/include/asm/crash_reserve.h |    2 ++
>  arch/x86/include/asm/crash_reserve.h   |    1 +
>  kernel/crash_reserve.c                 |    2 +-
>  4 files changed, 6 insertions(+), 1 deletion(-)
> 
> --- a/arch/arm64/include/asm/crash_reserve.h~crash-fix-x86_32-crash-memory-reserve-dead-loop-bug
> +++ a/arch/arm64/include/asm/crash_reserve.h
> @@ -7,4 +7,6 @@
>  
>  #define CRASH_ADDR_LOW_MAX              arm64_dma_phys_limit
>  #define CRASH_ADDR_HIGH_MAX             (PHYS_MASK + 1)
> +
> +#define HAVE_ARCH_CRASHKERNEL_RESERVATION_HIGH
>  #endif
> --- a/arch/riscv/include/asm/crash_reserve.h~crash-fix-x86_32-crash-memory-reserve-dead-loop-bug
> +++ a/arch/riscv/include/asm/crash_reserve.h
> @@ -7,5 +7,7 @@
>  #define CRASH_ADDR_LOW_MAX		dma32_phys_limit
>  #define CRASH_ADDR_HIGH_MAX		memblock_end_of_DRAM()
>  
> +#define HAVE_ARCH_CRASHKERNEL_RESERVATION_HIGH
> +
>  extern phys_addr_t memblock_end_of_DRAM(void);
>  #endif
> --- a/arch/x86/include/asm/crash_reserve.h~crash-fix-x86_32-crash-memory-reserve-dead-loop-bug
> +++ a/arch/x86/include/asm/crash_reserve.h
> @@ -26,6 +26,7 @@ extern unsigned long swiotlb_size_or_def
>  #else
>  # define CRASH_ADDR_LOW_MAX     SZ_4G
>  # define CRASH_ADDR_HIGH_MAX    SZ_64T
> +#define HAVE_ARCH_CRASHKERNEL_RESERVATION_HIGH
>  #endif
>  
>  # define DEFAULT_CRASH_KERNEL_LOW_SIZE crash_low_size_default()
> --- a/kernel/crash_reserve.c~crash-fix-x86_32-crash-memory-reserve-dead-loop-bug
> +++ a/kernel/crash_reserve.c
> @@ -305,7 +305,7 @@ int __init parse_crashkernel(char *cmdli
>  	/* crashkernel=X[@offset] */
>  	ret = __parse_crashkernel(cmdline, system_ram, crash_size,
>  				crash_base, NULL);
> -#ifdef CONFIG_ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
> +#ifdef HAVE_ARCH_CRASHKERNEL_RESERVATION_HIGH
>  	/*
>  	 * If non-NULL 'high' passed in and no normal crashkernel
>  	 * setting detected, try parsing crashkernel=,high|low.
> _
> 
> Patches currently in -mm which might be from ruanjinjie@huawei.com are
> 
> crash-fix-x86_32-crash-memory-reserve-dead-loop-bug.patch
> crash-fix-x86_32-crash-memory-reserve-dead-loop-bug-at-high.patch
> arm-use-generic-interface-to-simplify-crashkernel-reservation.patch
> 
