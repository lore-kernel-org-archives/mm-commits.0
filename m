Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B943C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:55:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FA8F610E8
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:55:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347893AbhIBVz4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:55:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347888AbhIBVzr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:55:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8335E610A1;
        Thu,  2 Sep 2021 21:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619688;
        bh=zC+HPfxnIfu08KELhIdi8IPcvZWnrQW6fSGPYQzR7cc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=kT66G9VJAoTdD3JaHbcTz1+vyPeLeKLX799ZZXiPrEtG/uH8UpCqBP2/xqS1XFDTF
         pWquFmiYSNSoM8t3eeRpc/jqdH+D1rGXD9j0e996p14MzhTIzBR7XLZWUUDjjR1Hqo
         YKIRt6yxDm0ewzYu2snnK3uLUFvcK0cR3GnmBpGY=
Date:   Thu, 02 Sep 2021 14:54:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexs@kernel.org, apopple@nvidia.com,
        axboe@kernel.dk, david@redhat.com, guro@fb.com, hannes@cmpxchg.org,
        iamjoonsoo.kim@lge.com, linmiaohe@huawei.com, linux-mm@kvack.org,
        mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org,
        richard.weiyang@gmail.com, shakeelb@google.com,
        shy828301@gmail.com, songmuchun@bytedance.com, surenb@google.com,
        tj@kernel.org, torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 092/212] mm, memcg: add mem_cgroup_disabled checks
 in vmpressure and swap-related functions
Message-ID: <20210902215447._Oq31k-Ai%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Suren Baghdasaryan <surenb@google.com>
Subject: mm, memcg: add mem_cgroup_disabled checks in vmpressure and swap-related functions

Add mem_cgroup_disabled check in vmpressure, mem_cgroup_uncharge_swap and
cgroup_throttle_swaprate functions.  This minimizes the memcg overhead in
the pagefault and exit_mmap paths when memcgs are disabled using
cgroup_disable=memory command-line option.

This change results in ~2.1% overhead reduction when running PFT test [1]
comparing {CONFIG_MEMCG=n, CONFIG_MEMCG_SWAP=n} against {CONFIG_MEMCG=y,
CONFIG_MEMCG_SWAP=y, cgroup_disable=memory} configuration on an 8-core
ARM64 Android device.

[1] https://lkml.org/lkml/2006/8/29/294 also used in mmtests suite

Link: https://lkml.kernel.org/r/20210713010934.299876-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 +++
 mm/swapfile.c   |    3 +++
 mm/vmpressure.c |    7 ++++++-
 3 files changed, 12 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-add-mem_cgroup_disabled-checks-in-vmpressure-and-swap-related-functions
+++ a/mm/memcontrol.c
@@ -7297,6 +7297,9 @@ void mem_cgroup_uncharge_swap(swp_entry_
 	struct mem_cgroup *memcg;
 	unsigned short id;
 
+	if (mem_cgroup_disabled())
+		return;
+
 	id = swap_cgroup_record(entry, 0, nr_pages);
 	rcu_read_lock();
 	memcg = mem_cgroup_from_id(id);
--- a/mm/swapfile.c~mm-memcg-add-mem_cgroup_disabled-checks-in-vmpressure-and-swap-related-functions
+++ a/mm/swapfile.c
@@ -3784,6 +3784,9 @@ void cgroup_throttle_swaprate(struct pag
 	struct swap_info_struct *si, *next;
 	int nid = page_to_nid(page);
 
+	if (mem_cgroup_disabled())
+		return;
+
 	if (!(gfp_mask & __GFP_IO))
 		return;
 
--- a/mm/vmpressure.c~mm-memcg-add-mem_cgroup_disabled-checks-in-vmpressure-and-swap-related-functions
+++ a/mm/vmpressure.c
@@ -240,7 +240,12 @@ static void vmpressure_work_fn(struct wo
 void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
 		unsigned long scanned, unsigned long reclaimed)
 {
-	struct vmpressure *vmpr = memcg_to_vmpressure(memcg);
+	struct vmpressure *vmpr;
+
+	if (mem_cgroup_disabled())
+		return;
+
+	vmpr = memcg_to_vmpressure(memcg);
 
 	/*
 	 * Here we only want to account pressure that userland is able to
_
