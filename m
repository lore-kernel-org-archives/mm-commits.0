Return-Path: <SRS0=SqaX=DN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54C4CC4363D
	for <mm-commits@archiver.kernel.org>; Tue,  6 Oct 2020 21:40:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9E9A208B8
	for <mm-commits@archiver.kernel.org>; Tue,  6 Oct 2020 21:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602020423;
	bh=Cp/1Avxh8L2/FvDXNVHE4cqzpYPx/+UVLHesVQtWvfw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Meom8ESNAn8zKUfebjgTEWpWtJgklBMSKfIql7WK+wM+ECMjCYjrPY8/NqWFo0bvd
	 6n3X760euCUKF57V1sbFf6n+TyeF+mTDhKbI8EGuoKG+1dhlAsPLTXOVooXxL5Fq36
	 oFSANkjZr2WKKM/wU641/7Q2dMdAZZsFOPDZuP/s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgJFVkW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Oct 2020 17:40:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgJFVkW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Oct 2020 17:40:22 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCA1A208B6;
        Tue,  6 Oct 2020 21:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602020421;
        bh=Cp/1Avxh8L2/FvDXNVHE4cqzpYPx/+UVLHesVQtWvfw=;
        h=Date:From:To:Subject:From;
        b=awqKFe1/FVS3OS7F/t//Ha9v8EVwC333w4HyBwDWXcGS98Xws4exA1Z4B5C9KSYKR
         4W2tZ1Wl12tpt3CY89F0yTNbRcgQBvfYhuR3poVYmJAP87oHDSkhVMOw5wkOPmra1d
         2Ib1lCEP8NezSEcxS/QluPPnMjY9r/k2rVvAuHYs=
Date:   Tue, 06 Oct 2020 14:40:20 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, peterx@redhat.com, sfr@canb.auug.org.au
Subject:  +
 mm-remove-src-dst-mm-parameter-in-copy_page_range-v2-fix.patch added to -mm
 tree
Message-ID: <20201006214020.RvXOQ8QdB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-remove-src-dst-mm-parameter-in-copy_page_range-v2-fix
has been added to the -mm tree.  Its filename is
     mm-remove-src-dst-mm-parameter-in-copy_page_range-v2-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-src-dst-mm-parameter-in-copy_page_range-v2-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-src-dst-mm-parameter-in-copy_page_range-v2-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-remove-src-dst-mm-parameter-in-copy_page_range-v2.patch
mm-remove-src-dst-mm-parameter-in-copy_page_range-v2-fix.patch

