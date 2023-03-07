Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC9EDC742A7
	for <mm-commits@archiver.kernel.org>; Tue,  7 Mar 2023 22:26:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjCGW0U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Mar 2023 17:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjCGW0O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Mar 2023 17:26:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 342439BA49
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 14:25:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4498B81A40
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 22:25:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92975C433EF;
        Tue,  7 Mar 2023 22:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678227924;
        bh=nI8cQunnHVT+AX01AN/J4VhzofzKk2fSwpJg4VSxsAE=;
        h=Date:To:From:Subject:From;
        b=JX5AkKqY7GJsvUCDNr/uDqIvRMLlyLzhwMdbVu6FA5yCCLiqWZ0+A+1gTpxHUts7l
         iV2O0xNaSjNcfj688JzIrrg8PUwKxGVId+tC3egmpbEVuJHuxiGCC0FKD9Q8jgChgA
         Ioh5Jjgi89BB6t173FiCcc4sJl2qswz1d3V5zWyM=
Date:   Tue, 07 Mar 2023 14:25:24 -0800
To:     mm-commits@vger.kernel.org, tkhai@ya.ru, sultan@kerneltoast.com,
        shy828301@gmail.com, shakeelb@google.com, rppt@kernel.org,
        roman.gushchin@linux.dev, penguin-kernel@i-love.sakura.ne.jp,
        paulmck@kernel.org, muchun.song@linux.dev, mhocko@kernel.org,
        hannes@cmpxchg.org, david@redhat.com, dave@stgolabs.net,
        zhengqi.arch@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-make-memcg-slab-shrink-lockless.patch added to mm-unstable branch
Message-Id: <20230307222524.92975C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: make memcg slab shrink lockless
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-make-memcg-slab-shrink-lockless.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-make-memcg-slab-shrink-lockless.patch

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
Subject: mm: vmscan: make memcg slab shrink lockless
Date: Tue, 7 Mar 2023 14:56:00 +0800

Like global slab shrink, this commit also uses SRCU to make memcg slab
shrink lockless.

We can reproduce the down_read_trylock() hotspot through the following
script:

```

DIR="/root/shrinker/memcg/mnt"

do_create()
{
    mkdir -p /sys/fs/cgroup/memory/test
    mkdir -p /sys/fs/cgroup/perf_event/test
    echo 4G > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
    for i in `seq 0 $1`;
    do
        mkdir -p /sys/fs/cgroup/memory/test/$i;
        echo $$ > /sys/fs/cgroup/memory/test/$i/cgroup.procs;
        echo $$ > /sys/fs/cgroup/perf_event/test/cgroup.procs;
        mkdir -p $DIR/$i;
    done
}

do_mount()
{
    for i in `seq $1 $2`;
    do
        mount -t tmpfs $i $DIR/$i;
    done
}

do_touch()
{
    for i in `seq $1 $2`;
    do
        echo $$ > /sys/fs/cgroup/memory/test/$i/cgroup.procs;
        echo $$ > /sys/fs/cgroup/perf_event/test/cgroup.procs;
            dd if=/dev/zero of=$DIR/$i/file$i bs=1M count=1 &
    done
}

case "$1" in
  touch)
    do_touch $2 $3
    ;;
  test)
      do_create 4000
    do_mount 0 4000
    do_touch 0 3000
    ;;
  *)
    exit 1
    ;;
esac
```

Save the above script, then run test and touch commands.
Then we can use the following perf command to view hotspots:

perf top -U -F 999

1) Before applying this patchset:

  32.31%  [kernel]           [k] down_read_trylock
  19.40%  [kernel]           [k] pv_native_safe_halt
  16.24%  [kernel]           [k] up_read
  15.70%  [kernel]           [k] shrink_slab
   4.69%  [kernel]           [k] _find_next_bit
   2.62%  [kernel]           [k] shrink_node
   1.78%  [kernel]           [k] shrink_lruvec
   0.76%  [kernel]           [k] do_shrink_slab

2) After applying this patchset:

  27.83%  [kernel]           [k] _find_next_bit
  16.97%  [kernel]           [k] shrink_slab
  15.82%  [kernel]           [k] pv_native_safe_halt
   9.58%  [kernel]           [k] shrink_node
   8.31%  [kernel]           [k] shrink_lruvec
   5.64%  [kernel]           [k] do_shrink_slab
   3.88%  [kernel]           [k] mem_cgroup_iter

At the same time, we use the following perf command to capture
IPC information:

perf stat -e cycles,instructions -G test -a --repeat 5 -- sleep 10

1) Before applying this patchset:

 Performance counter stats for 'system wide' (5 runs):

      454187219766      cycles                    test                    ( +-  1.84% )
       78896433101      instructions              test #    0.17  insn per cycle           ( +-  0.44% )

        10.0020430 +- 0.0000366 seconds time elapsed  ( +-  0.00% )

2) After applying this patchset:

 Performance counter stats for 'system wide' (5 runs):

      841954709443      cycles                    test                    ( +- 15.80% )  (98.69%)
      527258677936      instructions              test #    0.63  insn per cycle           ( +- 15.11% )  (98.68%)

          10.01064 +- 0.00831 seconds time elapsed  ( +-  0.08% )

We can see that IPC drops very seriously when calling down_read_trylock()
at high frequency.  After using SRCU, the IPC is at a normal level.

