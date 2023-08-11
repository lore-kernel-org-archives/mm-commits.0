Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0759C001DB
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236918AbjHKXA5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236864AbjHKW7w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:59:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E66330D2
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99CF666B5A
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00BE0C433C7;
        Fri, 11 Aug 2023 22:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794784;
        bh=YwtnlD8xR13EAk59sWMXLRLwIHtv0u1DBbzS9ExVTkk=;
        h=Date:To:From:Subject:From;
        b=clbBjjlfRVS8HPcFq2EtMb4POWPOvZ+aM8/CsQWcmnggnmB3UjvuWd2j5jfRYLVOZ
         gXGeKx2h18ZuremlZ7Uh4S6UoDB/hz+SqvcDBOymkLjwt7b0OYRET66v88UgWH970M
         wslUG+ynzrMTv703Aiirs50u5dH3lb7LnhLIsoaY=
Date:   Fri, 11 Aug 2023 15:59:43 -0700
To:     mm-commits@vger.kernel.org, zhangpeng362@huawei.com,
        willy@infradead.org, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-convert-do_shared_fault-to-folios.patch removed from -mm tree
Message-Id: <20230811225944.00BE0C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory: convert do_shared_fault() to folios
has been removed from the -mm tree.  Its filename was
     mm-memory-convert-do_shared_fault-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/memory: convert do_shared_fault() to folios
Date: Thu, 6 Jul 2023 09:38:46 -0700

Saves three implicit calls to compound_head().

Link: https://lkml.kernel.org/r/20230706163847.403202-3-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: ZhangPeng <zhangpeng362@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/memory.c~mm-memory-convert-do_shared_fault-to-folios
+++ a/mm/memory.c
@@ -4602,21 +4602,24 @@ static vm_fault_t do_shared_fault(struct
 {
 	struct vm_area_struct *vma = vmf->vma;
 	vm_fault_t ret, tmp;
+	struct folio *folio;
 
 	ret = __do_fault(vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		return ret;
 
+	folio = page_folio(vmf->page);
+
 	/*
 	 * Check if the backing address space wants to know that the page is
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
@@ -4624,8 +4627,8 @@ static vm_fault_t do_shared_fault(struct
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


