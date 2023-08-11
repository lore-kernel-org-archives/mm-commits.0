Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD711C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236441AbjHKXEx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236755AbjHKXDb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:03:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F773A80
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:01:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D5BA67ADA
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:01:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63879C433C7;
        Fri, 11 Aug 2023 23:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794896;
        bh=Cs10onGkpuMfSew/3BvxT7RsEybIWIjuxJEGSQjXDE8=;
        h=Date:To:From:Subject:From;
        b=MlwmizFUkT3AVxr4x0kxvS+8ndkxyiC7PdgpnC8n+ZO1A46HeVyX7qiI7Y4fZ4C4B
         hyR25g/BKRcAFgoMAA52P8ZrnqKDI7dCenk8YUg6VM0FcW60THYCxxJvniNznery4/
         zd7wKlIj2eSFVrZUG3/IR4pXuO8M+Zu93vRh4tyQ=
Date:   Fri, 11 Aug 2023 16:01:35 -0700
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
        dalias@libc.org, chris@zankel.net, catalin.marinas@arm.com,
        borntraeger@linux.ibm.com, bhe@redhat.com, bcain@quicinc.com,
        arnd@arndb.de, agordeev@linux.ibm.com, christophe.leroy@csgroup.eu,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ioremap-consider-ioremap-space-in-generic-ioremap.patch removed from -mm tree
Message-Id: <20230811230136.63879C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/ioremap: consider IOREMAP space in generic ioremap
has been removed from the -mm tree.  Its filename was
     mm-ioremap-consider-ioremap-space-in-generic-ioremap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: mm/ioremap: consider IOREMAP space in generic ioremap
Date: Thu, 6 Jul 2023 23:45:16 +0800

Architectures like powerpc have a dedicated space for IOREMAP mappings.

If so, use it in generic_ioremap_prot().

Link: https://lkml.kernel.org/r/20230706154520.11257-16-bhe@redhat.com
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ioremap.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/mm/ioremap.c~mm-ioremap-consider-ioremap-space-in-generic-ioremap
+++ a/mm/ioremap.c
@@ -11,6 +11,15 @@
 #include <linux/io.h>
 #include <linux/export.h>
 
+/*
+ * Ioremap often, but not always uses the generic vmalloc area. E.g on
+ * Power ARCH, it could have different ioremap space.
+ */
+#ifndef IOREMAP_START
+#define IOREMAP_START   VMALLOC_START
+#define IOREMAP_END     VMALLOC_END
+#endif
+
 void __iomem *generic_ioremap_prot(phys_addr_t phys_addr, size_t size,
 				   pgprot_t prot)
 {
@@ -35,8 +44,8 @@ void __iomem *generic_ioremap_prot(phys_
 	if (!ioremap_allowed(phys_addr, size, pgprot_val(prot)))
 		return NULL;
 
-	area = get_vm_area_caller(size, VM_IOREMAP,
-			__builtin_return_address(0));
+	area = __get_vm_area_caller(size, VM_IOREMAP, IOREMAP_START,
+				    IOREMAP_END, __builtin_return_address(0));
 	if (!area)
 		return NULL;
 	vaddr = (unsigned long)area->addr;
@@ -66,7 +75,7 @@ void generic_iounmap(volatile void __iom
 	if (!iounmap_allowed(vaddr))
 		return;
 
-	if (is_vmalloc_addr(vaddr))
+	if (is_ioremap_addr(vaddr))
 		vunmap(vaddr);
 }
 
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are


