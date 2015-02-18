From: akpm@linux-foundation.org
Subject: [merged] fs-befs-linuxvfsc-remove-unnecessary-casting.patch
 removed from -mm tree
Date: Wed, 18 Feb 2015 11:42:46 -0800
Message-ID: <54e4eb36.3kiyOIT2RiQ5L+cV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45996 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbbBRTmr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:42:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/befs/linuxvfs.c: remove unnecessary casting
has been removed from the -mm tree.  Its filename was
     fs-befs-linuxvfsc-remove-unnecessary-casting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/befs/linuxvfs.c: remove unnecessary casting

Fix the following coccinelle warning:

fs/befs/linuxvfs.c:278:14-36: WARNING: casting value returned by memory
allocation function to (struct befs_inode_info *) is useless.

[akpm@linux-foundation.org: avoid 80-col ugliness]
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/linuxvfs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/befs/linuxvfs.c~fs-befs-linuxvfsc-remove-unnecessary-casting fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~fs-befs-linuxvfsc-remove-unnecessary-casting
+++ a/fs/befs/linuxvfs.c
@@ -274,9 +274,9 @@ more:
 static struct inode *
 befs_alloc_inode(struct super_block *sb)
 {
-        struct befs_inode_info *bi;
-        bi = (struct befs_inode_info *)kmem_cache_alloc(befs_inode_cachep,
-							GFP_KERNEL);
+	struct befs_inode_info *bi;
+
+	bi = kmem_cache_alloc(befs_inode_cachep, GFP_KERNEL);
         if (!bi)
                 return NULL;
         return &bi->vfs_inode;
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch

