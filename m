From: akpm@linux-foundation.org
Subject: - smackfs-do-not-trust-count-in-inodes-writes.patch removed from -mm tree
Date: Mon, 17 Mar 2008 13:57:18 -0700
Message-ID: <200803172057.m2HKvI8Y030611@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756840AbYCQU5v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 16:57:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darwish.07@gmail.com, casey@schaufler-ca.com, mm-commits@vger.kernel.org


The patch titled
     smackfs: do not trust `count' in inodes write()s
has been removed from the -mm tree.  Its filename was
     smackfs-do-not-trust-count-in-inodes-writes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: smackfs: do not trust `count' in inodes write()s
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Smackfs write() implementation does not put a higher bound on the number of
bytes to copy from user-space.  This may lead to a DOS attack if a malicious
`count' field is given.

Assure that given `count' is exactly the length needed for a /smack/load rule.
 In case of /smack/cipso where the length is relative, assure that `count'
does not exceed the size needed for a buffer representing maximum possible
number of CIPSO 2.2 categories.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Acked-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/smack/smack.h   |    8 --------
 security/smack/smackfs.c |   31 ++++++++++++++++++++-----------
 2 files changed, 20 insertions(+), 19 deletions(-)

diff -puN security/smack/smack.h~smackfs-do-not-trust-count-in-inodes-writes security/smack/smack.h
--- a/security/smack/smack.h~smackfs-do-not-trust-count-in-inodes-writes
+++ a/security/smack/smack.h
@@ -26,14 +26,6 @@
 #define SMK_MAXLEN	23
 #define SMK_LABELLEN	(SMK_MAXLEN+1)
 
-/*
- * How many kinds of access are there?
- * Here's your answer.
- */
-#define SMK_ACCESSDASH	'-'
-#define SMK_ACCESSLOW	"rwxa"
-#define SMK_ACCESSKINDS	(sizeof(SMK_ACCESSLOW) - 1)
-
 struct superblock_smack {
 	char		*smk_root;
 	char		*smk_floor;
diff -puN security/smack/smackfs.c~smackfs-do-not-trust-count-in-inodes-writes security/smack/smackfs.c
--- a/security/smack/smackfs.c~smackfs-do-not-trust-count-in-inodes-writes
+++ a/security/smack/smackfs.c
@@ -81,10 +81,23 @@ static struct semaphore smack_write_sem;
 /*
  * Values for parsing cipso rules
  * SMK_DIGITLEN: Length of a digit field in a rule.
- * SMK_CIPSOMEN: Minimum possible cipso rule length.
+ * SMK_CIPSOMIN: Minimum possible cipso rule length.
+ * SMK_CIPSOMAX: Maximum possible cipso rule length.
  */
 #define SMK_DIGITLEN 4
-#define SMK_CIPSOMIN (SMK_MAXLEN + 2 * SMK_DIGITLEN)
+#define SMK_CIPSOMIN (SMK_LABELLEN + 2 * SMK_DIGITLEN)
+#define SMK_CIPSOMAX (SMK_CIPSOMIN + SMACK_CIPSO_MAXCATNUM * SMK_DIGITLEN)
+
+/*
+ * Values for parsing MAC rules
+ * SMK_ACCESS: Maximum possible combination of access permissions
+ * SMK_ACCESSLEN: Maximum length for a rule access field
+ * SMK_LOADLEN: Smack rule length
+ */
+#define SMK_ACCESS    "rwxa"
+#define SMK_ACCESSLEN (sizeof(SMK_ACCESS) - 1)
+#define SMK_LOADLEN   (SMK_LABELLEN + SMK_LABELLEN + SMK_ACCESSLEN)
+
 
 /*
  * Seq_file read operations for /smack/load
@@ -229,14 +242,10 @@ static void smk_set_access(struct smack_
  * The format is exactly:
  *     char subject[SMK_LABELLEN]
  *     char object[SMK_LABELLEN]
- *     char access[SMK_ACCESSKINDS]
+ *     char access[SMK_ACCESSLEN]
  *
- *     Anything following is commentary and ignored.
- *
- * writes must be SMK_LABELLEN+SMK_LABELLEN+4 bytes.
+ * writes must be SMK_LABELLEN+SMK_LABELLEN+SMK_ACCESSLEN bytes.
  */
-#define MINIMUM_LOAD (SMK_LABELLEN + SMK_LABELLEN + SMK_ACCESSKINDS)
-
 static ssize_t smk_write_load(struct file *file, const char __user *buf,
 			      size_t count, loff_t *ppos)
 {
@@ -253,7 +262,7 @@ static ssize_t smk_write_load(struct fil
 		return -EPERM;
 	if (*ppos != 0)
 		return -EINVAL;
-	if (count < MINIMUM_LOAD)
+	if (count != SMK_LOADLEN)
 		return -EINVAL;
 
 	data = kzalloc(count, GFP_KERNEL);
@@ -513,7 +522,7 @@ static ssize_t smk_write_cipso(struct fi
 		return -EPERM;
 	if (*ppos != 0)
 		return -EINVAL;
-	if (count <= SMK_CIPSOMIN)
+	if (count < SMK_CIPSOMIN || count > SMK_CIPSOMAX)
 		return -EINVAL;
 
 	data = kzalloc(count + 1, GFP_KERNEL);
@@ -547,7 +556,7 @@ static ssize_t smk_write_cipso(struct fi
 	if (ret != 1 || catlen > SMACK_CIPSO_MAXCATNUM)
 		goto out;
 
-	if (count <= (SMK_CIPSOMIN + catlen * SMK_DIGITLEN))
+	if (count != (SMK_CIPSOMIN + catlen * SMK_DIGITLEN))
 		goto out;
 
 	memset(mapcatset, 0, sizeof(mapcatset));
_

Patches currently in -mm which might be from darwish.07@gmail.com are

git-kvm.patch
git-security-testing.patch
smack-do-not-dereference-null-ipc-object.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch

