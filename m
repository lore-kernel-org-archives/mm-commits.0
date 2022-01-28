Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6968BC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 28 Jan 2022 21:38:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351511AbiA1ViW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Jan 2022 16:38:22 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58942 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351613AbiA1Vhz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jan 2022 16:37:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58702B826FE
        for <mm-commits@vger.kernel.org>; Fri, 28 Jan 2022 21:37:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 698ACC340E7;
        Fri, 28 Jan 2022 21:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643405873;
        bh=CXkSUfrjogxSsxWWc4gLm9+ykUhw9VrFhUcZwsZcGDw=;
        h=Date:From:To:Subject:From;
        b=Qo5pXv5RBEHUidmqC8i6RF8vwQI9AEh7s6zxvGto8oWL//xhAJ29Z0uBUoT68tpmG
         E22cUFYDLlE6FsrCA2I4pG9croSZ+rz2ZwsGspDQrsPXKYnReBCsKEj9E44rRjwTs0
         e5X7g12DkJLHRUFYhp87x760KO+OInE9+kUDuxDk=
Date:   Fri, 28 Jan 2022 13:37:50 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, tglx@linutronix.de,
        sfr@canb.auug.org.au, rmk+kernel@armlinux.org.uk,
        paul.walmsley@sifive.com, palmer@rivosinc.com, palmer@dabbelt.com,
        mingo@redhat.com, linux@armlinux.org.uk, hpa@zytor.com,
        ebiederm@xmission.com, dave.hansen@linux.intel.com,
        catalin.marinas@arm.com, bp@alien8.de, bhe@redhat.com,
        aou@eecs.berkeley.edu, alex@ghiti.fr, jszhang@kernel.org
Subject:  [failures]
 arm-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch removed from -mm
 tree
Message-ID: <20220128213750.MIW5R%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm: use IS_ENABLED(CONFIG_KEXEC_CORE) instead of #ifdef
has been removed from the -mm tree.  Its filename was
     arm-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Jisheng Zhang <jszhang@kernel.org>
Subject: arm: use IS_ENABLED(CONFIG_KEXEC_CORE) instead of #ifdef

Replace the conditional compilation using "#ifdef CONFIG_KEXEC_CORE" by a
check for "IS_ENABLED(CONFIG_KEXEC_CORE)", to simplify the code and
increase compile coverage.

Link: https://lkml.kernel.org/r/20211206160514.2000-6-jszhang@kernel.org
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/setup.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/arch/arm/kernel/setup.c~arm-use-is_enabledconfig_kexec_core-instead-of-ifdef
+++ a/arch/arm/kernel/setup.c
@@ -973,7 +973,6 @@ static int __init init_machine_late(void
 }
 late_initcall(init_machine_late);
 
-#ifdef CONFIG_KEXEC
 /*
  * The crash region must be aligned to 128MB to avoid
  * zImage relocating below the reserved region.
@@ -1001,6 +1000,9 @@ static void __init reserve_crashkernel(v
 	unsigned long long total_mem;
 	int ret;
 
+	if (!IS_ENABLED(CONFIG_KEXEC_CORE))
+		return;
+
 	total_mem = get_total_mem();
 	ret = parse_crashkernel(boot_command_line, total_mem,
 				&crash_size, &crash_base);
@@ -1056,9 +1058,6 @@ static void __init reserve_crashkernel(v
 		insert_resource(&iomem_resource, &crashk_boot_res);
 	}
 }
-#else
-static inline void reserve_crashkernel(void) {}
-#endif /* CONFIG_KEXEC */
 
 void __init hyp_mode_check(void)
 {
_

Patches currently in -mm which might be from jszhang@kernel.org are

kexec-make-crashk_res-crashk_low_res-and-crash_notes-symbols-always-visible.patch
riscv-mm-init-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch
x86-setup-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch
arm64-mm-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch

