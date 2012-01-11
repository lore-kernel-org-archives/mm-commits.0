From: akpm@linux-foundation.org
Subject: [merged] mm-account-reaped-page-cache-on-inode-cache-pruning.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:26:41 -0800
Message-ID: <20120111212641.9DAC710004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:58471 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758145Ab2AKV0m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:26:42 -0500
Received: by mail-gy0-f202.google.com with SMTP id r15so136887ghr.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:26:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, david@fromorbit.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: account reaped page cache on inode cache pruning
has been removed from the -mm tree.  Its filename was
     mm-account-reaped-page-cache-on-inode-cache-pruning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm: account reaped page cache on inode cache pruning

Inode cache pruning indirectly reclaims page-cache by invalidating mapping
pages.  Let's account them into reclaim-state to notice this progress in
memory reclaimer.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/inode.c~mm-account-reaped-page-cache-on-inode-cache-pruning fs/inode.c
--- a/fs/inode.c~mm-account-reaped-page-cache-on-inode-cache-pruning
+++ a/fs/inode.c
@@ -776,6 +776,8 @@ void prune_icache_sb(struct super_block 
 	else
 		__count_vm_events(PGINODESTEAL, reap);
 	spin_unlock(&sb->s_inode_lru_lock);
+	if (current->reclaim_state)
+		current->reclaim_state->reclaimed_slab += reap;
 
 	dispose_list(&freeable);
 }
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch
mm-take-pagevecs-off-reclaim-stack.patch

