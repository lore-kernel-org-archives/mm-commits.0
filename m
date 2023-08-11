Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C60E8C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236764AbjHKXA5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235401AbjHKW7w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:59:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12BA2D55
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 461F36556B
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CED8C433C7;
        Fri, 11 Aug 2023 22:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794782;
        bh=VCA9bfK5HINENq5C7KKtB6s1NvHsNaXzCkBY5TmdqC8=;
        h=Date:To:From:Subject:From;
        b=VFCidtLXOwbhJQSifMpYXom2ZUJcyut3Tz6xNxJEh3stNkC53ve4dT+jnnvBs2zTL
         2tcaXy2SgvwPh8USzabnKWs+YukzuHNbH1xiZl529r294gQ2eLLAc2PwExtJL3Y+LF
         Cg7nYRm5dzmn1p8uaiNK3R9OJdxGMwfsT0v5CPEU=
Date:   Fri, 11 Aug 2023 15:59:42 -0700
To:     mm-commits@vger.kernel.org, zhangpeng362@huawei.com,
        willy@infradead.org, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-convert-wp_page_shared-to-use-folios.patch removed from -mm tree
Message-Id: <20230811225942.9CED8C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory: convert wp_page_shared() to use folios
has been removed from the -mm tree.  Its filename was
     mm-memory-convert-wp_page_shared-to-use-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/memory: convert wp_page_shared() to use folios
Date: Thu, 6 Jul 2023 09:38:45 -0700

Saves six implicit calls to compound_head().

Link: https://lkml.kernel.org/r/20230706163847.403202-2-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: ZhangPeng <zhangpeng362@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/mm/memory.c~mm-memory-convert-wp_page_shared-to-use-folios
+++ a/mm/memory.c
@@ -3283,13 +3283,13 @@ static vm_fault_t wp_pfn_shared(struct v
 	return 0;
 }
 
-static vm_fault_t wp_page_shared(struct vm_fault *vmf)
+static vm_fault_t wp_page_shared(struct vm_fault *vmf, struct folio *folio)
 	__releases(vmf->ptl)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	vm_fault_t ret = 0;
 
-	get_page(vmf->page);
+	folio_get(folio);
 
 	if (vma->vm_ops && vma->vm_ops->page_mkwrite) {
 		vm_fault_t tmp;
@@ -3298,21 +3298,21 @@ static vm_fault_t wp_page_shared(struct
 		tmp = do_page_mkwrite(vmf);
 		if (unlikely(!tmp || (tmp &
 				      (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))) {
-			put_page(vmf->page);
+			folio_put(folio);
 			return tmp;
 		}
 		tmp = finish_mkwrite_fault(vmf);
 		if (unlikely(tmp & (VM_FAULT_ERROR | VM_FAULT_NOPAGE))) {
-			unlock_page(vmf->page);
-			put_page(vmf->page);
+			folio_unlock(folio);
+			folio_put(folio);
 			return tmp;
 		}
 	} else {
 		wp_page_reuse(vmf);
-		lock_page(vmf->page);
+		folio_lock(folio);
 	}
 	ret |= fault_dirty_shared_page(vmf);
-	put_page(vmf->page);
+	folio_put(folio);
 
 	return ret;
 }
@@ -3363,6 +3363,9 @@ static vm_fault_t do_wp_page(struct vm_f
 
 	vmf->page = vm_normal_page(vma, vmf->address, vmf->orig_pte);
 
+	if (vmf->page)
+		folio = page_folio(vmf->page);
+
 	/*
 	 * Shared mapping: we are guaranteed to have VM_WRITE and
 	 * FAULT_FLAG_WRITE set at this point.
@@ -3377,12 +3380,9 @@ static vm_fault_t do_wp_page(struct vm_f
 		 */
 		if (!vmf->page)
 			return wp_pfn_shared(vmf);
-		return wp_page_shared(vmf);
+		return wp_page_shared(vmf, folio);
 	}
 
-	if (vmf->page)
-		folio = page_folio(vmf->page);
-
 	/*
 	 * Private mapping: create an exclusive anonymous page copy if reuse
 	 * is impossible. We might miss VM_WRITE for FOLL_FORCE handling.
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


