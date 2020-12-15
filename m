Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AE71C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:13:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4785D224F4
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:13:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbgLODN0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:13:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:36482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728089AbgLODNL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:13:11 -0500
Date:   Mon, 14 Dec 2020 19:12:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001967;
        bh=ekaX+Hi8JaFvMZz94M9IWHNlqTcfFkRyLezPVVr8y8s=;
        h=From:To:Subject:In-Reply-To:From;
        b=cDfKS+7SkFoSybiwX0kb0IMmNrjCi3++p5/RTVkWZzi6mjpQRggzrV1jndYJn0xcR
         ypuC4BmjJsDtgcv4e4+MtCR8y5Gq1ZmGT7ghu6j/Ab6mmLMnIn6+hRn2xSFXlfns23
         FfDi+JMC0ZNAVtEUyJtieeszStDc20djwZWMv5Wg=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, iamjoonsoo.kim@lge.com,
        linux-mm@kvack.org, mateusznosek0@gmail.com,
        mm-commits@vger.kernel.org, nigupta@nvidia.com, sh_def@163.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 161/200] mm/compaction: make defer_compaction and
 compaction_deferred static
Message-ID: <20201215031246.i0OwwU3Tv%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Hui Su <sh_def@163.com>
Subject: mm/compaction: make defer_compaction and compaction_deferred static

defer_compaction() and compaction_deferred() and compaction_restarting()
in mm/compaction.c won't be used in other files, so make them static, and
remove the declaration in the header file.

Take the chance to fix a typo.

Link: https://lkml.kernel.org/r/20201123170801.GA9625@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Nitin Gupta <nigupta@nvidia.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Mateusz Nosek <mateusznosek0@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |   12 ------------
 mm/compaction.c            |    8 ++++----
 2 files changed, 4 insertions(+), 16 deletions(-)

--- a/include/linux/compaction.h~mm-compaction-make-defer_compaction-and-compaction_deferred-static
+++ a/include/linux/compaction.h
@@ -98,11 +98,8 @@ extern void reset_isolation_suitable(pg_
 extern enum compact_result compaction_suitable(struct zone *zone, int order,
 		unsigned int alloc_flags, int highest_zoneidx);
 
-extern void defer_compaction(struct zone *zone, int order);
-extern bool compaction_deferred(struct zone *zone, int order);
 extern void compaction_defer_reset(struct zone *zone, int order,
 				bool alloc_success);
-extern bool compaction_restarting(struct zone *zone, int order);
 
 /* Compaction has made some progress and retrying makes sense */
 static inline bool compaction_made_progress(enum compact_result result)
@@ -194,15 +191,6 @@ static inline enum compact_result compac
 	return COMPACT_SKIPPED;
 }
 
-static inline void defer_compaction(struct zone *zone, int order)
-{
-}
-
-static inline bool compaction_deferred(struct zone *zone, int order)
-{
-	return true;
-}
-
 static inline bool compaction_made_progress(enum compact_result result)
 {
 	return false;
--- a/mm/compaction.c~mm-compaction-make-defer_compaction-and-compaction_deferred-static
+++ a/mm/compaction.c
@@ -157,7 +157,7 @@ EXPORT_SYMBOL(__ClearPageMovable);
  * allocation success. 1 << compact_defer_shift, compactions are skipped up
  * to a limit of 1 << COMPACT_MAX_DEFER_SHIFT
  */
-void defer_compaction(struct zone *zone, int order)
+static void defer_compaction(struct zone *zone, int order)
 {
 	zone->compact_considered = 0;
 	zone->compact_defer_shift++;
@@ -172,7 +172,7 @@ void defer_compaction(struct zone *zone,
 }
 
 /* Returns true if compaction should be skipped this time */
-bool compaction_deferred(struct zone *zone, int order)
+static bool compaction_deferred(struct zone *zone, int order)
 {
 	unsigned long defer_limit = 1UL << zone->compact_defer_shift;
 
@@ -209,7 +209,7 @@ void compaction_defer_reset(struct zone
 }
 
 /* Returns true if restarting compaction after many failures */
-bool compaction_restarting(struct zone *zone, int order)
+static bool compaction_restarting(struct zone *zone, int order)
 {
 	if (order < zone->compact_order_failed)
 		return false;
@@ -237,7 +237,7 @@ static void reset_cached_positions(struc
 }
 
 /*
- * Compound pages of >= pageblock_order should consistenly be skipped until
+ * Compound pages of >= pageblock_order should consistently be skipped until
  * released. It is always pointless to compact pages of such order (if they are
  * migratable), and the pageblocks they occupy cannot contain any free pages.
  */
_
