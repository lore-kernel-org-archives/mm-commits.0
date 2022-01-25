Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7E5BC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jan 2022 06:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245126AbiAYGVF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jan 2022 01:21:05 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59828 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244197AbiAYGSD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jan 2022 01:18:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 043BC6091F
        for <mm-commits@vger.kernel.org>; Tue, 25 Jan 2022 06:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A14FC340E0;
        Tue, 25 Jan 2022 06:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643091479;
        bh=YJgNZiOs5fCFkb3QXPWBfFI/re19le6GkXt9rWSbbYg=;
        h=Date:From:To:Subject:From;
        b=LaSUoND7efxbZjflNkX299NUptNcg28PgWrrD8L6PtBQiuhCB27kqIQ3MoAAalrlO
         tVD9MPCoOhktEyCKGkQFm/FEkR604GhhxzRihY5Zn6ldX2LBAnXJbeN+k+jjIMmIi0
         aPQUeqMXFhsBAvP1XEoVhgD4XotQWNzVDG65IZ90=
Date:   Mon, 24 Jan 2022 22:17:57 -0800
From:   akpm@linux-foundation.org
To:     alex@ghiti.fr, aou@eecs.berkeley.edu, bhe@redhat.com, bp@alien8.de,
        catalin.marinas@arm.com, dave.hansen@linux.intel.com,
        ebiederm@xmission.com, hpa@zytor.com, jszhang@kernel.org,
        linux@armlinux.org.uk, mingo@redhat.com,
        mm-commits@vger.kernel.org, palmer@dabbelt.com,
        palmer@rivosinc.com, paul.walmsley@sifive.com,
        rmk+kernel@armlinux.org.uk, tglx@linutronix.de, will@kernel.org
Subject:  +
 arm-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch added to -mm
 tree
Message-ID: <20220125061757.TRb3SZR-M%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm: use IS_ENABLED(CONFIG_KEXEC_CORE) instead of #ifdef
has been added to the -mm tree.  Its filename is
     arm-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
arm-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch

