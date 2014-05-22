From: akpm@linux-foundation.org
Subject: +
 fs-superblock-avoid-locking-counting-inodes-and-dentries-before-reclaiming-them.patch added to -mm tree
Date: Thu, 22 May 2014 11:05:18 -0700
Message-ID: <537e3c5e.X0Px0bysms1Ewle3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58902 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaEVSFT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 May 2014 14:05:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yuanhan.liu@linux.intel.com, viro@zeniv.linux.org.uk, riel@redhat.com, mgorman@suse.de, jack@suse.cz, hughd@google.com, hannes@cmpxchg.org, david@fromorbit.com, bob.liu@oracle.com, tim.c.chen@linux.intel.com

Subject: + fs-superblock-avoid-locking-counting-inodes-and-dentries-before-reclaiming-them.patch added to -mm tree
To: tim.c.chen@linux.intel.com,bob.liu@oracle.com,david@fromorbit.com,hannes@cmpxchg.org,hughd@google.com,jack@suse.cz,mgorman@suse.de,riel@redhat.com,viro@zeniv.linux.org.uk,yuanhan.liu@linux.intel.com
From: akpm@linux-foundation.org
Date: Thu, 22 May 2014 11:05:18 -0700


The patch titled
     Subject: fs/superblock: avoid locking counting inodes and dentries before reclaiming them
has been added to the -mm tree.  Its filename is
     fs-superblock-avoid-locking-counting-inodes-and-dentries-before-reclaiming-them.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-superblock-avoid-locking-counting-inodes-and-dentries-before-reclaiming-them.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-superblock-avoid-locking-counting-inodes-and-dentries-before-reclaiming-them.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: fs/superblock: avoid locking counting inodes and dentries before reclaiming them

We remove the call to grab_super_passive in call to super_cache_count. 
This becomes a scalability bottleneck as multiple threads are trying to do
memory reclamation, e.g.  when we are doing large amount of file read and
page cache is under pressure.  The cached objects quickly got reclaimed
down to 0 and we are aborting the cache_scan() reclaim.  But counting
creates a log jam acquiring the sb_lock.

We are holding the shrinker_rwsem which ensures the safety of call to
list_lru_count_node() and s_op->nr_cached_objects.  The shrinker is
unregistered now before ->kill_sb() so the operation is safe when we are
doing unmount.

The impact will depend heavily on the machine and the workload but for a
small machine using postmark tuned to use 4xRAM size the results were

                                  3.15.0-rc5            3.15.0-rc5
                                     vanilla         shrinker-v1r1
Ops/sec Transactions         21.00 (  0.00%)       24.00 ( 14.29%)
Ops/sec FilesCreate          39.00 (  0.00%)       44.00 ( 12.82%)
Ops/sec CreateTransact       10.00 (  0.00%)       12.00 ( 20.00%)
Ops/sec FilesDeleted       6202.00 (  0.00%)     6202.00 (  0.00%)
Ops/sec DeleteTransact       11.00 (  0.00%)       12.00 (  9.09%)
Ops/sec DataRead/MB          25.97 (  0.00%)       29.10 ( 12.05%)
Ops/sec DataWrite/MB         49.99 (  0.00%)       56.02 ( 12.06%)

ffsb running in a configuration that is meant to simulate a mail server showed

                                 3.15.0-rc5             3.15.0-rc5
                                    vanilla          shrinker-v1r1
Ops/sec readall           9402.63 (  0.00%)      9567.97 (  1.76%)
Ops/sec create            4695.45 (  0.00%)      4735.00 (  0.84%)
Ops/sec delete             173.72 (  0.00%)       179.83 (  3.52%)
Ops/sec Transactions     14271.80 (  0.00%)     14482.81 (  1.48%)
Ops/sec Read                37.00 (  0.00%)        37.60 (  1.62%)
Ops/sec Write               18.20 (  0.00%)        18.30 (  0.55%)

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Bob Liu <bob.liu@oracle.com>
Cc: Jan Kara <jack@suse.cz>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN fs/super.c~fs-superblock-avoid-locking-counting-inodes-and-dentries-before-reclaiming-them fs/super.c
--- a/fs/super.c~fs-superblock-avoid-locking-counting-inodes-and-dentries-before-reclaiming-them
+++ a/fs/super.c
@@ -112,9 +112,14 @@ static unsigned long super_cache_count(s
 
 	sb = container_of(shrink, struct super_block, s_shrink);
 
-	if (!grab_super_passive(sb))
-		return 0;
-
+	/*
+	 * Don't call grab_super_passive as it is a potential
+	 * scalability bottleneck. The counts could get updated
+	 * between super_cache_count and super_cache_scan anyway.
+	 * Call to super_cache_count with shrinker_rwsem held
+	 * ensures the safety of call to list_lru_count_node() and
+	 * s_op->nr_cached_objects().
+	 */
 	if (sb->s_op && sb->s_op->nr_cached_objects)
 		total_objects = sb->s_op->nr_cached_objects(sb,
 						 sc->nid);
@@ -125,7 +130,6 @@ static unsigned long super_cache_count(s
 						 sc->nid);
 
 	total_objects = vfs_pressure_ratio(total_objects);
-	drop_super(sb);
 	return total_objects;
 }
 
_

Patches currently in -mm which might be from tim.c.chen@linux.intel.com are

fs-superblock-unregister-sb-shrinker-before-kill_sb.patch
fs-superblock-avoid-locking-counting-inodes-and-dentries-before-reclaiming-them.patch
mm-vmscan-use-proportional-scanning-during-direct-reclaim-and-full-scan-at-def_priority.patch
linux-next.patch
rwsem-support-optimistic-spinning.patch
rwsem-support-optimistic-spinning-checkpatch-fixes.patch

