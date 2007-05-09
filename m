From: akpm@linux-foundation.org
Subject: - knfsd-avoid-oops-if-buggy-userspace-performs-confusing-filehandle-dentry-mapping.patch removed from -mm tree
Date: Wed, 09 May 2007 14:53:23 -0700
Message-ID: <200705092153.l49LrN2g003081@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37393 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759182AbXEIVxn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:53:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: avoid Oops if buggy userspace performs confusing filehandle->dentry mapping
has been removed from the -mm tree.  Its filename was
     knfsd-avoid-oops-if-buggy-userspace-performs-confusing-filehandle-dentry-mapping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: avoid Oops if buggy userspace performs confusing filehandle->dentry mapping
From: NeilBrown <neilb@suse.de>

When a lookup request arrives, nfsd uses information provided by userspace
(mountd) to find the right filesystem.

It then assumes that the same filehandle type as the incoming filehandle can
be used to create an outgoing filehandle.

However if mountd is buggy, or maybe just being creative, the filesystem may
not support that filesystem type, and the kernel could oops, particularly if
'ex_uuid' is NULL but a FSID_UUID* filehandle type is used.

So add some proper checking that the fsid version/type from the incoming
filehandle is actually supportable, and ignore that information if it isn't
supportable.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfsfh.c |   56 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 50 insertions(+), 6 deletions(-)

diff -puN fs/nfsd/nfsfh.c~knfsd-avoid-oops-if-buggy-userspace-performs-confusing-filehandle-dentry-mapping fs/nfsd/nfsfh.c
--- a/fs/nfsd/nfsfh.c~knfsd-avoid-oops-if-buggy-userspace-performs-confusing-filehandle-dentry-mapping
+++ a/fs/nfsd/nfsfh.c
@@ -323,7 +323,7 @@ fh_compose(struct svc_fh *fhp, struct sv
 	 *
 	 */
 
-	u8 version = 1;
+	u8 version;
 	u8 fsid_type = 0;
 	struct inode * inode = dentry->d_inode;
 	struct dentry *parent = dentry->d_parent;
@@ -341,15 +341,59 @@ fh_compose(struct svc_fh *fhp, struct sv
 	 * the reference filehandle (if it is in the same export)
 	 * or the export options.
 	 */
+ retry:
+	version = 1;
 	if (ref_fh && ref_fh->fh_export == exp) {
 		version = ref_fh->fh_handle.fh_version;
-		if (version == 0xca)
+		fsid_type = ref_fh->fh_handle.fh_fsid_type;
+
+		if (ref_fh == fhp)
+			fh_put(ref_fh);
+		ref_fh = NULL;
+
+		switch (version) {
+		case 0xca:
 			fsid_type = FSID_DEV;
-		else
-			fsid_type = ref_fh->fh_handle.fh_fsid_type;
-		/* We know this version/type works for this export
-		 * so there is no need for further checks.
+			break;
+		case 1:
+			break;
+		default:
+			goto retry;
+		}
+
+		/* Need to check that this type works for this
+		 * export point.  As the fsid -> filesystem mapping
+		 * was guided by user-space, there is no guarantee
+		 * that the filesystem actually supports that fsid
+		 * type. If it doesn't we loop around again without
+		 * ref_fh set.
 		 */
+		switch(fsid_type) {
+		case FSID_DEV:
+			if (!old_valid_dev(ex_dev))
+				goto retry;
+			/* FALL THROUGH */
+		case FSID_MAJOR_MINOR:
+		case FSID_ENCODE_DEV:
+			if (!(exp->ex_dentry->d_inode->i_sb->s_type->fs_flags
+			      & FS_REQUIRES_DEV))
+				goto retry;
+			break;
+		case FSID_NUM:
+			if (! (exp->ex_flags & NFSEXP_FSID))
+				goto retry;
+			break;
+		case FSID_UUID8:
+		case FSID_UUID16:
+			if (!root_export)
+				goto retry;
+			/* fall through */
+		case FSID_UUID4_INUM:
+		case FSID_UUID16_INUM:
+			if (exp->ex_uuid == NULL)
+				goto retry;
+			break;
+		}
 	} else if (exp->ex_uuid) {
 		if (fhp->fh_maxsize >= 64) {
 			if (root_export)
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
introduce-freezer-flags-rev-2.patch
git-md-accel.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
