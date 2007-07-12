From: akpm@linux-foundation.org
Subject: + file-capabilities-clear-caps-cleanup.patch added to -mm tree
Date: Wed, 11 Jul 2007 17:39:54 -0700
Message-ID: <200707120039.l6C0dsxJ030600@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55918 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936949AbXGLAkS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jul 2007 20:40:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, casey@schaufler-ca.com, chrisw@sous-sol.org, jmorris@namei.org, kaigai@kaigai.gr.jp, morgan@kernel.org, sds@tycho.nsa.gov


The patch titled
     file capabilities: clear caps cleanup
has been added to the -mm tree.  Its filename is
     file-capabilities-clear-caps-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: file capabilities: clear caps cleanup
From: "Serge E. Hallyn" <serue@us.ibm.com>

As suggested by Steve Beattie, rather than jump into a conditional block in
certain cases, define and use a static inline bprm_clear_caps().

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Acked-by: Andrew Morgan <morgan@kernel.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: KaiGai Kohei <kaigai@kaigai.gr.jp>
Acked-by: James Morris <jmorris@namei.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/commoncap.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff -puN security/commoncap.c~file-capabilities-clear-caps-cleanup security/commoncap.c
--- a/security/commoncap.c~file-capabilities-clear-caps-cleanup
+++ a/security/commoncap.c
@@ -109,6 +109,13 @@ void cap_capset_set (struct task_struct 
 	target->cap_permitted = *permitted;
 }
 
+static inline void bprm_clear_caps(struct linux_binprm *bprm)
+{
+	cap_clear (bprm->cap_inheritable);
+	cap_clear (bprm->cap_permitted);
+	cap_clear (bprm->cap_effective);
+}
+
 #ifdef CONFIG_SECURITY_FILE_CAPABILITIES
 
 static inline int cap_from_disk(struct vfs_cap_data_disk *dcap,
@@ -144,8 +151,10 @@ static int get_file_caps(struct linux_bi
 	struct inode *inode;
 
 	dcaps = (struct vfs_cap_data_disk *)&v1caps;
-	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID)
-		goto clear_caps;
+	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID) {
+		bprm_clear_caps(bprm);
+		return 0;
+	}
 
 	dentry = dget(bprm->file->f_dentry);
 	inode = dentry->d_inode;
@@ -186,21 +195,16 @@ out:
 	dput(dentry);
 	if ((void *)dcaps != (void *)&v1caps)
 		kfree(dcaps);
-	if (rc) {
-clear_caps:
-		cap_clear (bprm->cap_inheritable);
-		cap_clear (bprm->cap_permitted);
-		cap_clear (bprm->cap_effective);
-	}
+	if (rc)
+		bprm_clear_caps(bprm);
+
 	return rc;
 }
 
 #else
 static inline int get_file_caps(struct linux_binprm *bprm)
 {
-	cap_clear (bprm->cap_inheritable);
-	cap_clear (bprm->cap_permitted);
-	cap_clear (bprm->cap_effective);
+	bprm_clear_caps(bprm);
 	return 0;
 }
 #endif
_

Patches currently in -mm which might be from serue@us.ibm.com are

implement-file-posix-capabilities.patch
implement-file-posix-capabilities-fix.patch
file-capabilities-introduce-cap_setfcap.patch
file-capabilities-get_file_caps-cleanups.patch
file-caps-update-selinux-xattr-hooks.patch
file-capabilities-clear-caps-cleanup.patch
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
