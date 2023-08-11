Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56C98C04A94
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:05:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235592AbjHKXE6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236962AbjHKXDh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:03:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B9C3ABD
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:01:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 655F667ADC
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:01:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B29C433C7;
        Fri, 11 Aug 2023 23:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794900;
        bh=ArF7vWIbgDMvNqmxfNkNP74R6mDxHr11XsUml9n7KEc=;
        h=Date:To:From:Subject:From;
        b=ARXiJpWdtQ+8C0Bv9V/HiS30cVAdHj7pcZdIAF5JluRds6eQc0JRwu7bx3JgEy/DP
         3vPJSFCMISbv2ICWnwxVKWzYTaqTXYMujUyl+/XDkTitsRQ+VDn8SdqU52SfDpNNeF
         cbMIK0azG+ckTCLCf9iVom3hQJ5zRR5JkLPPgV7c=
Date:   Fri, 11 Aug 2023 16:01:40 -0700
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        willy@infradead.org, will@kernel.org, wangkefeng.wang@huawei.com,
        vgupta@kernel.org, svens@linux.ibm.com,
        stefan.kristiansson@saunalahti.fi, shorne@gmail.com,
        schnelle@linux.ibm.com, rppt@kernel.org, npiggin@gmail.com,
        nathan@kernel.org, mpe@ellerman.id.au, jonas@southpole.se,
        jcmvbkbc@gmail.com, James.Bottomley@HansenPartnership.com,
        hch@lst.de, hca@linux.ibm.com, gor@linux.ibm.com,
        glaubitz@physik.fu-berlin.de, gerald.schaefer@linux.ibm.com,
        geert@linux-m68k.org, deller@gmx.de, David.Laight@ACULAB.COM,
        dalias@libc.org, chris@zankel.net, christophe.leroy@csgroup.eu,
        catalin.marinas@arm.com, borntraeger@linux.ibm.com,
        bcain@quicinc.com, arnd@arndb.de, agordeev@linux.ibm.com,
        bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mm-add-wrapper-function-ioremap_prot.patch removed from -mm tree
Message-Id: <20230811230140.B2B29C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arm64 : mm: add wrapper function ioremap_prot()
has been removed from the -mm tree.  Its filename was
     arm64-mm-add-wrapper-function-ioremap_prot.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: arm64 : mm: add wrapper function ioremap_prot()
Date: Thu, 6 Jul 2023 23:45:19 +0800

Since hook functions ioremap_allowed() and iounmap_allowed() will be
obsoleted, add wrapper function ioremap_prot() to contain the the specific
handling in addition to generic_ioremap_prot() invocation.

Link: https://lkml.kernel.org/r/20230706154520.11257-19-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/io.h |    3 +--
 arch/arm64/mm/ioremap.c     |   10 ++++++----
 2 files changed, 7 insertions(+), 6 deletions(-)

--- a/arch/arm64/include/asm/io.h~arm64-mm-add-wrapper-function-ioremap_prot
+++ a/arch/arm64/include/asm/io.h
@@ -139,8 +139,7 @@ extern void __memset_io(volatile void __
  * I/O memory mapping functions.
  */
 
-bool ioremap_allowed(phys_addr_t phys_addr, size_t size, unsigned long prot);
-#define ioremap_allowed ioremap_allowed
+#define ioremap_prot ioremap_prot
 
 #define _PAGE_IOREMAP PROT_DEVICE_nGnRE
 
--- a/arch/arm64/mm/ioremap.c~arm64-mm-add-wrapper-function-ioremap_prot
+++ a/arch/arm64/mm/ioremap.c
@@ -3,20 +3,22 @@
 #include <linux/mm.h>
 #include <linux/io.h>
 
-bool ioremap_allowed(phys_addr_t phys_addr, size_t size, unsigned long prot)
+void __iomem *ioremap_prot(phys_addr_t phys_addr, size_t size,
+			   unsigned long prot)
 {
 	unsigned long last_addr = phys_addr + size - 1;
 
 	/* Don't allow outside PHYS_MASK */
 	if (last_addr & ~PHYS_MASK)
-		return false;
+		return NULL;
 
 	/* Don't allow RAM to be mapped. */
 	if (WARN_ON(pfn_is_map_memory(__phys_to_pfn(phys_addr))))
-		return false;
+		return NULL;
 
-	return true;
+	return generic_ioremap_prot(phys_addr, size, __pgprot(prot));
 }
+EXPORT_SYMBOL(ioremap_prot);
 
 /*
  * Must be called after early_fixmap_init
_

Patches currently in -mm which might be from bhe@redhat.com are

net-altera-tse-make-altera_tse-depend-on-has_iomem.patch
irqchip-al-fic-make-al_fic-depend-on-has_iomem.patch

