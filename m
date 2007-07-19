From: akpm@linux-foundation.org
Subject: + fs-romfs-inodec-trivial-improvements.patch added to -mm tree
Date: Thu, 19 Jul 2007 15:53:00 -0700
Message-ID: <200707192253.l6JMr0pI027027@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38610 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752384AbXGSWxH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 18:53:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com


The patch titled
     fs/romfs/inode.c: trivial improvements
has been added to the -mm tree.  Its filename is
     fs-romfs-inodec-trivial-improvements.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs/romfs/inode.c: trivial improvements
From: WANG Cong <xiyou.wangcong@gmail.com>

- There are no lists in fs/romfs/inode.c, so using list_entry
  is a bit confusing.  Replace it with container_of.

- It is unnecessary to cast the return value of
  kmem_cache_alloc, since it returns a void* pointer.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/romfs/inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/romfs/inode.c~fs-romfs-inodec-trivial-improvements fs/romfs/inode.c
--- a/fs/romfs/inode.c~fs-romfs-inodec-trivial-improvements
+++ a/fs/romfs/inode.c
@@ -92,7 +92,7 @@ static inline unsigned long romfs_maxsiz
 
 static inline struct romfs_inode_info *ROMFS_I(struct inode *inode)
 {
-	return list_entry(inode, struct romfs_inode_info, vfs_inode);
+	return container_of(inode, struct romfs_inode_info, vfs_inode);
 }
 
 static __u32
@@ -555,7 +555,7 @@ static struct kmem_cache * romfs_inode_c
 static struct inode *romfs_alloc_inode(struct super_block *sb)
 {
 	struct romfs_inode_info *ei;
-	ei = (struct romfs_inode_info *)kmem_cache_alloc(romfs_inode_cachep, GFP_KERNEL);
+	ei = kmem_cache_alloc(romfs_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	return &ei->vfs_inode;
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
fs-romfs-inodec-trivial-improvements.patch
