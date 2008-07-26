From: akpm@linux-foundation.org
Subject: - vfs-add-cond_resched_lock-while-scanning-dentry-lru-lists.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:13:15 -0700
Message-ID: <200807262113.m6QLDFLd019583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757404AbYGZVNT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:13:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k-makita@np.css.fujitsu.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: add cond_resched_lock while scanning dentry LRU lists
has been removed from the -mm tree.  Its filename was
     vfs-add-cond_resched_lock-while-scanning-dentry-lru-lists.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: add cond_resched_lock while scanning dentry LRU lists
From: Kentaro Makita <k-makita@np.css.fujitsu.com>

Add cond_resched_lock(&dcache_lock) while scanning LRU lists on
superblocks in __shrink_dcache_sb()

Signed-off-by: Kentaro Makita <k-makita@np.css.fujitsu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/dcache.c~vfs-add-cond_resched_lock-while-scanning-dentry-lru-lists fs/dcache.c
--- a/fs/dcache.c~vfs-add-cond_resched_lock-while-scanning-dentry-lru-lists
+++ a/fs/dcache.c
@@ -487,6 +487,7 @@ restart:
 				if (!cnt)
 					break;
 			}
+			cond_resched_lock(&dcache_lock);
 		}
 	}
 	while (!list_empty(&tmp)) {
_

Patches currently in -mm which might be from k-makita@np.css.fujitsu.com are

origin.patch

