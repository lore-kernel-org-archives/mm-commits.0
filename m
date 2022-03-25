Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0F3EC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357376AbiCYBdp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357443AbiCYBdM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B04BF03A
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFEF7B82725
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD7AC340EC;
        Fri, 25 Mar 2022 01:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171870;
        bh=KFcKFc7VRIladPvJwmqFPbozlnRf3IoC0piwOhjkddg=;
        h=Date:To:From:Subject:From;
        b=HXzybvrHeT+u72EAU+IhJbBWenk6OL7E8vof9F7TvzcBLhnLSxtIeV6g2AP6sCIqm
         fkJzciZmWjvRQDN+sT56ZJbeLSonFmc7wFs3WaeetFIdZGXKP9iqBvMUJi6hnuTDHB
         LaoDpofoM7IwS9mGEc1l+qY6wgKgNwX9TJvMA22o=
Date:   Thu, 24 Mar 2022 18:31:09 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vvs@virtuozzo.com,
        uladzislau.rezki@sony.com, oleksiy.avramchenko@sonymobile.com,
        npiggin@gmail.com, hch@lst.de, urezki@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-vmalloc-move-draining-areas-out-of-caller-context.patch removed from -mm tree
Message-Id: <20220325013110.8DD7AC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: Move draining areas out of caller context
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-move-draining-areas-out-of-caller-context.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: Move draining areas out of caller context

A caller initiates the drain procces from its context once the
drain threshold is reached or passed. There are at least two
drawbacks of doing so:

a) a caller can be a high-prio or RT task. In that case it can
   stuck in doing the actual drain of all lazily freed areas.
   This is not optimal because such tasks usually are latency
   sensitive where the control should be returned back as soon
   as possible in order to drive such workloads in time. See
   96e2db456135 ("mm/vmalloc: rework the drain logic")

b) It is not safe to call vfree() during holding a spinlock due
   to the vmap_purge_lock mutex. The was a report about this from
   Zeal Robot <zealci@zte.com.cn> here:
   https://lore.kernel.org/all/20211222081026.484058-1-chi.minghao@zte.com.cn

Moving the drain to the separate work context addresses those
issues.

v1->v2:
   - Added prefix "_work" to the drain worker function.
v2->v3:
   - Remove the drain_vmap_work_in_progress. Extra queuing
     is expectable under heavy load but it can be disregarded
     because a work will bail out if nothing to be done.

Link: https://lkml.kernel.org/r/20220131144058.35608-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>
Cc: Uladzislau Rezki <uladzislau.rezki@sony.com>
Cc: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-move-draining-areas-out-of-caller-context
+++ a/mm/vmalloc.c
@@ -791,6 +791,8 @@ RB_DECLARE_CALLBACKS_MAX(static, free_vm
 
 static void purge_vmap_area_lazy(void);
 static BLOCKING_NOTIFIER_HEAD(vmap_notify_list);
+static void drain_vmap_area_work(struct work_struct *work);
+static DECLARE_WORK(drain_vmap_work, drain_vmap_area_work);
 
 static atomic_long_t nr_vmalloc_pages;
 
@@ -1718,18 +1720,6 @@ static bool __purge_vmap_area_lazy(unsig
 }
 
 /*
- * Kick off a purge of the outstanding lazy areas. Don't bother if somebody
- * is already purging.
- */
-static void try_purge_vmap_area_lazy(void)
-{
-	if (mutex_trylock(&vmap_purge_lock)) {
-		__purge_vmap_area_lazy(ULONG_MAX, 0);
-		mutex_unlock(&vmap_purge_lock);
-	}
-}
-
-/*
  * Kick off a purge of the outstanding lazy areas.
  */
 static void purge_vmap_area_lazy(void)
@@ -1740,6 +1730,20 @@ static void purge_vmap_area_lazy(void)
 	mutex_unlock(&vmap_purge_lock);
 }
 
+static void drain_vmap_area_work(struct work_struct *work)
+{
+	unsigned long nr_lazy;
+
+	do {
+		mutex_lock(&vmap_purge_lock);
+		__purge_vmap_area_lazy(ULONG_MAX, 0);
+		mutex_unlock(&vmap_purge_lock);
+
+		/* Recheck if further work is required. */
+		nr_lazy = atomic_long_read(&vmap_lazy_nr);
+	} while (nr_lazy > lazy_max_pages());
+}
+
 /*
  * Free a vmap area, caller ensuring that the area has been unmapped
  * and flush_cache_vunmap had been called for the correct range
@@ -1766,7 +1770,7 @@ static void free_vmap_area_noflush(struc
 
 	/* After this point, we may free va at any time */
 	if (unlikely(nr_lazy > lazy_max_pages()))
-		try_purge_vmap_area_lazy();
+		schedule_work(&drain_vmap_work);
 }
 
 /*
_

Patches currently in -mm which might be from urezki@gmail.com are


