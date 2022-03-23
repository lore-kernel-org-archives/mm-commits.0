Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5EA5C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 23:06:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345435AbiCWXI0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 19:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234935AbiCWXIJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 19:08:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864539027C
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 16:06:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31142B82183
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 23:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E557BC340F7;
        Wed, 23 Mar 2022 23:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648076797;
        bh=+YGftbqbU90b8j5fQHsfgsfEMHcpmMhQkMql1qawrEo=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=MoVRwHLAeamjs5j1Md+cNU+tuxEGEOJcqyODri+BPRcxb29fMBcV1NvaxyYf8PiO5
         ynXHbBFeq5z0yFUc2vbNuDjAeEa/QDjNr8xtN0zQdVc8deUiSyWveFYB439gkfZmnj
         jM1t2ALQbUxVqRtuyNl6zlrY12Kfl+szhXqleWPE=
Date:   Wed, 23 Mar 2022 16:06:36 -0700
To:     will@kernel.org, tglx@linutronix.de, rmk+kernel@armlinux.org.uk,
        paul.walmsley@sifive.com, palmer@rivosinc.com, palmer@dabbelt.com,
        mingo@redhat.com, linux@armlinux.org.uk, hpa@zytor.com,
        ebiederm@xmission.com, dave.hansen@linux.intel.com,
        catalin.marinas@arm.com, bp@alien8.de, bhe@redhat.com,
        aou@eecs.berkeley.edu, alex@ghiti.fr, jszhang@kernel.org,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 26/41] riscv: mm: init: use IS_ENABLED(CONFIG_KEXEC_CORE) instead of #ifdef
Message-Id: <20220323230636.E557BC340F7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
