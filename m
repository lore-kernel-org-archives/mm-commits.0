Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 839FBC25B08
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 19:05:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237586AbiHQTFi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 15:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241362AbiHQTFO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 15:05:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF425B791
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 12:05:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6304D6144A
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 19:05:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3DDC433D7;
        Wed, 17 Aug 2022 19:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660763110;
        bh=gRaUGRcFcV0IOMVA1gbZQudCLe99mNwbxShQYSOxjFs=;
        h=Date:To:From:Subject:From;
        b=YWU0E8G3LOO8AiRrlwm5dxCRRX7hzKd+rkjwUzlxpxdBH/Y7jhMSZXKnuwOPOE/LX
         n8mP0ulcA/nORtp1t9DUVtJMvvQ055plTDx3ndIugFo09qPizZBnpD3+fqnW1z1vxh
         8/CklkHa1vmUG/vnO/FRWncH+nFodNAbXbyWxY78=
Date:   Wed, 17 Aug 2022 12:05:09 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        willy@infradead.org, will@kernel.org, vbabka@suse.cz,
        vaibhav@linux.ibm.com, tj@kernel.org, szhai2@cs.rochester.edu,
        suleiman@google.com, steven@liquorix.net, sofia.trinh@edi.works,
        rppt@kernel.org, peterz@infradead.org, oleksandr@natalenko.name,
        Michael@MichaelLarabel.com, mhocko@kernel.org, mgorman@suse.de,
        linmiaohe@huawei.com, holger@applied-asynchrony.com,
        Hi-Angel@yandex.ru, heftig@archlinux.org, hdanton@sina.com,
        hannes@cmpxchg.org, djbyrne@mtu.edu, d@chaos-reins.com,
        dave.hansen@linux.intel.com, corbet@lwn.net,
        catalin.marinas@arm.com, bgeffon@google.com, baohua@kernel.org,
        axboe@kernel.dk, aneesh.kumar@linux.ibm.com, ak@linux.intel.com,
        yuzhao@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-optimize-multiple-memcgs.patch added to mm-unstable branch
Message-Id: <20220817190510.AA3DDC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: multi-gen LRU: optimize multiple memcgs
has been added to the -mm mm-unstable branch.  Its filename is
     mm-multi-gen-lru-optimize-multiple-memcgs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-multi-gen-lru-optimize-multiple-memcgs.patch

This patch will later appear in the mm-unstable branch at
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
From: Yu Zhao <yuzhao@google.com>
Subject: mm: multi-gen LRU: optimize multiple memcgs
Date: Mon, 15 Aug 2022 01:13:28 -0600

When multiple memcgs are available, it is possible to make better choices
based on generations and tiers and therefore improve the overall
performance under global memory pressure.  This patch adds a rudimentary
optimization to select memcgs that can drop single-use unmapped clean
pages first.  Doing so reduces the chance of going into the aging path or
swapping.  These two decisions can be costly.

A typical example that benefits from this optimization is a server running
mixed types of workloads, e.g., heavy anon workload in one memcg and heavy
buffered I/O workload in the other.

Though this optimization can be applied to both kswapd and direct reclaim,
it is only added to kswapd to keep the patchset manageable.  Later
improvements will cover the direct reclaim path.

