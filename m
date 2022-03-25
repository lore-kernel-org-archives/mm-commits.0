Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4765CC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355477AbiCYBha (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357518AbiCYBf5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D34D3980A
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:34:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50E8FB8272F
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4CBC340EC;
        Fri, 25 Mar 2022 01:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172048;
        bh=FauNymN4EWcPtTyAntuCPZeTa54AiRe3a3ZAq3OQumk=;
        h=Date:To:From:Subject:From;
        b=P3XleOdElEVZyOO4BISXOWMQa6Sy7RR4blDcyaW2RMqtWzfE5n8vilRSo2BaO4LIE
         Ps26dY2Ykw8m71I7naSg+ALDpQilbWTDyNl7oZWEf5R8/pVmcXvWR60/BYhksYWmz0
         D4HHngR0H2QLTr469hkj2FbwrUB4PN3SQ9BDEs9A=
Date:   Thu, 24 Mar 2022 18:34:07 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, tglx@linutronix.de,
        rmk+kernel@armlinux.org.uk, paul.walmsley@sifive.com,
        palmer@rivosinc.com, palmer@dabbelt.com, mingo@redhat.com,
        linux@armlinux.org.uk, hpa@zytor.com, ebiederm@xmission.com,
        dave.hansen@linux.intel.com, catalin.marinas@arm.com, bp@alien8.de,
        bhe@redhat.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
        jszhang@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] arm64-mm-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch removed from -mm tree
Message-Id: <20220325013407.EA4CBC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: mm: use IS_ENABLED(CONFIG_KEXEC_CORE) instead of #ifdef
has been removed from the -mm tree.  Its filename was
     arm64-mm-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jisheng Zhang <jszhang@kernel.org>
Subject: arm64: mm: use IS_ENABLED(CONFIG_KEXEC_CORE) instead of #ifdef

Replace the conditional compilation using "#ifdef CONFIG_KEXEC_CORE" by a
check for "IS_ENABLED(CONFIG_KEXEC_CORE)", to simplify the code and
increase compile coverage.

Link: https://lkml.kernel.org/r/20211206160514.2000-5-jszhang@kernel.org
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/init.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/arch/arm64/mm/init.c~arm64-mm-use-is_enabledconfig_kexec_core-instead-of-ifdef
+++ a/arch/arm64/mm/init.c
@@ -64,7 +64,6 @@ EXPORT_SYMBOL(memstart_addr);
  */
 phys_addr_t arm64_dma_phys_limit __ro_after_init;
 
-#ifdef CONFIG_KEXEC_CORE
 /*
  * reserve_crashkernel() - reserves memory for crash kernel
  *
@@ -78,6 +77,9 @@ static void __init reserve_crashkernel(v
 	unsigned long long crash_max = arm64_dma_phys_limit;
 	int ret;
 
+	if (!IS_ENABLED(CONFIG_KEXEC_CORE))
+		return;
+
 	ret = parse_crashkernel(boot_command_line, memblock_phys_mem_size(),
 				&crash_size, &crash_base);
 	/* no crashkernel= or invalid value specified */
@@ -110,11 +112,6 @@ static void __init reserve_crashkernel(v
 	crashk_res.start = crash_base;
 	crashk_res.end = crash_base + crash_size - 1;
 }
-#else
-static void __init reserve_crashkernel(void)
-{
-}
-#endif /* CONFIG_KEXEC_CORE */
 
 /*
  * Return the maximum physical address for a zone accessible by the given bits
_

Patches currently in -mm which might be from jszhang@kernel.org are


