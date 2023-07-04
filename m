Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA256EB64DA
	for <mm-commits@archiver.kernel.org>; Tue,  4 Jul 2023 05:39:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjGDFjT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Jul 2023 01:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjGDFjQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jul 2023 01:39:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB2EBE
        for <mm-commits@vger.kernel.org>; Mon,  3 Jul 2023 22:39:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 215636112F
        for <mm-commits@vger.kernel.org>; Tue,  4 Jul 2023 05:39:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F88C433C7;
        Tue,  4 Jul 2023 05:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688449154;
        bh=oE6EOkDXJadpAccjZKWgUlXIy8pxOwaT/3EXJVFwBrk=;
        h=Date:To:From:Subject:From;
        b=dsQhqn5lUC+hmAvdHmtepL9rhAWJ+sn6EuIvFtWflv6eU+1x8yx1vkbxpbmnFjMT8
         aQJX4Z2IIa1FC7v8WNkiQyfEGFek2ubD1Ro3VEIEYUagdGAKZT2Jhg3CY8qydowgK3
         iB0fCe1AIIWgT4F8g+KvrdKKycrhb1wMx/HtG+8Y=
Date:   Mon, 03 Jul 2023 22:39:13 -0700
To:     mm-commits@vger.kernel.org, zhangpeng362@huawei.com,
        willy@infradead.org, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-convert-do_shared_fault-to-folios.patch removed from -mm tree
Message-Id: <20230704053914.76F88C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory: convert do_shared_fault() to folios
has been removed from the -mm tree.  Its filename was
     mm-memory-convert-do_shared_fault-to-folios.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/memory: convert do_shared_fault() to folios
Date: Sun, 2 Jul 2023 22:58:49 -0700

Saves three implicit calls to compound_head().

Link: https://lkml.kernel.org/r/20230703055850.227169-3-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: ZhangPeng <zhangpeng362@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/memory.c~mm-memory-convert-do_shared_fault-to-folios
+++ a/mm/memory.c
@@ -4605,6 +4605,7 @@ static vm_fault_t do_shared_fault(struct
 {
 	struct vm_area_struct *vma = vmf->vma;
 	vm_fault_t ret, tmp;
+	struct folio *folio = page_folio(vmf->page);
 
 	ret = __do_fault(vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
@@ -4615,11 +4616,11 @@ static vm_fault_t do_shared_fault(struct
 	 * about to become writable
 	 */
 	if (vma->vm_ops->page_mkwrite) {
-		unlock_page(vmf->page);
+		folio_unlock(folio);
 		tmp = do_page_mkwrite(vmf);
 		if (unlikely(!tmp ||
 				(tmp & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))) {
-			put_page(vmf->page);
+			folio_put(folio);
 			return tmp;
 		}
 	}
@@ -4627,8 +4628,8 @@ static vm_fault_t do_shared_fault(struct
 	ret |= finish_fault(vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE |
 					VM_FAULT_RETRY))) {
-		unlock_page(vmf->page);
-		put_page(vmf->page);
+		folio_unlock(folio);
+		folio_put(folio);
 		return ret;
 	}
 
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-increase-usage-of-folio_next_index-helper.patch
mm-memory-convert-do_read_fault-to-use-folios.patch