Link: https://lkml.kernel.org/r/20230307065605.58209-4-zhengqi.arch@bytedance.com
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

 mm/vmscan.c |   46 +++++++++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 19 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-make-memcg-slab-shrink-lockless
+++ a/mm/vmscan.c
@@ -57,6 +57,7 @@
 #include <linux/khugepaged.h>
 #include <linux/rculist_nulls.h>
 #include <linux/random.h>
+#include <linux/srcu.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -221,8 +222,21 @@ static inline int shrinker_defer_size(in
 static struct shrinker_info *shrinker_info_protected(struct mem_cgroup *memcg,
 						     int nid)
 {
-	return rcu_dereference_protected(memcg->nodeinfo[nid]->shrinker_info,
-					 lockdep_is_held(&shrinker_rwsem));
+	return srcu_dereference_check(memcg->nodeinfo[nid]->shrinker_info,
+				      &shrinker_srcu,
+				      lockdep_is_held(&shrinker_rwsem));
+}
+
+static struct shrinker_info *shrinker_info_srcu(struct mem_cgroup *memcg,
+						     int nid)
+{
+	return srcu_dereference(memcg->nodeinfo[nid]->shrinker_info,
+				&shrinker_srcu);
+}
+
+static void free_shrinker_info_rcu(struct rcu_head *head)
+{
+	kvfree(container_of(head, struct shrinker_info, rcu));
 }
 
 static inline bool need_expand(int new_nr_max, int old_nr_max)
@@ -269,7 +283,7 @@ static int expand_one_shrinker_info(stru
 		       defer_size - old_defer_size);
 
 		rcu_assign_pointer(pn->shrinker_info, new);
-		kvfree_rcu(old, rcu);
+		call_srcu(&shrinker_srcu, &old->rcu, free_shrinker_info_rcu);
 	}
 
 	return 0;
@@ -355,15 +369,16 @@ void set_shrinker_bit(struct mem_cgroup
 {
 	if (shrinker_id >= 0 && memcg && !mem_cgroup_is_root(memcg)) {
 		struct shrinker_info *info;
+		int srcu_idx;
 
-		rcu_read_lock();
-		info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
+		srcu_idx = srcu_read_lock(&shrinker_srcu);
+		info = shrinker_info_srcu(memcg, nid);
 		if (!WARN_ON_ONCE(shrinker_id >= info->map_nr_max)) {
 			/* Pairs with smp mb in shrink_slab() */
 			smp_mb__before_atomic();
 			set_bit(shrinker_id, info->map);
 		}
-		rcu_read_unlock();
+		srcu_read_unlock(&shrinker_srcu, srcu_idx);
 	}
 }
 
@@ -377,7 +392,6 @@ static int prealloc_memcg_shrinker(struc
 		return -ENOSYS;
 
 	down_write(&shrinker_rwsem);
-	/* This may call shrinker, so it must use down_read_trylock() */
 	id = idr_alloc(&shrinker_idr, shrinker, 0, 0, GFP_KERNEL);
 	if (id < 0)
 		goto unlock;
@@ -411,7 +425,7 @@ static long xchg_nr_deferred_memcg(int n
 {
 	struct shrinker_info *info;
 
-	info = shrinker_info_protected(memcg, nid);
+	info = shrinker_info_srcu(memcg, nid);
 	return atomic_long_xchg(&info->nr_deferred[shrinker->id], 0);
 }
 
@@ -420,7 +434,7 @@ static long add_nr_deferred_memcg(long n
 {
 	struct shrinker_info *info;
 
-	info = shrinker_info_protected(memcg, nid);
+	info = shrinker_info_srcu(memcg, nid);
 	return atomic_long_add_return(nr, &info->nr_deferred[shrinker->id]);
 }
 
@@ -898,15 +912,14 @@ static unsigned long shrink_slab_memcg(g
 {
 	struct shrinker_info *info;
 	unsigned long ret, freed = 0;
+	int srcu_idx;
 	int i;
 
 	if (!mem_cgroup_online(memcg))
 		return 0;
 
-	if (!down_read_trylock(&shrinker_rwsem))
-		return 0;
-
-	info = shrinker_info_protected(memcg, nid);
+	srcu_idx = srcu_read_lock(&shrinker_srcu);
+	info = shrinker_info_srcu(memcg, nid);
 	if (unlikely(!info))
 		goto unlock;
 
@@ -956,14 +969,9 @@ static unsigned long shrink_slab_memcg(g
 				set_shrinker_bit(memcg, nid, i);
 		}
 		freed += ret;
-
-		if (rwsem_is_contended(&shrinker_rwsem)) {
-			freed = freed ? : 1;
-			break;
-		}
 	}
 unlock:
-	up_read(&shrinker_rwsem);
+	srcu_read_unlock(&shrinker_srcu, srcu_idx);
 	return freed;
 }
 #else /* CONFIG_MEMCG */
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-vmscan-add-a-map_nr_max-field-to-shrinker_info.patch
mm-vmscan-make-global-slab-shrink-lockless.patch
mm-vmscan-make-memcg-slab-shrink-lockless.patch
mm-shrinkers-make-count-and-scan-in-shrinker-debugfs-lockless.patch
mm-vmscan-hold-write-lock-to-reparent-shrinker-nr_deferred.patch
mm-vmscan-remove-shrinker_rwsem-from-synchronize_shrinkers.patch
mm-shrinkers-convert-shrinker_rwsem-to-mutex.patch

