Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DC55C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:30:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350261AbiCYBcX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357349AbiCYBcH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:32:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801F24BB85
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:30:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AD46B82729
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:30:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93474C340EE;
        Fri, 25 Mar 2022 01:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171831;
        bh=wbG+jAXNoNgVpV5S0pDsxD+rTFRKgiqjEorX1j/Z/mE=;
        h=Date:To:From:Subject:From;
        b=pOOv4T5S9r6YgoQvhDkljqReen7UqSz5RvmRVPrhDj0fteG5vylijQCwdDEmH/HNI
         K+W7te426C6sanXUfAFbE+OEG8xKR/oX4ll8el3QuB3upmo0tpJI5BUmZr3pnfbenn
         hh2BqvwuFVK3BALSADRUFV7xr/lpOYrKLRxXYxMM=
Date:   Thu, 24 Mar 2022 18:30:31 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        willy@infradead.org, vdavydov.dev@gmail.com, vbabka@suse.cz,
        tytso@mit.edu, trond.myklebust@hammerspace.com,
        shy828301@gmail.com, shakeelb@google.com, roman.gushchin@linux.dev,
        richard.weiyang@gmail.com, mhocko@kernel.org,
        kari.argillander@gmail.com, jaegeuk@kernel.org, hannes@cmpxchg.org,
        fam.zheng@bytedance.com, duanxiongchun@bytedance.com,
        david@fromorbit.com, chao@kernel.org, Anna.Schumaker@Netapp.com,
        alexs@kernel.org, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] fs-allocate-inode-by-using-alloc_inode_sb.patch removed from -mm tree
Message-Id: <20220325013031.93474C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: allocate inode by using alloc_inode_sb()
has been removed from the -mm tree.  Its filename was
     fs-allocate-inode-by-using-alloc_inode_sb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: fs: allocate inode by using alloc_inode_sb()

The inode allocation is supposed to use alloc_inode_sb(), so convert
kmem_cache_alloc() of all filesystems to alloc_inode_sb().

Link: https://lkml.kernel.org/r/20220228122126.37293-5-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Theodore Ts'o <tytso@mit.edu>		[ext4]
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Alex Shi <alexs@kernel.org>
Cc: Anna Schumaker <Anna.Schumaker@Netapp.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kari Argillander <kari.argillander@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/bdev.c             |    2 +-
 drivers/dax/super.c      |    2 +-
 fs/9p/vfs_inode.c        |    2 +-
 fs/adfs/super.c          |    2 +-
 fs/affs/super.c          |    2 +-
 fs/afs/super.c           |    2 +-
 fs/befs/linuxvfs.c       |    2 +-
 fs/bfs/inode.c           |    2 +-
 fs/btrfs/inode.c         |    2 +-
 fs/ceph/inode.c          |    2 +-
 fs/cifs/cifsfs.c         |    2 +-
 fs/coda/inode.c          |    2 +-
 fs/ecryptfs/super.c      |    2 +-
 fs/efs/super.c           |    2 +-
 fs/erofs/super.c         |    2 +-
 fs/exfat/super.c         |    2 +-
 fs/ext2/super.c          |    2 +-
 fs/ext4/super.c          |    2 +-
 fs/fat/inode.c           |    2 +-
 fs/freevxfs/vxfs_super.c |    2 +-
 fs/fuse/inode.c          |    2 +-
 fs/gfs2/super.c          |    2 +-
 fs/hfs/super.c           |    2 +-
 fs/hfsplus/super.c       |    2 +-
 fs/hostfs/hostfs_kern.c  |    2 +-
 fs/hpfs/super.c          |    2 +-
 fs/hugetlbfs/inode.c     |    2 +-
 fs/isofs/inode.c         |    2 +-
 fs/jffs2/super.c         |    2 +-
 fs/jfs/super.c           |    2 +-
 fs/minix/inode.c         |    2 +-
 fs/nfs/inode.c           |    2 +-
 fs/nilfs2/super.c        |    2 +-
 fs/ntfs/inode.c          |    2 +-
 fs/ntfs3/super.c         |    2 +-
 fs/ocfs2/dlmfs/dlmfs.c   |    2 +-
 fs/ocfs2/super.c         |    2 +-
 fs/openpromfs/inode.c    |    2 +-
 fs/orangefs/super.c      |    2 +-
 fs/overlayfs/super.c     |    2 +-
 fs/proc/inode.c          |    2 +-
 fs/qnx4/inode.c          |    2 +-
 fs/qnx6/inode.c          |    2 +-
 fs/reiserfs/super.c      |    2 +-
 fs/romfs/super.c         |    2 +-
 fs/squashfs/super.c      |    2 +-
 fs/sysv/inode.c          |    2 +-
 fs/ubifs/super.c         |    2 +-
 fs/udf/super.c           |    2 +-
 fs/ufs/super.c           |    2 +-
 fs/vboxsf/super.c        |    2 +-
 fs/xfs/xfs_icache.c      |    2 +-
 fs/zonefs/super.c        |    2 +-
 ipc/mqueue.c             |    2 +-
 mm/shmem.c               |    2 +-
 net/socket.c             |    2 +-
 net/sunrpc/rpc_pipe.c    |    2 +-
 57 files changed, 57 insertions(+), 57 deletions(-)

