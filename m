From: akpm@linux-foundation.org
Subject: [merged]
 fs-befs-remove-useless-pr_err-in-befs_init_inodecache.patch removed from
 -mm tree
Date: Mon, 01 Aug 2016 17:25:31 -0700
Message-ID: <579fe87b.4zWb0noNNWcwbGkC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47764 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbcHBAZc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2016 20:25:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: salah.triki@acm.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: befs: remove useless pr_err in befs_init_inodecache()
has been removed from the -mm tree.  Its filename was
     fs-befs-remove-useless-pr_err-in-befs_init_inodecache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Salah Triki <salah.triki@acm.org>
Subject: fs: befs: remove useless pr_err in befs_init_inodecache()

Remove pr_err since kmem_cache_create log error and dump stack.

Link: http://lkml.kernel.org/r/e6d03cbc9542495dc6174b59e32fcd41c1393cfc.1464226521.git.salah.triki@acm.org
Signed-off-by: Salah Triki <salah.triki@acm.org>
---
 1 file changed, 2 insertions(+), 4 deletions(-)

index 04541f3..c734f21 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/linuxvfs.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/befs/linuxvfs.c~fs-befs-remove-useless-pr_err-in-befs_init_inodecache fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~fs-befs-remove-useless-pr_err-in-befs_init_inodecache
+++ a/fs/befs/linuxvfs.c
@@ -436,10 +436,9 @@ befs_init_inodecache(void)
 					      0, (SLAB_RECLAIM_ACCOUNT|
 						SLAB_MEM_SPREAD|SLAB_ACCOUNT),
 					      init_once);
-	if (befs_inode_cachep == NULL) {
-		pr_err("%s: Couldn't initialize inode slabcache\n", __func__);
+	if (befs_inode_cachep == NULL)
 		return -ENOMEM;
-	}
+
 	return 0;
 }
 
@@ -524,7 +523,6 @@ befs_utf2nls(struct super_block *sb, con
 
 	*out = result = kmalloc(maxlen, GFP_NOFS);
 	if (!*out) {
-		*out_len = 0;
 		return -ENOMEM;
 	}
 
_

Patches currently in -mm which might be from salah.triki@acm.org are


