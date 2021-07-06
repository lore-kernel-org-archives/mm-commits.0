Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D29BC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:13:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55C3160FE3
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbhGFTPk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:15:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231883AbhGFTPk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:15:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 851066023F;
        Tue,  6 Jul 2021 19:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598780;
        bh=efJ+k5vESuotIGF8+OJ0SYSFL42Khrw65aH986L3VlY=;
        h=Date:From:To:Subject:From;
        b=Hfs1TlTpICaWFXQkD1ripFUbgqFDOaKT0y1pRKlfk1nthGYLudVCwKkQUwQFdch8p
         6547Vc5mnEGxv1EsJFQdTeQFfRrPq0fxXD+XuQNpprIpVCO7VMbuuBrSFxFHPq82uq
         fbBD7qJiT9cpV95PDeQAliWzt983TATE6iZ15Ijg=
Date:   Tue, 06 Jul 2021 12:13:00 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, dbueso@suse.de, geert@linux-m68k.org,
        ldufour@linux.ibm.com, Liam.Howlett@Oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged] mm-mremap-use-vma_lookup-in-vma_to_resize.patch
 removed from -mm tree
Message-ID: <20210706191300.1qpcXq_P2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: use vma_lookup() in vma_to_resize()
has been removed from the -mm tree.  Its filename was
     mm-mremap-use-vma_lookup-in-vma_to_resize.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: mm/mremap: use vma_lookup() in vma_to_resize()

Use vma_lookup() to find the VMA at a specific address.  As vma_lookup()
will return NULL if the address is not within any VMA, the start address
no longer needs to be validated.

Link: https://lkml.kernel.org/r/20210521174745.2219620-21-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/mremap.c~mm-mremap-use-vma_lookup-in-vma_to_resize
+++ a/mm/mremap.c
@@ -634,10 +634,11 @@ static struct vm_area_struct *vma_to_res
 	unsigned long *p)
 {
 	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma = find_vma(mm, addr);
+	struct vm_area_struct *vma;
 	unsigned long pgoff;
 
-	if (!vma || vma->vm_start > addr)
+	vma = vma_lookup(mm, addr);
+	if (!vma)
 		return ERR_PTR(-EFAULT);
 
 	/*
_

Patches currently in -mm which might be from liam.howlett@oracle.com are


