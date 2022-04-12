Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 465BBC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 12 Apr 2022 04:20:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345756AbiDLEXI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Apr 2022 00:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345849AbiDLEWt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Apr 2022 00:22:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BEB2983E
        for <mm-commits@vger.kernel.org>; Mon, 11 Apr 2022 21:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6308C61781
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 04:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1925C385A6;
        Tue, 12 Apr 2022 04:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649737215;
        bh=DcciWOnGAULLxyanI6eBLcJAvJDdWFbrT9e563E2h3I=;
        h=Date:To:From:Subject:From;
        b=dNVqeZMs/u5ZXggVDD1rQdCB74KuqkmyJ+/TCy0ohkR8+54QkCDri+re61D+JLu5F
         hbODVEQPQBuszox8EpYvopQMvC5C9FbcODATxPIq5m5hRIRad7Hr9tfHu50yrunLhK
         2oJASVrB+nrM5eGv7jeu8Mt4+hKuZ38cR3afiwiU=
Date:   Mon, 11 Apr 2022 21:20:15 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, vaibhav@linux.ibm.com,
        szhai2@cs.rochester.edu, suleiman@google.com, steven@liquorix.net,
        sofia.trinh@edi.works, shy828301@gmail.com,
        oleksandr@natalenko.name, mgorman@techsingularity.net,
        holger@applied-asynchrony.com, Hi-Angel@yandex.ru,
        heftig@archlinux.org, hannes@cmpxchg.org, djbyrne@mtu.edu,
        d@chaos-reins.com, bgeffon@google.com, baohua@kernel.org,
        yuzhao@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-optimize-multiple-memcgs.patch added to -mm tree
Message-Id: <20220412042015.B1925C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: multi-gen LRU: optimize multiple memcgs
has been added to the -mm tree.  Its filename is
     mm-multi-gen-lru-optimize-multiple-memcgs.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-multi-gen-lru-optimize-multiple-memcgs.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-multi-gen-lru-optimize-multiple-memcgs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm: multi-gen LRU: optimize multiple memcgs

When multiple memcgs are available, it is possible to make better choices
based on generations and tiers and therefore improve the overall
performance under global memory pressure.  This patch adds a rudimentary
optimization to select memcgs that can drop single-use unmapped clean
pages first.  Doing so reduces the chance of going into the aging path or
swapping.  These two operations can be costly.

A typical example that benefits from this optimization is a server running
mixed types of workloads, e.g., heavy anon workload in one memcg and heavy
buffered I/O workload in the other.

Though this optimization can be applied to both kswapd and direct reclaim,
it is only added to kswapd to keep the patchset manageable.  Later
improvements will cover the direct reclaim path.

Server benchmark results:
  Mixed workloads:
    fio (buffered I/O): +[1, 3]%
                IOPS         BW
      patch1-8: 2154k        8415MiB/s
      patch1-9: 2205k        8613MiB/s

    memcached (anon): +[132, 136]%
                Ops/sec      KB/sec
      patch1-8: 819618.49    31838.48
      patch1-9: 1916516.06   74447.92

  Mixed workloads:
    fio (buffered I/O): +[59, 61]%
                IOPS         BW
      5.18-rc1: 1378k        5385MiB/s
      patch1-9: 2205k        8613MiB/s

    memcached (anon): +[229, 233]%
                Ops/sec      KB/sec
      5.18-rc1: 578946.00    22489.44
      patch1-9: 1916516.06   74447.92

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

Link: https://lkml.kernel.org/r/20220407031525.2368067-10-yuzhao@google.com
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
Cc: Barry Song <baohua@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmscan.c~mm-multi-gen-lru-optimize-multiple-memcgs
+++ a/mm/vmscan.c
@@ -129,6 +129,13 @@ struct scan_control {
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
 
@@ -4324,6 +4331,22 @@ static void lru_gen_age_node(struct pgli
 
 	VM_BUG_ON(!current_is_kswapd());
 
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
 	current->reclaim_state->mm_walk = &pgdat->mm_walk;
 
 	memcg = mem_cgroup_iter(NULL, NULL, NULL);
@@ -4729,7 +4752,8 @@ static int isolate_folios(struct lruvec
 	return scanned;
 }
 
-static int evict_folios(struct lruvec *lruvec, struct scan_control *sc, int swappiness)
+static int evict_folios(struct lruvec *lruvec, struct scan_control *sc, int swappiness,
+			bool *swapped)
 {
 	int type;
 	int scanned;
@@ -4795,6 +4819,9 @@ static int evict_folios(struct lruvec *l
 
 	sc->nr_reclaimed += reclaimed;
 
+	if (type == LRU_GEN_ANON && swapped)
+		*swapped = true;
+
 	return scanned;
 }
 
@@ -4823,8 +4850,10 @@ static long get_nr_to_scan(struct lruvec
 	if (!nr_to_scan)
 		return 0;
 
-	if (!need_aging)
+	if (!need_aging) {
+		sc->memcgs_need_aging = false;
 		return nr_to_scan;
+	}
 
 	/* leave the work to lru_gen_age_node() */
 	if (current_is_kswapd())
@@ -4846,6 +4875,8 @@ static void lru_gen_shrink_lruvec(struct
 {
 	struct blk_plug plug;
 	long scanned = 0;
+	bool swapped = false;
+	unsigned long reclaimed = sc->nr_reclaimed;
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
 	lru_add_drain();
@@ -4871,13 +4902,19 @@ static void lru_gen_shrink_lruvec(struct
 		if (!nr_to_scan)
 			break;
 
-		delta = evict_folios(lruvec, sc, swappiness);
+		delta = evict_folios(lruvec, sc, swappiness, &swapped);
 		if (!delta)
 			break;
 
+		if (sc->memcgs_avoid_swapping && swappiness < 200 && swapped)
+			break;
+
 		scanned += delta;
-		if (scanned >= nr_to_scan)
+		if (scanned >= nr_to_scan) {
+			if (!swapped && sc->nr_reclaimed - reclaimed >= MIN_LRU_BATCH)
+				sc->memcgs_need_swapping = false;
 			break;
+		}
 
 		cond_resched();
 	}
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

