Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 274CEEE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:43:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbjHUUn3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbjHUUnA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:43:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6990CC0
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:41:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4516264B2D
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:41:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96EEAC433C7;
        Mon, 21 Aug 2023 20:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650492;
        bh=0Vtz7m9mR8JXhM0W/BipnbGns7UaWAl4geflhDbBnvE=;
        h=Date:To:From:Subject:From;
        b=ZKdcW4+nTqSFduZKc5sbWZdkhYyrCaMIp0RRz4geW1XyILhmReuPYjiZbyZ2OSEa2
         776bl0bbr0wDk2n/SY3vWhtPWEym9e03wqZ9beTL0AQzowaOJ3y135POsmhpg2lTgd
         O4leHXbSEuFtJx8JSYY3wGEBZCOiVWMiO8AyiDwg=
Date:   Mon, 21 Aug 2023 13:41:32 -0700
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        willy@infradead.org, tsbogend@alpha.franken.de, rppt@kernel.org,
        richard@nod.at, paul.walmsley@sifive.com, palmer@rivosinc.com,
        jonas@southpole.se, imbrenda@linux.ibm.com, hughd@google.com,
        guoren@kernel.org, glaubitz@physik.fu-berlin.de,
        geert+renesas@glider.be, geert@linux-m68k.org, dinguyen@kernel.org,
        david@redhat.com, davem@davemloft.net, dave.hansen@linux.intel.com,
        christophe.leroy@csgroup.eu, chenhuacai@kernel.org,
        catalin.marinas@arm.com, arnd@arndb.de, vishal.moola@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] csky-convert-__pte_free_tlb-to-use-ptdescs.patch removed from -mm tree
Message-Id: <20230821204132.96EEAC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: csky: convert __pte_free_tlb() to use ptdescs
has been removed from the -mm tree.  Its filename was
     csky-convert-__pte_free_tlb-to-use-ptdescs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: csky: convert __pte_free_tlb() to use ptdescs
Date: Mon, 7 Aug 2023 16:05:01 -0700

Part of the conversions to replace pgtable constructor/destructors with
ptdesc equivalents.

Link: https://lkml.kernel.org/r/20230807230513.102486-20-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Guo Ren <guoren@kernel.org>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/csky/include/asm/pgalloc.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/csky/include/asm/pgalloc.h~csky-convert-__pte_free_tlb-to-use-ptdescs
+++ a/arch/csky/include/asm/pgalloc.h
@@ -63,8 +63,8 @@ static inline pgd_t *pgd_alloc(struct mm
 
 #define __pte_free_tlb(tlb, pte, address)		\
 do {							\
-	pgtable_pte_page_dtor(pte);			\
-	tlb_remove_page(tlb, pte);			\
+	pagetable_pte_dtor(page_ptdesc(pte));		\
+	tlb_remove_page_ptdesc(tlb, page_ptdesc(pte));	\
 } while (0)
 
 extern void pagetable_init(void);
_

Patches currently in -mm which might be from vishal.moola@gmail.com are


