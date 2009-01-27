From: akpm@linux-foundation.org
Subject: + vfs-further-changes-from-macro-to-inline-function-in-fsh.patch added to -mm tree
Date: Tue, 27 Jan 2009 12:55:16 -0800
Message-ID: <200901272055.n0RKtGOi005410@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751856AbZA0U4z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 15:56:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: swhiteho@redhat.com, randy.dunlap@oracle.com, viro@zeniv.linux.org.uk


The patch titled
     vfs: further changes from macro to inline function in fs.h
has been added to the -mm tree.  Its filename is
     vfs-further-changes-from-macro-to-inline-function-in-fsh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: further changes from macro to inline function in fs.h
From: Steven Whitehouse <swhiteho@redhat.com>

There is a second set of macros for when CONFIG_FILE_LOCKING is not set. 
This patch updates those to become inline functions as well.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |   45 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 38 insertions(+), 7 deletions(-)

diff -puN include/linux/fs.h~vfs-further-changes-from-macro-to-inline-function-in-fsh include/linux/fs.h
--- a/include/linux/fs.h~vfs-further-changes-from-macro-to-inline-function-in-fsh
+++ a/include/linux/fs.h
@@ -1816,13 +1816,44 @@ static inline int break_lease(struct ino
 	return 0;
 }
 #else /* !CONFIG_FILE_LOCKING */
-#define locks_mandatory_locked(a) ({ 0; })
-#define locks_mandatory_area(a, b, c, d, e) ({ 0; })
-#define __mandatory_lock(a) ({ 0; })
-#define mandatory_lock(a) ({ 0; })
-#define locks_verify_locked(a) ({ 0; })
-#define locks_verify_truncate(a, b, c) ({ 0; })
-#define break_lease(a, b) ({ 0; })
+static inline int locks_mandatory_locked(struct inode *inode)
+{
+	return 0;
+}
+
+static inline int locks_mandatory_area(int rw, struct inode *inode,
+				       struct file *filp, loff_t offset,
+				       size_t count)
+{
+	return 0;
+}
+
+static inline int __mandatory_lock(struct inode *inode)
+{
+	return 0;
+}
+
+static inline int mandatory_lock(struct inode *inode)
+{
+	return 0;
+}
+
+static inline int locks_verify_locked(struct inode *inode)
+{
+	return 0;
+}
+
+static inline int locks_verify_truncate(struct inode *inode, struct file *filp,
+					size_t size)
+{
+	return 0;
+}
+
+static inline int break_lease(struct inode *inode, unsigned int mode)
+{
+	return 0;
+}
+
 #endif /* CONFIG_FILE_LOCKING */
 
 /* fs/open.c */
_

Patches currently in -mm which might be from swhiteho@redhat.com are

linux-next.patch
vfs-update-fsh-to-use-inline-functions-when-no-file-locking-set.patch
vfs-further-changes-from-macro-to-inline-function-in-fsh.patch

