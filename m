Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AECBC0015E
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjFSXWU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjFSXVS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:21:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EC6F9
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:21:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C28BF60F78
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:21:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196EAC433CC;
        Mon, 19 Jun 2023 23:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216874;
        bh=q/b2Pp82AiUpZTTi2udXB/+VGLrzvhHONzk/NAvpFN0=;
        h=Date:To:From:Subject:From;
        b=2f0FBrTEz/D04ANKfMuaF+nsnQRGDXJQ2CnbZmd9Q5NA4KDHy6zQCmM3QgLJadcM7
         8IU38CTK8FF8nmq4DAPO3PLpOh5TXP0+OXsNTpE9lZK9pcHUBssgodLX6o5giiKkl0
         HNLJmPz8F3WoidMc426hX86S7bK8zhdj9wDv/Vew=
Date:   Mon, 19 Jun 2023 16:21:13 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        willy@infradead.org, will@kernel.org, tsbogend@alpha.franken.de,
        tglx@linutronix.de, surenb@google.com, rppt@kernel.org,
        peterz@infradead.org, palmer@dabbelt.com, mpe@ellerman.id.au,
        monstr@monstr.eu, mingo@kernel.org, mike.kravetz@oracle.com,
        linux@armlinux.org.uk, kirill.shutemov@linux.intel.com,
        jcmvbkbc@gmail.com, imbrenda@linux.ibm.com, hpa@zytor.com,
        hca@linux.ibm.com, glaubitz@physik.fu-berlin.de,
        gerg@linux-m68k.org, geert@linux-m68k.org, deller@gmx.de,
        david@redhat.com, davem@davemloft.net, dave.anglin@bell.net,
        chris@zankel.net, catalin.marinas@arm.com,
        borntraeger@linux.ibm.com, aneesh.kumar@linux.ibm.com,
        alexghiti@rivosinc.com, agordeev@linux.ibm.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sparc-iounit-and-iommu-use-pte_offset_kernel.patch removed from -mm tree
Message-Id: <20230619232114.196EAC433CC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: sparc: iounit and iommu use pte_offset_kernel()
has been removed from the -mm tree.  Its filename was
     sparc-iounit-and-iommu-use-pte_offset_kernel.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: sparc: iounit and iommu use pte_offset_kernel()
Date: Thu, 8 Jun 2023 12:33:40 -0700 (PDT)

iounit_alloc() and sbus_iommu_alloc() are working from pmd_off_k(),
so should use pte_offset_kernel() instead of pte_offset_map(), to avoid
the question of whether a pte_unmap() will be needed to balance.

Link: https://lkml.kernel.org/r/99962272-12ff-975d-bf7f-7fd5d95a2df5@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: John David Anglin <dave.anglin@bell.net>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/io-unit.c |    2 +-
 arch/sparc/mm/iommu.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sparc/mm/iommu.c~sparc-iounit-and-iommu-use-pte_offset_kernel
+++ a/arch/sparc/mm/iommu.c
@@ -358,7 +358,7 @@ static void *sbus_iommu_alloc(struct dev
 				__flush_page_to_ram(page);
 
 			pmdp = pmd_off_k(addr);
-			ptep = pte_offset_map(pmdp, addr);
+			ptep = pte_offset_kernel(pmdp, addr);
 
 			set_pte(ptep, mk_pte(virt_to_page(page), dvma_prot));
 		}
--- a/arch/sparc/mm/io-unit.c~sparc-iounit-and-iommu-use-pte_offset_kernel
+++ a/arch/sparc/mm/io-unit.c
@@ -244,7 +244,7 @@ static void *iounit_alloc(struct device
 			long i;
 
 			pmdp = pmd_off_k(addr);
-			ptep = pte_offset_map(pmdp, addr);
+			ptep = pte_offset_kernel(pmdp, addr);
 
 			set_pte(ptep, mk_pte(virt_to_page(page), dvma_prot));
 
_

Patches currently in -mm which might be from hughd@google.com are


