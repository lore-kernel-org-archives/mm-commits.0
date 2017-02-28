From: akpm@linux-foundation.org
Subject: [merged] fs-affs-make-export-work-with-cold-dcache.patch removed
 from -mm tree
Date: Tue, 28 Feb 2017 12:50:29 -0800
Message-ID: <58b5e295.N1dDWJUVy7gUQcKs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52710 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751804AbdB1Uvd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 15:51:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, viro@zeniv.linux.org.uk, weiyongjun1@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs: make export work with cold dcache
has been removed from the -mm tree.  Its filename was
     fs-affs-make-export-work-with-cold-dcache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs: make export work with cold dcache

This adds get_parent function so that nfs client can still work after
cache drop (Tested on NFS v4 with echo 3 > /proc/sys/vm/drop_caches)

[weiyongjun1@huawei.com: fix return value check in affs_get_parent()]
  Link: http://lkml.kernel.org/r/20170123141018.2331-1-weiyj.lk@gmail.com
Link: http://lkml.kernel.org/r/20170109191208.6085-8-fabf@skynet.be
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Suggested-by: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/namei.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff -puN fs/affs/namei.c~fs-affs-make-export-work-with-cold-dcache fs/affs/namei.c
--- a/fs/affs/namei.c~fs-affs-make-export-work-with-cold-dcache
+++ a/fs/affs/namei.c
@@ -447,6 +447,24 @@ done:
 	return retval;
 }
 
+static struct dentry *affs_get_parent(struct dentry *child)
+{
+	struct inode *parent;
+	struct buffer_head *bh;
+
+	bh = affs_bread(child->d_sb, d_inode(child)->i_ino);
+	if (!bh)
+		return ERR_PTR(-EIO);
+
+	parent = affs_iget(child->d_sb,
+			   be32_to_cpu(AFFS_TAIL(child->d_sb, bh)->parent));
+	brelse(bh);
+	if (IS_ERR(parent))
+		return ERR_CAST(parent);
+
+	return d_obtain_alias(parent);
+}
+
 static struct inode *affs_nfs_get_inode(struct super_block *sb, u64 ino,
 					u32 generation)
 {
@@ -484,6 +502,7 @@ static struct dentry *affs_fh_to_parent(
 const struct export_operations affs_export_ops = {
 	.fh_to_dentry = affs_fh_to_dentry,
 	.fh_to_parent = affs_fh_to_parent,
+	.get_parent = affs_get_parent,
 };
 
 const struct dentry_operations affs_dentry_operations = {
_

Patches currently in -mm which might be from fabf@skynet.be are


