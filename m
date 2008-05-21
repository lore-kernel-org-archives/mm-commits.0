From: akpm@linux-foundation.org
Subject: + flock-remove-unused-fields-from-file_lock_operations.patch added to -mm tree
Date: Wed, 21 May 2008 14:41:37 -0700
Message-ID: <200805212141.m4LLfb0u002166@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755850AbYEUVlu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 May 2008 17:41:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, bfields@fieldses.org, matthew@wil.cx, viro@zeniv.linux.org.uk


The patch titled
     flock: remove unused fields from file_lock_operations
has been added to the -mm tree.  Its filename is
     flock-remove-unused-fields-from-file_lock_operations.patch

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
-
 	if (fl->fl_nspid) {
 		put_pid(fl->fl_nspid);
 		fl->fl_nspid = NULL;
diff -puN include/linux/fs.h~flock-remove-unused-fields-from-file_lock_operations include/linux/fs.h
--- a/include/linux/fs.h~flock-remove-unused-fields-from-file_lock_operations
+++ a/include/linux/fs.h
@@ -894,8 +894,6 @@ static inline int file_check_writeable(s
 typedef struct files_struct *fl_owner_t;
 
 struct file_lock_operations {
-	void (*fl_insert)(struct file_lock *);	/* lock insertion callback */
-	void (*fl_remove)(struct file_lock *);	/* lock removal callback */
 	void (*fl_copy_lock)(struct file_lock *, struct file_lock *);
 	void (*fl_release_private)(struct file_lock *);
 };
_

Patches currently in -mm which might be from den@openvz.org are

origin.patch
flock-remove-unused-fields-from-file_lock_operations.patch
proc-proc_get_inode-should-get-module-only-once.patch
modules-proper-cleanup-of-kobject-without-config_sysfs.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

