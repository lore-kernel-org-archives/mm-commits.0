Return-Path: <SRS0=ColI=A4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48B81C433E2
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jul 2020 21:11:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E4BA20717
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jul 2020 21:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595020284;
	bh=lL1LsMmRzgGcRr/+QHwfxWU4RODAXX5GjB+Nrj2t4h4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=eeCCvmuQH7cnmgwHNQW5PCgX+pqUiEf8nUe1/0s9RnVcIv3XXwaEybUTvgKQ0etcD
	 8eGQIzlCg47A6AA+jL75tBu5mR69E2U+iOFmGUDweH5uETA/HNaMnmiLqnfV9ttFR7
	 GDqOFl0Zm5VctznRvtS40XWPbzopi4EhcAlJ6n3k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgGQVLX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jul 2020 17:11:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:42564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726399AbgGQVLX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Jul 2020 17:11:23 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D121F2076A;
        Fri, 17 Jul 2020 21:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595020283;
        bh=lL1LsMmRzgGcRr/+QHwfxWU4RODAXX5GjB+Nrj2t4h4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HkdHywCJcXjccQ8jnVpFV8qCE/ONl08ifzWe+W6Nd0hs0IojgFl3YnFtYKDI5ETq7
         VFYFtHwouus5g5dkXlvbFUqhk6xymtvWih89ibbf13wdQ2yxR3LsKwNrb3SPywcinu
         bIzanX7og+uFhHffKZkhyxqscIMl/R21BN+ydgr0=
Date:   Fri, 17 Jul 2020 14:11:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     mm-commits@vger.kernel.org, palmerdabbelt@google.com,
        penberg@kernel.org, rientjes@google.com, rppt@linux.ibm.com,
        thomas.lendacky@amd.com
Subject:  +
 riscv-use-generic-pgprot_-macros-from-linux-pgtableh.patch added to -mm
 tree
Message-ID: <20200717211122.30vLqmcUU%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: riscv: use generic pgprot_* macros from <linux/pgtable.h>
has been added to the -mm tree.  Its filename is
     riscv-use-generic-pgprot_-macros-from-linux-pgtableh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/riscv-use-generic-pgprot_-macros-from-linux-pgtableh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/riscv-use-generic-pgprot_-macros-from-linux-pgtableh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-pgtable-make-generic-pgprot_-macros-available-for-no-mmu.patch
riscv-use-generic-pgprot_-macros-from-linux-pgtableh.patch