--- a/block/bdev.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/block/bdev.c
@@ -385,7 +385,7 @@ static struct kmem_cache * bdev_cachep _
 
 static struct inode *bdev_alloc_inode(struct super_block *sb)
 {
-	struct bdev_inode *ei = kmem_cache_alloc(bdev_cachep, GFP_KERNEL);
+	struct bdev_inode *ei = alloc_inode_sb(sb, bdev_cachep, GFP_KERNEL);
 
 	if (!ei)
 		return NULL;
--- a/drivers/dax/super.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/drivers/dax/super.c
@@ -282,7 +282,7 @@ static struct inode *dax_alloc_inode(str
 	struct dax_device *dax_dev;
 	struct inode *inode;
 
-	dax_dev = kmem_cache_alloc(dax_cache, GFP_KERNEL);
+	dax_dev = alloc_inode_sb(sb, dax_cache, GFP_KERNEL);
 	if (!dax_dev)
 		return NULL;
 
--- a/fs/9p/vfs_inode.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/9p/vfs_inode.c
@@ -228,7 +228,7 @@ struct inode *v9fs_alloc_inode(struct su
 {
 	struct v9fs_inode *v9inode;
 
-	v9inode = kmem_cache_alloc(v9fs_inode_cache, GFP_KERNEL);
+	v9inode = alloc_inode_sb(sb, v9fs_inode_cache, GFP_KERNEL);
 	if (!v9inode)
 		return NULL;
 #ifdef CONFIG_9P_FSCACHE
--- a/fs/adfs/super.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/adfs/super.c
@@ -220,7 +220,7 @@ static struct kmem_cache *adfs_inode_cac
 static struct inode *adfs_alloc_inode(struct super_block *sb)
 {
 	struct adfs_inode_info *ei;
-	ei = kmem_cache_alloc(adfs_inode_cachep, GFP_KERNEL);
+	ei = alloc_inode_sb(sb, adfs_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	return &ei->vfs_inode;
--- a/fs/affs/super.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/affs/super.c
@@ -100,7 +100,7 @@ static struct inode *affs_alloc_inode(st
 {
 	struct affs_inode_info *i;
 
-	i = kmem_cache_alloc(affs_inode_cachep, GFP_KERNEL);
+	i = alloc_inode_sb(sb, affs_inode_cachep, GFP_KERNEL);
 	if (!i)
 		return NULL;
 
--- a/fs/afs/super.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/afs/super.c
@@ -679,7 +679,7 @@ static struct inode *afs_alloc_inode(str
 {
 	struct afs_vnode *vnode;
 
-	vnode = kmem_cache_alloc(afs_inode_cachep, GFP_KERNEL);
+	vnode = alloc_inode_sb(sb, afs_inode_cachep, GFP_KERNEL);
 	if (!vnode)
 		return NULL;
 
--- a/fs/befs/linuxvfs.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/befs/linuxvfs.c
@@ -277,7 +277,7 @@ befs_alloc_inode(struct super_block *sb)
 {
 	struct befs_inode_info *bi;
 
-	bi = kmem_cache_alloc(befs_inode_cachep, GFP_KERNEL);
+	bi = alloc_inode_sb(sb, befs_inode_cachep, GFP_KERNEL);
 	if (!bi)
 		return NULL;
 	return &bi->vfs_inode;
--- a/fs/bfs/inode.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/bfs/inode.c
@@ -239,7 +239,7 @@ static struct kmem_cache *bfs_inode_cach
 static struct inode *bfs_alloc_inode(struct super_block *sb)
 {
 	struct bfs_inode_info *bi;
-	bi = kmem_cache_alloc(bfs_inode_cachep, GFP_KERNEL);
+	bi = alloc_inode_sb(sb, bfs_inode_cachep, GFP_KERNEL);
 	if (!bi)
 		return NULL;
 	return &bi->vfs_inode;
--- a/fs/btrfs/inode.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/btrfs/inode.c
@@ -8787,7 +8787,7 @@ struct inode *btrfs_alloc_inode(struct s
 	struct btrfs_inode *ei;
 	struct inode *inode;
 
-	ei = kmem_cache_alloc(btrfs_inode_cachep, GFP_KERNEL);
+	ei = alloc_inode_sb(sb, btrfs_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 
--- a/fs/ceph/inode.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/ceph/inode.c
@@ -447,7 +447,7 @@ struct inode *ceph_alloc_inode(struct su
 	struct ceph_inode_info *ci;
 	int i;
 
-	ci = kmem_cache_alloc(ceph_inode_cachep, GFP_NOFS);
+	ci = alloc_inode_sb(sb, ceph_inode_cachep, GFP_NOFS);
 	if (!ci)
 		return NULL;
 
--- a/fs/cifs/cifsfs.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/cifs/cifsfs.c
@@ -354,7 +354,7 @@ static struct inode *
 cifs_alloc_inode(struct super_block *sb)
 {
 	struct cifsInodeInfo *cifs_inode;
-	cifs_inode = kmem_cache_alloc(cifs_inode_cachep, GFP_KERNEL);
+	cifs_inode = alloc_inode_sb(sb, cifs_inode_cachep, GFP_KERNEL);
 	if (!cifs_inode)
 		return NULL;
 	cifs_inode->cifsAttrs = 0x20;	/* default */
--- a/fs/coda/inode.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/coda/inode.c
@@ -43,7 +43,7 @@ static struct kmem_cache * coda_inode_ca
 static struct inode *coda_alloc_inode(struct super_block *sb)
 {
 	struct coda_inode_info *ei;
-	ei = kmem_cache_alloc(coda_inode_cachep, GFP_KERNEL);
+	ei = alloc_inode_sb(sb, coda_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	memset(&ei->c_fid, 0, sizeof(struct CodaFid));
--- a/fs/ecryptfs/super.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/ecryptfs/super.c
@@ -38,7 +38,7 @@ static struct inode *ecryptfs_alloc_inod
 	struct ecryptfs_inode_info *inode_info;
 	struct inode *inode = NULL;
 
-	inode_info = kmem_cache_alloc(ecryptfs_inode_info_cache, GFP_KERNEL);
+	inode_info = alloc_inode_sb(sb, ecryptfs_inode_info_cache, GFP_KERNEL);
 	if (unlikely(!inode_info))
 		goto out;
 	if (ecryptfs_init_crypt_stat(&inode_info->crypt_stat)) {
--- a/fs/efs/super.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/efs/super.c
@@ -69,7 +69,7 @@ static struct kmem_cache * efs_inode_cac
 static struct inode *efs_alloc_inode(struct super_block *sb)
 {
 	struct efs_inode_info *ei;
-	ei = kmem_cache_alloc(efs_inode_cachep, GFP_KERNEL);
+	ei = alloc_inode_sb(sb, efs_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	return &ei->vfs_inode;
--- a/fs/erofs/super.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/erofs/super.c
@@ -84,7 +84,7 @@ static void erofs_inode_init_once(void *
 static struct inode *erofs_alloc_inode(struct super_block *sb)
 {
 	struct erofs_inode *vi =
-		kmem_cache_alloc(erofs_inode_cachep, GFP_KERNEL);
+		alloc_inode_sb(sb, erofs_inode_cachep, GFP_KERNEL);
 
 	if (!vi)
 		return NULL;
--- a/fs/exfat/super.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/exfat/super.c
@@ -183,7 +183,7 @@ static struct inode *exfat_alloc_inode(s
 {
 	struct exfat_inode_info *ei;
 
-	ei = kmem_cache_alloc(exfat_inode_cachep, GFP_NOFS);
+	ei = alloc_inode_sb(sb, exfat_inode_cachep, GFP_NOFS);
 	if (!ei)
 		return NULL;
 
--- a/fs/ext2/super.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/ext2/super.c
@@ -180,7 +180,7 @@ static struct kmem_cache * ext2_inode_ca
 static struct inode *ext2_alloc_inode(struct super_block *sb)
 {
 	struct ext2_inode_info *ei;
-	ei = kmem_cache_alloc(ext2_inode_cachep, GFP_KERNEL);
+	ei = alloc_inode_sb(sb, ext2_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	ei->i_block_alloc_info = NULL;
--- a/fs/ext4/super.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/ext4/super.c
@@ -1316,7 +1316,7 @@ static struct inode *ext4_alloc_inode(st
 {
 	struct ext4_inode_info *ei;
 
-	ei = kmem_cache_alloc(ext4_inode_cachep, GFP_NOFS);
+	ei = alloc_inode_sb(sb, ext4_inode_cachep, GFP_NOFS);
 	if (!ei)
 		return NULL;
 
--- a/fs/fat/inode.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/fat/inode.c
@@ -745,7 +745,7 @@ static struct kmem_cache *fat_inode_cach
 static struct inode *fat_alloc_inode(struct super_block *sb)
 {
 	struct msdos_inode_info *ei;
-	ei = kmem_cache_alloc(fat_inode_cachep, GFP_NOFS);
+	ei = alloc_inode_sb(sb, fat_inode_cachep, GFP_NOFS);
 	if (!ei)
 		return NULL;
 
--- a/fs/freevxfs/vxfs_super.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/freevxfs/vxfs_super.c
@@ -124,7 +124,7 @@ static struct inode *vxfs_alloc_inode(st
 {
 	struct vxfs_inode_info *vi;
 
-	vi = kmem_cache_alloc(vxfs_inode_cachep, GFP_KERNEL);
+	vi = alloc_inode_sb(sb, vxfs_inode_cachep, GFP_KERNEL);
 	if (!vi)
 		return NULL;
 	inode_init_once(&vi->vfs_inode);
--- a/fs/fuse/inode.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/fuse/inode.c
@@ -72,7 +72,7 @@ static struct inode *fuse_alloc_inode(st
 {
 	struct fuse_inode *fi;
 
-	fi = kmem_cache_alloc(fuse_inode_cachep, GFP_KERNEL);
+	fi = alloc_inode_sb(sb, fuse_inode_cachep, GFP_KERNEL);
 	if (!fi)
 		return NULL;
 
--- a/fs/gfs2/super.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/gfs2/super.c
@@ -1425,7 +1425,7 @@ static struct inode *gfs2_alloc_inode(st
 {
 	struct gfs2_inode *ip;
 
-	ip = kmem_cache_alloc(gfs2_inode_cachep, GFP_KERNEL);
+	ip = alloc_inode_sb(sb, gfs2_inode_cachep, GFP_KERNEL);
 	if (!ip)
 		return NULL;
 	ip->i_flags = 0;
--- a/fs/hfsplus/super.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/hfsplus/super.c
@@ -624,7 +624,7 @@ static struct inode *hfsplus_alloc_inode
 {
 	struct hfsplus_inode_info *i;
 
-	i = kmem_cache_alloc(hfsplus_inode_cachep, GFP_KERNEL);
+	i = alloc_inode_sb(sb, hfsplus_inode_cachep, GFP_KERNEL);
 	return i ? &i->vfs_inode : NULL;
 }
 
--- a/fs/hfs/super.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/hfs/super.c
@@ -162,7 +162,7 @@ static struct inode *hfs_alloc_inode(str
 {
 	struct hfs_inode_info *i;
 
-	i = kmem_cache_alloc(hfs_inode_cachep, GFP_KERNEL);
+	i = alloc_inode_sb(sb, hfs_inode_cachep, GFP_KERNEL);
 	return i ? &i->vfs_inode : NULL;
 }
 
--- a/fs/hostfs/hostfs_kern.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/hostfs/hostfs_kern.c
@@ -222,7 +222,7 @@ static struct inode *hostfs_alloc_inode(
 {
 	struct hostfs_inode_info *hi;
 
-	hi = kmem_cache_alloc(hostfs_inode_cache, GFP_KERNEL_ACCOUNT);
+	hi = alloc_inode_sb(sb, hostfs_inode_cache, GFP_KERNEL_ACCOUNT);
 	if (hi == NULL)
 		return NULL;
 	hi->fd = -1;
--- a/fs/hpfs/super.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/hpfs/super.c
@@ -232,7 +232,7 @@ static struct kmem_cache * hpfs_inode_ca
 static struct inode *hpfs_alloc_inode(struct super_block *sb)
 {
 	struct hpfs_inode_info *ei;
-	ei = kmem_cache_alloc(hpfs_inode_cachep, GFP_NOFS);
+	ei = alloc_inode_sb(sb, hpfs_inode_cachep, GFP_NOFS);
 	if (!ei)
 		return NULL;
 	return &ei->vfs_inode;
--- a/fs/hugetlbfs/inode.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/hugetlbfs/inode.c
@@ -1110,7 +1110,7 @@ static struct inode *hugetlbfs_alloc_ino
 
 	if (unlikely(!hugetlbfs_dec_free_inodes(sbinfo)))
 		return NULL;
-	p = kmem_cache_alloc(hugetlbfs_inode_cachep, GFP_KERNEL);
+	p = alloc_inode_sb(sb, hugetlbfs_inode_cachep, GFP_KERNEL);
 	if (unlikely(!p)) {
 		hugetlbfs_inc_free_inodes(sbinfo);
 		return NULL;
--- a/fs/isofs/inode.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/isofs/inode.c
@@ -70,7 +70,7 @@ static struct kmem_cache *isofs_inode_ca
 static struct inode *isofs_alloc_inode(struct super_block *sb)
 {
 	struct iso_inode_info *ei;
-	ei = kmem_cache_alloc(isofs_inode_cachep, GFP_KERNEL);
+	ei = alloc_inode_sb(sb, isofs_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	return &ei->vfs_inode;
--- a/fs/jffs2/super.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/jffs2/super.c
@@ -39,7 +39,7 @@ static struct inode *jffs2_alloc_inode(s
 {
 	struct jffs2_inode_info *f;
 
-	f = kmem_cache_alloc(jffs2_inode_cachep, GFP_KERNEL);
+	f = alloc_inode_sb(sb, jffs2_inode_cachep, GFP_KERNEL);
 	if (!f)
 		return NULL;
 	return &f->vfs_inode;
--- a/fs/jfs/super.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/jfs/super.c
@@ -102,7 +102,7 @@ static struct inode *jfs_alloc_inode(str
 {
 	struct jfs_inode_info *jfs_inode;
 
-	jfs_inode = kmem_cache_alloc(jfs_inode_cachep, GFP_NOFS);
+	jfs_inode = alloc_inode_sb(sb, jfs_inode_cachep, GFP_NOFS);
 	if (!jfs_inode)
 		return NULL;
 #ifdef CONFIG_QUOTA
--- a/fs/minix/inode.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/minix/inode.c
@@ -63,7 +63,7 @@ static struct kmem_cache * minix_inode_c
 static struct inode *minix_alloc_inode(struct super_block *sb)
 {
 	struct minix_inode_info *ei;
-	ei = kmem_cache_alloc(minix_inode_cachep, GFP_KERNEL);
+	ei = alloc_inode_sb(sb, minix_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	return &ei->vfs_inode;
--- a/fs/nfs/inode.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/nfs/inode.c
@@ -2238,7 +2238,7 @@ static int nfs_update_inode(struct inode
 struct inode *nfs_alloc_inode(struct super_block *sb)
 {
 	struct nfs_inode *nfsi;
-	nfsi = kmem_cache_alloc(nfs_inode_cachep, GFP_KERNEL);
+	nfsi = alloc_inode_sb(sb, nfs_inode_cachep, GFP_KERNEL);
 	if (!nfsi)
 		return NULL;
 	nfsi->flags = 0UL;
--- a/fs/nilfs2/super.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/nilfs2/super.c
@@ -151,7 +151,7 @@ struct inode *nilfs_alloc_inode(struct s
 {
 	struct nilfs_inode_info *ii;
 
-	ii = kmem_cache_alloc(nilfs_inode_cachep, GFP_NOFS);
+	ii = alloc_inode_sb(sb, nilfs_inode_cachep, GFP_NOFS);
 	if (!ii)
 		return NULL;
 	ii->i_bh = NULL;
--- a/fs/ntfs3/super.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/ntfs3/super.c
@@ -399,7 +399,7 @@ static struct kmem_cache *ntfs_inode_cac
 
 static struct inode *ntfs_alloc_inode(struct super_block *sb)
 {
-	struct ntfs_inode *ni = kmem_cache_alloc(ntfs_inode_cachep, GFP_NOFS);
+	struct ntfs_inode *ni = alloc_inode_sb(sb, ntfs_inode_cachep, GFP_NOFS);
 
 	if (!ni)
 		return NULL;
--- a/fs/ntfs/inode.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/ntfs/inode.c
@@ -310,7 +310,7 @@ struct inode *ntfs_alloc_big_inode(struc
 	ntfs_inode *ni;
 
 	ntfs_debug("Entering.");
-	ni = kmem_cache_alloc(ntfs_big_inode_cache, GFP_NOFS);
+	ni = alloc_inode_sb(sb, ntfs_big_inode_cache, GFP_NOFS);
 	if (likely(ni != NULL)) {
 		ni->state = 0;
 		return VFS_I(ni);
--- a/fs/ocfs2/dlmfs/dlmfs.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/ocfs2/dlmfs/dlmfs.c
@@ -280,7 +280,7 @@ static struct inode *dlmfs_alloc_inode(s
 {
 	struct dlmfs_inode_private *ip;
 
-	ip = kmem_cache_alloc(dlmfs_inode_cache, GFP_NOFS);
+	ip = alloc_inode_sb(sb, dlmfs_inode_cache, GFP_NOFS);
 	if (!ip)
 		return NULL;
 
--- a/fs/ocfs2/super.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/ocfs2/super.c
@@ -548,7 +548,7 @@ static struct inode *ocfs2_alloc_inode(s
 {
 	struct ocfs2_inode_info *oi;
 
-	oi = kmem_cache_alloc(ocfs2_inode_cachep, GFP_NOFS);
+	oi = alloc_inode_sb(sb, ocfs2_inode_cachep, GFP_NOFS);
 	if (!oi)
 		return NULL;
 
--- a/fs/openpromfs/inode.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/openpromfs/inode.c
@@ -335,7 +335,7 @@ static struct inode *openprom_alloc_inod
 {
 	struct op_inode_info *oi;
 
-	oi = kmem_cache_alloc(op_inode_cachep, GFP_KERNEL);
+	oi = alloc_inode_sb(sb, op_inode_cachep, GFP_KERNEL);
 	if (!oi)
 		return NULL;
 
--- a/fs/orangefs/super.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/orangefs/super.c
@@ -107,7 +107,7 @@ static struct inode *orangefs_alloc_inod
 {
 	struct orangefs_inode_s *orangefs_inode;
 
-	orangefs_inode = kmem_cache_alloc(orangefs_inode_cache, GFP_KERNEL);
+	orangefs_inode = alloc_inode_sb(sb, orangefs_inode_cache, GFP_KERNEL);
 	if (!orangefs_inode)
 		return NULL;
 
--- a/fs/overlayfs/super.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/overlayfs/super.c
@@ -174,7 +174,7 @@ static struct kmem_cache *ovl_inode_cach
 
 static struct inode *ovl_alloc_inode(struct super_block *sb)
 {
-	struct ovl_inode *oi = kmem_cache_alloc(ovl_inode_cachep, GFP_KERNEL);
+	struct ovl_inode *oi = alloc_inode_sb(sb, ovl_inode_cachep, GFP_KERNEL);
 
 	if (!oi)
 		return NULL;
--- a/fs/proc/inode.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/proc/inode.c
@@ -66,7 +66,7 @@ static struct inode *proc_alloc_inode(st
 {
 	struct proc_inode *ei;
 
-	ei = kmem_cache_alloc(proc_inode_cachep, GFP_KERNEL);
+	ei = alloc_inode_sb(sb, proc_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	ei->pid = NULL;
--- a/fs/qnx4/inode.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/qnx4/inode.c
@@ -338,7 +338,7 @@ static struct kmem_cache *qnx4_inode_cac
 static struct inode *qnx4_alloc_inode(struct super_block *sb)
 {
 	struct qnx4_inode_info *ei;
-	ei = kmem_cache_alloc(qnx4_inode_cachep, GFP_KERNEL);
+	ei = alloc_inode_sb(sb, qnx4_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	return &ei->vfs_inode;
--- a/fs/qnx6/inode.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/qnx6/inode.c
@@ -597,7 +597,7 @@ static struct kmem_cache *qnx6_inode_cac
 static struct inode *qnx6_alloc_inode(struct super_block *sb)
 {
 	struct qnx6_inode_info *ei;
-	ei = kmem_cache_alloc(qnx6_inode_cachep, GFP_KERNEL);
+	ei = alloc_inode_sb(sb, qnx6_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	return &ei->vfs_inode;
--- a/fs/reiserfs/super.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/reiserfs/super.c
@@ -639,7 +639,7 @@ static struct kmem_cache *reiserfs_inode
 static struct inode *reiserfs_alloc_inode(struct super_block *sb)
 {
 	struct reiserfs_inode_info *ei;
-	ei = kmem_cache_alloc(reiserfs_inode_cachep, GFP_KERNEL);
+	ei = alloc_inode_sb(sb, reiserfs_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	atomic_set(&ei->openers, 0);
--- a/fs/romfs/super.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/romfs/super.c
@@ -375,7 +375,7 @@ static struct inode *romfs_alloc_inode(s
 {
 	struct romfs_inode_info *inode;
 
-	inode = kmem_cache_alloc(romfs_inode_cachep, GFP_KERNEL);
+	inode = alloc_inode_sb(sb, romfs_inode_cachep, GFP_KERNEL);
 	return inode ? &inode->vfs_inode : NULL;
 }
 
--- a/fs/squashfs/super.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/squashfs/super.c
@@ -584,7 +584,7 @@ static void __exit exit_squashfs_fs(void
 static struct inode *squashfs_alloc_inode(struct super_block *sb)
 {
 	struct squashfs_inode_info *ei =
-		kmem_cache_alloc(squashfs_inode_cachep, GFP_KERNEL);
+		alloc_inode_sb(sb, squashfs_inode_cachep, GFP_KERNEL);
 
 	return ei ? &ei->vfs_inode : NULL;
 }
--- a/fs/sysv/inode.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/sysv/inode.c
@@ -306,7 +306,7 @@ static struct inode *sysv_alloc_inode(st
 {
 	struct sysv_inode_info *si;
 
-	si = kmem_cache_alloc(sysv_inode_cachep, GFP_KERNEL);
+	si = alloc_inode_sb(sb, sysv_inode_cachep, GFP_KERNEL);
 	if (!si)
 		return NULL;
 	return &si->vfs_inode;
--- a/fs/ubifs/super.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/ubifs/super.c
@@ -268,7 +268,7 @@ static struct inode *ubifs_alloc_inode(s
 {
 	struct ubifs_inode *ui;
 
-	ui = kmem_cache_alloc(ubifs_inode_slab, GFP_NOFS);
+	ui = alloc_inode_sb(sb, ubifs_inode_slab, GFP_NOFS);
 	if (!ui)
 		return NULL;
 
--- a/fs/udf/super.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/udf/super.c
@@ -136,7 +136,7 @@ static struct kmem_cache *udf_inode_cach
 static struct inode *udf_alloc_inode(struct super_block *sb)
 {
 	struct udf_inode_info *ei;
-	ei = kmem_cache_alloc(udf_inode_cachep, GFP_KERNEL);
+	ei = alloc_inode_sb(sb, udf_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 
--- a/fs/ufs/super.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/ufs/super.c
@@ -1443,7 +1443,7 @@ static struct inode *ufs_alloc_inode(str
 {
 	struct ufs_inode_info *ei;
 
-	ei = kmem_cache_alloc(ufs_inode_cachep, GFP_NOFS);
+	ei = alloc_inode_sb(sb, ufs_inode_cachep, GFP_NOFS);
 	if (!ei)
 		return NULL;
 
--- a/fs/vboxsf/super.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/vboxsf/super.c
@@ -241,7 +241,7 @@ static struct inode *vboxsf_alloc_inode(
 {
 	struct vboxsf_inode *sf_i;
 
-	sf_i = kmem_cache_alloc(vboxsf_inode_cachep, GFP_NOFS);
+	sf_i = alloc_inode_sb(sb, vboxsf_inode_cachep, GFP_NOFS);
 	if (!sf_i)
 		return NULL;
 
--- a/fs/xfs/xfs_icache.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/xfs/xfs_icache.c
@@ -77,7 +77,7 @@ xfs_inode_alloc(
 	 * XXX: If this didn't occur in transactions, we could drop GFP_NOFAIL
 	 * and return NULL here on ENOMEM.
 	 */
-	ip = kmem_cache_alloc(xfs_inode_cache, GFP_KERNEL | __GFP_NOFAIL);
+	ip = alloc_inode_sb(mp->m_super, xfs_inode_cache, GFP_KERNEL | __GFP_NOFAIL);
 
 	if (inode_init_always(mp->m_super, VFS_I(ip))) {
 		kmem_cache_free(xfs_inode_cache, ip);
--- a/fs/zonefs/super.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/zonefs/super.c
@@ -1137,7 +1137,7 @@ static struct inode *zonefs_alloc_inode(
 {
 	struct zonefs_inode_info *zi;
 
-	zi = kmem_cache_alloc(zonefs_inode_cachep, GFP_KERNEL);
+	zi = alloc_inode_sb(sb, zonefs_inode_cachep, GFP_KERNEL);
 	if (!zi)
 		return NULL;
 
--- a/ipc/mqueue.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/ipc/mqueue.c
@@ -486,7 +486,7 @@ static struct inode *mqueue_alloc_inode(
 {
 	struct mqueue_inode_info *ei;
 
-	ei = kmem_cache_alloc(mqueue_inode_cachep, GFP_KERNEL);
+	ei = alloc_inode_sb(sb, mqueue_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	return &ei->vfs_inode;
--- a/mm/shmem.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/mm/shmem.c
@@ -3708,7 +3708,7 @@ static struct kmem_cache *shmem_inode_ca
 static struct inode *shmem_alloc_inode(struct super_block *sb)
 {
 	struct shmem_inode_info *info;
-	info = kmem_cache_alloc(shmem_inode_cachep, GFP_KERNEL);
+	info = alloc_inode_sb(sb, shmem_inode_cachep, GFP_KERNEL);
 	if (!info)
 		return NULL;
 	return &info->vfs_inode;
--- a/net/socket.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/net/socket.c
@@ -301,7 +301,7 @@ static struct inode *sock_alloc_inode(st
 {
 	struct socket_alloc *ei;
 
-	ei = kmem_cache_alloc(sock_inode_cachep, GFP_KERNEL);
+	ei = alloc_inode_sb(sb, sock_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	init_waitqueue_head(&ei->socket.wq.wait);
--- a/net/sunrpc/rpc_pipe.c~fs-allocate-inode-by-using-alloc_inode_sb
+++ a/net/sunrpc/rpc_pipe.c
@@ -197,7 +197,7 @@ static struct inode *
 rpc_alloc_inode(struct super_block *sb)
 {
 	struct rpc_inode *rpci;
-	rpci = kmem_cache_alloc(rpc_inode_cachep, GFP_KERNEL);
+	rpci = alloc_inode_sb(sb, rpc_inode_cachep, GFP_KERNEL);
 	if (!rpci)
 		return NULL;
 	return &rpci->vfs_inode;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


