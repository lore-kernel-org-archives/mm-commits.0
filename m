From: akpm@linux-foundation.org
Subject: [folded-merged]
 inode-convert-inode-lru-list-to-generic-lru-list-code-inode-move-inode-to-a-different-list-inside-lock.patch removed from -mm tree
Date: Tue, 10 Sep 2013 15:28:58 -0700
Message-ID: <522f9d2a.TE4pkoKFAiYohffb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40039 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab3IJW27 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Sep 2013 18:28:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, glommer@openvz.org, dchinner@redhat.com, glommer@gmail.com

Subject: [folded-merged] inode-convert-inode-lru-list-to-generic-lru-list-code-inode-move-inode-to-a-different-list-inside-lock.patch removed from -mm tree
To: glommer@gmail.com,dchinner@redhat.com,glommer@openvz.org,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 10 Sep 2013 15:28:58 -0700


The patch titled
     Subject: inode: move inode to a different list inside lock
has been removed from the -mm tree.  Its filename was
     inode-convert-inode-lru-list-to-generic-lru-list-code-inode-move-inode-to-a-different-list-inside-lock.patch

This patch was dropped because it was folded into inode-convert-inode-lru-list-to-generic-lru-list-code.patch

------------------------------------------------------
From: Glauber Costa <glommer@gmail.com>
Subject: inode: move inode to a different list inside lock

When removing an element from the lru, this will be done today after the lock
is released. This is a clear mistake, although we are not sure if the bugs we
are seeing are related to this. All list manipulations are done inside the
lock, and so should this one.

Signed-off-by: Glauber Costa <glommer@openvz.org>
Tested-by: Michal Hocko <mhocko@suse.cz>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/inode.c~inode-convert-inode-lru-list-to-generic-lru-list-code-inode-move-inode-to-a-different-list-inside-lock fs/inode.c
--- a/fs/inode.c~inode-convert-inode-lru-list-to-generic-lru-list-code-inode-move-inode-to-a-different-list-inside-lock
+++ a/fs/inode.c
@@ -736,9 +736,9 @@ inode_lru_isolate(struct list_head *item
 
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
+	list_move(&inode->i_lru, freeable);
 	spin_unlock(&inode->i_lock);
 
-	list_move(&inode->i_lru, freeable);
 	this_cpu_dec(nr_unused);
 	return LRU_REMOVED;
 }
_

Patches currently in -mm which might be from glommer@gmail.com are

origin.patch
memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
list_lru-per-node-list-infrastructure-fix.patch
list_lru-per-node-list-infrastructure-fix-broken-lru_retry-behaviour.patch
list_lru-remove-special-case-function-list_lru_dispose_all.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix-dquot-isolation-hang.patch
list_lru-dynamically-adjust-node-arrays-super-fix-for-destroy-lrus.patch

