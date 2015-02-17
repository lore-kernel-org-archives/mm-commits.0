From: akpm@linux-foundation.org
Subject: [folded-merged]
 fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch removed from -mm
 tree
Date: Tue, 17 Feb 2015 13:37:12 -0800
Message-ID: <54e3b488.lkaYl9c/utyie+fh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36289 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbbBQVhN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Feb 2015 16:37:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-befs-linuxvfsc-remove-unnecessary-casting-fix
has been removed from the -mm tree.  Its filename was
     fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch

This patch was dropped because it was folded into fs-befs-linuxvfsc-remove-unnecessary-casting.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-befs-linuxvfsc-remove-unnecessary-casting-fix

avoid 80-col ugliness

Cc: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/linuxvfs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/befs/linuxvfs.c~fs-befs-linuxvfsc-remove-unnecessary-casting-fix fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~fs-befs-linuxvfsc-remove-unnecessary-casting-fix
+++ a/fs/befs/linuxvfs.c
@@ -274,8 +274,9 @@ more:
 static struct inode *
 befs_alloc_inode(struct super_block *sb)
 {
-	struct befs_inode_info *bi = kmem_cache_alloc(befs_inode_cachep,
-						      GFP_KERNEL);
+	struct befs_inode_info *bi;
+
+	bi = kmem_cache_alloc(befs_inode_cachep, GFP_KERNEL);
         if (!bi)
                 return NULL;
         return &bi->vfs_inode;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fs-befs-linuxvfsc-remove-unnecessary-casting.patch
samples-seccomp-improve-label-helper-fix.patch

