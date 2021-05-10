Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96536C433ED
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:29:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64C516142D
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:29:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbhEJEaL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 00:30:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229533AbhEJEaL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 00:30:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3BAF61421;
        Mon, 10 May 2021 04:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620620946;
        bh=UvxyI4iMLe4g2RIkcotYnTNFrzx9dzDtusNeFZm3awg=;
        h=Date:From:To:Subject:From;
        b=1UNzxZepvWZAGth7tBLk9aakeoMY471jMOFAW0gffzIETf9ahkiQJ4DlhP3gYdpX6
         R/9oc6gQ05xZujJjTQ6+h/f+z3wEhNzgJVjbv1AnhG8Crl1HoFnw5/Xf/sz6YlO0VD
         Js6Fiina95Qv11Nftr1pXBrR70bipl0RUAf/UXQM=
Date:   Sun, 09 May 2021 21:29:06 -0700
From:   akpm@linux-foundation.org
To:     catalin.marinas@arm.com, mm-commits@vger.kernel.org,
        tsbogend@alpha.franken.de, wangkefeng.wang@huawei.com,
        will@kernel.org
Subject:  + mm-move-holes_in_zone-into-mm.patch added to -mm tree
Message-ID: <20210510042906.yHaPauiek%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kconfig: move HOLES_IN_ZONE into mm
has been added to the -mm tree.  Its filename is
     mm-move-holes_in_zone-into-mm.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-move-holes_in_zone-into-mm.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-move-holes_in_zone-into-mm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -128,6 +128,9 @@ config HAVE_FAST_GUP
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

mm-page-writeback-kill-get_writeback_state-comments.patch
mm-move-holes_in_zone-into-mm.patch

