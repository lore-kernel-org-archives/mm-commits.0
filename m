Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92129C2D0A3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 03:12:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BD58223C7
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 03:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604459549;
	bh=zaWXTf4BfnDJJb9cTvf/lUcaYIPuQbusmeMTFaLBF7E=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=jcxt7U8bXBLrOtbjMWXJtsiTXiWhfSdT7csg2oWmDgJu7V7cRAybK5/6mr0TM8EkI
	 AdnXGSogDiSORvkJpoL70sUqxf4Q85+HtndVxT9ijweWyoERXmzDeI4ElSehkUaJGA
	 fP+uuJhJV2vwpABnjnGFGVo56tjINUN2tkQsA704=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbgKDDM2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 22:12:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:50124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729835AbgKDDM2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 22:12:28 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96A2A20657;
        Wed,  4 Nov 2020 03:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604459548;
        bh=zaWXTf4BfnDJJb9cTvf/lUcaYIPuQbusmeMTFaLBF7E=;
        h=Date:From:To:Subject:From;
        b=K/V3hxzdTwTIHS9yzJz+7Tzt6hGkew2uPX3R0mwsdQpEWcJZXCr/3Fk1SRzOby/t1
         fI45Tu+5U+9OURqroa/9fyL6RgsBd8HGSULOXNcb4XzwQl4nbsbV98LgCasjnFDfi+
         nEo0pWEmzS5dNGLBfTvW3ubg5YE6EMIaXZ/K/yI8=
Date:   Tue, 03 Nov 2020 19:12:15 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, vgupta@synopsys.com,
        tony.luck@intel.com, schmitzmic@gmail.com, mroos@linux.ee,
        mattst88@gmail.com, linux@armlinux.org.uk,
        glaubitz@physik.fu-berlin.de, gerg@linux-m68k.org,
        geert@linux-m68k.org, corbet@lwn.net, catalin.marinas@arm.com,
        adobriyan@gmail.com, rppt@linux.ibm.com
Subject:  + m68k-deprecate-discontigmem.patch added to -mm tree
Message-ID: <20201104031215.-3o4d%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: m68k: deprecate DISCONTIGMEM
has been added to the -mm tree.  Its filename is
     m68k-deprecate-discontigmem.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/m68k-deprecate-discontigmem.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/m68k-deprecate-discontigmem.patch

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
Subject: m68k: deprecate DISCONTIGMEM

DISCONTIGMEM was intended to provide more efficient support for systems
with holes in their physical address space that FLATMEM did.

Yet, it's overhead in terms of the memory consumption seems to overweight
the savings on the unused memory map.

For a ARAnyM system with 16 MBytes of FastRAM configured, the memory usage
reported after page allocator initialization is

Memory: 23828K/30720K available (3206K kernel code, 535K rwdata, 936K rodata, 768K init, 193K bss, 6892K reserved, 0K cma-reserved)

and with DISCONTIGMEM disabled and with relatively large hole in the memory
map it is:

Memory: 23864K/30720K available (3197K kernel code, 516K rwdata, 936K rodata, 764K init, 179K bss, 6856K reserved, 0K cma-reserved)

Moreover, since m68k already has custom pfn_valid() it is possible to
define HAVE_ARCH_PFN_VALID to enable freeing of unused memory map. The
minimal size of a hole that can be freed should not be less than
MAX_ORDER_NR_PAGES so to achieve more substantial memory savings let m68k
also define custom FORCE_MAX_ZONEORDER.

With FORCE_MAX_ZONEORDER set to 9 memory usage becomes:

Memory: 23880K/30720K available (3197K kernel code, 516K rwdata, 936K rodata, 764K init, 179K bss, 6840K reserved, 0K cma-reserved)

Link: https://lkml.kernel.org/r/20201101170454.9567-14-rppt@kernel.org
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

 arch/m68k/Kconfig.cpu |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

--- a/arch/m68k/Kconfig.cpu~m68k-deprecate-discontigmem
+++ a/arch/m68k/Kconfig.cpu
@@ -20,6 +20,7 @@ choice
 
 config M68KCLASSIC
 	bool "Classic M68K CPU family support"
+	select HAVE_ARCH_PFN_VALID
 
 config COLDFIRE
 	bool "Coldfire CPU family support"
@@ -377,11 +378,34 @@ config SINGLE_MEMORY_CHUNK
 	help
 	  Ignore all but the first contiguous chunk of physical memory for VM
 	  purposes.  This will save a few bytes kernel size and may speed up
-	  some operations.  Say N if not sure.
+	  some operations.
+	  When this option os set to N, you may want to lower "Maximum zone
+	  order" to save memory that could be wasted for unused memory map.
+	  Say N if not sure.
 
 config ARCH_DISCONTIGMEM_ENABLE
+	depends on BROKEN
 	def_bool MMU && !SINGLE_MEMORY_CHUNK
 
+config FORCE_MAX_ZONEORDER
+	int "Maximum zone order" if ADVANCED
+	depends on !SINGLE_MEMORY_CHUNK
+	default "11"
+	help
+	  The kernel memory allocator divides physically contiguous memory
+	  blocks into "zones", where each zone is a power of two number of
+	  pages.  This option selects the largest power of two that the kernel
+	  keeps in the memory allocator.  If you need to allocate very large
+	  blocks of physically contiguous memory, then you may need to
+	  increase this value.
+
+	  For systems that have holes in their physical address space this
+	  value also defines the minimal size of the hole that allows
+	  freeing unused memory map.
+
+	  This config option is actually maximum order plus one. For example,
+	  a value of 11 means that the largest free memory block is 2^10 pages.
+
 config 060_WRITETHROUGH
 	bool "Use write-through caching for 68060 supervisor accesses"
 	depends on ADVANCED && M68060
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

