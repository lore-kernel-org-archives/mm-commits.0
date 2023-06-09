Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ED0AC7EE43
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:34:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbjFIXe4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbjFIXdS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:33:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EAF94211
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:30:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE4A363EA3
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B94C433EF;
        Fri,  9 Jun 2023 23:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353425;
        bh=Gc5NnQqdWFyNABXNMBILiBzN9cvvxqwnWZCo+JANXaM=;
        h=Date:To:From:Subject:From;
        b=WvDwUmrVccr9AjPPIv7DtBl1j2LQDArLpF6YQNc8211sxUKgFgUN2yzcRGD2VCbn7
         kxstQcUmB1/x2FVWptEK8ZQpEAgWKW0migK4n+SXlrngcUOu+AJKODPJCCVjjJLYUC
         XfSL5WupQ6X/OMAC9Kcv6aCut0ndnJ8QstgFfagU=
Date:   Fri, 09 Jun 2023 16:30:24 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
        willy@infradead.org, urezki@gmail.com, sj@kernel.org,
        rppt@kernel.org, lstoakes@gmail.com,
        kirill.shutemov@linux.intel.com, hch@lst.de, ryan.roberts@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-must-set-pte-via-arch-code.patch removed from -mm tree
Message-Id: <20230609233025.14B94C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: vmalloc must set pte via arch code
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-must-set-pte-via-arch-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: vmalloc must set pte via arch code
Date: Fri, 2 Jun 2023 10:29:46 +0100

Patch series "Fixes for pte encapsulation bypasses", v3.

A series to improve the encapsulation of pte entries by disallowing
non-arch code from directly dereferencing pte_t pointers.


This patch (of 4):

It is bad practice to directly set pte entries within a pte table. 
Instead all modifications must go through arch-provided helpers such as
set_pte_at() to give the arch code visibility and allow it to check (and
potentially modify) the operation.

Link: https://lkml.kernel.org/r/20230602092949.545577-1-ryan.roberts@arm.com
Link: https://lkml.kernel.org/r/20230602092949.545577-2-ryan.roberts@arm.com
Fixes: 3e9a9e256b1e ("mm: add a vmap_pfn function")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-must-set-pte-via-arch-code
+++ a/mm/vmalloc.c
@@ -2944,10 +2944,16 @@ struct vmap_pfn_data {
 static int vmap_pfn_apply(pte_t *pte, unsigned long addr, void *private)
 {
 	struct vmap_pfn_data *data = private;
+	unsigned long pfn = data->pfns[data->idx];
+	pte_t ptent;
 
-	if (WARN_ON_ONCE(pfn_valid(data->pfns[data->idx])))
+	if (WARN_ON_ONCE(pfn_valid(pfn)))
 		return -EINVAL;
-	*pte = pte_mkspecial(pfn_pte(data->pfns[data->idx++], data->prot));
+
+	ptent = pte_mkspecial(pfn_pte(pfn, data->prot));
+	set_pte_at(&init_mm, addr, pte, ptent);
+
+	data->idx++;
 	return 0;
 }
 
_

Patches currently in -mm which might be from ryan.roberts@arm.com are


