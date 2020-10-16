Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50C91C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:48:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00F52216C4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881294;
	bh=8C/DNlJgjG2uPHpyq3Jo3JEDkOPMHK6lml8JOHtJPUg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=zFGHNtmB3ubSEuSELDnlvXythMnBvFpiAmnw53Tm0m0MarV3L1syYlxFHXA+pcd31
	 angyDzKisAvs/1SBbhkr/aBPgsZ319Wuf8j3gc+5UA5dw7f6orImJi4nlSGCEokah/
	 9aPlI6Ct/0NZmswLJqa19jBdQVQ0uXRMx3JozGFs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392693AbgJPUsN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:48:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392676AbgJPUsN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:48:13 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2572214DB;
        Fri, 16 Oct 2020 20:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881293;
        bh=8C/DNlJgjG2uPHpyq3Jo3JEDkOPMHK6lml8JOHtJPUg=;
        h=Date:From:To:Subject:From;
        b=OyNZ8mCAqjoz/0JtkRlH0jRmhVfITMjarDO7PtGtwRi5HnFLBte1wox6ikksj/V6n
         6SFXPNhB7xupQELYU06aUfzpbmRsOfX+iupcE6/QGLzNngsOcRzNy0XPhhjxdvhokn
         50ziZcam30TVLwB4ZMiWUTov7ap4OIVCjqYN2hug=
Date:   Fri, 16 Oct 2020 13:48:12 -0700
From:   akpm@linux-foundation.org
To:     kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        willy@infradead.org, ying.huang@intel.com
Subject:  [merged]
 mm-memory-remove-page-fault-assumption-of-compound-page-size.patch removed
 from -mm tree
Message-ID: <20201016204812.m6hXm3X1C%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory: remove page fault assumption of compound page size
has been removed from the -mm tree.  Its filename was
     mm-memory-remove-page-fault-assumption-of-compound-page-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/memory: remove page fault assumption of compound page size

A compound page in the page cache will not necessarily be of PMD size,
so check explicitly.

[willy@infradead.org: fix remove page fault assumption of compound page size]
  Link: https://lkml.kernel.org/r/20201001152259.14932-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20200908195539.25896-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/memory.c~mm-memory-remove-page-fault-assumption-of-compound-page-size
+++ a/mm/memory.c
@@ -3709,13 +3709,14 @@ static vm_fault_t do_set_pmd(struct vm_f
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
 	pmd_t entry;
 	int i;
-	vm_fault_t ret;
+	vm_fault_t ret = VM_FAULT_FALLBACK;
 
 	if (!transhuge_vma_suitable(vma, haddr))
-		return VM_FAULT_FALLBACK;
+		return ret;
 
-	ret = VM_FAULT_FALLBACK;
 	page = compound_head(page);
+	if (compound_order(page) != HPAGE_PMD_ORDER)
+		return ret;
 
 	/*
 	 * Archs like ppc64 need additonal space to store information
_

Patches currently in -mm which might be from willy@infradead.org are

mm-update-the-documentation-for-vfree.patch

