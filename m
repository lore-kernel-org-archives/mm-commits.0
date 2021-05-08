Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 684CEC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 372B961402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhEHWib (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:38:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:41064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHWib (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:38:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B9CC613E8;
        Sat,  8 May 2021 22:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513449;
        bh=doGSEmw3FH3MoUy6M4l/p3qvDp/gYPrdyFeg3YuyEAI=;
        h=Date:From:To:Subject:From;
        b=YvHi3ZPF2+0oQoAOOm1L0ihE/HVABZE/QVetKdrw5AuMDGnF7dDr8T6qn8CRQ0E2m
         2aJlsX1s2jAU/TdtoH57F7qZY0Hnd+xJMM73oGptI3JY56RzvG9AvBMYdOh/aAagU8
         pHcT/m2HiiypG6tH5lINQNp0T2Z+4KjdbarnthgE=
Date:   Sat, 08 May 2021 15:37:28 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-rejects.patch removed from -mm tree
Message-ID: <20210508223728.9gk4hDVUR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/Kconfig     |    6 +++++-
 include/linux/bitmap.h |    4 +++-
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/include/linux/bitmap.h~linux-next-rejects
+++ a/include/linux/bitmap.h
@@ -5,10 +5,12 @@
 #ifndef __ASSEMBLY__
 
 #include <linux/align.h>
-#include <linux/types.h>
 #include <linux/bitops.h>
 #include <linux/limits.h>
 #include <linux/string.h>
+#include <linux/types.h>
+
+struct device;
 
 /*
  * bitmaps provide bit arrays that consume one or more unsigned
--- a/arch/riscv/Kconfig~linux-next-rejects
+++ a/arch/riscv/Kconfig
@@ -28,19 +28,23 @@ config RISCV
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_SET_DIRECT_MAP
 	select ARCH_HAS_SET_MEMORY
-	select ARCH_HAS_STRICT_KERNEL_RWX if MMU
+	select ARCH_HAS_STRICT_KERNEL_RWX if MMU && !XIP_KERNEL
+	select ARCH_HAS_STRICT_MODULE_RWX if MMU && !XIP_KERNEL
+	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_OPTIONAL_KERNEL_RWX if ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_OPTIONAL_KERNEL_RWX_DEFAULT
 	select ARCH_SUPPORTS_HUGETLBFS if MMU
 	select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT if MMU
 	select ARCH_WANT_FRAME_POINTERS
 	select ARCH_WANT_HUGE_PMD_SHARE if 64BIT
+	select BINFMT_FLAT_NO_DATA_START_OFFSET if !MMU
 	select CLONE_BACKWARDS
 	select CLINT_TIMER if !MMU
 	select COMMON_CLK
 	select EDAC_SUPPORT
 	select GENERIC_ARCH_TOPOLOGY if SMP
 	select GENERIC_ATOMIC64 if !64BIT
+	select GENERIC_CLOCKEVENTS_BROADCAST if SMP
 	select GENERIC_EARLY_IOREMAP
 	select GENERIC_GETTIMEOFDAY if HAVE_GENERIC_VDSO
 	select GENERIC_IOREMAP
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
cifsd-is-broken.patch
kernel-forkc-export-kernel_thread-to-modules.patch

