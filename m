Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 681A5EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:21:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjFSXVw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbjFSXVN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:21:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE9010D7
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:20:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C2A360F60
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:20:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED36C433C8;
        Mon, 19 Jun 2023 23:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216858;
        bh=JsNS4QVtKPG24aetuGmjh8Lia5uGZH2W7DpGeGMw5yQ=;
        h=Date:To:From:Subject:From;
        b=BXh1JJjKigkk+AjaARoL3+KONuiIA0TVWqQwVJTztkgxIxCmK83fULn2ebWIMLuQt
         K9EtnfTw/xNs/qtQLQo/lW/D5ZAoXbwaFmj0BDf7JO42KmNHqcjY35bQkvwSJvGaJl
         UryuMjmjq22EbzN+qmXVNzsCh4fztM+9wJy1amqc=
Date:   Mon, 19 Jun 2023 16:20:58 -0700
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
Subject: [merged mm-stable] parisc-unmap_uncached_pte-use-pte_offset_kernel.patch removed from -mm tree
Message-Id: <20230619232058.BED36C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: parisc: unmap_uncached_pte() use pte_offset_kernel()
has been removed from the -mm tree.  Its filename was
     parisc-unmap_uncached_pte-use-pte_offset_kernel.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: parisc: unmap_uncached_pte() use pte_offset_kernel()
Date: Thu, 8 Jun 2023 12:20:00 -0700 (PDT)

unmap_uncached_pte() is working from pgd_offset_k(vaddr), so it should
use pte_offset_kernel() instead of pte_offset_map(), to avoid the
question of whether a pte_unmap() will be needed to balance.

Link: https://lkml.kernel.org/r/358dfe21-a47f-9d3-bf21-9c454735944@google.com
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

 arch/parisc/kernel/pci-dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/parisc/kernel/pci-dma.c~parisc-unmap_uncached_pte-use-pte_offset_kernel
+++ a/arch/parisc/kernel/pci-dma.c
@@ -164,7 +164,7 @@ static inline void unmap_uncached_pte(pm
 		pmd_clear(pmd);
 		return;
 	}
-	pte = pte_offset_map(pmd, vaddr);
+	pte = pte_offset_kernel(pmd, vaddr);
 	vaddr &= ~PMD_MASK;
 	end = vaddr + size;
 	if (end > PMD_SIZE)
_

Patches currently in -mm which might be from hughd@google.com are


