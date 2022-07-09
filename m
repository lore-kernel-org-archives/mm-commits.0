Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17676C43334
	for <mm-commits@archiver.kernel.org>; Sat,  9 Jul 2022 02:31:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiGICbr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jul 2022 22:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiGICbq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2022 22:31:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB167A518
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 19:31:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E62BB80CE6
        for <mm-commits@vger.kernel.org>; Sat,  9 Jul 2022 02:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9585CC341C0;
        Sat,  9 Jul 2022 02:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657333902;
        bh=hXM+xhcI74MBcfgUPJEys75Iy08IM+ouQ9hN5Lcv/as=;
        h=Date:To:From:Subject:From;
        b=bZLfLrsqmv1yymL7yk107kIJkGuPdixmQU1LCdBjjD6u93JAMCMAGkbfSx1auc9i0
         +Rdw8RFLXyMtxvk0jjFm3qqn0qgOQsKmWNOGAAzaREujIjz2kPJXEGZhEcMM6TXO1S
         hUI+PS4a8459Cp9K7t0b1ErF0lDeeNVGoo6t6p1k=
Date:   Fri, 08 Jul 2022 19:31:41 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mkoutny@suse.com, mhocko@kernel.org,
        longman@redhat.com, hannes@cmpxchg.org,
        duanxiongchun@bytedance.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memcontrol-remove-dead-code-and-comments.patch removed from -mm tree
Message-Id: <20220709023142.9585CC341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memcontrol: remove dead code and comments
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-remove-dead-code-and-comments.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: remove dead code and comments
Date: Tue, 21 Jun 2022 20:56:48 +0800

Patch series "Use obj_cgroup APIs to charge the LRU pages", v6.

With the following patchsets applied, all the kernel memory is charged with
the new APIs of obj_cgroup:

	commit f2fe7b09a52b ("mm: memcg/slab: charge individual slab objects instead of pages")
	commit b4e0b68fbd9d ("mm: memcontrol: use obj_cgroup APIs to charge kmem pages")

But user memory allocations (LRU pages) pinning memcgs for a long time -
it exists at a larger scale and is causing recurring problems in the real
world: page cache doesn't get reclaimed for a long time, or is used by the
second, third, fourth, ...  instance of the same job that was restarted
into a new cgroup every time.  Unreclaimable dying cgroups pile up, waste
memory, and make page reclaim very inefficient.

We can convert LRU pages and most other raw memcg pins to the objcg
direction to fix this problem, and then the LRU pages will not pin the
memcgs.

This patchset aims to make the LRU pages to drop the reference to memory
cgroup by using the APIs of obj_cgroup.  Finally, we can see that the
number of the dying cgroups will not increase if we run the following test
script.

#!/bin/bash

dd if=/dev/zero of=temp bs=4096 count=1
cat /proc/cgroups | grep memory

for i in {0..2000}
do
	mkdir /sys/fs/cgroup/memory/test$i
	echo $$ > /sys/fs/cgroup/memory/test$i/cgroup.procs
	cat temp >> log
	echo $$ > /sys/fs/cgroup/memory/cgroup.procs
	rmdir /sys/fs/cgroup/memory/test$i
done

cat /proc/cgroups | grep memory

rm -f temp log



This patch (of 11):

Since no-hierarchy mode is deprecated after

  commit bef8620cd8e0 ("mm: memcg: deprecate the non-hierarchical mode")

so parent_mem_cgroup() cannot return a NULL except root memcg, however,
root memcg cannot be offline, so it is safe to drop the check of returned
value of parent_mem_cgroup().  Remove those dead code.

The comments in memcg_offline_kmem() above memcg_reparent_list_lrus() are
out of date since

  commit 5abc1e37afa0 ("mm: list_lru: allocate list_lru_one only when needed")

There is no ordering requirement between memcg_reparent_list_lrus() and
memcg_reparent_objcgs(), so remove those outdated comments.

