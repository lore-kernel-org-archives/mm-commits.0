From: akpm@linux-foundation.org
Subject: [merged] vfs-further-changes-from-macro-to-inline-function-in-fsh.patch removed from -mm tree
Date: Mon, 30 Mar 2009 12:06:32 -0700
Message-ID: <200903301906.n2UJ6Whp019066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759382AbZC3TKU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 15:10:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: swhiteho@redhat.com, randy.dunlap@oracle.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: further changes from macro to inline function in fs.h
has been removed from the -mm tree.  Its filename was
     vfs-further-changes-from-macro-to-inline-function-in-fsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1805,13 +1805,44 @@ static inline int break_lease(struct ino
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

origin.patch
mm-page_mkwrite-change-prototype-to-match-fault.patch

