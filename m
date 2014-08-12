From: akpm@linux-foundation.org
Subject: [obsolete]
 fsh-add-argument-names-to-struct-file_lock_operations-funcs.patch removed
 from -mm tree
Date: Tue, 12 Aug 2014 12:35:34 -0700
Message-ID: <53ea6c86.7Z/j0JPKB+Sdvgtv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:44274 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604AbaHLTfh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:35:37 -0400
Received: by mail-vc0-f202.google.com with SMTP id hq11so1305408vcb.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:35:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bfields@fieldses.org, ccaulfie@redhat.com, jlayton@poochiereds.net, teigland@redhat.com, trond.myklebust@primarydata.com, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs.h: add argument names to struct file_lock_operations (*funcs)
has been removed from the -mm tree.  Its filename was
     fsh-add-argument-names-to-struct-file_lock_operations-funcs.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: fs.h: add argument names to struct file_lock_operations (*funcs)

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

 include/linux/fs.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/fs.h~fsh-add-argument-names-to-struct-file_lock_operations-funcs include/linux/fs.h
--- a/include/linux/fs.h~fsh-add-argument-names-to-struct-file_lock_operations-funcs
+++ a/include/linux/fs.h
@@ -859,8 +859,8 @@ static inline struct file *get_file(stru
 typedef void *fl_owner_t;
 
 struct file_lock_operations {
-	void (*fl_copy_lock)(struct file_lock *, struct file_lock *);
-	void (*fl_release_private)(struct file_lock *);
+	void (*fl_copy_lock)(struct file_lock *dst, struct file_lock *fl);
+	void (*fl_release_private)(struct file_lock *fl);
 };
 
 struct lock_manager_operations {
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
fsh-add-member-argument-descriptions-to-lock_manager_operations.patch
dlm-plock-add-argument-descriptions-to-notify.patch
dlm-fs-remove-unused-conf-from-lm_grant.patch
dlm-plock-reduce-indentation-by-rearranging-order.patch

