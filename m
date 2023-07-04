Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F9FAEB64DD
	for <mm-commits@archiver.kernel.org>; Tue,  4 Jul 2023 05:39:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbjGDFjP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Jul 2023 01:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjGDFjP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jul 2023 01:39:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E494E49
        for <mm-commits@vger.kernel.org>; Mon,  3 Jul 2023 22:39:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 082CD61122
        for <mm-commits@vger.kernel.org>; Tue,  4 Jul 2023 05:39:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633AEC433C8;
        Tue,  4 Jul 2023 05:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688449153;
        bh=5tkkyfLsSbwbd1jQaV4iaMLrfpV/ktiCclHPyP7+kec=;
        h=Date:To:From:Subject:From;
        b=ZSpIk1WZmne5Svm0m9pu7hbp6MAFI+j4cVEFMyhiaS1R1VUOs7Yhh0iepkCoTOif6
         PdFRl4XJUfTf/jwYnryiBWpQEV5qc85xYHBX0XhjLuztVHNFdoc8chC1xixxRUQF4s
         n0qdj3bSyWlCoysjDNAAZGzo5iaha76woo2cqOxY=
Date:   Mon, 03 Jul 2023 22:39:12 -0700
To:     mm-commits@vger.kernel.org, zhangpeng362@huawei.com,
        willy@infradead.org, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-convert-wp_page_shared-to-use-folios.patch removed from -mm tree
Message-Id: <20230704053913.633AEC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory: convert wp_page_shared() to use folios
has been removed from the -mm tree.  Its filename was
     mm-memory-convert-wp_page_shared-to-use-folios.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/memory: convert wp_page_shared() to use folios
Date: Sun, 2 Jul 2023 22:58:48 -0700

Saves five implicit calls to compound_head().

Link: https://lkml.kernel.org/r/20230703055850.227169-2-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: ZhangPeng <zhangpeng362@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/mm/memory.c~mm-memory-convert-wp_page_shared-to-use-folios
+++ a/mm/memory.c
@@ -3287,8 +3287,9 @@ static vm_fault_t wp_page_shared(struct
 {
 	struct vm_area_struct *vma = vmf->vma;
 	vm_fault_t ret = 0;
+	struct folio *folio = page_folio(vmf->page);
 
-	get_page(vmf->page);
+	folio_get(folio);
 
 	if (vma->vm_ops && vma->vm_ops->page_mkwrite) {
 		vm_fault_t tmp;
@@ -3297,21 +3298,21 @@ static vm_fault_t wp_page_shared(struct
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
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-increase-usage-of-folio_next_index-helper.patch
mm-memory-convert-do_shared_fault-to-folios.patch
mm-memory-convert-do_read_fault-to-use-folios.patch

