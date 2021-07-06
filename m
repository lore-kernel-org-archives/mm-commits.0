Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA000C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5EF461C91
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbhGFTU6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:20:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229925AbhGFTU5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:20:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8231261C87;
        Tue,  6 Jul 2021 19:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599098;
        bh=M9LU6mMCNfhlKGJUoP7zh4bLcIaiWFLb/Dq4o/QKE78=;
        h=Date:From:To:Subject:From;
        b=A+9u+Px8otsr+CQKoCWjaqhGMSV5cVASgGPM0rUpLO7oYpJPg254Xg1OMBl2PUdv7
         Lv7NuIvxzGFJGKo9R+xg5IaeEH5rJ07K+lvH6pxqyj3gA1ciydIDRS+KY+wW+GKuev
         jkg/n0zPg0B/7mEifkZDmaf2ljheuTJLaGIH9dqs=
Date:   Tue, 06 Jul 2021 12:18:18 -0700
From:   akpm@linux-foundation.org
To:     catalin.marinas@arm.com, mm-commits@vger.kernel.org,
        tsbogend@alpha.franken.de, wangkefeng.wang@huawei.com,
        will@kernel.org
Subject:  [merged] mm-move-holes_in_zone-into-mm.patch removed from
 -mm tree
Message-ID: <20210706191818.WvXbMhsQ3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kconfig: move HOLES_IN_ZONE into mm
has been removed from the -mm tree.  Its filename was
     mm-move-holes_in_zone-into-mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm/kconfig: move HOLES_IN_ZONE into mm

commit a55749639dc1 ("ia64: drop marked broken DISCONTIGMEM and
VIRTUAL_MEM_MAP") drop VIRTUAL_MEM_MAP, so there is no need HOLES_IN_ZONE
on ia64.

Also move HOLES_IN_ZONE into mm/Kconfig, select it if architecture needs
this feature.

Link: https://lkml.kernel.org/r/20210417075946.181402-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>	[arm64]
Cc: Will Deacon <will@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig |    4 +---
 arch/ia64/Kconfig  |    3 ---
 arch/mips/Kconfig  |    3 ---
 mm/Kconfig         |    3 +++
 4 files changed, 4 insertions(+), 9 deletions(-)

--- a/arch/arm64/Kconfig~mm-move-holes_in_zone-into-mm
+++ a/arch/arm64/Kconfig
@@ -201,6 +201,7 @@ config ARM64
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HAVE_GENERIC_VDSO
+	select HOLES_IN_ZONE
 	select IOMMU_DMA if IOMMU_SUPPORT
 	select IRQ_DOMAIN
 	select IRQ_FORCED_THREADING
@@ -1052,9 +1053,6 @@ config NEED_PER_CPU_EMBED_FIRST_CHUNK
 	def_bool y
 	depends on NUMA
 
-config HOLES_IN_ZONE
-	def_bool y
-
 source "kernel/Kconfig.hz"
 
 config ARCH_SPARSEMEM_ENABLE
--- a/arch/ia64/Kconfig~mm-move-holes_in_zone-into-mm
+++ a/arch/ia64/Kconfig
@@ -308,9 +308,6 @@ config NODES_SHIFT
 	  MAX_NUMNODES will be 2^(This value).
 	  If in doubt, use the default.
 
-config HOLES_IN_ZONE
-	bool
-
 config HAVE_ARCH_NODEDATA_EXTENSION
 	def_bool y
 	depends on NUMA
--- a/arch/mips/Kconfig~mm-move-holes_in_zone-into-mm
+++ a/arch/mips/Kconfig
@@ -1233,9 +1233,6 @@ config HAVE_PLAT_MEMCPY
 config ISA_DMA_API
 	bool
 
-config HOLES_IN_ZONE
-	bool
-
 config SYS_SUPPORTS_RELOCATABLE
 	bool
 	help
--- a/mm/Kconfig~mm-move-holes_in_zone-into-mm
+++ a/mm/Kconfig
@@ -96,6 +96,9 @@ config HAVE_FAST_GUP
 	depends on MMU
 	bool
 
+config HOLES_IN_ZONE
+	bool
+
 # Don't discard allocated memory used to track "memory" and "reserved" memblocks
 # after early boot, so it can still be used to test for validity of memory.
 # Also, memblocks are updated with memory hot(un)plug.
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-add-setup_initial_init_mm-helper.patch
arc-convert-to-setup_initial_init_mm.patch
arm-convert-to-setup_initial_init_mm.patch
arm64-convert-to-setup_initial_init_mm.patch
csky-convert-to-setup_initial_init_mm.patch
h8300-convert-to-setup_initial_init_mm.patch
m68k-convert-to-setup_initial_init_mm.patch
nds32-convert-to-setup_initial_init_mm.patch
nios2-convert-to-setup_initial_init_mm.patch
openrisc-convert-to-setup_initial_init_mm.patch
powerpc-convert-to-setup_initial_init_mm.patch
riscv-convert-to-setup_initial_init_mm.patch
s390-convert-to-setup_initial_init_mm.patch
sh-convert-to-setup_initial_init_mm.patch
x86-convert-to-setup_initial_init_mm.patch

