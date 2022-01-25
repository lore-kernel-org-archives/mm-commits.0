Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 338B6C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jan 2022 06:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244150AbiAYGUy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jan 2022 01:20:54 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54668 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244153AbiAYGRz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jan 2022 01:17:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D2ECB816BF
        for <mm-commits@vger.kernel.org>; Tue, 25 Jan 2022 06:17:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE38C340E0;
        Tue, 25 Jan 2022 06:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643091472;
        bh=4pLOJ7+n4vZxVR+GKq9J4qL+x7WZgQ5tiWZQITiSINg=;
        h=Date:From:To:Subject:From;
        b=Am5K67SDgfgqOOHZAnEIi7VhB6YyaiDBiUKIIuY30qINnMCjCmWj4Zi6XhPgN6vJG
         +aF7fMJT2Y69401nB06EQzOrEczXCqwROwQ244keX/54quPgbfGqWFuNFq0xWp8n/k
         2udsIw8R0oAibo7tohVjh6YeehctL/3YwIDWXAyc=
Date:   Mon, 24 Jan 2022 22:17:51 -0800
From:   akpm@linux-foundation.org
To:     alex@ghiti.fr, aou@eecs.berkeley.edu, bhe@redhat.com, bp@alien8.de,
        catalin.marinas@arm.com, dave.hansen@linux.intel.com,
        ebiederm@xmission.com, hpa@zytor.com, jszhang@kernel.org,
        linux@armlinux.org.uk, mingo@redhat.com,
        mm-commits@vger.kernel.org, palmer@dabbelt.com,
        palmer@rivosinc.com, paul.walmsley@sifive.com,
        rmk+kernel@armlinux.org.uk, tglx@linutronix.de, will@kernel.org
Subject:  +
 x86-setup-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch added to
 -mm tree
Message-ID: <20220125061751.lhh-XdcxN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/setup: use IS_ENABLED(CONFIG_KEXEC_CORE) instead of #ifdef
has been added to the -mm tree.  Its filename is
     x86-setup-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/x86-setup-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/x86-setup-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch

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
@@ -391,8 +391,6 @@ static void __init memblock_x86_reserve_
  * --------- Crashkernel reservation ------------------------------
  */
 
-#ifdef CONFIG_KEXEC_CORE
-
 /* 16M alignment for crash kernel regions */
 #define CRASH_ALIGN		SZ_16M
 
@@ -470,6 +468,9 @@ static void __init reserve_crashkernel(v
 	bool high = false;
 	int ret;
 
+	if (!IS_ENABLED(CONFIG_KEXEC_CORE))
+		return;
+
 	total_mem = memblock_phys_mem_size();
 
 	/* crashkernel=XM */
@@ -535,11 +536,6 @@ static void __init reserve_crashkernel(v
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

kexec-make-crashk_res-crashk_low_res-and-crash_notes-symbols-always-visible.patch
riscv-mm-init-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch
x86-setup-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch
arm64-mm-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch
arm-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch

