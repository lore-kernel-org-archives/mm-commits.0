From: akpm@linux-foundation.org
Subject: - security-protect-legacy-applications-from-executing-with-insufficient-privilege.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:24:51 -0700
Message-ID: <200807242324.m6ONOpTx010817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40225 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755550AbYGXXZT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:25:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: morgan@kernel.org, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     security: protect legacy applications from executing with insufficient privilege
has been removed from the -mm tree.  Its filename was
     security-protect-legacy-applications-from-executing-with-insufficient-privilege.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: security: protect legacy applications from executing with insufficient privilege
From: Andrew G. Morgan <morgan@kernel.org>

When cap_bset suppresses some of the forced (fP) capabilities of a file,
it is generally only safe to execute the program if it understands how to
recognize it doesn't have enough privilege to work correctly.  For legacy
applications (fE!=0), which have no non-destructive way to determine that
they are missing privilege, we fail to execute (EPERM) any executable that
requires fP capabilities, but would otherwise get pP' < fP.  This is a
fail-safe permission check.

For some discussion of why it is problematic for (legacy) privileged
applications to run with less than the set of capabilities requested for
them, see:

 http://userweb.kernel.org/~morgan/sendmail-capabilities-war-story.html

With this iteration of this support, we do not include setuid-0 based
privilege protection from the bounding set.  That is, the admin can still
(ab)use the bounding set to suppress the privileges of a setuid-0 program.

[akpm@linux-foundation.org: coding-style fixes]
[akpm@linux-foundation.org: cleanup]
Signed-off-by: Andrew G. Morgan <morgan@kernel.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/binfmts.h |    2 
 security/commoncap.c    |  108 ++++++++++++++++++++------------------
 2 files changed, 60 insertions(+), 50 deletions(-)

