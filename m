From: akpm@linux-foundation.org
Subject: + file-capabilities-change-fe-to-a-bool.patch added to -mm tree
Date: Fri, 13 Jul 2007 11:53:11 -0700
Message-ID: <200707131853.l6DIrC9n012457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55002 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760737AbXGMSyF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 14:54:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, casey@schaufler-ca.com, chrisw@sous-sol.org, jmorris@namei.org, kaigai@kaigai.gr.jp, morgan@kernel.org, sds@tycho.nsa.gov


The patch titled
     file capabilities: change fE to a bool
has been added to the -mm tree.  Its filename is
     file-capabilities-change-fe-to-a-bool.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: file capabilities: change fE to a bool
From: Serge E. Hallyn <serue@us.ibm.com>

The fE was previously a full capset which was masked with the calculated
new_permitted to get the process' new effective set.  It is now a single
bit in the xattr.  This patch changes bprm->cap_effective to a boolean. 
When that boolean is false, then P'e is the empty set.  When the boolean is
true, then P'e is set equal to P'p (new_permitted).  The rationale for this
is that either the application does not know about capabilities, and needs
to start with all permitted caps in its effective set, or it does know
about capabilities, and can start with an empty effective set and enable
the caps it wants when it wants.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Andrew Morgan <morgan@kernel.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: James Morris <jmorris@namei.org>
Cc: KaiGai Kohei <kaigai@kaigai.gr.jp>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/binfmts.h |    3 ++-
 security/commoncap.c    |   16 +++++++++-------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff -puN include/linux/binfmts.h~file-capabilities-change-fe-to-a-bool include/linux/binfmts.h
--- a/include/linux/binfmts.h~file-capabilities-change-fe-to-a-bool
+++ a/include/linux/binfmts.h
@@ -30,7 +30,8 @@ struct linux_binprm{
 	int sh_bang;
 	struct file * file;
 	int e_uid, e_gid;
-	kernel_cap_t cap_inheritable, cap_permitted, cap_effective;
+	kernel_cap_t cap_inheritable, cap_permitted;
+	bool cap_effective;
 	void *security;
 	int argc, envc;
 	char * filename;	/* Name of binary as seen by procps */
diff -puN security/commoncap.c~file-capabilities-change-fe-to-a-bool security/commoncap.c
--- a/security/commoncap.c~file-capabilities-change-fe-to-a-bool
+++ a/security/commoncap.c
@@ -113,7 +113,7 @@ static inline void bprm_clear_caps(struc
 {
 	cap_clear(bprm->cap_inheritable);
 	cap_clear(bprm->cap_permitted);
-	cap_clear(bprm->cap_effective);
+	bprm->cap_effective = false;
 }
 
 #ifdef CONFIG_SECURITY_FILE_CAPABILITIES
@@ -130,8 +130,10 @@ static inline int cap_from_disk(__le32 *
 
 	switch ((magic_etc & VFS_CAP_REVISION_MASK)) {
 	case VFS_CAP_REVISION:
-		bprm->cap_effective = (magic_etc & VFS_CAP_FLAGS_EFFECTIVE)
-					? CAP_FULL_SET : CAP_EMPTY_SET;
+		if (magic_etc & VFS_CAP_FLAGS_EFFECTIVE)
+			bprm->cap_effective = true;
+		else
+			bprm->cap_effective = false;
 		bprm->cap_permitted = to_cap_t( le32_to_cpu(caps[1]) );
 		bprm->cap_inheritable = to_cap_t( le32_to_cpu(caps[2]) );
 		return 0;
@@ -212,7 +214,7 @@ int cap_bprm_set_security (struct linux_
 			cap_set_full (bprm->cap_permitted);
 		}
 		if (bprm->e_uid == 0)
-			cap_set_full (bprm->cap_effective);
+			bprm->cap_effective = true;
 	}
 
 	return ret;
@@ -252,8 +254,8 @@ void cap_bprm_apply_creds (struct linux_
 	 * capability rules */
 	if (!is_init(current)) {
 		current->cap_permitted = new_permitted;
-		current->cap_effective =
-		    cap_intersect (new_permitted, bprm->cap_effective);
+		current->cap_effective = bprm->cap_effective ?
+				new_permitted : 0;
 	}
 
 	/* AUD: Audit candidate if current->cap_effective is set */
@@ -264,7 +266,7 @@ void cap_bprm_apply_creds (struct linux_
 int cap_bprm_secureexec (struct linux_binprm *bprm)
 {
 	if (current->uid != 0) {
-		if (!cap_isclear(bprm->cap_effective))
+		if (bprm->cap_effective)
 			return 1;
 		if (!cap_isclear(bprm->cap_permitted))
 			return 1;
_

Patches currently in -mm which might be from serue@us.ibm.com are

implement-file-posix-capabilities.patch
implement-file-posix-capabilities-fix.patch
file-capabilities-introduce-cap_setfcap.patch
file-capabilities-get_file_caps-cleanups.patch
file-caps-update-selinux-xattr-hooks.patch
file-capabilities-clear-caps-cleanup.patch
file-capabilities-clear-caps-cleanup-fix.patch
file-capabilities-change-xattr-format-v2.patch
file-capabilities-change-fe-to-a-bool.patch
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
pid-namespaces-round-up-the-api.patch
