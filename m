From: akpm@linux-foundation.org
Subject: [folded-merged]
 xfs-convert-dquot-cache-lru-to-list_lru-fix-dquot-isolation-hang.patch
 removed from -mm tree
Date: Tue, 10 Sep 2013 15:30:42 -0700
Message-ID: <522f9d92.lNy7kJjIKacS9xBu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab3IJWan (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Sep 2013 18:30:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, glommer@gmail.com, dchinner@redhat.com, david@fromorbit.com

Subject: [folded-merged] xfs-convert-dquot-cache-lru-to-list_lru-fix-dquot-isolation-hang.patch removed from -mm tree
To: david@fromorbit.com,dchinner@redhat.com,glommer@gmail.com,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 10 Sep 2013 15:30:42 -0700


The patch titled
     Subject: xfs: fix dquot isolation hang
has been removed from the -mm tree.  Its filename was
     xfs-convert-dquot-cache-lru-to-list_lru-fix-dquot-isolation-hang.patch

This patch was dropped because it was folded into xfs-convert-dquot-cache-lru-to-list_lru.patch

------------------------------------------------------
From: Dave Chinner <david@fromorbit.com>
Subject: xfs: fix dquot isolation hang

The new LRU list isolation code in xfs_qm_dquot_isolate() isn't
completely up to date.  Firstly, it needs conversion to return enum
lru_status values, not raw numbers. Secondly - most importantly - it
fails to unlock the dquot and relock the LRU in the LRU_RETRY path.
This leads to deadlocks in xfstests generic/232. Fix them.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Cc: Glauber Costa <glommer@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/xfs_qm.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN fs/xfs/xfs_qm.c~xfs-convert-dquot-cache-lru-to-list_lru-fix-dquot-isolation-hang fs/xfs/xfs_qm.c
--- a/fs/xfs/xfs_qm.c~xfs-convert-dquot-cache-lru-to-list_lru-fix-dquot-isolation-hang
+++ a/fs/xfs/xfs_qm.c
@@ -707,7 +707,7 @@ xfs_qm_dquot_isolate(
 		trace_xfs_dqreclaim_want(dqp);
 		list_del_init(&dqp->q_lru);
 		XFS_STATS_DEC(xs_qm_dquot_unused);
-		return 0;
+		return LRU_REMOVED;
 	}
 
 	/*
@@ -753,17 +753,19 @@ xfs_qm_dquot_isolate(
 	XFS_STATS_DEC(xs_qm_dquot_unused);
 	trace_xfs_dqreclaim_done(dqp);
 	XFS_STATS_INC(xs_qm_dqreclaims);
-	return 0;
+	return LRU_REMOVED;
 
 out_miss_busy:
 	trace_xfs_dqreclaim_busy(dqp);
 	XFS_STATS_INC(xs_qm_dqreclaim_misses);
-	return 2;
+	return LRU_SKIP;
 
 out_unlock_dirty:
 	trace_xfs_dqreclaim_busy(dqp);
 	XFS_STATS_INC(xs_qm_dqreclaim_misses);
-	return 3;
+	xfs_dqunlock(dqp);
+	spin_lock(lru_lock);
+	return LRU_RETRY;
 }
 
 static unsigned long
_

Patches currently in -mm which might be from david@fromorbit.com are

origin.patch
super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch

