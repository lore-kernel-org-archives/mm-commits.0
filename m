Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0FA6C41513
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235234AbjHKXBu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236294AbjHKXAf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:00:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED2E3A8F
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E5A862FEF
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9908C433C8;
        Fri, 11 Aug 2023 23:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794815;
        bh=xer/mpaIxUn6S5fS0s8EFRriTqU3z6G2kQ9N58ee2lY=;
        h=Date:To:From:Subject:From;
        b=MaTorzJJJQ6P2G1Z3qM/tvoS5bxDnIGDZv4nbTrszXcU0q++JzSV4imUom9HWRh5c
         gAfSUMJ0K4odyptoBZTWVztf0u8ZcArX5yQrLghWh3vZSn0UkPfBmWiPlJiKon4dGP
         nntOGFWGioqQpZjrntkBKIRuNfh141tJXYAjJAT0=
Date:   Fri, 11 Aug 2023 16:00:14 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-pass-folio-into-do_page_mkwrite.patch removed from -mm tree
Message-Id: <20230811230014.E9908C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory: pass folio into do_page_mkwrite()
has been removed from the -mm tree.  Its filename was
     mm-memory-pass-folio-into-do_page_mkwrite.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/memory: pass folio into do_page_mkwrite()
Date: Mon, 10 Jul 2023 22:35:44 -0700

Saves one implicit call to compound_head().

I'm not sure if I should change the name of the function to
do_folio_mkwrite() and update the description comment to reference a folio
as the vm_op is still called page_mkwrite.


Link: https://lkml.kernel.org/r/20230711053544.156617-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/memory.c~mm-memory-pass-folio-into-do_page_mkwrite
+++ a/mm/memory.c
@@ -2933,10 +2933,9 @@ static gfp_t __get_fault_gfp_mask(struct
  *
  * We do this without the lock held, so that it can sleep if it needs to.
  */
-static vm_fault_t do_page_mkwrite(struct vm_fault *vmf)
+static vm_fault_t do_page_mkwrite(struct vm_fault *vmf, struct folio *folio)
 {
 	vm_fault_t ret;
-	struct folio *folio = page_folio(vmf->page);
 	unsigned int old_flags = vmf->flags;
 
 	vmf->flags = FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE;
@@ -3298,7 +3297,7 @@ static vm_fault_t wp_page_shared(struct
 		vm_fault_t tmp;
 
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		tmp = do_page_mkwrite(vmf);
+		tmp = do_page_mkwrite(vmf, folio);
 		if (unlikely(!tmp || (tmp &
 				      (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))) {
 			folio_put(folio);
@@ -4621,7 +4620,7 @@ static vm_fault_t do_shared_fault(struct
 	 */
 	if (vma->vm_ops->page_mkwrite) {
 		folio_unlock(folio);
-		tmp = do_page_mkwrite(vmf);
+		tmp = do_page_mkwrite(vmf, folio);
 		if (unlikely(!tmp ||
 				(tmp & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))) {
 			folio_put(folio);
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


