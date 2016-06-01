From: akpm@linux-foundation.org
Subject: + fs-befs-remove-useless-pr_err-in-befs_init_inodecache.patch
 added to -mm tree
Date: Wed, 01 Jun 2016 16:42:41 -0700
Message-ID: <574f72f1.60DEMufON/jpjCos%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbcFAXmm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2016 19:42:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: salah.triki@acm.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: befs: remove useless pr_err in befs_init_inodecache()
has been added to the -mm tree.  Its filename is
     fs-befs-remove-useless-pr_err-in-befs_init_inodecache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-befs-remove-useless-pr_err-in-befs_init_inodecache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-befs-remove-useless-pr_err-in-befs_init_inodecache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fs-befs-move-useless-assignment.patch
fs-befs-check-silent-flag-before-logging-errors.patch
fs-befs-remove-useless-pr_err.patch
fs-befs-remove-useless-befs_error.patch
fs-befs-remove-useless-pr_err-in-befs_init_inodecache.patch

