Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FA94C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 29 Sep 2021 03:31:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 056EF613E6
	for <mm-commits@archiver.kernel.org>; Wed, 29 Sep 2021 03:31:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244020AbhI2Dc7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Sep 2021 23:32:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243999AbhI2Dc7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 28 Sep 2021 23:32:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B6AB6138F;
        Wed, 29 Sep 2021 03:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632886278;
        bh=uWRLiipXUoEhTMKcYDv8aEz0Y0OuC+yNMMdLzH2l3ho=;
        h=Date:From:To:Subject:From;
        b=PEipUA6yRzY+81HTkRXFWhYd0Tuc1PbZxlTLm5AJRBKui1WDbIzRonZHFmqQUnWT/
         QIg+FW5v61DzjuIsD3xzRqm9v39LMTr+fd95S068kvPEG7lactiDbrRJqa1BsHG/gR
         C59uz2rdCpSjA2ZcGzYWW0aoXbTU18PsWm38rTEE=
Date:   Tue, 28 Sep 2021 20:31:18 -0700
From:   akpm@linux-foundation.org
To:     benh@kernel.crashing.org, christophe.leroy@csgroup.eu,
        gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
        mm-commits@vger.kernel.org, paulus@ozlabs.org, sfr@canb.auug.org.au
Subject:  [to-be-updated]
 powerpc-use-generic-version-of-arch_is_kernel_initmem_freed.patch removed
 from -mm tree
Message-ID: <20210929033118.GxZvA7H_9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: use generic version of arch_is_kernel_initmem_freed()
has been removed from the -mm tree.  Its filename was
     powerpc-use-generic-version-of-arch_is_kernel_initmem_freed.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: powerpc: use generic version of arch_is_kernel_initmem_freed()

Generic version of arch_is_kernel_initmem_freed() now does the same
as powerpc version.

Remove the powerpc version.

Link: https://lkml.kernel.org/r/026c4fcbe018d35917e044de823efd57252c12e4.1632813331.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/sections.h |   13 -------------
 1 file changed, 13 deletions(-)

--- a/arch/powerpc/include/asm/sections.h~powerpc-use-generic-version-of-arch_is_kernel_initmem_freed
+++ a/arch/powerpc/include/asm/sections.h
@@ -6,21 +6,8 @@
 #include <linux/elf.h>
 #include <linux/uaccess.h>
 
-#define arch_is_kernel_initmem_freed arch_is_kernel_initmem_freed
-
 #include <asm-generic/sections.h>
 
-extern bool init_mem_is_free;
-
-static inline int arch_is_kernel_initmem_freed(unsigned long addr)
-{
-	if (!init_mem_is_free)
-		return 0;
-
-	return addr >= (unsigned long)__init_begin &&
-		addr < (unsigned long)__init_end;
-}
-
 extern char __head_end[];
 
 #ifdef __powerpc64__
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

s390-use-generic-version-of-arch_is_kernel_initmem_freed.patch

