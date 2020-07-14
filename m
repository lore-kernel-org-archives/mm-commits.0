Return-Path: <SRS0=97KN=AZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94226C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 01:00:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76B9C217BA
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 01:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594688409;
	bh=QoyScJ5HIfcd/7eZIOTcyjwIzrnGfSbwZbjOVcDCXrQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=lanzkmLlz0Iv1AkdIbKI0/rMZqKdKnoenqe51s1dYwmS/+yR903rxmoV/wVjr6sqy
	 +q945OM1Bg2M8w1jBGZ28EgivptOGgGuPQjhL+oBTTGo57e2mUfqxtFKd+nTN1sklX
	 YYgPb9uz1zJzVGGdtJsQjLEpoPIkyNpnqtc6kR6k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbgGNBAJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jul 2020 21:00:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726257AbgGNBAJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jul 2020 21:00:09 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE02B21841;
        Tue, 14 Jul 2020 01:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594688408;
        bh=QoyScJ5HIfcd/7eZIOTcyjwIzrnGfSbwZbjOVcDCXrQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=or6mKW6L2+sRycXpomM0z4sj2SpEvlbXkSliLhAMuEg4QG4/HloJXa2pAk7BUWVVG
         E3nPgKtbBPoqt9fhsVlxJ+OaiXfSSlQ3vhAkFa8AfvK+x8eX4TxwcPOKhu9f0RVz6p
         FMeg57Q8imTZPUkIMOIg/p8AH5cGlGDirY0/jrtA=
Date:   Mon, 13 Jul 2020 18:00:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        tj@kernel.org
Subject:  +
 mm-memcg-unify-reclaim-retry-limits-with-page-allocator.patch added to -mm
 tree
Message-ID: <20200714010007.x66lNqH5z%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memcg: unify reclaim retry limits with page allocator
has been added to the -mm tree.  Its filename is
     mm-memcg-unify-reclaim-retry-limits-with-page-allocator.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-unify-reclaim-retry-limits-with-page-allocator.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-unify-reclaim-retry-limits-with-page-allocator.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chris Down <chris@chrisdown.name>
Subject: mm, memcg: unify reclaim retry limits with page allocator

Reclaim retries have been set to 5 since the beginning of time in
commit 66e1707bc346 ("Memory controller: add per cgroup LRU and
reclaim").  However, we now have a generally agreed-upon standard for
page reclaim: MAX_RECLAIM_RETRIES (currently 16), added many years later
in commit 0a0337e0d1d1 ("mm, oom: rework oom detection").

In the absence of a compelling reason to declare an OOM earlier in memcg
context than page allocator context, it seems reasonable to supplant
MEM_CGROUP_RECLAIM_RETRIES with MAX_RECLAIM_RETRIES, making the page
allocator and memcg internals more similar in semantics when reclaim
fails to produce results, avoiding premature OOMs or throttling.

Link: http://lkml.kernel.org/r/da557856c9c7654308eaff4eedc1952a95e8df5f.1594640214.git.chris@chrisdown.name
Signed-off-by: Chris Down <chris@chrisdown.name>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-unify-reclaim-retry-limits-with-page-allocator
+++ a/mm/memcontrol.c
@@ -73,9 +73,6 @@ EXPORT_SYMBOL(memory_cgrp_subsys);
 
 struct mem_cgroup *root_mem_cgroup __read_mostly;
 
-/* The number of times we should retry reclaim failures before giving up. */
-#define MEM_CGROUP_RECLAIM_RETRIES	5
-
 /* Socket memory accounting disabled? */
 static bool cgroup_memory_nosocket;
 
@@ -2540,7 +2537,7 @@ void mem_cgroup_handle_over_high(void)
 	unsigned long pflags;
 	unsigned long nr_reclaimed;
 	unsigned int nr_pages = current->memcg_nr_pages_over_high;
-	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
+	int nr_retries = MAX_RECLAIM_RETRIES;
 	struct mem_cgroup *memcg;
 	bool in_retry = false;
 
@@ -2617,7 +2614,7 @@ static int try_charge(struct mem_cgroup
 		      unsigned int nr_pages)
 {
 	unsigned int batch = max(MEMCG_CHARGE_BATCH, nr_pages);
-	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
+	int nr_retries = MAX_RECLAIM_RETRIES;
 	struct mem_cgroup *mem_over_limit;
 	struct page_counter *counter;
 	unsigned long nr_reclaimed;
@@ -2736,7 +2733,7 @@ retry:
 		       get_order(nr_pages * PAGE_SIZE));
 	switch (oom_status) {
 	case OOM_SUCCESS:
-		nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
+		nr_retries = MAX_RECLAIM_RETRIES;
 		goto retry;
 	case OOM_FAILED:
 		goto force;
@@ -3396,7 +3393,7 @@ static inline bool memcg_has_children(st
  */
 static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
 {
-	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
+	int nr_retries = MAX_RECLAIM_RETRIES;
 
 	/* we call try-to-free pages for make this cgroup empty */
 	lru_add_drain_all();
@@ -6225,7 +6222,7 @@ static ssize_t memory_high_write(struct
 				 char *buf, size_t nbytes, loff_t off)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
-	unsigned int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
+	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
 	bool drained = false;
 	unsigned long high;
 	int err;
@@ -6273,7 +6270,7 @@ static ssize_t memory_max_write(struct k
 				char *buf, size_t nbytes, loff_t off)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
-	unsigned int nr_reclaims = MEM_CGROUP_RECLAIM_RETRIES;
+	unsigned int nr_reclaims = MAX_RECLAIM_RETRIES;
 	bool drained = false;
 	unsigned long max;
 	int err;
_

Patches currently in -mm which might be from chris@chrisdown.name are

tmpfs-per-superblock-i_ino-support.patch
tmpfs-support-64-bit-inums-per-sb.patch
mm-memcg-reclaim-more-aggressively-before-high-allocator-throttling.patch
mm-memcg-unify-reclaim-retry-limits-with-page-allocator.patch

