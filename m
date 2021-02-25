Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF6DC4332B
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:32:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93CEA64F18
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234802AbhBYTc1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:32:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:36918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234876AbhBYTaP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:30:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C881F64F37;
        Thu, 25 Feb 2021 19:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280648;
        bh=mxJ1U1+n8RAQdjW7RQj0Wn74m+BQxIEO0hCIwenUh64=;
        h=Date:From:To:Subject:From;
        b=g/9cGktp7FbG6wAW4/Gxzc+1x4fJri22DIey81JoRjhmKNrAaWu4uCSli6ghRgjiY
         iQzo3nV/FLO6rp6I7ZPNwAoU4eWQWTcpeBT4UEiITmhkTvsLkmrD1z/Tnx0bmu1Esy
         7wfKPNdEznhikThj56vzEjvhpqRvk0Hp0D+2DDjw=
Date:   Thu, 25 Feb 2021 11:17:27 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, dbueso@suse.de, joao.m.martins@oracle.com,
        kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        stable@vger.kernel.org, willy@infradead.org, ziy@nvidia.com
Subject:  [merged]
 hugetlb-fix-copy_huge_page_from_user-contig-page-struct-assumption.patch
 removed from -mm tree
Message-ID: <20210225191727.2TfC-zjCw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: fix copy_huge_page_from_user contig page struct assumption
has been removed from the -mm tree.  Its filename was
     hugetlb-fix-copy_huge_page_from_user-contig-page-struct-assumption.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: fix copy_huge_page_from_user contig page struct assumption

page structs are not guaranteed to be contiguous for gigantic pages.  The
routine copy_huge_page_from_user can encounter gigantic pages, yet it
assumes page structs are contiguous when copying pages from user space.

Since page structs for the target gigantic page are not contiguous, the
data copied from user space could overwrite other pages not associated
with the gigantic page and cause data corruption.

Non-contiguous page structs are generally not an issue.  However, they can
exist with a specific kernel configuration and hotplug operations.  For
example: Configure the kernel with CONFIG_SPARSEMEM and
!CONFIG_SPARSEMEM_VMEMMAP.  Then, hotplug add memory for the area where
the gigantic page will be allocated.

Link: https://lkml.kernel.org/r/20210217184926.33567-2-mike.kravetz@oracle.com
Fixes: 8fb5debc5fcd ("userfaultfd: hugetlbfs: add hugetlb_mcopy_atomic_pte for userfaultfd support")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/memory.c~hugetlb-fix-copy_huge_page_from_user-contig-page-struct-assumption
+++ a/mm/memory.c
@@ -5177,17 +5177,19 @@ long copy_huge_page_from_user(struct pag
 	void *page_kaddr;
 	unsigned long i, rc = 0;
 	unsigned long ret_val = pages_per_huge_page * PAGE_SIZE;
+	struct page *subpage = dst_page;
 
-	for (i = 0; i < pages_per_huge_page; i++) {
+	for (i = 0; i < pages_per_huge_page;
+	     i++, subpage = mem_map_next(subpage, dst_page, i)) {
 		if (allow_pagefault)
-			page_kaddr = kmap(dst_page + i);
+			page_kaddr = kmap(subpage);
 		else
-			page_kaddr = kmap_atomic(dst_page + i);
+			page_kaddr = kmap_atomic(subpage);
 		rc = copy_from_user(page_kaddr,
 				(const void __user *)(src + i * PAGE_SIZE),
 				PAGE_SIZE);
 		if (allow_pagefault)
-			kunmap(dst_page + i);
+			kunmap(subpage);
 		else
 			kunmap_atomic(page_kaddr);
 
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


