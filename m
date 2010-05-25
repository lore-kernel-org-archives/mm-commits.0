From: akpm@linux-foundation.org
Subject: + fs-ceph-use-err_cast.patch added to -mm tree
Date: Tue, 25 May 2010 15:56:34 -0700
Message-ID: <201005252256.o4PMuYmE019936@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756659Ab0EYW4l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 May 2010 18:56:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, sage@newdream.net, yehuda@hq.newdream.net


The patch titled
     fs/ceph: use ERR_CAST
has been added to the -mm tree.  Its filename is
     fs-ceph-use-err_cast.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/ceph: use ERR_CAST
From: Julia Lawall <julia@diku.dk>

Use ERR_CAST(x) rather than ERR_PTR(PTR_ERR(x)).  The former makes more
clear what is the purpose of the operation, which otherwise looks like a
no-op.

In the case of fs/ceph/inode.c, ERR_CAST is not needed, because the type of
the returned value is the same as the type of the enclosing function.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
T x;
identifier f;
@@

T f (...) { <+...
- ERR_PTR(PTR_ERR(x))
+ x
 ...+> }

@@
expression x;
@@

- ERR_PTR(PTR_ERR(x))
+ ERR_CAST(x)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Sage Weil <sage@newdream.net>
Cc: Yehuda Sadeh <yehuda@hq.newdream.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ceph/dir.c    |    2 +-
 fs/ceph/export.c |    2 +-
 fs/ceph/file.c   |    2 +-
 fs/ceph/inode.c  |    2 +-
 fs/ceph/osdmap.c |    2 +-
 fs/ceph/super.c  |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/ceph/dir.c~fs-ceph-use-err_cast fs/ceph/dir.c
--- a/fs/ceph/dir.c~fs-ceph-use-err_cast
+++ a/fs/ceph/dir.c
@@ -587,7 +587,7 @@ static struct dentry *ceph_lookup(struct
 		CEPH_MDS_OP_LOOKUPSNAP : CEPH_MDS_OP_LOOKUP;
 	req = ceph_mdsc_create_request(mdsc, op, USE_ANY_MDS);
 	if (IS_ERR(req))
-		return ERR_PTR(PTR_ERR(req));
+		return ERR_CAST(req);
 	req->r_dentry = dget(dentry);
 	req->r_num_caps = 2;
 	/* we only need inode linkage */
diff -puN fs/ceph/export.c~fs-ceph-use-err_cast fs/ceph/export.c
--- a/fs/ceph/export.c~fs-ceph-use-err_cast
+++ a/fs/ceph/export.c
@@ -133,7 +133,7 @@ static struct dentry *__cfh_to_dentry(st
 		req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPHASH,
 					       USE_ANY_MDS);
 		if (IS_ERR(req))
-			return ERR_PTR(PTR_ERR(req));
+			return ERR_CAST(req);
 
 		req->r_ino1 = vino;
 		req->r_ino2.ino = cfh->parent_ino;
diff -puN fs/ceph/file.c~fs-ceph-use-err_cast fs/ceph/file.c
--- a/fs/ceph/file.c~fs-ceph-use-err_cast
+++ a/fs/ceph/file.c
@@ -230,7 +230,7 @@ struct dentry *ceph_lookup_open(struct i
 	/* do the open */
 	req = prepare_open_request(dir->i_sb, flags, mode);
 	if (IS_ERR(req))
-		return ERR_PTR(PTR_ERR(req));
+		return ERR_CAST(req);
 	req->r_dentry = dget(dentry);
 	req->r_num_caps = 2;
 	if (flags & O_CREAT) {
diff -puN fs/ceph/inode.c~fs-ceph-use-err_cast fs/ceph/inode.c
--- a/fs/ceph/inode.c~fs-ceph-use-err_cast
+++ a/fs/ceph/inode.c
@@ -69,7 +69,7 @@ struct inode *ceph_get_snapdir(struct in
 
 	BUG_ON(!S_ISDIR(parent->i_mode));
 	if (IS_ERR(inode))
-		return ERR_PTR(PTR_ERR(inode));
+		return inode;
 	inode->i_mode = parent->i_mode;
 	inode->i_uid = parent->i_uid;
 	inode->i_gid = parent->i_gid;
diff -puN fs/ceph/osdmap.c~fs-ceph-use-err_cast fs/ceph/osdmap.c
--- a/fs/ceph/osdmap.c~fs-ceph-use-err_cast
+++ a/fs/ceph/osdmap.c
@@ -719,7 +719,7 @@ struct ceph_osdmap *osdmap_apply_increme
 		     len, *p, end);
 		newcrush = crush_decode(*p, min(*p+len, end));
 		if (IS_ERR(newcrush))
-			return ERR_PTR(PTR_ERR(newcrush));
+			return ERR_CAST(newcrush);
 	}
 
 	/* new flags? */
diff -puN fs/ceph/super.c~fs-ceph-use-err_cast fs/ceph/super.c
--- a/fs/ceph/super.c~fs-ceph-use-err_cast
+++ a/fs/ceph/super.c
@@ -810,7 +810,7 @@ static struct dentry *open_root_dentry(s
 	dout("open_root_inode opening '%s'\n", path);
 	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, USE_ANY_MDS);
 	if (IS_ERR(req))
-		return ERR_PTR(PTR_ERR(req));
+		return ERR_CAST(req);
 	req->r_path1 = kstrdup(path, GFP_NOFS);
 	req->r_ino1.ino = CEPH_INO_ROOT;
 	req->r_ino1.snap = CEPH_NOSNAP;
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-scsi-aacraid-eliminate-use-after-free.patch
arch-x86-pci-use-kasprintf.patch
fs-btrfs-use-memdup_user.patch
drivers-media-use-memdup_user.patch
drivers-i2c-use-memdup_user.patch
drivers-ieee1394-use-memdup_user.patch
drivers-infiniband-core-use-memdup_user.patch
drivers-ide-use-memdup_user.patch
drivers-isdn-use-memdup_user.patch
net-can-use-memdup_user.patch
net-dccp-use-memdup_user.patch
drivers-net-use-memdup_user.patch
drivers-net-cxgb3-use-memdup_user.patch
drivers-net-wan-use-memdup_user.patch
drivers-net-wireless-prism54-use-memdup_user.patch
drivers-s390-net-use-memdup_user.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-use-memdup_user.patch
drivers-block-use-memdup_user.patch
drivers-staging-dream-camera-use-memdup_user.patch
drivers-usb-gadget-use-memdup_user.patch
mm-use-memdup_user.patch
drivers-char-vtc-use-memdup_user.patch
drivers-message-i2o-i2o_configc-use-memdup_user.patch
fs-autofs4-use-memdup_user.patch
drivers-video-via-use-memdup_user.patch
drivers-telephony-ixjc-use-memdup_user.patch
drivers-char-ppdevc-use-kasprintf.patch
drivers-char-applicomc-use-memdup_user.patch
ipc-semc-use-err_cast.patch
crypto-use-err_cast.patch
drivers-mmc-host-use-err_cast.patch
fs-ubifs-use-err_cast.patch
fs-btrfs-use-err_cast.patch
mm-use-err_cast.patch
fs-ceph-use-err_cast.patch
fs-affs-use-err_cast.patch

