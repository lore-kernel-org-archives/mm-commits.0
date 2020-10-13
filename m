Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F2CAC43467
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:10:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2C6721D7F
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602630645;
	bh=QZ0cY+9+ZPsfNXdvZxJxRFZY2uEFsbOfzu6O2sTLZks=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Ep2ewbZoc19GIR3+F5hClJLLXaqbV7x/l+dykCU3NIbdyfDmfBXJa0+lKXBXY6jhs
	 yaEvmHC4/UyvfcgSmEGnc4nUYuK+Fftw6stSndpvcKwP2iGlvbcEb0jpzA1qECVzVO
	 Fr1m8p4tihBYuqIqrb4umDBgUUkJ/vr4f8GORCxw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729619AbgJMXKp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:10:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbgJMXKp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:10:45 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1AB321D40;
        Tue, 13 Oct 2020 23:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602630644;
        bh=QZ0cY+9+ZPsfNXdvZxJxRFZY2uEFsbOfzu6O2sTLZks=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=L1jh6JaXkpw57aJCl1vVS3e+TOtxw9vgWHrQlVRkN3AcQkS2sIfPw4kgVouiyJhpV
         3GwHvm87uOxUe6VSZWSwwrrf8wX6RbvXV7CBuX0upkAY6Zm5Eg5J8Fzob8HDbUfQvR
         /DzjsGN65t51x1sFLkglb30SIFUl1tw3Fnq0IIwg=
Date:   Tue, 13 Oct 2020 16:10:44 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     mm-commits@vger.kernel.org, peterx@redhat.com, sfr@canb.auug.org.au
Subject:  [folded-merged]
 mm-remove-src-dst-mm-parameter-in-copy_page_range-v2-fix.patch removed from
 -mm tree
Message-ID: <20201013231044.VWe-2mctV%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-remove-src-dst-mm-parameter-in-copy_page_range-v2-fix
has been removed from the -mm tree.  Its filename was
     mm-remove-src-dst-mm-parameter-in-copy_page_range-v2-fix.patch

This patch was dropped because it was folded into mm-remove-src-dst-mm-parameter-in-copy_page_range.patch

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm-remove-src-dst-mm-parameter-in-copy_page_range-v2-fix

The required change attached; this is quite special that we only referenced the
mm once in each of the function, so that temp variable can actually be avoided.
Ideally there should be some way to only define the variable on archs that need
this mm pointer (e.g., when set_pte_at() or some similar function is called
multiple times in some function, it should still be helpful to introduce a
local variable to keep dst_vma->vm_mm).  However I don't know a good way to do
this...

Link: https://lkml.kernel.org/r/20201006200138.GA6026@xz-x1
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/memory.c~mm-remove-src-dst-mm-parameter-in-copy_page_range-v2-fix
+++ a/mm/memory.c
@@ -798,7 +798,6 @@ copy_present_page(struct vm_area_struct
 		  pte_t *dst_pte, pte_t *src_pte, unsigned long addr, int *rss,
 		  struct page **prealloc, pte_t pte, struct page *page)
 {
-	struct mm_struct *dst_mm = dst_vma->vm_mm;
 	struct mm_struct *src_mm = src_vma->vm_mm;
 	struct page *new_page;
 
@@ -874,7 +873,7 @@ copy_present_page(struct vm_area_struct
 	/* All done, just insert the new page copy in the child */
 	pte = mk_pte(new_page, dst_vma->vm_page_prot);
 	pte = maybe_mkwrite(pte_mkdirty(pte), dst_vma);
-	set_pte_at(dst_mm, addr, dst_pte, pte);
+	set_pte_at(dst_vma->vm_mm, addr, dst_pte, pte);
 	return 0;
 }
 
@@ -887,7 +886,6 @@ copy_present_pte(struct vm_area_struct *
 		 pte_t *dst_pte, pte_t *src_pte, unsigned long addr, int *rss,
 		 struct page **prealloc)
 {
-	struct mm_struct *dst_mm = dst_vma->vm_mm;
 	struct mm_struct *src_mm = src_vma->vm_mm;
 	unsigned long vm_flags = src_vma->vm_flags;
 	pte_t pte = *src_pte;
@@ -932,7 +930,7 @@ copy_present_pte(struct vm_area_struct *
 	if (!(vm_flags & VM_UFFD_WP))
 		pte = pte_clear_uffd_wp(pte);
 
-	set_pte_at(dst_mm, addr, dst_pte, pte);
+	set_pte_at(dst_vma->vm_mm, addr, dst_pte, pte);
 	return 0;
 }
 
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-remove-src-dst-mm-parameter-in-copy_page_range.patch

