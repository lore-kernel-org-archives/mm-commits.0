Return-Path: <SRS0=vJaG=CJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 381BBC433E6
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 18:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B25A206E3
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 18:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598898598;
	bh=tmmZzq8xiYEIaW+6sZisaXgkMsy4Bwnt7d3X5Kd3YnQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=1pMWryDgynemYvoUzz4Tl4J3iWPZC0PBD6pHwdnA3g5Dbj9jVyuoJRNlgM/gcAwgd
	 bynUOm0yT/5gHM4x4F6FCGp/HJiHb/DeGrztLPH2xHP3HMEQXfMm2sbpTGG0hmPzKB
	 SeAfZAxF8tiIBHj4yTuenBgMin4F4jf1cX+HgKdc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbgHaS35 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Aug 2020 14:29:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbgHaS35 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 Aug 2020 14:29:57 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 664282071B;
        Mon, 31 Aug 2020 18:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598898596;
        bh=tmmZzq8xiYEIaW+6sZisaXgkMsy4Bwnt7d3X5Kd3YnQ=;
        h=Date:From:To:Subject:From;
        b=dVa0dgdCgoEhum+I8wBxXqgKjRtZyRGsbXDAFGzLRoncYcjWeOezvE3YdBwZqqyge
         vA9iO/1dNmt7ifblGWCZLcB5POYuyb03gAzuPBrtFb2MSrMkpQQ43LVSw6ZBVj2mVv
         toIbXO5eQKHzuP4FhpBNsR4gSRz09wZ+NaKhk4oM=
Date:   Mon, 31 Aug 2020 11:29:55 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, alex.shi@linux.alibaba.com,
        yuzhao@google.com
Subject:  + mm-use-self-explanatory-macros-rather-than-2.patch added
 to -mm tree
Message-ID: <20200831182955.fvguL%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use self-explanatory macros rather than "2"
has been added to the -mm tree.  Its filename is
     mm-use-self-explanatory-macros-rather-than-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-self-explanatory-macros-rather-than-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-self-explanatory-macros-rather-than-2.patch

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
@@ -2232,7 +2232,7 @@ static void get_scan_count(struct lruvec
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

mm-remove-activate_page-from-unuse_pte.patch
mm-remove-superfluous-__clearpageactive.patch
mm-use-add_page_to_lru_list-page_lru-page_off_lru.patch
mm-use-self-explanatory-macros-rather-than-2.patch

