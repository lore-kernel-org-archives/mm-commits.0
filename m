Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F074EE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbjHUUmy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbjHUUmG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:42:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B5C198
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:41:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AB326154F
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:41:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2382C433C8;
        Mon, 21 Aug 2023 20:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650468;
        bh=JNL946S0QTe/w/Fcf/fYIWjgUCJt+NvNi35Tr0AmlmY=;
        h=Date:To:From:Subject:From;
        b=Tqy7Cx0kpy5GTFfPc3SmX4SCKRfM8n1VwVRCvWXJsDc9PJG2/Yz59k3y+2bTFyWWg
         T1OZKWZ7lGx5cMeGYxbBUmjgDUDmdJIDFut60GufsafHT5XvBfjvmfjfLBWm6vFsKP
         fva1hbTVGLnNRx3rNfzBm3/nfasMNzHAfxEx8aMo=
Date:   Mon, 21 Aug 2023 13:41:08 -0700
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
Subject: [merged mm-stable] mm-convert-pmd_pgtable_page-callers-to-use-pmd_ptdesc.patch removed from -mm tree
Message-Id: <20230821204108.C2382C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: convert pmd_pgtable_page() callers to use pmd_ptdesc()
has been removed from the -mm tree.  Its filename was
     mm-convert-pmd_pgtable_page-callers-to-use-pmd_ptdesc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm: convert pmd_pgtable_page() callers to use pmd_ptdesc()
Date: Mon, 7 Aug 2023 16:04:46 -0700

Converts internal pmd_pgtable_page() callers to use pmd_ptdesc().  This
removes some direct accesses to struct page, working towards splitting out
struct ptdesc from struct page.

Link: https://lkml.kernel.org/r/20230807230513.102486-5-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
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
Cc: Guo Ren <guoren@kernel.org>
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

 include/linux/mm.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-convert-pmd_pgtable_page-callers-to-use-pmd_ptdesc
+++ a/include/linux/mm.h
@@ -2956,7 +2956,7 @@ static inline struct ptdesc *pmd_ptdesc(
 
 static inline spinlock_t *pmd_lockptr(struct mm_struct *mm, pmd_t *pmd)
 {
-	return ptlock_ptr(pmd_pgtable_page(pmd));
+	return ptlock_ptr(ptdesc_page(pmd_ptdesc(pmd)));
 }
 
 static inline bool pmd_ptlock_init(struct page *page)
@@ -2975,7 +2975,7 @@ static inline void pmd_ptlock_free(struc
 	ptlock_free(page);
 }
 
-#define pmd_huge_pte(mm, pmd) (pmd_pgtable_page(pmd)->pmd_huge_pte)
+#define pmd_huge_pte(mm, pmd) (pmd_ptdesc(pmd)->pmd_huge_pte)
 
 #else
 
_

Patches currently in -mm which might be from vishal.moola@gmail.com are


