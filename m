Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41FEDC727B2
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244071AbjHXXWX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244069AbjHXXVo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:21:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07D6E6F
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:21:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6081D63778
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8560C433C7;
        Thu, 24 Aug 2023 23:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919298;
        bh=cKWX9Rin/fahExDEv/7lVkaorcmld9GLAa3zZrOAEoU=;
        h=Date:To:From:Subject:From;
        b=lA8JOG3cH4muiYiPT8c+n4FRIfm2I/5L/IKq3e5aGFAY+MDgB6ybnb5qeNQWSWVeg
         jcPOCZfYFkF+/v8qApqGYkNqH5O+wmOQvfZ0zt1tn5VRie9iugsMA1DbS2HSbBZGFB
         vRfvR8yNOIFSRz33IT7LJN8AqJS+6hNNBeta57CM=
Date:   Thu, 24 Aug 2023 16:21:38 -0700
To:     mm-commits@vger.kernel.org, svens@linux.ibm.com, rppt@kernel.org,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, borntraeger@linux.ibm.com,
        agordeev@linux.ibm.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-implement-the-new-page-table-range-api.patch removed from -mm tree
Message-Id: <20230824232138.B8560C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: s390: implement the new page table range API
has been removed from the -mm tree.  Its filename was
     s390-implement-the-new-page-table-range-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: s390: implement the new page table range API
Date: Wed, 2 Aug 2023 16:13:51 +0100

Add set_ptes() and update_mmu_cache_range().

Link: https://lkml.kernel.org/r/20230802151406.3735276-24-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/pgtable.h |   33 +++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

--- a/arch/s390/include/asm/pgtable.h~s390-implement-the-new-page-table-range-api
+++ a/arch/s390/include/asm/pgtable.h
@@ -47,6 +47,7 @@ static inline void update_page_count(int
  * tables contain all the necessary information.
  */
 #define update_mmu_cache(vma, address, ptep)     do { } while (0)
+#define update_mmu_cache_range(vmf, vma, addr, ptep, nr) do { } while (0)
 #define update_mmu_cache_pmd(vma, address, ptep) do { } while (0)
 
 /*
@@ -1316,20 +1317,34 @@ pgprot_t pgprot_writecombine(pgprot_t pr
 pgprot_t pgprot_writethrough(pgprot_t prot);
 
 /*
- * Certain architectures need to do special things when PTEs
- * within a page table are directly modified.  Thus, the following
- * hook is made available.
+ * Set multiple PTEs to consecutive pages with a single call.  All PTEs
+ * are within the same folio, PMD and VMA.
  */
-static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
-			      pte_t *ptep, pte_t entry)
+static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
+			      pte_t *ptep, pte_t entry, unsigned int nr)
 {
 	if (pte_present(entry))
 		entry = clear_pte_bit(entry, __pgprot(_PAGE_UNUSED));
-	if (mm_has_pgste(mm))
-		ptep_set_pte_at(mm, addr, ptep, entry);
-	else
-		set_pte(ptep, entry);
+	if (mm_has_pgste(mm)) {
+		for (;;) {
+			ptep_set_pte_at(mm, addr, ptep, entry);
+			if (--nr == 0)
+				break;
+			ptep++;
+			entry = __pte(pte_val(entry) + PAGE_SIZE);
+			addr += PAGE_SIZE;
+		}
+	} else {
+		for (;;) {
+			set_pte(ptep, entry);
+			if (--nr == 0)
+				break;
+			ptep++;
+			entry = __pte(pte_val(entry) + PAGE_SIZE);
+		}
+	}
 }
+#define set_ptes set_ptes
 
 /*
  * Conversion functions: convert a page and protection to a page entry,
_

Patches currently in -mm which might be from willy@infradead.org are


