Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5491DDF4
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 04:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723523801; cv=none; b=tyaVPMgiocVjxtJ5jDxqRiL9ly+fwqa/VDNHHabpHmxW9Z4LNbn1dUCXdMJl1IthtwHXKK3HF/1V9FaEBHpxUN5SMwsAB9Ia9eafUMbAxek10PsyRns/e5lbUPPgserKJZpbmQ+SeGOK8Z+r7r+NX88mj/XMNUVNWAy2HvfgNIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723523801; c=relaxed/simple;
	bh=R4xrSAsYF2+zgaOSa3PHY9mvzoN03a4QYYlRV9L/PHg=;
	h=Date:To:From:Subject:Message-Id; b=oXMbwrmrSe3FreI7CH+t+diFIZWAyrvoJrf7z79kK4PdFeqoA/hiq8+LCJT1m5TpeGrewpWs5ZqN32sc/IZ2ai40qvCWazzHg3nroMyEJWvHtwK+PtwGy4ax8mIqVXdAlCQTh/JaMJ+PeFOVNpeVInLa0fnGPumAU/DNFGJQSoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZsvHBsHT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZsvHBsHT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08C9C4AF09;
	Tue, 13 Aug 2024 04:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723523800;
	bh=R4xrSAsYF2+zgaOSa3PHY9mvzoN03a4QYYlRV9L/PHg=;
	h=Date:To:From:Subject:From;
	b=ZsvHBsHTXmOBAh1fsOCohZHXC1l2VKbsGSU9Sp/3/JxRb4dAdiEDabtMGVbUK5HIj
	 P3ZWJqzCyd4eMl4h2WJew8twRZTUAI8hFAA0j7L4IMJ4FpmnEwLP8LBwZ+v4FI9WST
	 0Z9HrkY8xEZSKYWB7fbAUgV9KWJVyGm4hL4Q4DUU=
Date: Mon, 12 Aug 2024 21:36:40 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vgoyal@redhat.com,thunder.leizhen@huawei.com,tglx@linutronix.de,tangyouling@kylinos.cn,robh@kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mingo@redhat.com,linux@armlinux.org.uk,linus.walleij@linaro.org,kernel@xen0n.name,javierm@redhat.com,hpa@zytor.com,hbathini@linux.ibm.com,gregkh@linuxfoundation.org,eric.devolder@oracle.com,dyoung@redhat.com,deller@gmx.de,dave.hansen@linux.intel.com,chenjiahao16@huawei.com,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,bhe@redhat.com,arnd@arndb.de,aou@eecs.berkeley.edu,afd@ti.com,ruanjinjie@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] crash-fix-x86_32-crash-memory-reserve-dead-loop.patch removed from -mm tree
Message-Id: <20240813043640.B08C9C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crash: fix x86_32 crash memory reserve dead loop
has been removed from the -mm tree.  Its filename was
     crash-fix-x86_32-crash-memory-reserve-dead-loop.patch

This patch was dropped because an updated version will be issued

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

crash-fix-riscv64-crash-memory-reserve-dead-loop-v2.patch
arm-use-generic-interface-to-simplify-crashkernel-reservation.patch
crash-fix-crash-memory-reserve-exceed-system-memory-bug.patch

