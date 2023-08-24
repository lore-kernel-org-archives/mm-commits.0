Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C864C727AF
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240477AbjHXXWT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241313AbjHXXVr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:21:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6926DFB
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:21:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F39E264452
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:21:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 562DEC433C8;
        Thu, 24 Aug 2023 23:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919303;
        bh=gsYOSt+yWR8YQR41MxjtMXkgDyEEPV6oZtDr5twoYFo=;
        h=Date:To:From:Subject:From;
        b=yV66swb0aVOiml9DL75pyJV27pz7pEgwC+n5rKkxzrl8r5gopUBy/r/OJC71SSl/U
         zXublgqz3tL7VO/ktAKk+8WdSSAKNmyvC+1XETNcvOz+B0biLINCGfwKVbw8RP5V7Q
         ow9fOCkNhhnxPdZ2ete/Bf9hMZ9001nXNIoc/UME=
Date:   Thu, 24 Aug 2023 16:21:42 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, richard@nod.at,
        johannes@sipsolutions.net, anton.ivanov@cambridgegreys.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] um-implement-the-new-page-table-range-api.patch removed from -mm tree
Message-Id: <20230824232143.562DEC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: um: implement the new page table range API
has been removed from the -mm tree.  Its filename was
     um-implement-the-new-page-table-range-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: um: implement the new page table range API
Date: Wed, 2 Aug 2023 16:13:55 +0100

Add PFN_PTE_SHIFT and update_mmu_cache_range().

Link: https://lkml.kernel.org/r/20230802151406.3735276-28-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/asm/pgtable.h |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/arch/um/include/asm/pgtable.h~um-implement-the-new-page-table-range-api
+++ a/arch/um/include/asm/pgtable.h
@@ -242,11 +242,7 @@ static inline void set_pte(pte_t *pteptr
 	if(pte_present(*pteptr)) *pteptr = pte_mknewprot(*pteptr);
 }
 
-static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
-			      pte_t *pteptr, pte_t pteval)
-{
-	set_pte(pteptr, pteval);
-}
+#define PFN_PTE_SHIFT		PAGE_SHIFT
 
 #define __HAVE_ARCH_PTE_SAME
 static inline int pte_same(pte_t pte_a, pte_t pte_b)
@@ -290,6 +286,7 @@ struct mm_struct;
 extern pte_t *virt_to_pte(struct mm_struct *mm, unsigned long addr);
 
 #define update_mmu_cache(vma,address,ptep) do {} while (0)
+#define update_mmu_cache_range(vmf, vma, address, ptep, nr) do {} while (0)
 
 /*
  * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
_

Patches currently in -mm which might be from willy@infradead.org are


