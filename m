Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01B04C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349727AbiCYBhR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357513AbiCYBf4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6F438BCD
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:34:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7228060B08
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C0FC340EC;
        Fri, 25 Mar 2022 01:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172046;
        bh=/yQsCSxiEHSI/U+J6NbdPagVVKQq8GeEvQV9syHqmfA=;
        h=Date:To:From:Subject:From;
        b=yiFU2SfF25a7l6kxYOwUe96BWWtzzxtwBGgHHhIOrDum3nfZzyI7a/WsaeZO21Bbq
         VT1Qd66XU03SB+IUBTBL7Gobzsp+7ZekpiFGBPddzf102sq5E3QcM41SGTvz4PiU5c
         7A2fttGCbFMRSmqzg+8OkdNXJAAxjT5yFkeNhdCo=
Date:   Thu, 24 Mar 2022 18:34:06 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, tglx@linutronix.de,
        rmk+kernel@armlinux.org.uk, paul.walmsley@sifive.com,
        palmer@rivosinc.com, palmer@dabbelt.com, mingo@redhat.com,
        linux@armlinux.org.uk, hpa@zytor.com, ebiederm@xmission.com,
        dave.hansen@linux.intel.com, catalin.marinas@arm.com, bp@alien8.de,
        bhe@redhat.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
        jszhang@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] x86-setup-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch removed from -mm tree
Message-Id: <20220325013406.C5C0FC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/setup: use IS_ENABLED(CONFIG_KEXEC_CORE) instead of #ifdef
has been removed from the -mm tree.  Its filename was
     x86-setup-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from jszhang@kernel.org are


