Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3487C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 20:38:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9B6364F8F
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 20:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhCKUho (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Mar 2021 15:37:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:53232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229607AbhCKUhN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Mar 2021 15:37:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 660B264F87;
        Thu, 11 Mar 2021 20:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615495032;
        bh=RbQeAiFfpFTE43/NWyPq9hGusC4knu7sAZtmjOoREl4=;
        h=Date:From:To:Subject:From;
        b=B0zOKX13EC1hvX3Wg5gtS0qD6ssGziV1g/MWLc+skbk+UheFQl8FjB4B7lsAIv+a3
         /tyMZtXh+wD4P44ccNYdsRpKvMCfi1axbleohhbYwzrz3I4hBqMbZ88Q4c7dpjkogH
         ON991KQNdvf3l7qocMBDqVWwwYMSTggmDCePZ0wo=
Date:   Thu, 11 Mar 2021 12:37:11 -0800
From:   akpm@linux-foundation.org
To:     david@fromorbit.com, guro@fb.com, hannes@cmpxchg.org,
        ktkhai@virtuozzo.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, shy828301@gmail.com, vbabka@suse.cz
Subject:  +
 mm-vmscan-use-nid-from-shrink_control-for-tracepoint.patch added to -mm
 tree
Message-ID: <20210311203711.ps65dLl32%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: use nid from shrink_control for tracepoint
has been added to the -mm tree.  Its filename is
     mm-vmscan-use-nid-from-shrink_control-for-tracepoint.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-use-nid-from-shrink_control-for-tracepoint.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-use-nid-from-shrink_control-for-tracepoint.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: vmscan: use nid from shrink_control for tracepoint

Patch series "Make shrinker's nr_deferred memcg aware", v10.

Recently huge amount one-off slab drop was seen on some vfs metadata heavy
workloads, it turned out there were huge amount accumulated nr_deferred
objects seen by the shrinker.

On our production machine, I saw absurd number of nr_deferred shown as the
below tracing result: 

<...>-48776 [032] .... 27970562.458916: mm_shrink_slab_start:
super_cache_scan+0x0/0x1a0 ffff9a83046f3458: nid: 0 objects to shrink
2531805877005 gfp_flags GFP_HIGHUSER_MOVABLE pgs_scanned 32 lru_pgs
9300 cache items 1667 delta 11 total_scan 833

There are 2.5 trillion deferred objects on one node, assuming all of them
are dentry (192 bytes per object), so the total size of deferred on one
node is ~480TB.  It is definitely ridiculous.

I managed to reproduce this problem with kernel build workload plus
negative dentry generator.

First step, run the below kernel build test script:

NR_CPUS=`cat /proc/cpuinfo | grep -e processor | wc -l`

cd /root/Buildarea/linux-stable

for i in `seq 1500`; do
        cgcreate -g memory:kern_build
        echo 4G > /sys/fs/cgroup/memory/kern_build/memory.limit_in_bytes

        echo 3 > /proc/sys/vm/drop_caches
        cgexec -g memory:kern_build make clean > /dev/null 2>&1
        cgexec -g memory:kern_build make -j$NR_CPUS > /dev/null 2>&1

        cgdelete -g memory:kern_build
done

Then run the below negative dentry generator script:

NR_CPUS=`cat /proc/cpuinfo | grep -e processor | wc -l`

mkdir /sys/fs/cgroup/memory/test
echo $$ > /sys/fs/cgroup/memory/test/tasks

for i in `seq $NR_CPUS`; do
        while true; do
                FILE=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 64`
                cat $FILE 2>/dev/null
        done &
done

Then kswapd will shrink half of dentry cache in just one loop as the below
tracing result showed:

	kswapd0-475   [028] .... 305968.252561: mm_shrink_slab_start: super_cache_scan+0x0/0x190 0000000024acf00c: nid: 0
objects to shrink 4994376020 gfp_flags GFP_KERNEL cache items 93689873 delta 45746 total_scan 46844936 priority 12
	kswapd0-475   [021] .... 306013.099399: mm_shrink_slab_end: super_cache_scan+0x0/0x190 0000000024acf00c: nid: 0 unused
scan count 4994376020 new scan count 4947576838 total_scan 8 last shrinker return val 46844928

There were huge number of deferred objects before the shrinker was called,
the behavior does match the code but it might be not desirable from the
user's stand of point.

The excessive amount of nr_deferred might be accumulated due to various
reasons, for example:

* GFP_NOFS allocation

* Significant times of small amount scan (< scan_batch, 1024 for vfs
  metadata)

However the LRUs of slabs are per memcg (memcg-aware shrinkers) but the
deferred objects is per shrinker, this may have some bad effects:

* Poor isolation among memcgs.  Some memcgs which happen to have
  frequent limit reclaim may get nr_deferred accumulated to a huge number,
  then other innocent memcgs may take the fall.  In our case the main
  workload was hit.

* Unbounded deferred objects.  There is no cap for deferred objects, it
  can outgrow ridiculously as the tracing result showed.

* Easy to get out of control.  Although shrinkers take into account
  deferred objects, but it can go out of control easily.  One
  misconfigured memcg could incur absurd amount of deferred objects in a
  period of time.

* Sort of reclaim problems, i.e.  over reclaim, long reclaim latency,
  etc.  There may be hundred GB slab caches for vfe metadata heavy
  workload, shrink half of them may take minutes.  We observed latency
  spike due to the prolonged reclaim.

These issues also have been discussed in
https://lore.kernel.org/linux-mm/20200916185823.5347-1-shy828301@gmail.com/.
The patchset is the outcome of that discussion.

So this patchset makes nr_deferred per-memcg to tackle the problem.  It
does:

* Have memcg_shrinker_deferred per memcg per node, just like what
  shrinker_map does.  Instead it is an atomic_long_t array, each element
  represent one shrinker even though the shrinker is not memcg aware, this
  simplifies the implementation.  For memcg aware shrinkers, the deferred
  objects are just accumulated to its own memcg.  The shrinkers just see
  nr_deferred from its own memcg.  Non memcg aware shrinkers still use
  global nr_deferred from struct shrinker.

* Once the memcg is offlined, its nr_deferred will be reparented to its
  parent along with LRUs.

* The root memcg has memcg_shrinker_deferred array too.  It simplifies
  the handling of reparenting to root memcg.

* Cap nr_deferred to 2x of the length of lru.  The idea is borrowed from
  Dave Chinner's series
  (https://lore.kernel.org/linux-xfs/20191031234618.15403-1-david@fromorbit.com/)

The downside is each memcg has to allocate extra memory to store the
nr_deferred array.  On our production environment, there are typically
around 40 shrinkers, so each memcg needs ~320 bytes.  10K memcgs would
need ~3.2MB memory.  It seems fine.

We have been running the patched kernel on some hosts of our fleet (test
and production) for months, it works very well.  The monitor data shows
the working set is sustained as expected.


This patch (of 13):

The tracepoint's nid should show what node the shrink happens on, the
start tracepoint uses nid from shrinkctl, but the nid might be set to 0
before end tracepoint if the shrinker is not NUMA aware, so the tracing
log may show the shrink happens on one node but end up on the other node. 
It seems confusing.  And the following patch will remove using nid
directly in do_shrink_slab(), this patch also helps cleanup the code.

Link: https://lkml.kernel.org/r/20210311190845.9708-1-shy828301@gmail.com
Link: https://lkml.kernel.org/r/20210311190845.9708-2-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-use-nid-from-shrink_control-for-tracepoint
+++ a/mm/vmscan.c
@@ -536,7 +536,7 @@ static unsigned long do_shrink_slab(stru
 	else
 		new_nr = atomic_long_read(&shrinker->nr_deferred[nid]);
 
-	trace_mm_shrink_slab_end(shrinker, nid, freed, nr, new_nr, total_scan);
+	trace_mm_shrink_slab_end(shrinker, shrinkctl->nid, freed, nr, new_nr, total_scan);
 	return freed;
 }
 
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-vmscan-use-nid-from-shrink_control-for-tracepoint.patch
mm-vmscan-consolidate-shrinker_maps-handling-code.patch
mm-vmscan-use-shrinker_rwsem-to-protect-shrinker_maps-allocation.patch
mm-vmscan-remove-memcg_shrinker_map_size.patch
mm-vmscan-use-kvfree_rcu-instead-of-call_rcu.patch
mm-memcontrol-rename-shrinker_map-to-shrinker_info.patch
mm-vmscan-add-shrinker_info_protected-helper.patch
mm-vmscan-use-a-new-flag-to-indicate-shrinker-is-registered.patch
mm-vmscan-add-per-memcg-shrinker-nr_deferred.patch
mm-vmscan-use-per-memcg-nr_deferred-of-shrinker.patch
mm-vmscan-dont-need-allocate-shrinker-nr_deferred-for-memcg-aware-shrinkers.patch
mm-memcontrol-reparent-nr_deferred-when-memcg-offline.patch
mm-vmscan-shrink-deferred-objects-proportional-to-priority.patch

