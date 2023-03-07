Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6AB2C6FA99
	for <mm-commits@archiver.kernel.org>; Tue,  7 Mar 2023 22:27:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjCGW1q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Mar 2023 17:27:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbjCGW1O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Mar 2023 17:27:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D211B06FA
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 14:26:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BA5AB81A99
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 22:25:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEAD6C433D2;
        Tue,  7 Mar 2023 22:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678227929;
        bh=GTJllmmXfJP73EcwSZadw2GDWsDvTeWqTkThrXf54KE=;
        h=Date:To:From:Subject:From;
        b=wDhuazDtVXqL4E27hYjp29dnvPvwac+brWiRfIlks+RU1raqqCtevPABgI9j/EqXf
         2Gi4bvTKj1HgrwvkAUW9+xM9O4kDnguvPq68MwlyuS/HfDataPBe9rSioalAuNq5An
         bfu9zsBKXfvUBEDetq8l9aX7Vne4jpUIlHemHRGU=
Date:   Tue, 07 Mar 2023 14:25:28 -0800
To:     mm-commits@vger.kernel.org, tkhai@ya.ru, sultan@kerneltoast.com,
        shy828301@gmail.com, shakeelb@google.com, rppt@kernel.org,
        roman.gushchin@linux.dev, penguin-kernel@i-love.sakura.ne.jp,
        paulmck@kernel.org, muchun.song@linux.dev, mhocko@kernel.org,
        hannes@cmpxchg.org, david@redhat.com, dave@stgolabs.net,
        zhengqi.arch@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shrinkers-make-count-and-scan-in-shrinker-debugfs-lockless.patch added to mm-unstable branch
Message-Id: <20230307222528.DEAD6C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: shrinkers: make count and scan in shrinker debugfs lockless
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shrinkers-make-count-and-scan-in-shrinker-debugfs-lockless.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinkers-make-count-and-scan-in-shrinker-debugfs-lockless.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: shrinkers: make count and scan in shrinker debugfs lockless
Date: Tue, 7 Mar 2023 14:56:02 +0800

Like global and memcg slab shrink, also use SRCU to make count and scan
operations in memory shrinker debugfs lockless.

Link: https://lkml.kernel.org/r/20230307065605.58209-6-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill Tkhai <tkhai@ya.ru>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Sultan Alsawaf <sultan@kerneltoast.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shrinker_debug.c |   24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

--- a/mm/shrinker_debug.c~mm-shrinkers-make-count-and-scan-in-shrinker-debugfs-lockless
+++ a/mm/shrinker_debug.c
@@ -9,6 +9,7 @@
 /* defined in vmscan.c */
 extern struct rw_semaphore shrinker_rwsem;
 extern struct list_head shrinker_list;
+extern struct srcu_struct shrinker_srcu;
 
 static DEFINE_IDA(shrinker_debugfs_ida);
 static struct dentry *shrinker_debugfs_root;
@@ -49,18 +50,13 @@ static int shrinker_debugfs_count_show(s
 	struct mem_cgroup *memcg;
 	unsigned long total;
 	bool memcg_aware;
-	int ret, nid;
+	int ret = 0, nid, srcu_idx;
 
 	count_per_node = kcalloc(nr_node_ids, sizeof(unsigned long), GFP_KERNEL);
 	if (!count_per_node)
 		return -ENOMEM;
 
-	ret = down_read_killable(&shrinker_rwsem);
-	if (ret) {
-		kfree(count_per_node);
-		return ret;
-	}
-	rcu_read_lock();
+	srcu_idx = srcu_read_lock(&shrinker_srcu);
 
 	memcg_aware = shrinker->flags & SHRINKER_MEMCG_AWARE;
 
@@ -91,8 +87,7 @@ static int shrinker_debugfs_count_show(s
 		}
 	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
 
-	rcu_read_unlock();
-	up_read(&shrinker_rwsem);
+	srcu_read_unlock(&shrinker_srcu, srcu_idx);
 
 	kfree(count_per_node);
 	return ret;
@@ -115,9 +110,8 @@ static ssize_t shrinker_debugfs_scan_wri
 		.gfp_mask = GFP_KERNEL,
 	};
 	struct mem_cgroup *memcg = NULL;
-	int nid;
+	int nid, srcu_idx;
 	char kbuf[72];
-	ssize_t ret;
 
 	read_len = size < (sizeof(kbuf) - 1) ? size : (sizeof(kbuf) - 1);
 	if (copy_from_user(kbuf, buf, read_len))
@@ -146,11 +140,7 @@ static ssize_t shrinker_debugfs_scan_wri
 		return -EINVAL;
 	}
 
-	ret = down_read_killable(&shrinker_rwsem);
-	if (ret) {
-		mem_cgroup_put(memcg);
-		return ret;
-	}
+	srcu_idx = srcu_read_lock(&shrinker_srcu);
 
 	sc.nid = nid;
 	sc.memcg = memcg;
@@ -159,7 +149,7 @@ static ssize_t shrinker_debugfs_scan_wri
 
 	shrinker->scan_objects(shrinker, &sc);
 
-	up_read(&shrinker_rwsem);
+	srcu_read_unlock(&shrinker_srcu, srcu_idx);
 	mem_cgroup_put(memcg);
 
 	return size;
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-vmscan-add-a-map_nr_max-field-to-shrinker_info.patch
mm-vmscan-make-global-slab-shrink-lockless.patch
mm-vmscan-make-memcg-slab-shrink-lockless.patch
mm-shrinkers-make-count-and-scan-in-shrinker-debugfs-lockless.patch
mm-vmscan-hold-write-lock-to-reparent-shrinker-nr_deferred.patch
mm-vmscan-remove-shrinker_rwsem-from-synchronize_shrinkers.patch
mm-shrinkers-convert-shrinker_rwsem-to-mutex.patch

