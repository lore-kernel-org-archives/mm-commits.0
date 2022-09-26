Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF032C6FA82
	for <mm-commits@archiver.kernel.org>; Mon, 26 Sep 2022 21:05:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbiIZVFz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 17:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbiIZVFx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 17:05:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA57F67159
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 14:05:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B211B80AE8
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 21:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445CBC433D6;
        Mon, 26 Sep 2022 21:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664226347;
        bh=U+HduqRlsiDp+k63JTE+380rxbC3VcQNFn6dE1p7cok=;
        h=Date:To:From:Subject:From;
        b=FxZKojzNFNm6wyG531QCF5mN4aDS7SenzzXb6EkOiq9fzM7a5dNhHesv8ks5gjLFC
         myi0c+oYe8DM83lx14r725vjSQ2SeytpEOokyI0DwTOrGDWIH63UUE3oNrS3jk3LxB
         4+oM2nqMbU71VhMlhEouXO91xdnVxMhYnJwPM08Y=
Date:   Mon, 26 Sep 2022 14:05:46 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@suse.com,
        mgorman@suse.de, hch@infradead.org, hannes@cmpxchg.org,
        dan.carpenter@oracle.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch removed from -mm tree
Message-Id: <20220926210547.445CBC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-reduce-noise-in-show_mem-for-lowmem-allocations-fix
has been removed from the -mm tree.  Its filename was
     mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch

This patch was dropped because it was folded into mm-reduce-noise-in-show_mem-for-lowmem-allocations.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-reduce-noise-in-show_mem-for-lowmem-allocations-fix
Date: Thu Aug 25 08:39:47 PM PDT 2022

fix it for mapletree

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

--- a/mm/nommu.c~mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree
+++ a/mm/nommu.c
@@ -1272,7 +1272,7 @@ error_maple_preallocate:
 	kmem_cache_free(vm_region_jar, region);
 	vm_area_free(vma);
 	pr_warn("Allocation of vma tree for process %d failed\n", current->pid);
-	show_free_areas(0, NULL);
+	show_free_areas(0, NULL, GFP_KERNEL);
 	return -ENOMEM;
 
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-reduce-noise-in-show_mem-for-lowmem-allocations.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree-fix.patch
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

