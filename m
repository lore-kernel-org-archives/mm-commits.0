From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-do-not-include-dio-entry-in-case-of-orphan-scan.patch removed from
 -mm tree
Date: Fri, 06 Nov 2015 12:05:47 -0800
Message-ID: <563d081b./fOlIw3kbuhgkmIs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033404AbbKFUFr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:05:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: do not include dio entry in case of orphan scan
has been removed from the -mm tree.  Its filename was
     ocfs2-do-not-include-dio-entry-in-case-of-orphan-scan.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: do not include dio entry in case of orphan scan

dio entry will only do truncate in case of ORPHAN_NEED_TRUNCATE. So do
not include it when doing normal orphan scan to reduce contention.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |   15 ++++++++++++---
 fs/ocfs2/namei.c   |    2 --
 fs/ocfs2/namei.h   |    3 +++
 3 files changed, 15 insertions(+), 5 deletions(-)

diff -puN fs/ocfs2/journal.c~ocfs2-do-not-include-dio-entry-in-case-of-orphan-scan fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-do-not-include-dio-entry-in-case-of-orphan-scan
+++ a/fs/ocfs2/journal.c
@@ -2021,6 +2021,7 @@ struct ocfs2_orphan_filldir_priv {
 	struct dir_context	ctx;
 	struct inode		*head;
 	struct ocfs2_super	*osb;
+	enum ocfs2_orphan_reco_type orphan_reco_type;
 };
 
 static int ocfs2_orphan_filldir(struct dir_context *ctx, const char *name,
@@ -2036,6 +2037,12 @@ static int ocfs2_orphan_filldir(struct d
 	if (name_len == 2 && !strncmp("..", name, 2))
 		return 0;
 
+	/* do not include dio entry in case of orphan scan */
+	if ((p->orphan_reco_type == ORPHAN_NO_NEED_TRUNCATE) &&
+			(!strncmp(name, OCFS2_DIO_ORPHAN_PREFIX,
+			OCFS2_DIO_ORPHAN_PREFIX_LEN)))
+		return 0;
+
 	/* Skip bad inodes so that recovery can continue */
 	iter = ocfs2_iget(p->osb, ino,
 			  OCFS2_FI_FLAG_ORPHAN_RECOVERY, 0);
@@ -2060,14 +2067,16 @@ static int ocfs2_orphan_filldir(struct d
 
 static int ocfs2_queue_orphans(struct ocfs2_super *osb,
 			       int slot,
-			       struct inode **head)
+			       struct inode **head,
+			       enum ocfs2_orphan_reco_type orphan_reco_type)
 {
 	int status;
 	struct inode *orphan_dir_inode = NULL;
 	struct ocfs2_orphan_filldir_priv priv = {
 		.ctx.actor = ocfs2_orphan_filldir,
 		.osb = osb,
-		.head = *head
+		.head = *head,
+		.orphan_reco_type = orphan_reco_type
 	};
 
 	orphan_dir_inode = ocfs2_get_system_file_inode(osb,
@@ -2170,7 +2179,7 @@ static int ocfs2_recover_orphans(struct
 	trace_ocfs2_recover_orphans(slot);
 
 	ocfs2_mark_recovering_orphan_dir(osb, slot);
-	ret = ocfs2_queue_orphans(osb, slot, &inode);
+	ret = ocfs2_queue_orphans(osb, slot, &inode, orphan_reco_type);
 	ocfs2_clear_recovering_orphan_dir(osb, slot);
 
 	/* Error here should be noted, but we want to continue with as
diff -puN fs/ocfs2/namei.c~ocfs2-do-not-include-dio-entry-in-case-of-orphan-scan fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-do-not-include-dio-entry-in-case-of-orphan-scan
+++ a/fs/ocfs2/namei.c
@@ -106,8 +106,6 @@ static int ocfs2_double_lock(struct ocfs
 static void ocfs2_double_unlock(struct inode *inode1, struct inode *inode2);
 /* An orphan dir name is an 8 byte value, printed as a hex string */
 #define OCFS2_ORPHAN_NAMELEN ((int)(2 * sizeof(u64)))
-#define OCFS2_DIO_ORPHAN_PREFIX "dio-"
-#define OCFS2_DIO_ORPHAN_PREFIX_LEN 4
 
 static struct dentry *ocfs2_lookup(struct inode *dir, struct dentry *dentry,
 				   unsigned int flags)
diff -puN fs/ocfs2/namei.h~ocfs2-do-not-include-dio-entry-in-case-of-orphan-scan fs/ocfs2/namei.h
--- a/fs/ocfs2/namei.h~ocfs2-do-not-include-dio-entry-in-case-of-orphan-scan
+++ a/fs/ocfs2/namei.h
@@ -26,6 +26,9 @@
 #ifndef OCFS2_NAMEI_H
 #define OCFS2_NAMEI_H
 
+#define OCFS2_DIO_ORPHAN_PREFIX "dio-"
+#define OCFS2_DIO_ORPHAN_PREFIX_LEN 4
+
 extern const struct inode_operations ocfs2_dir_iops;
 
 struct dentry *ocfs2_get_parent(struct dentry *child);
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-dlm-fix-race-between-convert-and-recovery.patch
ocfs2-dlm-fix-race-between-convert-and-recovery-v2.patch
ocfs2-dlm-fix-race-between-convert-and-recovery-v3.patch
ocfs2-dlm-fix-bug-in-dlm_move_lockres_to_recovery_list.patch

