Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97126C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:18:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67175224B2
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:18:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgLODM1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:12:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:36678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727932AbgLODMS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:12:18 -0500
Date:   Mon, 14 Dec 2020 19:09:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001793;
        bh=S5odxIyLrjuweyZ63+eQOrr1/g5wbASQHlAjaEWAX2g=;
        h=From:To:Subject:In-Reply-To:From;
        b=W2ct9UFM9MOi/tY+eY+vwwWHxkwaBgZHgn0hSe7cmBDBzDChXWGPmdfayBmaa8NHg
         22x/8mQVsE8vfAZVcf+6ZtY3De28d9paZnU63kaJbGKInBEBlfdQ+NicGX2BeehAf7
         LJzM3xvT00XpjUOjQlcHaPevYkgJiWxJdrvc139A=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        catalin.marinas@arm.com, corbet@lwn.net, geert@linux-m68k.org,
        gerg@linux-m68k.org, glaubitz@physik.fu-berlin.de,
        linux-mm@kvack.org, linux@armlinux.org.uk, mattst88@gmail.com,
        mm-commits@vger.kernel.org, mroos@linux.ee, rppt@linux.ibm.com,
        schmitzmic@gmail.com, tony.luck@intel.com,
        torvalds@linux-foundation.org, vgupta@synopsys.com, will@kernel.org
Subject:  [patch 112/200] ia64: make SPARSEMEM default and disable
 DISCONTIGMEM
Message-ID: <20201215030951.N7nRi9IU0%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
