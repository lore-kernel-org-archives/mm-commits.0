Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56D16C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357505AbiCYBhS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357511AbiCYBf4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFC2381A6
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:34:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E94860A75
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:34:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A121BC340EC;
        Fri, 25 Mar 2022 01:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172045;
        bh=B3WiiDdDEUxlod2nqmLK8S97qmqf3Z5S2/XBDmVUzBg=;
        h=Date:To:From:Subject:From;
        b=Eb4RGYkucvHTEP5jqRNj3Foh3+6UovlAwYQYCT3xa2JpjgRfMxR11QYezv/cXVnYc
         NMwavblaXY0i6zSg3DTlfAi6urvhkJ9PiLiBwLrNrRSASQIotq5PnkArceED8s8oO7
         /lM94F8oVyoly3VGfZpLhpEesdmMVD2lgQTyWa2w=
Date:   Thu, 24 Mar 2022 18:34:05 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, tglx@linutronix.de,
        rmk+kernel@armlinux.org.uk, paul.walmsley@sifive.com,
        palmer@rivosinc.com, palmer@dabbelt.com, mingo@redhat.com,
        linux@armlinux.org.uk, hpa@zytor.com, ebiederm@xmission.com,
        dave.hansen@linux.intel.com, catalin.marinas@arm.com, bp@alien8.de,
        bhe@redhat.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
        jszhang@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] riscv-mm-init-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch removed from -mm tree
Message-Id: <20220325013405.A121BC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: riscv: mm: init: use IS_ENABLED(CONFIG_KEXEC_CORE) instead of #ifdef
has been removed from the -mm tree.  Its filename was
     riscv-mm-init-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -957,7 +957,6 @@ static inline void setup_vm_final(void)
 }
 #endif /* CONFIG_MMU */
 
-#ifdef CONFIG_KEXEC_CORE
 /*
  * reserve_crashkernel() - reserves memory for crash kernel
  *
@@ -974,6 +973,8 @@ static void __init reserve_crashkernel(v
 
 	int ret = 0;
 
+	if (!IS_ENABLED(CONFIG_KEXEC_CORE))
+		return;
 	/*
 	 * Don't reserve a region for a crash kernel on a crash kernel
 	 * since it doesn't make much sense and we have limited memory
@@ -1023,7 +1024,6 @@ static void __init reserve_crashkernel(v
 	crashk_res.start = crash_base;
 	crashk_res.end = crash_base + crash_size - 1;
 }
-#endif /* CONFIG_KEXEC_CORE */
 
 void __init paging_init(void)
 {
@@ -1037,9 +1037,7 @@ void __init misc_mem_init(void)
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


