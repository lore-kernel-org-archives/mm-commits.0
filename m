Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BE29C77B7A
	for <mm-commits@archiver.kernel.org>; Fri,  2 Jun 2023 20:55:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236225AbjFBUzK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Jun 2023 16:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236158AbjFBUzJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jun 2023 16:55:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8DBEE43
        for <mm-commits@vger.kernel.org>; Fri,  2 Jun 2023 13:55:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4664061CAD
        for <mm-commits@vger.kernel.org>; Fri,  2 Jun 2023 20:55:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A491C433EF;
        Fri,  2 Jun 2023 20:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685739307;
        bh=3S3I/AIHrQmcqYfRZYuSXwTmSjSauknp+iRPSTshozs=;
        h=Date:To:From:Subject:From;
        b=Bew/sanId/jKA7/JAuw+hJDvhwXY0Yd6+5g1bmsUvqOw1zsFijIh9d1XpjoqVn2te
         t2sjAfrmBq79HKspE8qA0+zPKIaHZ9MWcaroKnzzZDgkl4LNubnxefdxqpihDnGA5s
         rMoEpL+l/VEEYOOptB3R8+AMQoas+658L3/2Wwe8=
Date:   Fri, 02 Jun 2023 13:55:06 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
        willy@infradead.org, urezki@gmail.com, sj@kernel.org,
        rppt@kernel.org, lstoakes@gmail.com,
        kirill.shutemov@linux.intel.com, hch@lst.de, hch@infradead.org,
        ryan.roberts@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-must-set-pte-via-arch-code.patch added to mm-unstable branch
Message-Id: <20230602205507.9A491C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmalloc must set pte via arch code
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-must-set-pte-via-arch-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-must-set-pte-via-arch-code.patch

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
Cc: Christoph Hellwig <hch@infradead.org>
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

mm-vmalloc-must-set-pte-via-arch-code.patch
mm-damon-ops-common-atomically-test-and-clear-young-on-ptes-and-pmds.patch
mm-damon-ops-common-refactor-to-use-ptepmdp_clear_young_notify.patch
mm-fix-failure-to-unmap-pte-on-highmem-systems.patch

