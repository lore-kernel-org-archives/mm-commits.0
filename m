From: akpm@linux-foundation.org
Subject: [obsolete] afs-afs_alloc_inode-use-kmem_cache_zalloc.patch
 removed from -mm tree
Date: Fri, 21 Feb 2014 13:54:48 -0800
Message-ID: <5307cb28.fLzkFwnC07US4qCW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbaBUVyt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 16:54:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dhowells@redhat.com, fabf@skynet.be

Subject: [obsolete] afs-afs_alloc_inode-use-kmem_cache_zalloc.patch removed from -mm tree
To: fabf@skynet.be,dhowells@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 13:54:48 -0800


The patch titled
     Subject: afs: afs_alloc_inode: use kmem_cache_zalloc()
has been removed from the -mm tree.  Its filename was
     afs-afs_alloc_inode-use-kmem_cache_zalloc.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: afs: afs_alloc_inode: use kmem_cache_zalloc()

This patch calls zalloc for explicit zero fill and removes all memset 0.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/super.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN fs/afs/super.c~afs-afs_alloc_inode-use-kmem_cache_zalloc fs/afs/super.c
--- a/fs/afs/super.c~afs-afs_alloc_inode-use-kmem_cache_zalloc
+++ a/fs/afs/super.c
@@ -460,7 +460,6 @@ static void afs_i_init_once(void *_vnode
 {
 	struct afs_vnode *vnode = _vnode;
 
-	memset(vnode, 0, sizeof(*vnode));
 	inode_init_once(&vnode->vfs_inode);
 	init_waitqueue_head(&vnode->update_waitq);
 	mutex_init(&vnode->permits_lock);
@@ -481,17 +480,12 @@ static struct inode *afs_alloc_inode(str
 {
 	struct afs_vnode *vnode;
 
-	vnode = kmem_cache_alloc(afs_inode_cachep, GFP_KERNEL);
+	vnode = kmem_cache_zalloc(afs_inode_cachep, GFP_KERNEL);
 	if (!vnode)
 		return NULL;
 
 	atomic_inc(&afs_count_active_inodes);
 
-	memset(&vnode->fid, 0, sizeof(vnode->fid));
-	memset(&vnode->status, 0, sizeof(vnode->status));
