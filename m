From: akpm@linux-foundation.org
Subject: - configfsdlm-separate-out-__configfs_attr-into-configfsh.patch removed from -mm tree
Date: Tue, 10 Jul 2007 12:50:14 -0700
Message-ID: <200707101950.l6AJoEhk026234@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58752 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760588AbXGJTz0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jul 2007 15:55:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ssatyam@cse.iitk.ac.in, joel.becker@oracle.com, swhiteho@redhat.com, teigland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     configfs+dlm: Separate out __CONFIGFS_ATTR into configfs.h
has been removed from the -mm tree.  Its filename was
     configfsdlm-separate-out-__configfs_attr-into-configfsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: configfs+dlm: Separate out __CONFIGFS_ATTR into configfs.h
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>

fs/dlm/config.c contains a useful generic macro called __CONFIGFS_ATTR that is
similar to sysfs' __ATTR macro that makes defining attributes easy for any
user of configfs.  Separate it out into configfs.h so that other users
(forthcoming in dynamic netconsole patchset) can use it too.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: Joel Becker <joel.becker@oracle.com>
Cc: David Teigland <teigland@redhat.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dlm/config.c          |    8 --------
 include/linux/configfs.h |   16 ++++++++++++++++
 2 files changed, 16 insertions(+), 8 deletions(-)

diff -puN fs/dlm/config.c~configfsdlm-separate-out-__configfs_attr-into-configfsh fs/dlm/config.c
--- a/fs/dlm/config.c~configfsdlm-separate-out-__configfs_attr-into-configfsh
+++ a/fs/dlm/config.c
@@ -133,14 +133,6 @@ static ssize_t cluster_set(struct cluste
 	return len;
 }
 
-#define __CONFIGFS_ATTR(_name,_mode,_read,_write) {                           \
-	.attr   = { .ca_name = __stringify(_name),                            \
-		    .ca_mode = _mode,                                         \
-		    .ca_owner = THIS_MODULE },                                \
-	.show   = _read,                                                      \
-	.store  = _write,                                                     \
-}
-
 #define CLUSTER_ATTR(name, check_zero)                                        \
 static ssize_t name##_write(struct cluster *cl, const char *buf, size_t len)  \
 {                                                                             \
diff -puN include/linux/configfs.h~configfsdlm-separate-out-__configfs_attr-into-configfsh include/linux/configfs.h
--- a/include/linux/configfs.h~configfsdlm-separate-out-__configfs_attr-into-configfsh
+++ a/include/linux/configfs.h
@@ -130,6 +130,22 @@ struct configfs_attribute {
 	mode_t			ca_mode;
 };
 
+/*
+ * Users often need to create attribute structures for their configurable
+ * attributes, containing a configfs_attribute member and function pointers
+ * for the show() and store() operations on that attribute. They can use
+ * this macro (similar to sysfs' __ATTR) to make defining attributes easier.
+ */
+#define __CONFIGFS_ATTR(_name, _mode, _show, _store)			\
+{									\
+	.attr	= {							\
+			.ca_name = __stringify(_name),			\
+			.ca_mode = _mode,				\
+			.ca_owner = THIS_MODULE,			\
+	},								\
+	.show	= _show,						\
+	.store	= _store,						\
+}
 
 /*
  * If allow_link() exists, the item can symlink(2) out to other
_

Patches currently in -mm which might be from ssatyam@cse.iitk.ac.in are

git-gfs2-nmw.patch
git-ocfs2.patch
drivers-message-i2o-devicec-remove-redundant-gfp_atomic-from-kmalloc.patch
drivers-scsi-aic7xxx_oldc-remove-redundant-gfp_atomic-from-kmalloc.patch
netpoll-fix-a-leak-n-bug-in-netpoll_cleanup.patch
introduce-write_trylock_irqsave.patch
