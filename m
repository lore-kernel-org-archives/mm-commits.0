Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB096C07E99
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:32:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA698613C7
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbhGIVfU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 17:35:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:45778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231146AbhGIVfR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 17:35:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F31C0613C9;
        Fri,  9 Jul 2021 21:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625866353;
        bh=bLbtBSK2baUju4mfhrtTqQnBLOkWMZjK4NpT6346SJA=;
        h=Date:From:To:Subject:From;
        b=ouMmrcIeCX/zOV/4DuGatVJgLjDtoCoFflokkRul4D6Bfs1llR+Bx9hxy1OcC9yt3
         U+ll7ZvLGx48b1shMxS/EPFPgcWLHOnTUm4vWkM5sPrbNyf3c68OkE4cKMCtR4zciT
         4KphAHM5d34yZhTNrx1XAIMircL1osdYYVYMllyM=
Date:   Fri, 09 Jul 2021 14:32:31 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, bp@alien8.de, catalin.marinas@arm.com, cl@linux.com,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        david@redhat.com, elena.reshetova@intel.com, guro@fb.com,
        hagen@jauu.net, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, jejb@linux.ibm.com,
        kirill@shutemov.name, lkp@intel.com, luto@kernel.org,
        mark.rutland@arm.com, mingo@redhat.com, mm-commits@vger.kernel.org,
        mtk.manpages@gmail.com, palmer@dabbelt.com,
        palmerdabbelt@google.com, paul.walmsley@sifive.com,
        peterz@infradead.org, rick.p.edgecombe@intel.com,
        rppt@linux.ibm.com, shakeelb@google.com, shuah@kernel.org,
        tglx@linutronix.de, tycho@tycho.ws, viro@zeniv.linux.org.uk,
        will@kernel.org, willy@infradead.org
Subject:  [merged]
 riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch
 removed from -mm tree
Message-ID: <20210709213231.Y1VzcvZ_2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: riscv/Kconfig: make direct map manipulation options depend on MMU
has been removed from the -mm tree.  Its filename was
     riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: riscv/Kconfig: make direct map manipulation options depend on MMU

ARCH_HAS_SET_DIRECT_MAP and ARCH_HAS_SET_MEMORY configuration options have
no meaning when CONFIG_MMU is disabled and there is no point to enable
them for the nommu case.

Add an explicit dependency on MMU for these options.

Link: https://lkml.kernel.org/r/20210518072034.31572-3-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christopher Lameter <cl@linux.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Elena Reshetova <elena.reshetova@intel.com>
Cc: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Bottomley <jejb@linux.ibm.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Palmer Dabbelt <palmerdabbelt@google.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tycho Andersen <tycho@tycho.ws>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/riscv/Kconfig~riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu
+++ a/arch/riscv/Kconfig
@@ -26,8 +26,8 @@ config RISCV
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_MMIOWB
 	select ARCH_HAS_PTE_SPECIAL
-	select ARCH_HAS_SET_DIRECT_MAP
-	select ARCH_HAS_SET_MEMORY
+	select ARCH_HAS_SET_DIRECT_MAP if MMU
+	select ARCH_HAS_SET_MEMORY if MMU
 	select ARCH_HAS_STRICT_KERNEL_RWX if MMU && !XIP_KERNEL
 	select ARCH_HAS_STRICT_MODULE_RWX if MMU && !XIP_KERNEL
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
_

Patches currently in -mm which might be from rppt@linux.ibm.com are


