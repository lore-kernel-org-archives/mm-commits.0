From: akpm@linux-foundation.org
Subject: + gfs2-possible-null-pointer-dereference-fixup.patch added to -mm tree
Date: Tue, 04 Mar 2008 01:28:40 -0800
Message-ID: <200803040928.m249SeLU001339@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41231 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754858AbYCDJ37 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 04:29:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, gorcunov@gamil.com, swhiteho@redhat.com


The patch titled
     GFS2: possible null pointer dereference fixup
has been added to the -mm tree.  Its filename is
     gfs2-possible-null-pointer-dereference-fixup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: GFS2: possible null pointer dereference fixup
From: Cyrill Gorcunov <gorcunov@gmail.com>

gfs2_alloc_get may fail so we have to check it to prevent NULL pointer
dereference.

Signed-off-by: Cyrill Gorcunov <gorcunov@gamil.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/bmap.c        |    5 ++++-
 fs/gfs2/dir.c         |   10 +++++++---
 fs/gfs2/eattr.c       |    6 ++++++
 fs/gfs2/inode.c       |    7 ++++++-
 fs/gfs2/ops_address.c |    4 ++++
 fs/gfs2/ops_inode.c   |   11 ++++++++++-
 fs/gfs2/quota.c       |    9 +++++++--
 7 files changed, 44 insertions(+), 8 deletions(-)