Server benchmark results:
  Mixed workloads:
    fio (buffered I/O): +[19, 21]%
                IOPS         BW
      patch1-8: 1880k        7343MiB/s
      patch1-9: 2252k        8796MiB/s

    memcached (anon): +[119, 123]%
                Ops/sec      KB/sec
      patch1-8: 862768.65    33514.68
      patch1-9: 1911022.12   74234.54

  Mixed workloads:
    fio (buffered I/O): +[75, 77]%
                IOPS         BW
      5.19-rc1: 1279k        4996MiB/s
      patch1-9: 2252k        8796MiB/s

    memcached (anon): +[13, 15]%
                Ops/sec      KB/sec
      5.19-rc1: 1673524.04   65008.87
      patch1-9: 1911022.12   74234.54

  Configurations:
    (changes since patch 6)

    cat mixed.sh
    modprobe brd rd_nr=2 rd_size=56623104

    swapoff -a
    mkswap /dev/ram0
    swapon /dev/ram0

    mkfs.ext4 /dev/ram1
    mount -t ext4 /dev/ram1 /mnt

    memtier_benchmark -S /var/run/memcached/memcached.sock \
      -P memcache_binary -n allkeys --key-minimum=1 \
      --key-maximum=50000000 --key-pattern=P:P -c 1 -t 36 \
      --ratio 1:0 --pipeline 8 -d 2000

    fio -name=mglru --numjobs=36 --directory=/mnt --size=1408m \
      --buffered=1 --ioengine=io_uring --iodepth=128 \
      --iodepth_batch_submit=32 --iodepth_batch_complete=32 \
      --rw=randread --random_distribution=random --norandommap \
      --time_based --ramp_time=10m --runtime=90m --group_reporting &
    pid=$!

    sleep 200

    memtier_benchmark -S /var/run/memcached/memcached.sock \
      -P memcache_binary -n allkeys --key-minimum=1 \
      --key-maximum=50000000 --key-pattern=R:R -c 1 -t 36 \
      --ratio 0:1 --pipeline 8 --randomize --distinct-client-seed

    kill -INT $pid
    wait

Client benchmark results:
  no change (CONFIG_MEMCG=n)

Link: https://lkml.kernel.org/r/20220815071332.627393-10-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Acked-by: Brian Geffon <bgeffon@google.com>
Acked-by: Jan Alexander Steffens (heftig) <heftig@archlinux.org>
Acked-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Acked-by: Steven Barrett <steven@liquorix.net>
Acked-by: Suleiman Souhlal <suleiman@google.com>
Tested-by: Daniel Byrne <djbyrne@mtu.edu>
Tested-by: Donald Carr <d@chaos-reins.com>
Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Tested-by: Konstantin Kharlamov <Hi-Angel@yandex.ru>
Tested-by: Shuang Zhai <szhai2@cs.rochester.edu>
Tested-by: Sofia Trinh <sofia.trinh@edi.works>
Tested-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michael Larabel <Michael@MichaelLarabel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   55 +++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 46 insertions(+), 9 deletions(-)

