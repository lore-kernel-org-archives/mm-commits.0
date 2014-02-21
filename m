From: akpm@linux-foundation.org
Subject: + afs-afs_alloc_inode-use-kmem_cache_zalloc.patch added to -mm
 tree
Date: Fri, 21 Feb 2014 13:47:36 -0800
Message-ID: <5307c978.n4uH3VH3uPzsKtUn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58638 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458AbaBUVrh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 16:47:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dhowells@redhat.com, fabf@skynet.be

Subject: + afs-afs_alloc_inode-use-kmem_cache_zalloc.patch added to -mm tree
To: fabf@skynet.be,dhowells@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 13:47:36 -0800


The patch titled
     Subject: afs: afs_alloc_inode: use kmem_cache_zalloc()
has been added to the -mm tree.  Its filename is
     afs-afs_alloc_inode-use-kmem_cache_zalloc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/afs-afs_alloc_inode-use-kmem_cache_zalloc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/afs-afs_alloc_inode-use-kmem_cache_zalloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
-
-	vnode->volume		= NULL;
-	vnode->update_cnt	= 0;
 	vnode->flags		= 1 << AFS_VNODE_UNSET;
 	vnode->cb_promised	= false;
 
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-cifs-cifsfsc-add-__init-to-cifs_init_inodecache.patch
fs-udf-superc-add-__init-to-init_inodecache.patch
sys_sysfs-add-config_sysfs_syscall.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
fs-efs-superc-add-__init-to-init_inodecache.patch
fs-minix-inodec-add-__init-to-init_inodecache.patch
befs-replace-kmalloc-memset-0-by-kzalloc.patch
fs-ufs-superc-add-__init-to-init_inodecache.patch
ufs-sb-mutex-merge-mutex_destroy.patch
fs-adfs-superc-add-__init-to-init_inodecache.patch
afs-afs_alloc_inode-use-kmem_cache_zalloc.patch
afs-afs_alloc_inode-use-kmem_cache_zalloc-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
linux-next.patch

