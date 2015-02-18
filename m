From: akpm@linux-foundation.org
Subject: [merged] fs-ufs-superc-remove-unnecessary-casting.patch removed
 from -mm tree
Date: Wed, 18 Feb 2015 11:42:50 -0800
Message-ID: <54e4eb3a.bogpXyCiVnLhcPMX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46002 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbbBRTmv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:42:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, dushistov@mail.ru, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ufs/super.c: remove unnecessary casting
has been removed from the -mm tree.  Its filename was
     fs-ufs-superc-remove-unnecessary-casting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/ufs/super.c: remove unnecessary casting

Fix the following coccinelle warning:
fs/ufs/super.c:1418:7-28: WARNING: casting value returned by memory
allocation function to (struct ufs_inode_info *) is useless.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/ufs/super.c~fs-ufs-superc-remove-unnecessary-casting fs/ufs/super.c
--- a/fs/ufs/super.c~fs-ufs-superc-remove-unnecessary-casting
+++ a/fs/ufs/super.c
@@ -1415,9 +1415,11 @@ static struct kmem_cache * ufs_inode_cac
 static struct inode *ufs_alloc_inode(struct super_block *sb)
 {
 	struct ufs_inode_info *ei;
-	ei = (struct ufs_inode_info *)kmem_cache_alloc(ufs_inode_cachep, GFP_NOFS);
+
+	ei = kmem_cache_alloc(ufs_inode_cachep, GFP_NOFS);
 	if (!ei)
 		return NULL;
+
 	ei->vfs_inode.i_version = 1;
 	return &ei->vfs_inode;
 }
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch

