Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 907CDC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:46:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4396120897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816412;
	bh=ifaYfG/yFZB6D7SvRT5p06zXbPi3+9clxz/CxqBClCI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=UUrJOJdyJb7ux3vnAxE7xejBcy8PlofCzyV3PD9NUGvofTlEytsXEQ+6VvdegSvQm
	 ghnc4OsE9c6gzADoJUUGuhEIr+q20dxeVvInRcPJWFu66/m0J44lcTqlUhKpaikELi
	 eSvCCHgiDV/ZtnA8aGI5QXOMeyArQFdivo0gqqKY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388874AbgJPCqw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:46:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:34484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404339AbgJPCqv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:46:51 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1A3920E65;
        Fri, 16 Oct 2020 02:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816411;
        bh=ifaYfG/yFZB6D7SvRT5p06zXbPi3+9clxz/CxqBClCI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=15XLdK6W4wREZBic4ic3PJr0R6F8d7mPOho3KE2zDx/QnYArlnF62GChu44oLTwz3
         lO3m+6YK5E7rLobn1at8oLTPcWeGlGqGhGE6Nj05m2d5mcWByDg2sffD35GExY03xT
         u06gzXbYRtxXpHEmeDW4dI6ha/sc9onLzMh3ociQ=
Date:   Thu, 15 Oct 2020 19:46:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, yuzhao@google.com
Subject:  [patch 088/156] mm: use self-explanatory macros rather
 than "2"
Message-ID: <20201016024650.mor5hhv3H%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
