Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2A9BC6FA99
	for <mm-commits@archiver.kernel.org>; Tue,  7 Mar 2023 22:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbjCGW1F (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Mar 2023 17:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbjCGW0i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Mar 2023 17:26:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C60E6AF77E
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 14:26:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 626BEB81A88
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 22:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224C8C433EF;
        Tue,  7 Mar 2023 22:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678227922;
        bh=f5SPUBi+aOvKDISElkqZ2wWbXT5DUM9rZHI0wbnhnc4=;
        h=Date:To:From:Subject:From;
        b=ladOsKgpCB+1vMnv71MI3f+Eq/m85IKe6uPO1dk/dkd4OdHYQYeH5QY9hrWxRCdlx
         0DLiSpQQDz+Bt2TLUFcfAdTZNm9wWV+hTs0RktN/Mio7fZV50807fMWmDzz5CAwSNi
         PQo7hTk2iTzuW4ikywWTEzIrZF2WqmOS/gdPXKnI=
Date:   Tue, 07 Mar 2023 14:25:21 -0800
To:     mm-commits@vger.kernel.org, tkhai@ya.ru, shy828301@gmail.com,
        shakeelb@google.com, rppt@kernel.org, roman.gushchin@linux.dev,
        paulmck@kernel.org, muchun.song@linux.dev, mhocko@kernel.org,
        hannes@cmpxchg.org, david@redhat.com, dave@stgolabs.net,
        zhengqi.arch@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-make-global-slab-shrink-lockless.patch added to mm-unstable branch
Message-Id: <20230307222522.224C8C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: make global slab shrink lockless
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-make-global-slab-shrink-lockless.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-make-global-slab-shrink-lockless.patch

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
Subject: mm: vmscan: make global slab shrink lockless
Date: Tue, 7 Mar 2023 14:55:59 +0800

The shrinker_rwsem is a global read-write lock in shrinkers subsystem,
which protects most operations such as slab shrink, registration and
unregistration of shrinkers, etc.  This can easily cause problems in the
following cases.

1) When the memory pressure is high and there are many filesystems
   mounted or unmounted at the same time, slab shrink will be affected
   (down_read_trylock() failed).

   Such as the real workload mentioned by Kirill Tkhai:

   ```
   One of the real workloads from my experience is start of an
   overcommitted node containing many starting containers after node crash
   (or many resuming containers after reboot for kernel update).  In these
   cases memory pressure is huge, and the node goes round in long reclaim.
   ```

2) If a shrinker is blocked (such as the case mentioned in [1]) and a
   writer comes in (such as mount a fs), then this writer will be blocked
   and cause all subsequent shrinker-related operations to be blocked.

Even if there is no competitor when shrinking slab, there may still be a
problem.  If we have a long shrinker list and we do not reclaim enough
memory with each shrinker, then the down_read_trylock() may be called with
high frequency.  Because of the poor multicore scalability of atomic
operations, this can lead to a significant drop in IPC (instructions per
cycle).

So many times in history ([2],[3],[4],[5]), some people wanted to replace
shrinker_rwsem trylock with SRCU in the slab shrink, but all these patches
were abandoned because SRCU was not unconditionally enabled.

But now, since commit 1cd0bd06093c ("rcu: Remove CONFIG_SRCU"), the SRCU
is unconditionally enabled.  So it's time to use SRCU to protect readers
who previously held shrinker_rwsem.

This commit uses SRCU to make global slab shrink lockless, the memcg slab
shrink is handled in the subsequent patch.

[1]. https://lore.kernel.org/lkml/20191129214541.3110-1-ptikhomirov@virtuozzo.com/
[2]. https://lore.kernel.org/all/1437080113.3596.2.camel@stgolabs.net/
[3]. https://lore.kernel.org/lkml/1510609063-3327-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp/
[4]. https://lore.kernel.org/lkml/153365347929.19074.12509495712735843805.stgit@localhost.localdomain/
[5]. https://lore.kernel.org/lkml/20210927074823.5825-1-sultan@kerneltoast.com/

