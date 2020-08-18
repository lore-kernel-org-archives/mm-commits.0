Return-Path: <SRS0=0jXN=B4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25221C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:41:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 003E120786
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597790463;
	bh=jqqjol7gZu96R5XgXzsIs2/AOklW6luneGzZBtX3xuk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=YML5j/9BVAtxOAjyf5MMVQMbvaTG5rqDvfMGZSW1aiCzMr9DolubCEtozHBTNCsDE
	 FQCAZoFfX3cO2g0ORopPRJAgdLvHNieTyC0Ht/5vgoD+pVpRiBZXfdqbMs3/zqACTj
	 pFbrzK034l2Jxlra18JNMqU8ggras9uNs4GqYT9c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgHRWlC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:41:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:50520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727070AbgHRWlB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 18:41:01 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98A6E20786;
        Tue, 18 Aug 2020 22:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597790460;
        bh=jqqjol7gZu96R5XgXzsIs2/AOklW6luneGzZBtX3xuk=;
        h=Date:From:To:Subject:From;
        b=UVpWtTecUMYBnyepPYsNyE5Q2+hgsxutZOXgbw1+fstOWxo8A3N5ZpF7CDAhwsp8R
         dPrb3KVkSrAZH1gFXr6vd7k+eHWr4VdrIPzH8xKAjkKnCNGdu8fjM91d1kzwEqxVCx
         TOgyG7AiRdweuQ4esuYk/QTNnbtnLnESYiVxc0Qk=
Date:   Tue, 18 Aug 2020 15:41:00 -0700
From:   akpm@linux-foundation.org
To:     cai@lca.pw, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, vdavydov.dev@gmail.com
Subject:  [merged]
 mm-memcontrol-fix-a-data-race-in-scan-count.patch removed from -mm tree
Message-ID: <20200818224100.XLoaKYFP4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol: fix a data race in scan count
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-a-data-race-in-scan-count.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Qian Cai <cai@lca.pw>
Subject: mm/memcontrol: fix a data race in scan count

struct mem_cgroup_per_node mz.lru_zone_size[zone_idx][lru] could be
accessed concurrently as noticed by KCSAN,

 BUG: KCSAN: data-race in lruvec_lru_size / mem_cgroup_update_lru_size

 write to 0xffff9c804ca285f8 of 8 bytes by task 50951 on cpu 12:
  mem_cgroup_update_lru_size+0x11c/0x1d0
  mem_cgroup_update_lru_size at mm/memcontrol.c:1266
  isolate_lru_pages+0x6a9/0xf30
  shrink_active_list+0x123/0xcc0
  shrink_lruvec+0x8fd/0x1380
  shrink_node+0x317/0xd80
  do_try_to_free_pages+0x1f7/0xa10
  try_to_free_pages+0x26c/0x5e0
  __alloc_pages_slowpath+0x458/0x1290
  __alloc_pages_nodemask+0x3bb/0x450
  alloc_pages_vma+0x8a/0x2c0
  do_anonymous_page+0x170/0x700
  __handle_mm_fault+0xc9f/0xd00
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x6f9
  page_fault+0x34/0x40

 read to 0xffff9c804ca285f8 of 8 bytes by task 50964 on cpu 95:
  lruvec_lru_size+0xbb/0x270
  mem_cgroup_get_zone_lru_size at include/linux/memcontrol.h:536
  (inlined by) lruvec_lru_size at mm/vmscan.c:326
  shrink_lruvec+0x1d0/0x1380
  shrink_node+0x317/0xd80
  do_try_to_free_pages+0x1f7/0xa10
  try_to_free_pages+0x26c/0x5e0
  __alloc_pages_slowpath+0x458/0x1290
  __alloc_pages_nodemask+0x3bb/0x450
  alloc_pages_current+0xa6/0x120
  alloc_slab_page+0x3b1/0x540
  allocate_slab+0x70/0x660
  new_slab+0x46/0x70
  ___slab_alloc+0x4ad/0x7d0
  __slab_alloc+0x43/0x70
  kmem_cache_alloc+0x2c3/0x420
  getname_flags+0x4c/0x230
  getname+0x22/0x30
  do_sys_openat2+0x205/0x3b0
  do_sys_open+0x9a/0xf0
  __x64_sys_openat+0x62/0x80
  do_syscall_64+0x91/0xb47
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

 Reported by Kernel Concurrency Sanitizer on:
 CPU: 95 PID: 50964 Comm: cc1 Tainted: G        W  O L    5.5.0-next-20200204+ #6
 Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 07/10/2019

The write is under lru_lock, but the read is done as lockless.  The scan
count is used to determine how aggressively the anon and file LRU lists
should be scanned.  Load tearing could generate an inefficient heuristic,
so fix it by adding READ_ONCE() for the read.

Link: http://lkml.kernel.org/r/20200206034945.2481-1-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-fix-a-data-race-in-scan-count
+++ a/include/linux/memcontrol.h
@@ -630,7 +630,7 @@ unsigned long mem_cgroup_get_zone_lru_si
 	struct mem_cgroup_per_node *mz;
 
 	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	return mz->lru_zone_size[zone_idx][lru];
+	return READ_ONCE(mz->lru_zone_size[zone_idx][lru]);
 }
 
 void mem_cgroup_handle_over_high(void);
_

Patches currently in -mm which might be from cai@lca.pw are

fork-silence-a-false-postive-warning-in-__mmdrop.patch

