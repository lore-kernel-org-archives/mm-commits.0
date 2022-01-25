Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 372A9C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jan 2022 06:20:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245045AbiAYGUx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jan 2022 01:20:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54634 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244150AbiAYGRy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jan 2022 01:17:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BF0EB816B3
        for <mm-commits@vger.kernel.org>; Tue, 25 Jan 2022 06:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E688C340E0;
        Tue, 25 Jan 2022 06:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643091470;
        bh=a9L6RF9jys4OLdZ+JwQlr9pKNQA0XUzq7DK4ZOtaBPA=;
        h=Date:From:To:Subject:From;
        b=JO0ptCG4yuSEbGbimcHccuehhCSTJ8zSiA1ugybnv/pcId2wpQn5jtKbnk5fcNhhU
         6bsV4SomUWcy8lNKVgCqJPs66F5YjkFdzQ3WgdF1GjMP7uaXTbDuL+7f3aNWFx9xd3
         NILEwnN2H9iKL8JeyLFwiZgDbO8H4hBYW1lLsH+4=
Date:   Mon, 24 Jan 2022 22:17:48 -0800
From:   akpm@linux-foundation.org
To:     alex@ghiti.fr, aou@eecs.berkeley.edu, bhe@redhat.com, bp@alien8.de,
        catalin.marinas@arm.com, dave.hansen@linux.intel.com,
        ebiederm@xmission.com, hpa@zytor.com, jszhang@kernel.org,
        linux@armlinux.org.uk, mingo@redhat.com,
        mm-commits@vger.kernel.org, palmer@dabbelt.com,
        palmer@rivosinc.com, paul.walmsley@sifive.com,
        rmk+kernel@armlinux.org.uk, tglx@linutronix.de, will@kernel.org
Subject:  +
 riscv-mm-init-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch added
 to -mm tree
Message-ID: <20220125061748.PDTBik78W%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: riscv: mm: init: use IS_ENABLED(CONFIG_KEXEC_CORE) instead of #ifdef
has been added to the -mm tree.  Its filename is
     riscv-mm-init-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/riscv-mm-init-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/riscv-mm-init-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch

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
Subject: riscv: mm: init: use IS_ENABLED(CONFIG_KEXEC_CORE) instead of #ifdef

Replace the conditional compilation using "#ifdef CONFIG_KEXEC_CORE" by a
check for "IS_ENABLED(CONFIG_KEXEC_CORE)", to simplify the code and
increase compile coverage.

Link: https://lkml.kernel.org/r/20211206160514.2000-3-jszhang@kernel.org
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
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
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/mm/init.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/arch/riscv/mm/init.c~riscv-mm-init-use-is_enabledconfig_kexec_core-instead-of-ifdef
+++ a/arch/riscv/mm/init.c
@@ -955,7 +955,6 @@ static inline void setup_vm_final(void)
 }
 #endif /* CONFIG_MMU */
 
-#ifdef CONFIG_KEXEC_CORE
 /*
  * reserve_crashkernel() - reserves memory for crash kernel
  *
@@ -972,6 +971,8 @@ static void __init reserve_crashkernel(v
 
 	int ret = 0;
 
+	if (!IS_ENABLED(CONFIG_KEXEC_CORE))
+		return;
 	/*
 	 * Don't reserve a region for a crash kernel on a crash kernel
 	 * since it doesn't make much sense and we have limited memory
@@ -1021,7 +1022,6 @@ static void __init reserve_crashkernel(v
 	crashk_res.start = crash_base;
 	crashk_res.end = crash_base + crash_size - 1;
 }
-#endif /* CONFIG_KEXEC_CORE */
 
 void __init paging_init(void)
 {
@@ -1035,9 +1035,7 @@ void __init misc_mem_init(void)
 	arch_numa_init();
 	sparse_init();
 	zone_sizes_init();
-#ifdef CONFIG_KEXEC_CORE
 	reserve_crashkernel();
-#endif
 	memblock_dump_all();
 }
 
_

Patches currently in -mm which might be from jszhang@kernel.org are

kexec-make-crashk_res-crashk_low_res-and-crash_notes-symbols-always-visible.patch
riscv-mm-init-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch
x86-setup-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch
arm64-mm-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch
arm-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch

