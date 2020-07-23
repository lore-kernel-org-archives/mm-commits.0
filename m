Return-Path: <SRS0=ssb3=BC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86F8EC433E1
	for <mm-commits@archiver.kernel.org>; Thu, 23 Jul 2020 23:23:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C30320792
	for <mm-commits@archiver.kernel.org>; Thu, 23 Jul 2020 23:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595546616;
	bh=iTZMOGJAo/3NQLuhEg3gh60t8l63Zhn9YUxzBezCsMA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=0jefqt2buI+6yCUEpOCKIzWNaO7sMkKNY85gY8jbgYS25xpFTpnmxScMkIgIffw+1
	 VvRuppjNzQaLbDTNeLfTWTq+zb5Va+dQ8vZqI+hdo50NV6Eqltt0gHXuvImWGaksLL
	 H7OmW7lUK0WEMbNSFMYLadG3xvtq0uJY1TlgizNM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbgGWXXg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Jul 2020 19:23:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726723AbgGWXXf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Jul 2020 19:23:35 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BB3420825;
        Thu, 23 Jul 2020 23:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595546615;
        bh=iTZMOGJAo/3NQLuhEg3gh60t8l63Zhn9YUxzBezCsMA=;
        h=Date:From:To:Subject:From;
        b=sV5SyMEOtJuV93DcT83acr7+3Gtwgt+tm4e52t4hC3yIyhfiCOzqZ/bNoM1k6AXVx
         ipg2QLdM5xwnXK2K9LBlDiGXdoLfxlWtdhfsvRuA7c8tybqBFVK1ndKEAbr1+Eiv13
         Qc0ag11Kqwrcnyz7E+rjpRLBPbQ0tSoVAeKQVugY=
Date:   Thu, 23 Jul 2020 16:23:35 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, palmerdabbelt@google.com,
        penberg@kernel.org, rientjes@google.com, rppt@linux.ibm.com,
        thomas.lendacky@amd.com
Subject:  [merged]
 riscv-use-generic-pgprot_-macros-from-linux-pgtableh.patch removed from -mm
 tree
Message-ID: <20200723232335.E9Mp9riZq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: riscv: use generic pgprot_* macros from <linux/pgtable.h>
has been removed from the -mm tree.  Its filename was
     riscv-use-generic-pgprot_-macros-from-linux-pgtableh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pekka Enberg <penberg@kernel.org>
Subject: riscv: use generic pgprot_* macros from <linux/pgtable.h>

The <linux/pgtable.h> header now defines generic pgprot_ macros also for
the no-MMU configuration, so let's use them.

Link: http://lkml.kernel.org/r/20200715053340.576300-2-penberg@gmail.com
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Cc: Palmer Dabbelt <palmerdabbelt@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/include/asm/mmio.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/arch/riscv/include/asm/mmio.h~riscv-use-generic-pgprot_-macros-from-linux-pgtableh
+++ a/arch/riscv/include/asm/mmio.h
@@ -14,12 +14,6 @@
 #include <linux/types.h>
 #include <asm/mmiowb.h>
 
-#ifndef CONFIG_MMU
-#define pgprot_noncached(x)	(x)
-#define pgprot_writecombine(x)	(x)
-#define pgprot_device(x)	(x)
-#endif /* CONFIG_MMU */
-
 /* Generic IO read/write.  These perform native-endian accesses. */
 #define __raw_writeb __raw_writeb
 static inline void __raw_writeb(u8 val, volatile void __iomem *addr)
_

Patches currently in -mm which might be from penberg@kernel.org are


