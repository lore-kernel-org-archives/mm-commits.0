Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22534E7C4F4
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:17:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233617AbjJDURR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232977AbjJDURR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:17:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400D993
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:17:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93BCBC433C9;
        Wed,  4 Oct 2023 20:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450632;
        bh=+vGEX59cFi+C+iJo6WElSoAUIsR1gNSrp+wBbDdMAbQ=;
        h=Date:To:From:Subject:From;
        b=KYvVsCsb8Z0GBNCYPMpZzlUpXt4BF+jRU3JuVxq/svpDM674ZZrJP9waaRXQiq61R
         9gnfyMxigAd7gzP3ZyUjfP4crWf4lE1YiML6CAWiDs5yB5ljhhsVH0YHfOFr7IGVE8
         nkkmUQJz6K7k1t9Eg7v5Il/RC2ctNwag2bw46dEA=
Date:   Wed, 04 Oct 2023 13:17:11 -0700
To:     mm-commits@vger.kernel.org, vernhao@tencent.com,
        songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim-fix.patch removed from -mm tree
Message-Id: <20231004201712.93BCBC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim-fix
has been removed from the -mm tree.  Its filename was
     mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim-fix.patch

This patch was dropped because it was folded into mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim-fix
Date: Wed Sep 13 02:48:29 PM PDT 2023

fix swap_writepage_fs(), per Johannes

Link: https://lkml.kernel.org/r/20230913213343.GB48476@cmpxchg.org
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Xin Hao <vernhao@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_io.c~mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim-fix
+++ a/mm/page_io.c
@@ -295,7 +295,7 @@ static void swap_writepage_fs(struct pag
 	struct file *swap_file = sis->swap_file;
 	loff_t pos = page_file_offset(page);
 
-	count_swpout_vm_event(page_folio(sio->bvec[p].bv_page));
+	count_swpout_vm_event(page_folio(page));
 	set_page_writeback(page);
 	unlock_page(page);
 	if (wbc->swap_plug)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim.patch
mm-hugetlb-skip-initialization-of-gigantic-tail-struct-pages-if-freed-by-hvo-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2.patch
mm-ksm-add-smart-page-scanning-mode-fix.patch
mm-ksm-document-smart-scan-mode-fix.patch
mm-ksm-document-smart-scan-mode-fix-2.patch
mm-kmem-scoped-objcg-protection-checkpatch-fixes.patch
mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap-fix.patch
mm-thp-introduce-anon_orders-and-anon_always_mask-sysfs-files-fix.patch
kthread-add-kthread_stop_put-v2-fix.patch

