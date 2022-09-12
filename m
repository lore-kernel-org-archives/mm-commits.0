Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72537ECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 00:44:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiILAoN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 20:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiILAoN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 20:44:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C5827CE5
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 17:44:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 142ABB80B06
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 00:44:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC643C433D7;
        Mon, 12 Sep 2022 00:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662943449;
        bh=MvTXKMtXLoBivMcM/0wUnRH4XxTD6+Vbm0c58kM2R3A=;
        h=Date:To:From:Subject:From;
        b=wEMT8DrWFmbN0J1SZCbcTpZqHAeHHt82nVfAHdtzZ+Dg5aKkjGRCFoDhxFYmxcw/6
         FgT1MFvXZdYd84jemGBiBkfFc4M0qWMBpREvaM0D5EmmX6S+9VTdaGaGXD8q3LlIF6
         s6Xotv42kVJYVSCvVSpZ3IyahDVRk/qMXOpm8yJ0=
Date:   Sun, 11 Sep 2022 17:44:09 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        muchun.song@linux.dev, david@redhat.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-fix-null-ptr-deref-in-kswapd_is_running-fix.patch removed from -mm tree
Message-Id: <20220912004409.BC643C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-fix-null-ptr-deref-in-kswapd_is_running-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-null-ptr-deref-in-kswapd_is_running-fix.patch

This patch was dropped because it was folded into mm-fix-null-ptr-deref-in-kswapd_is_running.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fix-null-ptr-deref-in-kswapd_is_running-fix
Date: Sat Aug 27 03:04:21 PM PDT 2022

add comments

Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    1 +
 mm/compaction.c                |    6 ++++++
 2 files changed, 7 insertions(+)

--- a/include/linux/memory_hotplug.h~mm-fix-null-ptr-deref-in-kswapd_is_running-fix
+++ a/include/linux/memory_hotplug.h
@@ -215,6 +215,7 @@ void put_online_mems(void);
 void mem_hotplug_begin(void);
 void mem_hotplug_done(void);
 
+/* See kswapd_is_running() */
 static inline void pgdat_kswapd_lock(pg_data_t *pgdat)
 {
 	mutex_lock(&pgdat->kswapd_lock);
--- a/mm/compaction.c~mm-fix-null-ptr-deref-in-kswapd_is_running-fix
+++ a/mm/compaction.c
@@ -1980,6 +1980,12 @@ static inline bool is_via_compact_memory
 	return order == -1;
 }
 
+/*
+ * Determine whether kswapd is (or recently was!) running on this node.
+ *
+ * pgdat_kswapd_lock() pins pgdat->kswapd, so a concurrent kswapd_stop() can't
+ * zero it.
+ */
 static bool kswapd_is_running(pg_data_t *pgdat)
 {
 	bool running;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-fix-null-ptr-deref-in-kswapd_is_running.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
mm-demotion-add-support-for-explicit-memory-tiers-fix.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-delete-unused-mmf_oom_victim-flag-vs-mglru.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree-fix.patch
mm-vmscan-fix-a-lot-of-comments-vs-mglru.patch
swap-add-swap_cache_get_folio-fix.patch
memcg-reduce-size-of-memcg-vmstats-structures-fix.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme-fix.patch
ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes.patch
fs-uninline-inode_maybe_inc_iversion.patch

