Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48894C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:53:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A8F922CA1
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596779590;
	bh=Wyn4DZNb01Lc2i/PsI04stxe5lmuvYQN+RjvLmjcpKU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=TI0CgkVwF1ENIi7Sh8LjJ9lMUmHnMGoPt+KMUhstyQRvZdIjDsjtgaAK1jseDASvE
	 AordVJfmG/v6g5aidsbxQI2Z9HVxhEGRjD99414H18H8brI4k7qKMhYa6RrvUjsIaX
	 v83HBPkbTz/1iabC8Ofg/8CGdn4TQGYK3Iv5H1NQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbgHGFxJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 01:53:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGFxJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 01:53:09 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEDBE21744;
        Fri,  7 Aug 2020 05:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596779589;
        bh=Wyn4DZNb01Lc2i/PsI04stxe5lmuvYQN+RjvLmjcpKU=;
        h=Date:From:To:Subject:From;
        b=Fn/iCYPju8fODjYZHG8A5XBsgXauFqHxxF6nU+P6Jtl7FSvCqmdpnWR3MWbKjoj9d
         mRmQZAL5XL2MfZZFkluROmO4HmHpRL5naaHKY5QDCCGyLqs69DCamVnvXpbZ2QKuTV
         EAyUjdH9AxbI8LzZ2qZWTk48M4k4/Z4Ux1ow8I60=
Date:   Thu, 06 Aug 2020 22:53:08 -0700
From:   akpm@linux-foundation.org
To:     lkp@intel.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        sfr@canb.auug.org.au
Subject:  [folded-merged]
 mm-remove-unneeded-includes-of-asm-pgalloch-fix.patch removed from -mm tree
Message-ID: <20200807055308.D_eOmtk4M%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: fix compilation warning caused by missing include of asm/pgalloc.h
has been removed from the -mm tree.  Its filename was
     mm-remove-unneeded-includes-of-asm-pgalloch-fix.patch

This patch was dropped because it was folded into mm-remove-unneeded-includes-of-asm-pgalloch.patch

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: powerpc: fix compilation warning caused by missing include of asm/pgalloc.h

Recent rework of asm/pgalloc.h caused a compilation warning reported by
kbuild bot:

All warnings (new ones prefixed by >>):

>> arch/powerpc/mm/nohash/tlb.c:409:6: warning: no previous prototype for
>> 'tlb_flush_pgtable' [-Wmissing-prototypes]
     409 | void tlb_flush_pgtable(struct mmu_gather *tlb, unsigned long address)
         |      ^~~~~~~~~~~~~~~~~

Add missing include of asm/pgtable.h to arch/powerpc/mm/nohash/tlb.c to
make tlb_flush_pgtable() prototype visible there.

Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/nohash/tlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/mm/nohash/tlb.c~mm-remove-unneeded-includes-of-asm-pgalloch-fix
+++ a/arch/powerpc/mm/nohash/tlb.c
@@ -34,6 +34,7 @@
 #include <linux/of_fdt.h>
 #include <linux/hugetlb.h>
 
+#include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/tlb.h>
 #include <asm/code-patching.h>
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-remove-unneeded-includes-of-asm-pgalloch.patch
opeinrisc-switch-to-generic-version-of-pte-allocation.patch
xtensa-switch-to-generic-version-of-pte-allocation.patch
asm-generic-pgalloc-provide-generic-pmd_alloc_one-and-pmd_free_one.patch
asm-generic-pgalloc-provide-generic-pud_alloc_one-and-pud_free_one.patch
asm-generic-pgalloc-provide-generic-pgd_free.patch
mm-move-lib-ioremapc-to-mm.patch
mm-sparse-cleanup-the-code-surrounding-memory_present.patch
mm-vmalloc-remove-redundant-asignmnet-in-unmap_kernel_range_noflush.patch