Link: https://lkml.kernel.org/r/20220621125658.64935-1-songmuchun@bytedance.com
Link: https://lkml.kernel.org/r/20220621125658.64935-2-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    3 +--
 mm/memcontrol.c            |   12 ------------
 mm/vmscan.c                |    6 +-----
 3 files changed, 2 insertions(+), 19 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-remove-dead-code-and-comments
+++ a/include/linux/memcontrol.h
@@ -866,8 +866,7 @@ static inline struct mem_cgroup *lruvec_
  * parent_mem_cgroup - find the accounting parent of a memcg
  * @memcg: memcg whose parent to find
  *
- * Returns the parent memcg, or NULL if this is the root or the memory
- * controller is in legacy no-hierarchy mode.
+ * Returns the parent memcg, or NULL if this is the root.
  */
 static inline struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg)
 {
--- a/mm/memcontrol.c~mm-memcontrol-remove-dead-code-and-comments
+++ a/mm/memcontrol.c
@@ -3683,17 +3683,7 @@ static void memcg_offline_kmem(struct me
 		return;
 
 	parent = parent_mem_cgroup(memcg);
-	if (!parent)
-		parent = root_mem_cgroup;
-
 	memcg_reparent_objcgs(memcg, parent);
-
-	/*
-	 * After we have finished memcg_reparent_objcgs(), all list_lrus
-	 * corresponding to this cgroup are guaranteed to remain empty.
-	 * The ordering is imposed by list_lru_node->lock taken by
-	 * memcg_reparent_list_lrus().
-	 */
 	memcg_reparent_list_lrus(memcg, parent);
 }
 #else
@@ -7194,8 +7184,6 @@ static struct mem_cgroup *mem_cgroup_id_
 			break;
 		}
 		memcg = parent_mem_cgroup(memcg);
-		if (!memcg)
-			memcg = root_mem_cgroup;
 	}
 	return memcg;
 }
--- a/mm/vmscan.c~mm-memcontrol-remove-dead-code-and-comments
+++ a/mm/vmscan.c
@@ -409,13 +409,9 @@ void reparent_shrinker_deferred(struct m
 {
 	int i, nid;
 	long nr;
-	struct mem_cgroup *parent;
+	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
 	struct shrinker_info *child_info, *parent_info;
 
-	parent = parent_mem_cgroup(memcg);
-	if (!parent)
-		parent = root_mem_cgroup;
-
 	/* Prevent from concurrent shrinker_info expand */
 	down_read(&shrinker_rwsem);
 	for_each_node(nid) {
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-fix-missing-wake-up-event-for-fsdax-pages.patch
mm-rename-unlock_page_lruvec_irq-_irqrestore-to-lruvec_unlock_irq-_irqrestore.patch
mm-memcontrol-prepare-objcg-api-for-non-kmem-usage.patch
mm-memcontrol-make-lruvec-lock-safe-when-lru-pages-are-reparented.patch
mm-vmscan-rework-move_pages_to_lru.patch
mm-thp-make-split-queue-lock-safe-when-lru-pages-are-reparented.patch
mm-memcontrol-make-all-the-callers-of-foliopage_memcg-safe.patch
mm-memcontrol-introduce-memcg_reparent_ops.patch
mm-memcontrol-use-obj_cgroup-apis-to-charge-the-lru-pages.patch
mm-lru-add-vm_warn_on_once_folio-to-lru-maintenance-function.patch
mm-hugetlb_vmemmap-delete-hugetlb_optimize_vmemmap_enabled.patch
mm-hugetlb_vmemmap-optimize-vmemmap_optimize_mode-handling.patch
mm-hugetlb_vmemmap-introduce-the-name-hvo.patch
mm-hugetlb_vmemmap-move-vmemmap-code-related-to-hugetlb-to-hugetlb_vmemmapc.patch
mm-hugetlb_vmemmap-replace-early_param-with-core_param.patch
mm-hugetlb_vmemmap-improve-hugetlb_vmemmap-code-readability.patch
mm-hugetlb_vmemmap-move-code-comments-to-vmemmap_deduprst.patch
mm-hugetlb_vmemmap-use-ptrs_per_pte-instead-of-pmd_size-page_size.patch

