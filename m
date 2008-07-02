From: akpm@linux-foundation.org
Subject: - flock-remove-unused-fields-from-file_lock_operations.patch removed from -mm tree
Date: Wed, 02 Jul 2008 00:47:35 -0700
Message-ID: <200807020747.m627lZrv005660@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36352 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751923AbYGBH4T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 03:56:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, bfields@fieldses.org, matthew@wil.cx, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     flock: remove unused fields from file_lock_operations
has been removed from the -mm tree.  Its filename was
     flock-remove-unused-fields-from-file_lock_operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: flock: remove unused fields from file_lock_operations
From: "Denis V. Lunev" <den@openvz.org>

fl_insert and fl_remove are not used right now in the kernel. Remove them.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/locks.c         |    6 ------
 include/linux/fs.h |    2 --
 2 files changed, 8 deletions(-)

diff -puN fs/locks.c~flock-remove-unused-fields-from-file_lock_operations fs/locks.c
--- a/fs/locks.c~flock-remove-unused-fields-from-file_lock_operations
+++ a/fs/locks.c
@@ -561,9 +561,6 @@ static void locks_insert_lock(struct fil
 	/* insert into file's list */
 	fl->fl_next = *pos;
 	*pos = fl;
-
-	if (fl->fl_ops && fl->fl_ops->fl_insert)
-		fl->fl_ops->fl_insert(fl);
 }
 
 /*
@@ -586,9 +583,6 @@ static void locks_delete_lock(struct fil
 		fl->fl_fasync = NULL;
 	}
 
-	if (fl->fl_ops && fl->fl_ops->fl_remove)
-		fl->fl_ops->fl_remove(fl);
