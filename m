From: akpm@linux-foundation.org
Subject: + fs-affs-make-export-work-with-cold-dcache.patch added to -mm
 tree
Date: Wed, 18 Jan 2017 13:44:41 -0800
Message-ID: <587fe1c9.92/QhDEyCD28GTaQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37884 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752406AbdARVom (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2017 16:44:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs: make export work with cold dcache
has been added to the -mm tree.  Its filename is
     fs-affs-make-export-work-with-cold-dcache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-affs-make-export-work-with-cold-dcache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-affs-make-export-work-with-cold-dcache.patch

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
Subject: fs/affs: make export work with cold dcache

This adds get_parent function so that nfs client can still work after
cache drop (Tested on NFS v4 with echo 3 > /proc/sys/vm/drop_caches)

Link: http://lkml.kernel.org/r/20170109191208.6085-8-fabf@skynet.be
Signed-off-by: Fabian Frederick <fabf@skynet.be>
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
+	if (IS_ERR(bh))
+		return ERR_CAST(bh);
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

documentation-filesystems-proctxt-add-vmpin.patch
fs-affs-remove-reference-to-affs_parent_ino.patch
fs-affs-add-validation-block-function.patch
fs-affs-make-affs-exportable.patch
fs-affs-use-octal-for-permissions.patch
fs-affs-add-prefix-to-some-functions.patch
fs-affs-nameic-forward-declarations-clean-up.patch
fs-affs-make-export-work-with-cold-dcache.patch
fs-add-i_blocksize.patch