--- a/mm/vmscan.c~mm-multi-gen-lru-optimize-multiple-memcgs
+++ a/mm/vmscan.c
@@ -131,6 +131,13 @@ struct scan_control {
 	/* Always discard instead of demoting to lower tier memory */
 	unsigned int no_demotion:1;
 
+#ifdef CONFIG_LRU_GEN
+	/* help make better choices when multiple memcgs are available */
+	unsigned int memcgs_need_aging:1;
+	unsigned int memcgs_need_swapping:1;
+	unsigned int memcgs_avoid_swapping:1;
+#endif
+
 	/* Allocation order */
 	s8 order;
 
@@ -4437,6 +4444,22 @@ static void lru_gen_age_node(struct pgli
 
 	VM_WARN_ON_ONCE(!current_is_kswapd());
 
+	/*
+	 * To reduce the chance of going into the aging path or swapping, which
+	 * can be costly, optimistically skip them unless their corresponding
+	 * flags were cleared in the eviction path. This improves the overall
+	 * performance when multiple memcgs are available.
+	 */
+	if (!sc->memcgs_need_aging) {
+		sc->memcgs_need_aging = true;
+		sc->memcgs_avoid_swapping = !sc->memcgs_need_swapping;
+		sc->memcgs_need_swapping = true;
+		return;
+	}
+
+	sc->memcgs_need_swapping = true;
+	sc->memcgs_avoid_swapping = true;
+
 	set_mm_walk(pgdat);
 
 	memcg = mem_cgroup_iter(NULL, NULL, NULL);
@@ -4846,7 +4869,8 @@ static int isolate_folios(struct lruvec
 	return scanned;
 }
 
-static int evict_folios(struct lruvec *lruvec, struct scan_control *sc, int swappiness)
+static int evict_folios(struct lruvec *lruvec, struct scan_control *sc, int swappiness,
+			bool *need_swapping)
 {
 	int type;
 	int scanned;
@@ -4909,6 +4933,9 @@ static int evict_folios(struct lruvec *l
 
 	sc->nr_reclaimed += reclaimed;
 
+	if (type == LRU_GEN_ANON && need_swapping)
+		*need_swapping = true;
+
 	return scanned;
 }
 
@@ -4918,10 +4945,9 @@ static int evict_folios(struct lruvec *l
  *    reclaim.
  */
 static unsigned long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
-				    bool can_swap, unsigned long reclaimed)
+				    bool can_swap, unsigned long reclaimed, bool *need_aging)
 {
 	int priority;
-	bool need_aging;
 	unsigned long nr_to_scan;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	DEFINE_MAX_SEQ(lruvec);
@@ -4936,7 +4962,7 @@ static unsigned long get_nr_to_scan(stru
 	    (mem_cgroup_below_low(memcg) && !sc->memcg_low_reclaim))
 		return 0;
 
-	nr_to_scan = get_nr_evictable(lruvec, max_seq, min_seq, can_swap, &need_aging);
+	nr_to_scan = get_nr_evictable(lruvec, max_seq, min_seq, can_swap, need_aging);
 	if (!nr_to_scan)
 		return 0;
 
@@ -4952,7 +4978,7 @@ static unsigned long get_nr_to_scan(stru
 	if (!nr_to_scan)
 		return 0;
 
-	if (!need_aging)
+	if (!*need_aging)
 		return nr_to_scan;
 
 	/* skip the aging path at the default priority */
@@ -4972,6 +4998,8 @@ done:
 static void lru_gen_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
 	struct blk_plug plug;
+	bool need_aging = false;
+	bool need_swapping = false;
 	unsigned long scanned = 0;
 	unsigned long reclaimed = sc->nr_reclaimed;
 
@@ -4993,21 +5021,30 @@ static void lru_gen_shrink_lruvec(struct
 		else
 			swappiness = 0;
 
-		nr_to_scan = get_nr_to_scan(lruvec, sc, swappiness, reclaimed);
+		nr_to_scan = get_nr_to_scan(lruvec, sc, swappiness, reclaimed, &need_aging);
 		if (!nr_to_scan)
-			break;
+			goto done;
 
-		delta = evict_folios(lruvec, sc, swappiness);
+		delta = evict_folios(lruvec, sc, swappiness, &need_swapping);
 		if (!delta)
-			break;
+			goto done;
 
 		scanned += delta;
 		if (scanned >= nr_to_scan)
 			break;
 
+		if (sc->memcgs_avoid_swapping && swappiness < 200 && need_swapping)
+			break;
+
 		cond_resched();
 	}
 
+	/* see the comment in lru_gen_age_node() */
+	if (!need_aging)
+		sc->memcgs_need_aging = false;
+	if (!need_swapping)
+		sc->memcgs_need_swapping = false;
+done:
 	clear_mm_walk();
 
 	blk_finish_plug(&plug);
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-x86-arm64-add-arch_has_hw_pte_young.patch
mm-x86-add-config_arch_has_nonleaf_pmd_young.patch
mm-vmscanc-refactor-shrink_node.patch
revert-include-linux-mm_inlineh-fold-__update_lru_size-into-its-sole-caller.patch
mm-multi-gen-lru-groundwork.patch
mm-multi-gen-lru-minimal-implementation.patch
mm-multi-gen-lru-exploit-locality-in-rmap.patch
mm-multi-gen-lru-support-page-table-walks.patch
mm-multi-gen-lru-optimize-multiple-memcgs.patch
mm-multi-gen-lru-kill-switch.patch
mm-multi-gen-lru-thrashing-prevention.patch
mm-multi-gen-lru-debugfs-interface.patch
mm-multi-gen-lru-admin-guide.patch
mm-multi-gen-lru-design-doc.patch

