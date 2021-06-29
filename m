Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC670C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B78BA61D0D
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbhF2CmP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:42:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231348AbhF2CmP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:42:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DC78619AB;
        Tue, 29 Jun 2021 02:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934387;
        bh=FRzd6PJrVcPNI3ccFCj0MtDNk36pHF7pK9QzEFECNUg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GfHas/+vqz+SIe3M6Yhi7KSWBNnAh3xk6yOksoWyITz8sSJ31oa+0uYB2Pz/f82lV
         DPr2FWd6USRPQ5PD+mr8o5IIuodm88d16HZMjSvEvD33bAUjW6Aq5WDcDfG8JbRC3z
         K5bwItMVsOPdTktD+jSgRWqfTMRqy0lb65eNh3lc=
Date:   Mon, 28 Jun 2021 19:39:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, dbueso@suse.de,
        geert@linux-m68k.org, ldufour@linux.ibm.com,
        Liam.Howlett@Oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 124/192] mm/mremap: use vma_lookup() in
 vma_to_resize()
Message-ID: <20210629023947.nySF3mwFM%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
