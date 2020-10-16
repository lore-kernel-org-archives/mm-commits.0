Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C2A7C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35A5B21775
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881530;
	bh=MeGg+RNXR8hsH7wB+zyoXw8hVQrvJjntgaqOAT8Pqr8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=oLxaH77RqxinbRKlyLxPaS+yzqu4WsuP7hkL5nDF6WkySXsMKKqGyMjlPeB/5SgrJ
	 jzWjXt07smYnu7oHT9tld2pDBuRxiwHBuoATPecMnD6+jzJ4qi7DWr6lT0u5V6w5MY
	 t+YzlBTVMiQXWLyRsh1iPuWDecjRgIbLGbudTSFA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408326AbgJPUwJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:52:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732579AbgJPUwJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:52:09 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D2C720878;
        Fri, 16 Oct 2020 20:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881527;
        bh=MeGg+RNXR8hsH7wB+zyoXw8hVQrvJjntgaqOAT8Pqr8=;
        h=Date:From:To:Subject:From;
        b=2Ey8OOZ477sheZ7J9EoDlx65SEdUO8us36yhk3ZZhFSjmm4JMKIJcYEuS5LkXPkNK
         5UaUfnQARza2dHvRdPyiDEsu2ttXLFN/NjhS6HPP7iB364xLGo/Giu75uzZdY/Psor
         6vEmdRngahUgGw7rBnp4ZRKvNOuQpyeQ6VT+KHqE=
Date:   Fri, 16 Oct 2020 13:52:07 -0700
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, mm-commits@vger.kernel.org,
        yuzhao@google.com
Subject:  [merged]
 mm-use-self-explanatory-macros-rather-than-2.patch removed from -mm tree
Message-ID: <20201016205207.U71ktk4VZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use self-explanatory macros rather than "2"
has been removed from the -mm tree.  Its filename was
     mm-use-self-explanatory-macros-rather-than-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm: use self-explanatory macros rather than "2"

Link: http://lkml.kernel.org/r/20200831175042.3527153-2-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   12 ++++++++----
 include/linux/vmstat.h |    2 +-
 mm/vmscan.c            |    2 +-
 3 files changed, 10 insertions(+), 6 deletions(-)

--- a/include/linux/mmzone.h~mm-use-self-explanatory-macros-rather-than-2
+++ a/include/linux/mmzone.h
@@ -266,6 +266,8 @@ static inline bool is_active_lru(enum lr
 	return (lru == LRU_ACTIVE_ANON || lru == LRU_ACTIVE_FILE);
 }
 
+#define ANON_AND_FILE 2
+
 enum lruvec_flags {
 	LRUVEC_CONGESTED,		/* lruvec has many dirty pages
 					 * backed by a congested BDI
@@ -283,8 +285,8 @@ struct lruvec {
 	unsigned long			file_cost;
 	/* Non-resident age, driven by LRU movement */
 	atomic_long_t			nonresident_age;
-	/* Refaults at the time of last reclaim cycle, anon=0, file=1 */
-	unsigned long			refaults[2];
+	/* Refaults at the time of last reclaim cycle */
+	unsigned long			refaults[ANON_AND_FILE];
 	/* Various lruvec state flags (enum lruvec_flags) */
 	unsigned long			flags;
 #ifdef CONFIG_MEMCG
@@ -441,6 +443,8 @@ enum zone_type {
 
 #ifndef __GENERATING_BOUNDS_H
 
+#define ASYNC_AND_SYNC 2
+
 struct zone {
 	/* Read-mostly fields */
 
@@ -560,8 +564,8 @@ struct zone {
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 	/* pfn where compaction free scanner should start */
 	unsigned long		compact_cached_free_pfn;
-	/* pfn where async and sync compaction migration scanner should start */
-	unsigned long		compact_cached_migrate_pfn[2];
+	/* pfn where compaction migration scanner should start */
+	unsigned long		compact_cached_migrate_pfn[ASYNC_AND_SYNC];
 	unsigned long		compact_init_migrate_pfn;
 	unsigned long		compact_init_free_pfn;
 #endif
--- a/include/linux/vmstat.h~mm-use-self-explanatory-macros-rather-than-2
+++ a/include/linux/vmstat.h
@@ -28,7 +28,7 @@ struct reclaim_stat {
 	unsigned nr_writeback;
 	unsigned nr_immediate;
 	unsigned nr_pageout;
-	unsigned nr_activate[2];
+	unsigned nr_activate[ANON_AND_FILE];
 	unsigned nr_ref_keep;
 	unsigned nr_unmap_fail;
 	unsigned nr_lazyfree_fail;
--- a/mm/vmscan.c~mm-use-self-explanatory-macros-rather-than-2
+++ a/mm/vmscan.c
@@ -2239,7 +2239,7 @@ static void get_scan_count(struct lruvec
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	unsigned long anon_cost, file_cost, total_cost;
 	int swappiness = mem_cgroup_swappiness(memcg);
-	u64 fraction[2];
+	u64 fraction[ANON_AND_FILE];
 	u64 denominator = 0;	/* gcc */
 	enum scan_balance scan_balance;
 	unsigned long ap, fp;
_

Patches currently in -mm which might be from yuzhao@google.com are


