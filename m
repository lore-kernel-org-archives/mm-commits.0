From: akpm@linux-foundation.org
Subject: [obsolete]
 fsh-add-member-argument-descriptions-to-lock_manager_operations.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:35:36 -0700
Message-ID: <53ea6c88.eRL9j1xUyWLDIU0w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:37593 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbaHLTfh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:35:37 -0400
Received: by mail-oa0-f73.google.com with SMTP id g18so1918635oah.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:35:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bfields@fieldses.org, ccaulfie@redhat.com, jlayton@poochiereds.net, teigland@redhat.com, trond.myklebust@primarydata.com, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs.h: add member argument descriptions to lock_manager_operations
has been removed from the -mm tree.  Its filename was
     fsh-add-member-argument-descriptions-to-lock_manager_operations.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: fs.h: add member argument descriptions to lock_manager_operations

Function pointer struct members without argument type names
are not very clear.  Add them.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Teigland <teigland@redhat.com>
Acked-by: Jeff Layton <jlayton@poochiereds.net>
Cc: Christine Caulfield <ccaulfie@redhat.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/fs.h~fsh-add-member-argument-descriptions-to-lock_manager_operations include/linux/fs.h
--- a/include/linux/fs.h~fsh-add-member-argument-descriptions-to-lock_manager_operations
+++ a/include/linux/fs.h
@@ -864,12 +864,12 @@ struct file_lock_operations {
 };
 
 struct lock_manager_operations {
-	int (*lm_compare_owner)(struct file_lock *, struct file_lock *);
-	unsigned long (*lm_owner_key)(struct file_lock *);
-	void (*lm_notify)(struct file_lock *);	/* unblock callback */
-	int (*lm_grant)(struct file_lock *, struct file_lock *, int);
-	void (*lm_break)(struct file_lock *);
-	int (*lm_change)(struct file_lock **, int);
+	int (*lm_compare_owner)(struct file_lock *fl1, struct file_lock *fl2);
+	unsigned long (*lm_owner_key)(struct file_lock *fl);
+	void (*lm_notify)(struct file_lock *fl);	/* unblock callback */
+	int (*lm_grant)(struct file_lock *fl, struct file_lock *conf, int result);
+	void (*lm_break)(struct file_lock *fl);
+	int (*lm_change)(struct file_lock **fl, int type);
 };
 
 struct lock_manager {
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
dlm-plock-add-argument-descriptions-to-notify.patch
dlm-fs-remove-unused-conf-from-lm_grant.patch
dlm-plock-reduce-indentation-by-rearranging-order.patch

