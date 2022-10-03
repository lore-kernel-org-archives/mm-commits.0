Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 619DCC4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:06:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiJCVGH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiJCVFb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4CA140BB
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EF015CE0E6D
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48380C433B5;
        Mon,  3 Oct 2022 21:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831101;
        bh=K+KkEO1czCfLAZm8J1wIP1P9bq8fqCK5ZpHYNm3UHu8=;
        h=Date:To:From:Subject:From;
        b=MVLCx5CL4W+FWem5cjar9ivL8EATLU+2nvddbRCeuxeu0KwvMKN/aJIpS+6Y209jv
         JIRzReIyyD1BkQWZJucksrsnMcGqEnC5pDKfQ3m+3WJYuqZKNVUWj4VuGDCHs4Tzep
         82cZh+6UmJSYVtm0NXS5OHaVICtp/v8Bmk72lLMY=
Date:   Mon, 03 Oct 2022 14:05:00 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-convert-shmem_fault-to-use-shmem_get_folio_gfp.patch removed from -mm tree
Message-Id: <20221003210501.48380C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: convert shmem_fault() to use shmem_get_folio_gfp()
has been removed from the -mm tree.  Its filename was
     shmem-convert-shmem_fault-to-use-shmem_get_folio_gfp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: shmem: convert shmem_fault() to use shmem_get_folio_gfp()
Date: Fri, 2 Sep 2022 20:46:18 +0100

No particular advantage for this function, but necessary to remove
shmem_getpage_gfp().

[hughd@google.com: fix crash]
  Link: https://lkml.kernel.org/r/7693a84-bdc2-27b5-2695-d0fe8566571f@google.com
Link: https://lkml.kernel.org/r/20220902194653.1739778-23-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/shmem.c~shmem-convert-shmem_fault-to-use-shmem_get_folio_gfp
+++ a/mm/shmem.c
@@ -2065,6 +2065,7 @@ static vm_fault_t shmem_fault(struct vm_
 	struct vm_area_struct *vma = vmf->vma;
 	struct inode *inode = file_inode(vma->vm_file);
 	gfp_t gfp = mapping_gfp_mask(inode->i_mapping);
+	struct folio *folio = NULL;
 	int err;
 	vm_fault_t ret = VM_FAULT_LOCKED;
 
@@ -2127,10 +2128,12 @@ static vm_fault_t shmem_fault(struct vm_
 		spin_unlock(&inode->i_lock);
 	}
 
-	err = shmem_getpage_gfp(inode, vmf->pgoff, &vmf->page, SGP_CACHE,
+	err = shmem_get_folio_gfp(inode, vmf->pgoff, &folio, SGP_CACHE,
 				  gfp, vma, vmf, &ret);
 	if (err)
 		return vmf_error(err);
+	if (folio)
+		vmf->page = folio_file_page(folio, vmf->pgoff);
 	return ret;
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are


