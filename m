Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2144EC07E9D
	for <mm-commits@archiver.kernel.org>; Mon, 26 Sep 2022 21:05:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbiIZVFy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 17:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbiIZVFw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 17:05:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA9E767160
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 14:05:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4906061387
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 21:05:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E81DC433D6;
        Mon, 26 Sep 2022 21:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664226349;
        bh=n8u8+2XqEuIC1bkdc8sfCug+kywD10OPD6puE8U5IOA=;
        h=Date:To:From:Subject:From;
        b=1eF+kjCHZqkCPgi2CNBSjqoo5CiPb+i20GZy2h8AYsjcIw8Rp8Hi+SHvOd8Glx6B/
         y/bsiZHsUACMB4jbZE2I9Slfk49lNG2P1AX3WqsQZykesGp8Geh5z4Fel+GF3Mo5R0
         5aICbgT/XL2261jqEiRVvuoAqDjeCKQ2/poEc7p4=
Date:   Mon, 26 Sep 2022 14:05:48 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@suse.com,
        mgorman@suse.de, hch@infradead.org, hannes@cmpxchg.org,
        dan.carpenter@oracle.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree-fix.patch removed from -mm tree
Message-Id: <20220926210549.9E81DC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree-fix
has been removed from the -mm tree.  Its filename was
     mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree-fix.patch

This patch was dropped because it was folded into mm-reduce-noise-in-show_mem-for-lowmem-allocations.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree-fix
Date: Tue Aug 30 06:39:28 PM PDT 2022

update it for Michal's update

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/nommu.c~mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree-fix
+++ a/mm/nommu.c
@@ -1272,7 +1272,7 @@ error_maple_preallocate:
 	kmem_cache_free(vm_region_jar, region);
 	vm_area_free(vma);
 	pr_warn("Allocation of vma tree for process %d failed\n", current->pid);
-	show_free_areas(0, NULL, GFP_KERNEL);
+	show_free_areas(0, NULL);
 	return -ENOMEM;
 
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-reduce-noise-in-show_mem-for-lowmem-allocations.patch
mm-vmscan-fix-a-lot-of-comments-vs-mglru.patch
swap-add-swap_cache_get_folio-fix.patch
memcg-reduce-size-of-memcg-vmstats-structures-fix.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme-fix.patch
mm-page_allocc-rename-check_free_page-to-free_page_is_bad.patch
mm-page_allocc-rename-check_free_page-to-free_page_is_bad-fix.patch
mm-page_allocc-document-bulkfree_pcp_prepare-return-value.patch
fs-uninline-inode_maybe_inc_iversion.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-checkpatch-fixes.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-fix-fix.patch

