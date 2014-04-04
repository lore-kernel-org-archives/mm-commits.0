From: akpm@linux-foundation.org
Subject: [merged] ocfs2-remove-ocfs2_inode_skip_delete-flag.patch removed
 from -mm tree
Date: Fri, 04 Apr 2014 12:30:11 -0700
Message-ID: <533f0843.UoUo03RWTduyR23x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42727 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464AbaDDTaM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:30:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, srinivas.eeda@oracle.com, mfasheh@suse.de, jlbec@evilplan.org, jack@suse.cz

Subject: [merged] ocfs2-remove-ocfs2_inode_skip_delete-flag.patch removed from -mm tree
To: jack@suse.cz,jlbec@evilplan.org,mfasheh@suse.de,srinivas.eeda@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:30:11 -0700


The patch titled
     Subject: ocfs2: remove OCFS2_INODE_SKIP_DELETE flag
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-ocfs2_inode_skip_delete-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: ocfs2: remove OCFS2_INODE_SKIP_DELETE flag

The flag was never set, delete it.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c   |    6 ------
 fs/ocfs2/inode.h   |    8 +++-----
 fs/ocfs2/journal.c |    6 ------
 3 files changed, 3 insertions(+), 17 deletions(-)

diff -puN fs/ocfs2/inode.c~ocfs2-remove-ocfs2_inode_skip_delete-flag fs/ocfs2/inode.c
--- a/fs/ocfs2/inode.c~ocfs2-remove-ocfs2_inode_skip_delete-flag
+++ a/fs/ocfs2/inode.c
@@ -849,12 +849,6 @@ static int ocfs2_inode_is_valid_to_delet
 		goto bail_unlock;
 	}
 
-	/* If we have allowd wipe of this inode for another node, it
-	 * will be marked here so we can safely skip it. Recovery will
-	 * cleanup any inodes we might inadvertently skip here. */
-	if (oi->ip_flags & OCFS2_INODE_SKIP_DELETE)
-		goto bail_unlock;
-
 	ret = 1;
 bail_unlock:
 	spin_unlock(&oi->ip_lock);
diff -puN fs/ocfs2/inode.h~ocfs2-remove-ocfs2_inode_skip_delete-flag fs/ocfs2/inode.h
--- a/fs/ocfs2/inode.h~ocfs2-remove-ocfs2_inode_skip_delete-flag
+++ a/fs/ocfs2/inode.h
@@ -91,8 +91,6 @@ struct ocfs2_inode_info
 #define OCFS2_INODE_BITMAP		0x00000004
 /* This inode has been wiped from disk */
 #define OCFS2_INODE_DELETED		0x00000008
-/* Another node is deleting, so our delete is a nop */
-#define OCFS2_INODE_SKIP_DELETE		0x00000010
 /* Has the inode been orphaned on another node?
  *
  * This hints to ocfs2_drop_inode that it should clear i_nlink before
@@ -107,11 +105,11 @@ struct ocfs2_inode_info
  * rely on ocfs2_delete_inode to sort things out under the proper
  * cluster locks.
  */
-#define OCFS2_INODE_MAYBE_ORPHANED	0x00000020
+#define OCFS2_INODE_MAYBE_ORPHANED	0x00000010
 /* Does someone have the file open O_DIRECT */
-#define OCFS2_INODE_OPEN_DIRECT		0x00000040
+#define OCFS2_INODE_OPEN_DIRECT		0x00000020
 /* Tell the inode wipe code it's not in orphan dir */
-#define OCFS2_INODE_SKIP_ORPHAN_DIR     0x00000080
+#define OCFS2_INODE_SKIP_ORPHAN_DIR     0x00000040
 
 static inline struct ocfs2_inode_info *OCFS2_I(struct inode *inode)
 {
diff -puN fs/ocfs2/journal.c~ocfs2-remove-ocfs2_inode_skip_delete-flag fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-remove-ocfs2_inode_skip_delete-flag
+++ a/fs/ocfs2/journal.c
@@ -2132,12 +2132,6 @@ static int ocfs2_recover_orphans(struct
 		iter = oi->ip_next_orphan;
 
 		spin_lock(&oi->ip_lock);
-		/* The remote delete code may have set these on the
-		 * assumption that the other node would wipe them
-		 * successfully.  If they are still in the node's
-		 * orphan dir, we need to reset that state. */
-		oi->ip_flags &= ~(OCFS2_INODE_DELETED|OCFS2_INODE_SKIP_DELETE);
