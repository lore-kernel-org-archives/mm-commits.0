Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9670C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:57:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D575A60E9B
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:57:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350362AbhICU6S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:58:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350418AbhICU6Q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:58:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C3F860184;
        Fri,  3 Sep 2021 20:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702636;
        bh=9MVF/3ti0O1SiUVEPASMxnBcCWHrWk4jM/rz6lbXBek=;
        h=Date:From:To:Subject:From;
        b=ZyalUM7szWbpf+W35PhzaCkpsm38CmhuJLShVWXiBH7lFwBEPff2nKGFxsImZ/KPP
         Y4I24bbbbp7X4c4RMn378H82Uh/esBqluetM+aiRWEoKrNiDvtt5jTMKBqry4QhYZv
         ufhLC8nqFRRBXWO8WXMRI1MNJBcrrSAH7dFFbBhU=
Date:   Fri, 03 Sep 2021 13:57:15 -0700
From:   akpm@linux-foundation.org
To:     alexs@kernel.org, apopple@nvidia.com, axboe@kernel.dk,
        david@redhat.com, guro@fb.com, hannes@cmpxchg.org,
        iamjoonsoo.kim@lge.com, linmiaohe@huawei.com, mhocko@suse.com,
        minchan@kernel.org, mm-commits@vger.kernel.org,
        richard.weiyang@gmail.com, shakeelb@google.com,
        shy828301@gmail.com, songmuchun@bytedance.com, surenb@google.com,
        tj@kernel.org, willy@infradead.org
Subject:  [merged]
 =?US-ASCII?Q?mm-memcg-add-mem=5Fcgroup=5Fdisabled-checks-in-vmpressure-?=
 =?US-ASCII?Q?and-swap-related-functions.patch?= removed from -mm tree
Message-ID: <20210903205715.KeAFe9fSA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memcg: add mem_cgroup_disabled checks in vmpressure and swap-related functions
has been removed from the -mm tree.  Its filename was
     mm-memcg-add-mem_cgroup_disabled-checks-in-vmpressure-and-swap-related-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from surenb@google.com are


