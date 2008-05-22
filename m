From: akpm@linux-foundation.org
Subject: + security-protect-legacy-apps-from-insufficient-privilege.patch added to -mm tree
Date: Wed, 21 May 2008 22:41:57 -0700
Message-ID: <200805220541.m4M5fvaB019437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38073 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753585AbYEVFm7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 01:42:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: morgan@kernel.org, serue@us.ibm.com


The patch titled
     security: protect legacy applications from executing with insufficient privilege
has been added to the -mm tree.  Its filename is
     security-protect-legacy-apps-from-insufficient-privilege.patch

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

Signed-off-by: Andrew G. Morgan <morgan@kernel.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/binfmts.h |    2 
 security/commoncap.c    |  109 +++++++++++++++++++++-----------------
 2 files changed, 62 insertions(+), 49 deletions(-)

diff -puN include/linux/binfmts.h~security-protect-legacy-apps-from-insufficient-privilege include/linux/binfmts.h
--- a/include/linux/binfmts.h~security-protect-legacy-apps-from-insufficient-privilege
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
diff -puN security/commoncap.c~security-protect-legacy-apps-from-insufficient-privilege security/commoncap.c
--- a/security/commoncap.c~security-protect-legacy-apps-from-insufficient-privilege
+++ a/security/commoncap.c
@@ -156,8 +156,7 @@ void cap_capset_set (struct task_struct 
 
 static inline void bprm_clear_caps(struct linux_binprm *bprm)
 {
-	cap_clear(bprm->cap_inheritable);
-	cap_clear(bprm->cap_permitted);
+	cap_clear(bprm->cap_post_exec_permitted);
 	bprm->cap_effective = false;
 }
 
@@ -192,6 +191,7 @@ static inline int cap_from_disk(struct v
 {
 	__u32 magic_etc;
 	unsigned tocopy, i;
+	int ret;
 
 	if (size < sizeof(magic_etc))
 		return -EINVAL;
@@ -219,19 +219,42 @@ static inline int cap_from_disk(struct v
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
+		if (i >= tocopy) {
+			/*
+			 * Legacy capability sets have no upper bits
+			 */
+			bprm->cap_post_exec_permitted.cap[i] = 0;
+		} else {
+			__u32 value_cpu;
+			/*
+			 * pP' = (X & fP) | (pI & fI)
+			 */
+			value_cpu = le32_to_cpu(caps->data[i].permitted);
+			bprm->cap_post_exec_permitted.cap[i] = (
+					current->cap_bset.cap[i] & value_cpu
+				) | (
+					current->cap_inheritable.cap[i] &
+					le32_to_cpu(caps->data[i].inheritable)
+				);
+			if (value_cpu &
+			    ~bprm->cap_post_exec_permitted.cap[i]) {
+				/*
+				 * insufficient to execute correctly
+				 */
+				ret = -EPERM;
+			}
+		}
 	}
 
-	return 0;
+	/*
+	 * For legacy apps, with no internal support for recognizing they
+	 * do not have enough capabilities, we return an error if they are
+	 * missing some "forced" (aka file-permitted) capabilities.
+	 */
+	return (bprm->cap_effective ? ret : 0);
 }
 
 /* Locate any VFS capabilities: */
@@ -263,9 +286,9 @@ static int get_file_caps(struct linux_bi
 		goto out;
 
 	rc = cap_from_disk(&vcaps, bprm, rc);
-	if (rc)
+	if (rc == -EINVAL)
 		printk(KERN_NOTICE "%s: cap_from_disk returned %d for %s\n",
-			__func__, rc, bprm->filename);
+		       __func__, rc, bprm->filename);
 
 out:
 	dput(dentry);
@@ -298,25 +321,24 @@ int cap_bprm_set_security (struct linux_
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
@@ -324,17 +346,9 @@ int cap_bprm_set_security (struct linux_
 
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
 
@@ -344,8 +358,9 @@ void cap_bprm_apply_creds (struct linux_
 				bprm->e_gid = current->gid;
 			}
 			if (!capable (CAP_SETPCAP)) {
-				new_permitted = cap_intersect (new_permitted,
-							current->cap_permitted);
+				bprm->cap_post_exec_permitted = cap_intersect(
+					bprm->cap_post_exec_permitted,
+					current->cap_permitted);
 			}
 		}
 	}
@@ -357,9 +372,9 @@ void cap_bprm_apply_creds (struct linux_
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
@@ -374,9 +389,7 @@ int cap_bprm_secureexec (struct linux_bi
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

sys_prctl-fix-return-of-uninitialized-value.patch
security-protect-legacy-apps-from-insufficient-privilege.patch
security-protect-legacy-apps-from-insufficient-privilege-cleanup.patch

