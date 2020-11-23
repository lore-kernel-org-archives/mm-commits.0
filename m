Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AE28C63697
	for <mm-commits@archiver.kernel.org>; Mon, 23 Nov 2020 19:48:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2A9920719
	for <mm-commits@archiver.kernel.org>; Mon, 23 Nov 2020 19:48:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MbThk+5n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730584AbgKWTsD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Nov 2020 14:48:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:59514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730569AbgKWTsD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Nov 2020 14:48:03 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E83B1206F1;
        Mon, 23 Nov 2020 19:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606160883;
        bh=VjMYHANGKQ/s/oPUkXFaJ1tRO7LRfAc+qWGEL7CZeSM=;
        h=Date:From:To:Subject:From;
        b=MbThk+5n66f3MIvUt7pWhlaZKN9jhn5EIoEONRSL5etm4Ix45jzuc8VMPVja40q/5
         G+biELNUa+RYSGstH1PBepMmpwaRNXl/fN40+0W4qlwxk+ydsYV8yV4yW5p/EVWtAo
         zZGLSlGMXPUmMRKiDaKpGYhlcVrV8KIFIJJOQDoQ=
Date:   Mon, 23 Nov 2020 11:48:02 -0800
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, iamjoonsoo.kim@lge.com, mateusznosek0@gmail.com,
        mm-commits@vger.kernel.org, nigupta@nvidia.com, sh_def@163.com,
        vbabka@suse.cz
Subject:  +
 mm-compaction-make-defer_compaction-and-compaction_deferred-static.patch
 added to -mm tree
Message-ID: <20201123194802.0kmZxKmei%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: make defer_compaction and compaction_deferred static
has been added to the -mm tree.  Its filename is
     mm-compaction-make-defer_compaction-and-compaction_deferred-static.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-make-defer_compaction-and-compaction_deferred-static.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-make-defer_compaction-and-compaction_deferred-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hui Su <sh_def@163.com>
Subject: mm/compaction: make defer_compaction and compaction_deferred static

defer_compaction() and compaction_deferred() and compaction_restarting()
in mm/compaction.c won't be used in other files, so make them static, and
remove the declaration in the header file.

Take the chance to fix a typo.

Link: https://lkml.kernel.org/r/20201123170801.GA9625@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Cc: Nitin Gupta <nigupta@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
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

Patches currently in -mm which might be from sh_def@163.com are

mmslab_common-use-list_for_each_entry-in-dump_unreclaimable_slab.patch
mm-shmemc-make-shmem_mapping-inline.patch
mm-page_counter-use-page_counter_read-in-page_counter_set_max.patch
mm-hugetlbc-just-use-put_page_testzero-instead-of-page_count.patch
mm-compaction-move-compaction_suitables-comment-to-right-place.patch
mm-compaction-make-defer_compaction-and-compaction_deferred-static.patch
mm-oom_kill-change-comment-and-rename-is_dump_unreclaim_slabs.patch
acctc-use-elif-instead-of-end-and-elif.patch
mm-memcontrol-rewrite-mem_cgroup_page_lruvec.patch

