Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D0BAC388F2
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 03:11:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBC39223C7
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 03:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604459490;
	bh=X1SQGPSUkW2MeGQyGjrBFELY7LXtxborxQbdsDD7jYA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=CWdnxROMBzzNzepcmTSDYC4DQ823g1PXOOcLdLld9ZclETRWuyjAmxqyeCxSp2R00
	 oY40FEfb+dfsiBIHuFkJy54XTJJqhAoQxYjkwmtfFnrkKXNKbYCXjylmYfAF/u3bf0
	 XIit4QvQA5FEx1p8u5UWrC020HLbdMGU5XXPN2Bo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730318AbgKDDL3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 22:11:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:49660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730017AbgKDDL3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 22:11:29 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4B502067B;
        Wed,  4 Nov 2020 03:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604459488;
        bh=X1SQGPSUkW2MeGQyGjrBFELY7LXtxborxQbdsDD7jYA=;
        h=Date:From:To:Subject:From;
        b=Td4jeWkH6y3BzNh3+lQcIWTAMjvoqEqI7myC/N3Qz69cyMXMJpPMPx1Wop0wwX5uR
         4JzUY1azTxW8tFk2SuMbSSUQ3JlWz6dZoDCMJ074EovPmYk48zUzFdlsLAa0Rzsmxx
         n9Gi2v8t8ReyNtLb2PYDhKF8mIdB/yU+AeIdsnOM=
Date:   Tue, 03 Nov 2020 19:11:24 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, vgupta@synopsys.com,
        tony.luck@intel.com, schmitzmic@gmail.com, mroos@linux.ee,
        mattst88@gmail.com, linux@armlinux.org.uk,
        glaubitz@physik.fu-berlin.de, gerg@linux-m68k.org,
        geert@linux-m68k.org, corbet@lwn.net, catalin.marinas@arm.com,
        adobriyan@gmail.com, rppt@linux.ibm.com
Subject:  +
 ia64-make-sparsemem-default-and-disable-discontigmem.patch added to -mm tree
Message-ID: <20201104031124.5UR1K%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: make SPARSEMEM default and disable DISCONTIGMEM
has been added to the -mm tree.  Its filename is
     ia64-make-sparsemem-default-and-disable-discontigmem.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ia64-make-sparsemem-default-and-disable-discontigmem.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ia64-make-sparsemem-default-and-disable-discontigmem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: ia64: make SPARSEMEM default and disable DISCONTIGMEM

SPARSEMEM memory model suitable for systems with large holes in their
phyiscal memory layout. With SPARSEMEM_VMEMMAP enabled it provides
pfn_to_page() and page_to_pfn() as fast as FLATMEM.

Make it the default memory model for IA-64 and disable DISCONTIGMEM which
is considered obsolete for quite some time.

Link: https://lkml.kernel.org/r/20201101170454.9567-8-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Meelis Roos <mroos@linux.ee>
Cc: Michael Schmitz <schmitzmic@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/ia64/Kconfig~ia64-make-sparsemem-default-and-disable-discontigmem
+++ a/arch/ia64/Kconfig
@@ -288,6 +288,7 @@ config ARCH_SELECT_MEMORY_MODEL
 
 config ARCH_DISCONTIGMEM_ENABLE
 	def_bool y
+	depends on BROKEN
 	help
 	  Say Y to support efficient handling of discontiguous physical memory,
 	  for architectures which are either NUMA (Non-Uniform Memory Access)
@@ -299,12 +300,11 @@ config ARCH_FLATMEM_ENABLE
 
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
-	depends on ARCH_DISCONTIGMEM_ENABLE
 	select SPARSEMEM_VMEMMAP_ENABLE
 
-config ARCH_DISCONTIGMEM_DEFAULT
+config ARCH_SPARSEMEM_DEFAULT
 	def_bool y
-	depends on ARCH_DISCONTIGMEM_ENABLE
+	depends on ARCH_SPARSEMEM_ENABLE
 
 config NUMA
 	bool "NUMA support"
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-introduce-debug_pagealloc_map_pages-helper.patch
pm-hibernate-make-direct-map-manipulations-more-explicit.patch
arch-mm-restore-dependency-of-__kernel_map_pages-of-debug_pagealloc.patch
arch-mm-make-kernel_page_present-always-available.patch
alpha-switch-from-discontigmem-to-sparsemem.patch
ia64-remove-custom-__early_pfn_to_nid.patch
ia64-remove-ifdef-config_zone_dma32-statements.patch
ia64-discontig-paging_init-remove-local-max_pfn-calculation.patch
ia64-split-virtual-map-initialization-out-of-paging_init.patch
ia64-forbid-using-virtual_mem_map-with-flatmem.patch
ia64-make-sparsemem-default-and-disable-discontigmem.patch
arm-remove-config_arch_has_holes_memorymodel.patch
arm-arm64-move-free_unused_memmap-to-generic-mm.patch
arc-use-flatmem-with-freeing-of-unused-memory-map-instead-of-discontigmem.patch
m68k-mm-make-node-data-and-node-setup-depend-on-config_discontigmem.patch
m68k-mm-enable-use-of-generic-memory_modelh-for-discontigmem.patch
m68k-deprecate-discontigmem.patch

