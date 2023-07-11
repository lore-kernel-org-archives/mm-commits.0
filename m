Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABBD2C001B0
	for <mm-commits@archiver.kernel.org>; Tue, 11 Jul 2023 19:09:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbjGKTJe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Jul 2023 15:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjGKTJd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2023 15:09:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED711711
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 12:09:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D68E614C5
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 19:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611FDC433C7;
        Tue, 11 Jul 2023 19:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689102571;
        bh=0xv4WrXb/M5yteT6gIr9b0zGfYdUFIB7bkG+S/dy4tM=;
        h=Date:To:From:Subject:From;
        b=UZQnVNi+JsSCetE7mBiV6ldZxtk3Ays7+ckfNngrD1P+TNKDCcTPxfrfjFm0aQzO6
         Jew27Xkg5z7888UhPmA02LJJmas3/K1EUdLgSQN0SBuxNOCzCmbhp3owHanWtCq/tf
         vSuVGjTv7HH2WZZT7tbSV1a5VJ1tkjlldRZDXMIg=
Date:   Tue, 11 Jul 2023 12:09:30 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-pass-folio-into-do_page_mkwrite.patch added to mm-unstable branch
Message-Id: <20230711190931.611FDC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory: pass folio into do_page_mkwrite()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-pass-folio-into-do_page_mkwrite.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-pass-folio-into-do_page_mkwrite.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -2936,10 +2936,9 @@ static gfp_t __get_fault_gfp_mask(struct
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
@@ -3301,7 +3300,7 @@ static vm_fault_t wp_page_shared(struct
 		vm_fault_t tmp;
 
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		tmp = do_page_mkwrite(vmf);
+		tmp = do_page_mkwrite(vmf, folio);
 		if (unlikely(!tmp || (tmp &
 				      (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))) {
 			folio_put(folio);
@@ -4636,7 +4635,7 @@ static vm_fault_t do_shared_fault(struct
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

mm-increase-usage-of-folio_next_index-helper.patch
mm-memory-convert-do_page_mkwrite-to-use-folios.patch
mm-memory-convert-wp_page_shared-to-use-folios.patch
mm-memory-convert-do_shared_fault-to-folios.patch
mm-memory-convert-do_read_fault-to-use-folios.patch
mm-memory-pass-folio-into-do_page_mkwrite.patch

