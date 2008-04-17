From: akpm@linux-foundation.org
Subject: + nfs-lsm-make-nfsv4-set-lsm-mount-options.patch added to -mm tree
Date: Thu, 17 Apr 2008 14:04:33 -0700
Message-ID: <200804172104.m3HL4XS1027884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34383 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753755AbYDQVFS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Apr 2008 17:05:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eparis@redhat.com, bfields@fieldses.org, casey@schaufler-ca.com, jmorris@namei.org, sds@tycho.nsa.gov, trond.myklebust@fys.uio.no


The patch titled
     nfs/lsm: make NFSv4 set LSM mount options
has been added to the -mm tree.  Its filename is
     nfs-lsm-make-nfsv4-set-lsm-mount-options.patch

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
Subject: nfs/lsm: make NFSv4 set LSM mount options
From: Eric Paris <eparis@redhat.com>

NFSv3 get_sb operations call into the LSM layer to set security options passed
from userspace.  NFSv4 hooks were not originally added since it was reasonably
late in the merge window and NFSv3 was the only thing that had regressed (v4
has never supported any LSM options)

This patch makes NFSv4 call into the LSM to set security options rather than
just blindly dropping them with no notice to the user as happens today.  This
patch was tested in a simple NFSv4 environment with the context= option and
appeared to work as expected.

Signed-off-by: Eric Paris <eparis@redhat.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/super.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN fs/nfs/super.c~nfs-lsm-make-nfsv4-set-lsm-mount-options fs/nfs/super.c
--- a/fs/nfs/super.c~nfs-lsm-make-nfsv4-set-lsm-mount-options
+++ a/fs/nfs/super.c
@@ -2000,6 +2000,10 @@ static int nfs4_get_sb(struct file_syste
 		goto error_splat_super;
 	}
 
+	error = security_sb_set_mnt_opts(s, &data.lsm_opts);
+	if (error)
+		goto error_splat_root;
+
 	s->s_flags |= MS_ACTIVE;
 	mnt->mnt_sb = s;
 	mnt->mnt_root = mntroot;
@@ -2016,6 +2020,8 @@ out_free:
 	nfs_free_server(server);
 	goto out;
 
+error_splat_root:
+	dput(mntroot);
 error_splat_super:
 	up_write(&s->s_umount);
 	deactivate_super(s);
@@ -2095,6 +2101,8 @@ static int nfs4_xdev_get_sb(struct file_
 	mnt->mnt_sb = s;
 	mnt->mnt_root = mntroot;
 
+	security_sb_clone_mnt_opts(data->sb, s);
+
 	dprintk("<-- nfs4_xdev_get_sb() = 0\n");
 	return 0;
 
@@ -2174,6 +2182,8 @@ static int nfs4_referral_get_sb(struct f
 	mnt->mnt_sb = s;
 	mnt->mnt_root = mntroot;
 
+	security_sb_clone_mnt_opts(data->sb, s);
+
 	dprintk("<-- nfs4_referral_get_sb() = 0\n");
 	return 0;
 
_

Patches currently in -mm which might be from eparis@redhat.com are

nfs-lsm-make-nfsv4-set-lsm-mount-options.patch
git-selinux.patch
signals-cleanup-security_task_kill-usage-implementation.patch