diff -puN fs/gfs2/bmap.c~gfs2-possible-null-pointer-dereference-fixup fs/gfs2/bmap.c
--- a/fs/gfs2/bmap.c~gfs2-possible-null-pointer-dereference-fixup
+++ a/fs/gfs2/bmap.c
@@ -900,6 +900,8 @@ static int do_grow(struct gfs2_inode *ip
 	int error;
 
 	al = gfs2_alloc_get(ip);
+	if (!al)
+		return -ENOMEM;
 
 	error = gfs2_quota_lock(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 	if (error)
@@ -1081,7 +1083,8 @@ static int trunc_dealloc(struct gfs2_ino
 		lblock = (size - 1) >> sdp->sd_sb.sb_bsize_shift;
 
 	find_metapath(sdp, lblock, &mp, ip->i_height);
-	gfs2_alloc_get(ip);
+	if (!gfs2_alloc_get(ip))
+		return -ENOMEM;
 
 	error = gfs2_quota_hold(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 	if (error)
diff -puN fs/gfs2/dir.c~gfs2-possible-null-pointer-dereference-fixup fs/gfs2/dir.c
--- a/fs/gfs2/dir.c~gfs2-possible-null-pointer-dereference-fixup
+++ a/fs/gfs2/dir.c
@@ -1868,11 +1868,14 @@ static int leaf_dealloc(struct gfs2_inod
 	if (!ht)
 		return -ENOMEM;
 
-	gfs2_alloc_get(dip);
+	if (!gfs2_alloc_get(dip)) {
+		error = -ENOMEM;
+		goto out;
+	}
 
 	error = gfs2_quota_hold(dip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 	if (error)
-		goto out;
+		goto out_put;
 
 	error = gfs2_rindex_hold(sdp, &dip->i_alloc->al_ri_gh);
 	if (error)
@@ -1946,8 +1949,9 @@ out_rlist:
 	gfs2_glock_dq_uninit(&dip->i_alloc->al_ri_gh);
 out_qs:
 	gfs2_quota_unhold(dip);
-out:
+out_put:
 	gfs2_alloc_put(dip);
+out:
 	kfree(ht);
 	return error;
 }
diff -puN fs/gfs2/eattr.c~gfs2-possible-null-pointer-dereference-fixup fs/gfs2/eattr.c
--- a/fs/gfs2/eattr.c~gfs2-possible-null-pointer-dereference-fixup
+++ a/fs/gfs2/eattr.c
@@ -318,6 +318,8 @@ static int ea_remove_unstuffed(struct gf
 	int error;
 
 	al = gfs2_alloc_get(ip);
+	if (!al)
+		return -ENOMEM;
 
 	error = gfs2_quota_hold(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 	if (error)
@@ -681,6 +683,8 @@ static int ea_alloc_skeleton(struct gfs2
 	int error;
 
 	al = gfs2_alloc_get(ip);
+	if (!al)
+		return -ENOMEM;
 
 	error = gfs2_quota_lock(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 	if (error)
@@ -1464,6 +1468,8 @@ int gfs2_ea_dealloc(struct gfs2_inode *i
 	int error;
 
 	al = gfs2_alloc_get(ip);
+	if (!al)
+		return -ENOMEM;
 
 	error = gfs2_quota_hold(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 	if (error)
diff -puN fs/gfs2/inode.c~gfs2-possible-null-pointer-dereference-fixup fs/gfs2/inode.c
--- a/fs/gfs2/inode.c~gfs2-possible-null-pointer-dereference-fixup
+++ a/fs/gfs2/inode.c
@@ -351,6 +351,8 @@ int gfs2_dinode_dealloc(struct gfs2_inod
 	}
 
 	al = gfs2_alloc_get(ip);
+	if (!al)
+		return -ENOMEM;
 
 	error = gfs2_quota_hold(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 	if (error)
@@ -825,7 +827,8 @@ static int make_dinode(struct gfs2_inode
 	int error;
 
 	munge_mode_uid_gid(dip, &mode, &uid, &gid);
-	gfs2_alloc_get(dip);
+	if (!gfs2_alloc_get(dip))
+		return -ENOMEM;
 
 	error = gfs2_quota_lock(dip, uid, gid);
 	if (error)
@@ -860,6 +863,8 @@ static int link_dinode(struct gfs2_inode
 	int error;
 
 	al = gfs2_alloc_get(dip);
+	if (!al)
+		return -ENOMEM;
 
 	error = gfs2_quota_lock(dip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 	if (error)
diff -puN fs/gfs2/ops_address.c~gfs2-possible-null-pointer-dereference-fixup fs/gfs2/ops_address.c
--- a/fs/gfs2/ops_address.c~gfs2-possible-null-pointer-dereference-fixup
+++ a/fs/gfs2/ops_address.c
@@ -649,6 +649,10 @@ static int gfs2_write_begin(struct file 
 
 	if (alloc_required) {
 		al = gfs2_alloc_get(ip);
+		if (!al) {
+			error = -ENOMEM;
+			goto out_unlock;
+		}
 
 		error = gfs2_quota_lock(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 		if (error)
diff -puN fs/gfs2/ops_inode.c~gfs2-possible-null-pointer-dereference-fixup fs/gfs2/ops_inode.c
--- a/fs/gfs2/ops_inode.c~gfs2-possible-null-pointer-dereference-fixup
+++ a/fs/gfs2/ops_inode.c
@@ -200,6 +200,10 @@ static int gfs2_link(struct dentry *old_
 
 	if (alloc_required) {
 		struct gfs2_alloc *al = gfs2_alloc_get(dip);
+		if (!al) {
+			error = -ENOMEM;
+			goto out_gunlock;
+		}
 
 		error = gfs2_quota_lock(dip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 		if (error)
@@ -716,6 +720,10 @@ static int gfs2_rename(struct inode *odi
 
 	if (alloc_required) {
 		struct gfs2_alloc *al = gfs2_alloc_get(ndip);
+		if (!al) {
+			error = -ENOMEM;
+			goto out_gunlock;
+		}
 
 		error = gfs2_quota_lock(ndip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 		if (error)
@@ -953,7 +961,8 @@ static int setattr_chown(struct inode *i
 	if (!(attr->ia_valid & ATTR_GID) || ogid == ngid)
 		ogid = ngid = NO_QUOTA_CHANGE;
 
-	gfs2_alloc_get(ip);
+	if (!gfs2_alloc_get(ip))
+		return -ENOMEM;
 
 	error = gfs2_quota_lock(ip, nuid, ngid);
 	if (error)
diff -puN fs/gfs2/quota.c~gfs2-possible-null-pointer-dereference-fixup fs/gfs2/quota.c
--- a/fs/gfs2/quota.c~gfs2-possible-null-pointer-dereference-fixup
+++ a/fs/gfs2/quota.c
@@ -617,8 +617,9 @@ static int gfs2_adjust_quota(struct gfs2
 	int err = -EIO;
 
 	if (gfs2_is_stuffed(ip)) {
-		struct gfs2_alloc *al = NULL;
-		al = gfs2_alloc_get(ip);
+		struct gfs2_alloc *al = gfs2_alloc_get(ip);
+		if (!al)
+			return -ENOMEM;
 		/* just request 1 blk */
 		al->al_requested = 1;
 		gfs2_inplace_reserve(ip);
@@ -729,6 +730,10 @@ static int do_sync(unsigned int num_qd, 
 
 	if (nalloc) {
 		al = gfs2_alloc_get(ip);
+		if (!al) {
+			error = -ENOMEM;
+			goto out_gunlock;
+		}
 
 		al->al_requested = nalloc * (data_blocks + ind_blocks);
 
_

Patches currently in -mm which might be from gorcunov@gmail.com are

git-avr32.patch
gfs2-possible-null-pointer-dereference-fixup.patch
m32r-cleanup-drop-dataidt-section-in-vmlinuxlds-script.patch
slub-fix-possible-null-pointer-dereference.patch
slub-fix-possible-null-pointer-dereference-fix.patch
elf-use-ei_nident-instead-of-numeric-value.patch
binfmt-fill_elf_header-cleanup-use-straight-memset-first.patch