Link: https://lkml.kernel.org/r/20230307065605.58209-3-zhengqi.arch@bytedance.com
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
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-make-global-slab-shrink-lockless
+++ a/mm/vmscan.c
@@ -202,6 +202,7 @@ static void set_task_reclaim_state(struc
 
 LIST_HEAD(shrinker_list);
 DECLARE_RWSEM(shrinker_rwsem);
+DEFINE_SRCU(shrinker_srcu);
 
 #ifdef CONFIG_MEMCG
 static int shrinker_nr_max;
@@ -706,7 +707,7 @@ void free_prealloced_shrinker(struct shr
 void register_shrinker_prepared(struct shrinker *shrinker)
 {
 	down_write(&shrinker_rwsem);
-	list_add_tail(&shrinker->list, &shrinker_list);
+	list_add_tail_rcu(&shrinker->list, &shrinker_list);
 	shrinker->flags |= SHRINKER_REGISTERED;
 	shrinker_debugfs_add(shrinker);
 	up_write(&shrinker_rwsem);
@@ -760,13 +761,15 @@ void unregister_shrinker(struct shrinker
 		return;
 
 	down_write(&shrinker_rwsem);
-	list_del(&shrinker->list);
+	list_del_rcu(&shrinker->list);
 	shrinker->flags &= ~SHRINKER_REGISTERED;
 	if (shrinker->flags & SHRINKER_MEMCG_AWARE)
 		unregister_memcg_shrinker(shrinker);
 	debugfs_entry = shrinker_debugfs_remove(shrinker);
 	up_write(&shrinker_rwsem);
 
+	synchronize_srcu(&shrinker_srcu);
+
 	debugfs_remove_recursive(debugfs_entry);
 
 	kfree(shrinker->nr_deferred);
@@ -786,6 +789,7 @@ void synchronize_shrinkers(void)
 {
 	down_write(&shrinker_rwsem);
 	up_write(&shrinker_rwsem);
+	synchronize_srcu(&shrinker_srcu);
 }
 EXPORT_SYMBOL(synchronize_shrinkers);
 
@@ -996,6 +1000,7 @@ static unsigned long shrink_slab(gfp_t g
 {
 	unsigned long ret, freed = 0;
 	struct shrinker *shrinker;
+	int srcu_idx;
 
 	/*
 	 * The root memcg might be allocated even though memcg is disabled
@@ -1007,10 +1012,10 @@ static unsigned long shrink_slab(gfp_t g
 	if (!mem_cgroup_disabled() && !mem_cgroup_is_root(memcg))
 		return shrink_slab_memcg(gfp_mask, nid, memcg, priority);
 
-	if (!down_read_trylock(&shrinker_rwsem))
-		goto out;
+	srcu_idx = srcu_read_lock(&shrinker_srcu);
 
-	list_for_each_entry(shrinker, &shrinker_list, list) {
+	list_for_each_entry_srcu(shrinker, &shrinker_list, list,
+				 srcu_read_lock_held(&shrinker_srcu)) {
 		struct shrink_control sc = {
 			.gfp_mask = gfp_mask,
 			.nid = nid,
@@ -1021,19 +1026,9 @@ static unsigned long shrink_slab(gfp_t g
 		if (ret == SHRINK_EMPTY)
 			ret = 0;
 		freed += ret;
-		/*
-		 * Bail out if someone want to register a new shrinker to
-		 * prevent the registration from being stalled for long periods
-		 * by parallel ongoing shrinking.
-		 */
-		if (rwsem_is_contended(&shrinker_rwsem)) {
-			freed = freed ? : 1;
-			break;
-		}
 	}
 
-	up_read(&shrinker_rwsem);
-out:
+	srcu_read_unlock(&shrinker_srcu, srcu_idx);
 	cond_resched();
 	return freed;
 }
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-vmscan-add-a-map_nr_max-field-to-shrinker_info.patch
mm-vmscan-make-global-slab-shrink-lockless.patch
mm-vmscan-make-memcg-slab-shrink-lockless.patch
mm-shrinkers-make-count-and-scan-in-shrinker-debugfs-lockless.patch
mm-vmscan-hold-write-lock-to-reparent-shrinker-nr_deferred.patch
mm-vmscan-remove-shrinker_rwsem-from-synchronize_shrinkers.patch
mm-shrinkers-convert-shrinker_rwsem-to-mutex.patch