diff -puN include/linux/binfmts.h~security-protect-legacy-applications-from-executing-with-insufficient-privilege include/linux/binfmts.h
--- a/include/linux/binfmts.h~security-protect-legacy-applications-from-executing-with-insufficient-privilege
+++ a/include/linux/binfmts.h
@@ -38,7 +38,7 @@ struct linux_binprm{
 		     misc_bang:1;
 	struct file * file;
 	int e_uid, e_gid;
-	kernel_cap_t cap_inheritable, cap_permitted;
+	kernel_cap_t cap_post_exec_permitted;
 	bool cap_effective;
 	void *security;
 	int argc, envc;
diff -puN security/commoncap.c~security-protect-legacy-applications-from-executing-with-insufficient-privilege security/commoncap.c
--- a/security/commoncap.c~security-protect-legacy-applications-from-executing-with-insufficient-privilege
+++ a/security/commoncap.c
@@ -162,8 +162,7 @@ void cap_capset_set (struct task_struct 
 
 static inline void bprm_clear_caps(struct linux_binprm *bprm)
 {
-	cap_clear(bprm->cap_inheritable);
-	cap_clear(bprm->cap_permitted);
+	cap_clear(bprm->cap_post_exec_permitted);
 	bprm->cap_effective = false;
 }
 
@@ -198,6 +197,7 @@ static inline int cap_from_disk(struct v
 {
 	__u32 magic_etc;
 	unsigned tocopy, i;
+	int ret;
 
 	if (size < sizeof(magic_etc))
 		return -EINVAL;
@@ -225,19 +225,40 @@ static inline int cap_from_disk(struct v
 		bprm->cap_effective = false;
 	}
 
-	for (i = 0; i < tocopy; ++i) {
-		bprm->cap_permitted.cap[i] =
-			le32_to_cpu(caps->data[i].permitted);
-		bprm->cap_inheritable.cap[i] =
-			le32_to_cpu(caps->data[i].inheritable);
-	}
-	while (i < VFS_CAP_U32) {
-		bprm->cap_permitted.cap[i] = 0;
-		bprm->cap_inheritable.cap[i] = 0;
-		i++;
+	ret = 0;
+
+	CAP_FOR_EACH_U32(i) {
+		__u32 value_cpu;
+
+		if (i >= tocopy) {
+			/*
+			 * Legacy capability sets have no upper bits
+			 */
+			bprm->cap_post_exec_permitted.cap[i] = 0;
+			continue;
+		}
+		/*
+		 * pP' = (X & fP) | (pI & fI)
+		 */
+		value_cpu = le32_to_cpu(caps->data[i].permitted);
+		bprm->cap_post_exec_permitted.cap[i] =
+			(current->cap_bset.cap[i] & value_cpu) |
+			(current->cap_inheritable.cap[i] &
+				le32_to_cpu(caps->data[i].inheritable));
+		if (value_cpu & ~bprm->cap_post_exec_permitted.cap[i]) {
+			/*
+			 * insufficient to execute correctly
+			 */
+			ret = -EPERM;
+		}
 	}
 
-	return 0;
+	/*
+	 * For legacy apps, with no internal support for recognizing they
+	 * do not have enough capabilities, we return an error if they are
+	 * missing some "forced" (aka file-permitted) capabilities.
+	 */
+	return bprm->cap_effective ? ret : 0;
 }
 
 /* Locate any VFS capabilities: */
@@ -269,9 +290,9 @@ static int get_file_caps(struct linux_bi
 		goto out;
 
 	rc = cap_from_disk(&vcaps, bprm, rc);
-	if (rc)
+	if (rc == -EINVAL)
 		printk(KERN_NOTICE "%s: cap_from_disk returned %d for %s\n",
-			__func__, rc, bprm->filename);
+		       __func__, rc, bprm->filename);
 
 out:
 	dput(dentry);
@@ -304,25 +325,24 @@ int cap_bprm_set_security (struct linux_
 	int ret;
 
 	ret = get_file_caps(bprm);
-	if (ret)
-		printk(KERN_NOTICE "%s: get_file_caps returned %d for %s\n",
-			__func__, ret, bprm->filename);
-
-	/*  To support inheritance of root-permissions and suid-root
-	 *  executables under compatibility mode, we raise all three
-	 *  capability sets for the file.
-	 *
-	 *  If only the real uid is 0, we only raise the inheritable
-	 *  and permitted sets of the executable file.
-	 */
 
-	if (!issecure (SECURE_NOROOT)) {
+	if (!issecure(SECURE_NOROOT)) {
+		/*
+		 * To support inheritance of root-permissions and suid-root
+		 * executables under compatibility mode, we override the
+		 * capability sets for the file.
+		 *
+		 * If only the real uid is 0, we do not set the effective
+		 * bit.
+		 */
 		if (bprm->e_uid == 0 || current->uid == 0) {
-			cap_set_full (bprm->cap_inheritable);
-			cap_set_full (bprm->cap_permitted);
+			/* pP' = (cap_bset & ~0) | (pI & ~0) */
+			bprm->cap_post_exec_permitted = cap_combine(
+				current->cap_bset, current->cap_inheritable
+				);
+			bprm->cap_effective = (bprm->e_uid == 0);
+			ret = 0;
 		}
-		if (bprm->e_uid == 0)
-			bprm->cap_effective = true;
 	}
 
 	return ret;
@@ -330,17 +350,9 @@ int cap_bprm_set_security (struct linux_
 
 void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 {
-	/* Derived from fs/exec.c:compute_creds. */
-	kernel_cap_t new_permitted, working;
-
-	new_permitted = cap_intersect(bprm->cap_permitted,
-				 current->cap_bset);
-	working = cap_intersect(bprm->cap_inheritable,
-				 current->cap_inheritable);
-	new_permitted = cap_combine(new_permitted, working);
-
 	if (bprm->e_uid != current->uid || bprm->e_gid != current->gid ||
-	    !cap_issubset (new_permitted, current->cap_permitted)) {
+	    !cap_issubset(bprm->cap_post_exec_permitted,
+			  current->cap_permitted)) {
 		set_dumpable(current->mm, suid_dumpable);
 		current->pdeath_signal = 0;
 
@@ -350,9 +362,9 @@ void cap_bprm_apply_creds (struct linux_
 				bprm->e_gid = current->gid;
 			}
 			if (cap_limit_ptraced_target()) {
-				new_permitted =
-					cap_intersect(new_permitted,
-						      current->cap_permitted);
+				bprm->cap_post_exec_permitted = cap_intersect(
+					bprm->cap_post_exec_permitted,
+					current->cap_permitted);
 			}
 		}
 	}
@@ -364,9 +376,9 @@ void cap_bprm_apply_creds (struct linux_
 	 * in the init_task struct. Thus we skip the usual
 	 * capability rules */
 	if (!is_global_init(current)) {
-		current->cap_permitted = new_permitted;
+		current->cap_permitted = bprm->cap_post_exec_permitted;
 		if (bprm->cap_effective)
-			current->cap_effective = new_permitted;
+			current->cap_effective = bprm->cap_post_exec_permitted;
 		else
 			cap_clear(current->cap_effective);
 	}
@@ -381,9 +393,7 @@ int cap_bprm_secureexec (struct linux_bi
 	if (current->uid != 0) {
 		if (bprm->cap_effective)
 			return 1;
-		if (!cap_isclear(bprm->cap_permitted))
-			return 1;
-		if (!cap_isclear(bprm->cap_inheritable))
+		if (!cap_isclear(bprm->cap_post_exec_permitted))
 			return 1;
 	}
 
_

Patches currently in -mm which might be from morgan@kernel.org are

origin.patch
sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch

