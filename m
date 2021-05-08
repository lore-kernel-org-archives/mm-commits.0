Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1204AC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBC8161426
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:50:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhEHWvT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:51:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHWvS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:51:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F269161402;
        Sat,  8 May 2021 22:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514216;
        bh=QVLHmAA2u5TID3IUqyQ+tKg4fJJWtIRn97M6XfqGyco=;
        h=Date:From:To:Subject:From;
        b=l9EsxSMAMSXPXpDbteDss0bkY4mQRhm6GUC6dLLhH6zu1oNb+NkysMoGDL34XAyra
         0btHj29IHkQGwreJm7BAnZJgFxpg6+maRrdoTZuu8i0Al7K1Xwg5zp8gZM0I5sVK1G
         bHlmMrRS3Mc1d7biIQRx3VBgOTJP7rtc3wRqjQX0=
Date:   Sat, 08 May 2021 15:50:15 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, aou@eecs.berkeley.edu, arnd@arndb.de,
        benh@kernel.crashing.org, borntraeger@de.ibm.com, bp@alien8.de,
        catalin.marinas@arm.com, dalias@libc.org, deller@gmx.de,
        gor@linux.ibm.com, hca@linux.ibm.com, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, linux@armlinux.org.uk,
        mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        palmerdabbelt@google.com, paul.walmsley@sifive.com,
        paulus@samba.org, tglx@linutronix.de, tsbogend@alpha.franken.de,
        vgupta@synopsys.com, viro@zeniv.linux.org.uk, will@kernel.org,
        ysato@users.sourceforge.jp
Subject:  [merged]
 mm-drop-redundant-have_arch_transparent_hugepage.patch removed from -mm
 tree
Message-ID: <20210508225015.5A3-nfZx5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop redundant HAVE_ARCH_TRANSPARENT_HUGEPAGE
has been removed from the -mm tree.  Its filename was
     mm-drop-redundant-have_arch_transparent_hugepage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm: drop redundant HAVE_ARCH_TRANSPARENT_HUGEPAGE

HAVE_ARCH_TRANSPARENT_HUGEPAGE has duplicate definitions on platforms that
subscribe it.  Drop these reduntant definitions and instead just select it
on applicable platforms.

Link: https://lkml.kernel.org/r/1617259448-22529-7-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Vineet Gupta <vgupta@synopsys.com>		[arc]
Cc: Russell King <linux@armlinux.org.uk>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Palmer Dabbelt <palmerdabbelt@google.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/Kconfig |    5 +----
 arch/arm/Kconfig |    5 +----
 2 files changed, 2 insertions(+), 8 deletions(-)

--- a/arch/arc/Kconfig~mm-drop-redundant-have_arch_transparent_hugepage
+++ a/arch/arc/Kconfig
@@ -29,6 +29,7 @@ config ARC
 	select GENERIC_SMP_IDLE_THREAD
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
+	select HAVE_ARCH_TRANSPARENT_HUGEPAGE if ARC_MMU_V4
 	select HAVE_DEBUG_STACKOVERFLOW
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_FUTEX_CMPXCHG if FUTEX
@@ -84,10 +85,6 @@ config STACKTRACE_SUPPORT
 	def_bool y
 	select STACKTRACE
 
-config HAVE_ARCH_TRANSPARENT_HUGEPAGE
-	def_bool y
-	depends on ARC_MMU_V4
-
 menu "ARC Architecture Configuration"
 
 menu "ARC Platform/SoC/Board"
--- a/arch/arm/Kconfig~mm-drop-redundant-have_arch_transparent_hugepage
+++ a/arch/arm/Kconfig
@@ -78,6 +78,7 @@ config ARM
 	select HAVE_ARCH_SECCOMP_FILTER if AEABI && !OABI_COMPAT
 	select HAVE_ARCH_THREAD_STRUCT_WHITELIST
 	select HAVE_ARCH_TRACEHOOK
+	select HAVE_ARCH_TRANSPARENT_HUGEPAGE if ARM_LPAE
 	select HAVE_ARM_SMCCC if CPU_V7
 	select HAVE_EBPF_JIT if !CPU_ENDIAN_BE32
 	select HAVE_CONTEXT_TRACKING
@@ -1512,10 +1513,6 @@ config HW_PERF_EVENTS
 	def_bool y
 	depends on ARM_PMU
 
-config HAVE_ARCH_TRANSPARENT_HUGEPAGE
-       def_bool y
-       depends on ARM_LPAE
-
 config ARCH_WANT_GENERAL_HUGETLB
 	def_bool y
 
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are


