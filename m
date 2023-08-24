Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BDCEC727A4
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244063AbjHXXWw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244035AbjHXXWL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:22:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE53FA1
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:22:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DF8B64FED
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32EFC433C7;
        Thu, 24 Aug 2023 23:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919328;
        bh=u3jcdJPPmkIFMWT7fu1fMzTJzpF7MNVI6RiQuC/Qhz4=;
        h=Date:To:From:Subject:From;
        b=xOKgOIRmYr5f1XKsilFxM/8PQ8cfQo9/ZsOYRcNSlNkjjjxktekYqyDGENFX3U/i2
         WlU+M1qJXZeYxVMaUg00EE4IW5tBGiIfXH0aVty95ln2xCrqDE4AwCwmGqKyrKJAqp
         ogDKYPYMRuRvYscHxp4CZ5mK1/8NXFR/nnsLv95Q=
Date:   Thu, 24 Aug 2023 16:22:08 -0700
To:     mm-commits@vger.kernel.org, stettberger@dokucode.de,
        rppt@kernel.org, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-checks-for-pte_index.patch removed from -mm tree
Message-Id: <20230824232208.D32EFC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove checks for pte_index
has been removed from the -mm tree.  Its filename was
     mm-remove-checks-for-pte_index.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove checks for pte_index
Date: Sat, 19 Aug 2023 04:18:37 +0100

Since pte_index is always defined, we don't need to check whether it's
defined or not.  Delete the slow version that doesn't depend on it and
remove the #define since nobody needs to test for it.

Link: https://lkml.kernel.org/r/20230819031837.3160096-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Christian Dietrich <stettberger@dokucode.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    1 -
 mm/memory.c             |   17 +----------------
 2 files changed, 1 insertion(+), 17 deletions(-)

--- a/include/linux/pgtable.h~mm-remove-checks-for-pte_index
+++ a/include/linux/pgtable.h
@@ -63,7 +63,6 @@ static inline unsigned long pte_index(un
 {
 	return (address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1);
 }
-#define pte_index pte_index
 
 #ifndef pmd_index
 static inline unsigned long pmd_index(unsigned long address)
--- a/mm/memory.c~mm-remove-checks-for-pte_index
+++ a/mm/memory.c
@@ -1869,7 +1869,6 @@ out:
 	return retval;
 }
 
-#ifdef pte_index
 static int insert_page_in_batch_locked(struct vm_area_struct *vma, pte_t *pte,
 			unsigned long addr, struct page *page, pgprot_t prot)
 {
@@ -1884,7 +1883,7 @@ static int insert_page_in_batch_locked(s
 }
 
 /* insert_pages() amortizes the cost of spinlock operations
- * when inserting pages in a loop. Arch *must* define pte_index.
+ * when inserting pages in a loop.
  */
 static int insert_pages(struct vm_area_struct *vma, unsigned long addr,
 			struct page **pages, unsigned long *num, pgprot_t prot)
@@ -1943,7 +1942,6 @@ out:
 	*num = remaining_pages_total;
 	return ret;
 }
-#endif  /* ifdef pte_index */
 
 /**
  * vm_insert_pages - insert multiple pages into user vma, batching the pmd lock.
@@ -1963,7 +1961,6 @@ out:
 int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
 			struct page **pages, unsigned long *num)
 {
-#ifdef pte_index
 	const unsigned long end_addr = addr + (*num * PAGE_SIZE) - 1;
 
 	if (addr < vma->vm_start || end_addr >= vma->vm_end)
@@ -1975,18 +1972,6 @@ int vm_insert_pages(struct vm_area_struc
 	}
 	/* Defer page refcount checking till we're about to map that page. */
 	return insert_pages(vma, addr, pages, num, vma->vm_page_prot);
-#else
-	unsigned long idx = 0, pgcount = *num;
-	int err = -EINVAL;
-
-	for (; idx < pgcount; ++idx) {
-		err = vm_insert_page(vma, addr + (PAGE_SIZE * idx), pages[idx]);
-		if (err)
-			break;
-	}
-	*num = pgcount - idx;
-	return err;
-#endif  /* ifdef pte_index */
 }
 EXPORT_SYMBOL(vm_insert_pages);
 
_

Patches currently in -mm which might be from willy@infradead.org are


