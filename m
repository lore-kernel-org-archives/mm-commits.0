Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 672A0C04AB4
	for <mm-commits@archiver.kernel.org>; Wed, 20 Sep 2023 16:52:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234157AbjITQwq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Sep 2023 12:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233691AbjITQwq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Sep 2023 12:52:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF149F
        for <mm-commits@vger.kernel.org>; Wed, 20 Sep 2023 09:52:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1A9C433C7;
        Wed, 20 Sep 2023 16:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695228758;
        bh=xaz+9WANGE9y5DGxk05HIA8wdirK50uts8Ee1kZDAqI=;
        h=Date:To:From:Subject:From;
        b=qx4atM4r2QwdhZzuUsv8dgWTURI1bdE4j2P2/Mcr7qce3HC7e0XNRvJyCXuhastNC
         bOdFeNWt3jKf+gLSvPpnndsivBKgPqeuiHKfE2WEtkQPobgh/r4ubxy2p+w17qvdWt
         9WeVCaT5Vs40ZM7bsK1+JtNql8ExFA4V2EDdJhdI=
Date:   Wed, 20 Sep 2023 09:52:38 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        fengwei.yin@intel.com, david@redhat.com, dave.hansen@intel.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-report-success-more-often-from-filemap_map_folio_range.patch added to mm-hotfixes-unstable branch
Message-Id: <20230920165238.CB1A9C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: report success more often from filemap_map_folio_range()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-report-success-more-often-from-filemap_map_folio_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-report-success-more-often-from-filemap_map_folio_range.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: report success more often from filemap_map_folio_range()
Date: Wed, 20 Sep 2023 04:53:35 +0100

Even though we had successfully mapped the relevant page, we would rarely
return success from filemap_map_folio_range().  That leads to falling back
from the VMA lock path to the mmap_lock path, which is a speed &
scalability issue.  Found by inspection.

Link: https://lkml.kernel.org/r/20230920035336.854212-1-willy@infradead.org
Fixes: 617c28ecab22 ("filemap: batch PTE mappings")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/filemap.c~mm-report-success-more-often-from-filemap_map_folio_range
+++ a/mm/filemap.c
@@ -3503,7 +3503,7 @@ skip:
 		if (count) {
 			set_pte_range(vmf, folio, page, count, addr);
 			folio_ref_add(folio, count);
-			if (in_range(vmf->address, addr, count))
+			if (in_range(vmf->address, addr, count * PAGE_SIZE))
 				ret = VM_FAULT_NOPAGE;
 		}
 
@@ -3517,7 +3517,7 @@ skip:
 	if (count) {
 		set_pte_range(vmf, folio, page, count, addr);
 		folio_ref_add(folio, count);
-		if (in_range(vmf->address, addr, count))
+		if (in_range(vmf->address, addr, count * PAGE_SIZE))
 			ret = VM_FAULT_NOPAGE;
 	}
 
_

Patches currently in -mm which might be from willy@infradead.org are

i915-limit-the-length-of-an-sg-list-to-the-requested-length.patch
mm-report-success-more-often-from-filemap_map_folio_range.patch
mm-abstract-moving-to-the-next-pfn.patch
mm-convert-dax-lock-unlock-page-to-lock-unlock-folio.patch
buffer-pass-gfp-flags-to-folio_alloc_buffers.patch
buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp.patch
ext4-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch
buffer-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch
buffer-convert-getblk_unmovable-and-__getblk-to-use-bdev_getblk.patch
buffer-convert-sb_getblk-to-call-__getblk.patch
ext4-call-bdev_getblk-from-sb_getblk_gfp.patch
buffer-remove-__getblk_gfp.patch
hugetlb-use-a-folio-in-free_hpage_workfn.patch
hugetlb-remove-a-few-calls-to-page_folio.patch
hugetlb-convert-remove_pool_huge_page-to-remove_pool_hugetlb_folio.patch

