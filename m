From: akpm@linux-foundation.org
Subject: + file-capabilities-get_file_caps-cleanups.patch added to -mm tree
Date: Thu, 28 Jun 2007 15:36:14 -0700
Message-ID: <200706282236.l5SMaEDt003082@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44350 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762092AbXF1Wgj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jun 2007 18:36:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, casey@schaufler-ca.com, chrisw@sous-sol.org, jmorris@namei.org, kaigai@kaigai.gr.jp, morgan@kernel.org, sds@tycho.nsa.gov


The patch titled
     file capabilities: get_file_caps cleanups
has been added to the -mm tree.  Its filename is
     file-capabilities-get_file_caps-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: file capabilities: get_file_caps cleanups
From: Serge E. Hallyn <serue@us.ibm.com>

Two cleanups relating to set_file caps.

Rename set_file_caps to get_file_caps, since we are getting
the file capabilities, and setting the bprm caps to them.

Move the clearing of bprm caps into get_file_caps, and do it
only when we don't copy them from the capability xattr.

Changelog:
	Fix location of 'clear_caps' label.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andrew Morgan <morgan@kernel.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: KaiGai Kohei <kaigai@kaigai.gr.jp>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/commoncap.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff -puN security/commoncap.c~file-capabilities-get_file_caps-cleanups security/commoncap.c
--- a/security/commoncap.c~file-capabilities-get_file_caps-cleanups
+++ a/security/commoncap.c
@@ -135,21 +135,20 @@ static inline int cap_from_disk(struct v
 }
 
 /* Locate any VFS capabilities: */
-static int set_file_caps(struct linux_binprm *bprm)
+static int get_file_caps(struct linux_binprm *bprm)
 {
 	struct dentry *dentry;
-	int rc;
+	int rc = 0;
 	struct vfs_cap_data_disk_v1 v1caps;
 	struct vfs_cap_data_disk *dcaps;
 	struct inode *inode;
 
 	dcaps = (struct vfs_cap_data_disk *)&v1caps;
 	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID)
-		return 0;
+		goto clear_caps;
 
 	dentry = dget(bprm->file->f_dentry);
 	inode = dentry->d_inode;
-	rc = 0;
 	if (!inode->i_op || !inode->i_op->getxattr)
 		goto out;
 
@@ -187,12 +186,21 @@ out:
 	dput(dentry);
 	if ((void *)dcaps != (void *)&v1caps)
 		kfree(dcaps);
+	if (rc) {
+clear_caps:
+		cap_clear (bprm->cap_inheritable);
+		cap_clear (bprm->cap_permitted);
+		cap_clear (bprm->cap_effective);
+	}
 	return rc;
 }
 
 #else
-static inline int set_file_caps(struct linux_binprm *bprm)
+static inline int get_file_caps(struct linux_binprm *bprm)
 {
+	cap_clear (bprm->cap_inheritable);
+	cap_clear (bprm->cap_permitted);
+	cap_clear (bprm->cap_effective);
 	return 0;
 }
 #endif
@@ -201,13 +209,7 @@ int cap_bprm_set_security (struct linux_
 {
 	int ret;
 
-	/* Copied from fs/exec.c:prepare_binprm. */
-
-	cap_clear (bprm->cap_inheritable);
-	cap_clear (bprm->cap_permitted);
-	cap_clear (bprm->cap_effective);
-
-	ret = set_file_caps(bprm);
+	ret = get_file_caps(bprm);
 
 	/*  To support inheritance of root-permissions and suid-root
 	 *  executables under compatibility mode, we raise all three
_

Patches currently in -mm which might be from serue@us.ibm.com are

implement-file-posix-capabilities.patch
implement-file-posix-capabilities-fix.patch
file-capabilities-introduce-cap_setfcap.patch
file-capabilities-get_file_caps-cleanups.patch
remove-config_uts_ns-and-config_ipc_ns.patch
user-namespace-add-the-framework.patch
user-namespace-add-unshare.patch
mm-fix-create_new_namespaces-return-value.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
containersv10-basic-container-framework.patch
containersv10-basic-container-framework-fix.patch
containersv10-example-cpu-accounting-subsystem.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface.patch
containersv10-add-procfs-interface-fix.patch
containersv10-make-cpusets-a-client-of-containers.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
containersv10-simple-debug-info-subsystem.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
containersv10-support-for-automatic-userspace-release-agents.patch
containers-implement-subsys-post_clone.patch
containers-implement-namespace-tracking-subsystem-v3.patch
