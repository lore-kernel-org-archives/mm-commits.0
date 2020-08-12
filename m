Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CCDEC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:31:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 356CE206B2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195869;
	bh=QB0tk5mIKYywOTbrfN9ufpCy0SQoBtGIrigaiA7/bC0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=U7SG8SrZDjfUTZDMsCeKUxgXstnKlFaEuoBONiSe5VbYHBjnMXQvV3fxBv8q3EbaF
	 Vs/ki1zoXLkfY1SSyltLZvmGmPXvzskIr4HgDIWcvgahco7IeJXngX1iSEf3lIEUSY
	 q2POJov5NFDhv3ylImLA3f7ucywctOXzsib7QTRI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgHLBbJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:31:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBbI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:31:08 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D78EC2076C;
        Wed, 12 Aug 2020 01:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195868;
        bh=QB0tk5mIKYywOTbrfN9ufpCy0SQoBtGIrigaiA7/bC0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XUNaTxI0L0xJJl2MfQ0GRyMxt0ads3XU41XgOtqsdSJ4B4pxMa14JmIaaJjrVYRsk
         OhvyoVFNyvrLQ16z0GbebKinv37cUiWPM+M4LsuFAK/Iu4QVnhS5MBmGnBrA3uoj9+
         UGedZE+l0PkkapWVT/j29+pH7fPvqpRJfJOMvRsw=
Date:   Tue, 11 Aug 2020 18:31:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, iamjoonsoo.kim@lge.com,
        keescook@chromium.org, linux-mm@kvack.org, mcgrof@kernel.org,
        mm-commits@vger.kernel.org, nigupta@nvidia.com,
        torvalds@linux-foundation.org, vbabka@suse.cz, yzaikin@google.com
Subject:  [patch 016/165] mm: use unsigned types for fragmentation
 score
Message-ID: <20200812013107.sL41I3PXS%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Nitin Gupta <nigupta@nvidia.com>
Subject: mm: use unsigned types for fragmentation score

Proactive compaction uses per-node/zone "fragmentation score" which is
always in range [0, 100], so use unsigned type of these scores as well as
for related constants.

Link: http://lkml.kernel.org/r/20200618010319.13159-1-nigupta@nvidia.com
Signed-off-by: Nitin Gupta <nigupta@nvidia.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    4 ++--
 kernel/sysctl.c            |    2 +-
 mm/compaction.c            |   18 +++++++++---------
 mm/vmstat.c                |    2 +-
 4 files changed, 13 insertions(+), 13 deletions(-)

--- a/include/linux/compaction.h~mm-use-unsigned-types-for-fragmentation-score
+++ a/include/linux/compaction.h
@@ -85,13 +85,13 @@ static inline unsigned long compact_gap(
 
 #ifdef CONFIG_COMPACTION
 extern int sysctl_compact_memory;
-extern int sysctl_compaction_proactiveness;
+extern unsigned int sysctl_compaction_proactiveness;
 extern int sysctl_compaction_handler(struct ctl_table *table, int write,
 			void *buffer, size_t *length, loff_t *ppos);
 extern int sysctl_extfrag_threshold;
 extern int sysctl_compact_unevictable_allowed;
 
-extern int extfrag_for_order(struct zone *zone, unsigned int order);
+extern unsigned int extfrag_for_order(struct zone *zone, unsigned int order);
 extern int fragmentation_index(struct zone *zone, unsigned int order);
 extern enum compact_result try_to_compact_pages(gfp_t gfp_mask,
 		unsigned int order, unsigned int alloc_flags,
--- a/kernel/sysctl.c~mm-use-unsigned-types-for-fragmentation-score
+++ a/kernel/sysctl.c
@@ -2854,7 +2854,7 @@ static struct ctl_table vm_table[] = {
 	{
 		.procname	= "compaction_proactiveness",
 		.data		= &sysctl_compaction_proactiveness,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(sysctl_compaction_proactiveness),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
--- a/mm/compaction.c~mm-use-unsigned-types-for-fragmentation-score
+++ a/mm/compaction.c
@@ -53,7 +53,7 @@ static inline void count_compact_events(
 /*
  * Fragmentation score check interval for proactive compaction purposes.
  */
-static const int HPAGE_FRAG_CHECK_INTERVAL_MSEC = 500;
+static const unsigned int HPAGE_FRAG_CHECK_INTERVAL_MSEC = 500;
 
 /*
  * Page order with-respect-to which proactive compaction
@@ -1890,7 +1890,7 @@ static bool kswapd_is_running(pg_data_t
  * ZONE_DMA32. For smaller zones, the score value remains close to zero,
  * and thus never exceeds the high threshold for proactive compaction.
  */
-static int fragmentation_score_zone(struct zone *zone)
+static unsigned int fragmentation_score_zone(struct zone *zone)
 {
 	unsigned long score;
 
@@ -1906,9 +1906,9 @@ static int fragmentation_score_zone(stru
  * the node's score falls below the low threshold, or one of the back-off
  * conditions is met.
  */
-static int fragmentation_score_node(pg_data_t *pgdat)
+static unsigned int fragmentation_score_node(pg_data_t *pgdat)
 {
-	unsigned long score = 0;
+	unsigned int score = 0;
 	int zoneid;
 
 	for (zoneid = 0; zoneid < MAX_NR_ZONES; zoneid++) {
@@ -1921,17 +1921,17 @@ static int fragmentation_score_node(pg_d
 	return score;
 }
 
-static int fragmentation_score_wmark(pg_data_t *pgdat, bool low)
+static unsigned int fragmentation_score_wmark(pg_data_t *pgdat, bool low)
 {
-	int wmark_low;
+	unsigned int wmark_low;
 
 	/*
 	 * Cap the low watermak to avoid excessive compaction
 	 * activity in case a user sets the proactivess tunable
 	 * close to 100 (maximum).
 	 */
-	wmark_low = max(100 - sysctl_compaction_proactiveness, 5);
-	return low ? wmark_low : min(wmark_low + 10, 100);
+	wmark_low = max(100U - sysctl_compaction_proactiveness, 5U);
+	return low ? wmark_low : min(wmark_low + 10, 100U);
 }
 
 static bool should_proactive_compact_node(pg_data_t *pgdat)
@@ -2615,7 +2615,7 @@ int sysctl_compact_memory;
  * aggressively the kernel should compact memory in the
  * background. It takes values in the range [0, 100].
  */
-int __read_mostly sysctl_compaction_proactiveness = 20;
+unsigned int __read_mostly sysctl_compaction_proactiveness = 20;
 
 /*
  * This is the entry point for compacting all nodes via
--- a/mm/vmstat.c~mm-use-unsigned-types-for-fragmentation-score
+++ a/mm/vmstat.c
@@ -1101,7 +1101,7 @@ static int __fragmentation_index(unsigne
  * It is defined as the percentage of pages found in blocks of size
  * less than 1 << order. It returns values in range [0, 100].
  */
-int extfrag_for_order(struct zone *zone, unsigned int order)
+unsigned int extfrag_for_order(struct zone *zone, unsigned int order)
 {
 	struct contig_page_info info;
 
_
