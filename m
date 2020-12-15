Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0B6FC2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:12:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A64132251E
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:12:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgLODMg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:12:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:35702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727674AbgLODMX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:12:23 -0500
Date:   Mon, 14 Dec 2020 19:10:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001817;
        bh=/ytR9iCCY4lh8anJUxGG1W/l2r9YMqnrsdhnByg3ytA=;
        h=From:To:Subject:In-Reply-To:From;
        b=pkyZOomJeAJTdBBNDqC6idfqqcxq5o24BB3VTPQPQnCY8+1iy/opMf8ETs7x9jsuL
         zBndU1iwG7D7qUNj/q6UAuMitFAEcWsA4hUerIhosd54T8ImhA0xT+7M0ut3hGm0VE
         SLVIWocTZSY/luGHv7LUrQL9RO1hbvktdLP1BWIY=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        catalin.marinas@arm.com, corbet@lwn.net, geert@linux-m68k.org,
        gerg@linux-m68k.org, glaubitz@physik.fu-berlin.de,
        linux-mm@kvack.org, linux@armlinux.org.uk, mattst88@gmail.com,
        mm-commits@vger.kernel.org, mroos@linux.ee, rppt@linux.ibm.com,
        schmitzmic@gmail.com, tony.luck@intel.com,
        torvalds@linux-foundation.org, vgupta@synopsys.com, will@kernel.org
Subject:  [patch 118/200] m68k: deprecate DISCONTIGMEM
Message-ID: <20201215031015.E8wNR_bpm%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
