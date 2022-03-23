Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50FADC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 23:06:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241438AbiCWXI0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 19:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345427AbiCWXIZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 19:08:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F53690CD2
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 16:06:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50027B8214D
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 23:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1128CC340E8;
        Wed, 23 Mar 2022 23:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648076800;
        bh=uTtGglfMFY8KfuadzkmhhyVkCyWEjyIGAIi60j44qkY=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=NSYNVSw+Lb8GBq9toDSddF3tevOIMyBfvAW7i4wC2zyj2b0qOx7X45RM4UjjwdRCg
         Yd/qgNY7quW1pPVgZHXdlTWCPmShMxV5pt86EK2Gx/14buu5kXMUDnE13BLIkd2yM/
         c3S+bwOtkjSKBEJdP3Eb0k3emz1weg9xLZsDsRYM=
Date:   Wed, 23 Mar 2022 16:06:39 -0700
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
Subject: [patch 27/41] x86/setup: use IS_ENABLED(CONFIG_KEXEC_CORE) instead of #ifdef
Message-Id: <20220323230640.1128CC340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jisheng Zhang <jszhang@kernel.org>
Subject: x86/setup: use IS_ENABLED(CONFIG_KEXEC_CORE) instead of #ifdef

Replace the conditional compilation using "#ifdef CONFIG_KEXEC_CORE" by a
check for "IS_ENABLED(CONFIG_KEXEC_CORE)", to simplify the code and
increase compile coverage.

Link: https://lkml.kernel.org/r/20211206160514.2000-4-jszhang@kernel.org
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
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
Cc: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/arch/x86/kernel/setup.c~x86-setup-use-is_enabledconfig_kexec_core-instead-of-ifdef
+++ a/arch/x86/kernel/setup.c
@@ -411,8 +411,6 @@ static void __init memblock_x86_reserve_
  * --------- Crashkernel reservation ------------------------------
  */
 
-#ifdef CONFIG_KEXEC_CORE
-
 /* 16M alignment for crash kernel regions */
 #define CRASH_ALIGN		SZ_16M
 
@@ -490,6 +488,9 @@ static void __init reserve_crashkernel(v
 	bool high = false;
 	int ret;
 
+	if (!IS_ENABLED(CONFIG_KEXEC_CORE))
+		return;
+
 	total_mem = memblock_phys_mem_size();
 
 	/* crashkernel=XM */
@@ -555,11 +556,6 @@ static void __init reserve_crashkernel(v
 	crashk_res.end   = crash_base + crash_size - 1;
 	insert_resource(&iomem_resource, &crashk_res);
 }
-#else
-static void __init reserve_crashkernel(void)
-{
-}
-#endif
 
 static struct resource standard_io_resources[] = {
 	{ .name = "dma1", .start = 0x00, .end = 0x1f,
_
