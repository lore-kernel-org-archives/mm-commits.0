Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD359E7734B
	for <mm-commits@archiver.kernel.org>; Sat, 30 Sep 2023 00:19:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjI3ATm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Sep 2023 20:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjI3ATl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2023 20:19:41 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF58AC
        for <mm-commits@vger.kernel.org>; Fri, 29 Sep 2023 17:19:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E18C433C7;
        Sat, 30 Sep 2023 00:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696033179;
        bh=hh+Pc+PTTr+OMc7jRuPtYVpZauEIkIsd/Ls6pRdQuBA=;
        h=Date:To:From:Subject:From;
        b=o+a1PPMp/KVS1Gwjn8NReUy2Mc+B9qaT9aHyF21GLJK/Kh7pyOOu58x368WiVDdtC
         ZuOnTTHmU6KhUTb1LLAZ1paLs5F9qcuyhi/8l1Ght02eG7Ip1AvdShXUWhi0uGTwYl
         MH6imvT4ZvhA52ZI9a4NrTAuWp3IislMnvnKGBi4=
Date:   Fri, 29 Sep 2023 17:19:38 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@suse.com,
        jpiotrowski@linux.microsoft.com, hannes@cmpxchg.org,
        gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memcg-reconsider-kmemlimit_in_bytes-deprecation-fix.patch removed from -mm tree
Message-Id: <20230930001938.E8E18C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-memcg-reconsider-kmemlimit_in_bytes-deprecation-fix
has been removed from the -mm tree.  Its filename was
     mm-memcg-reconsider-kmemlimit_in_bytes-deprecation-fix.patch

This patch was dropped because it was folded into mm-memcg-reconsider-kmemlimit_in_bytes-deprecation.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcg-reconsider-kmemlimit_in_bytes-deprecation-fix
Date: Mon Sep 25 11:31:21 AM PDT 2023

fix build - remove unused local

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-reconsider-kmemlimit_in_bytes-deprecation-fix
+++ a/mm/memcontrol.c
@@ -3097,7 +3097,6 @@ static void obj_cgroup_uncharge_pages(st
 static int obj_cgroup_charge_pages(struct obj_cgroup *objcg, gfp_t gfp,
 				   unsigned int nr_pages)
 {
-	struct page_counter *counter;
 	struct mem_cgroup *memcg;
 	int ret;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcg-reconsider-kmemlimit_in_bytes-deprecation.patch
mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-shrinker-convert-shrinker_rwsem-to-mutex-fix.patch
mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim-fix.patch
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

