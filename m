From: akpm@linux-foundation.org
Subject: + hfsplus-add-necessary-declarations-for-posix-acls-support.patch added to -mm tree
Date: Mon, 29 Jul 2013 13:07:58 -0700
Message-ID: <51f6cb9e.kqrk5De/2icd9e++%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58975 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab3G2UH7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jul 2013 16:07:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, htl10@users.sourceforge.net, hch@infradead.org, slava@dubeyko.com

Subject: + hfsplus-add-necessary-declarations-for-posix-acls-support.patch added to -mm tree
To: slava@dubeyko.com,hch@infradead.org,htl10@users.sourceforge.net,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Mon, 29 Jul 2013 13:07:58 -0700


The patch titled
     Subject: hfsplus: add necessary declarations for POSIX ACLs support
has been added to the -mm tree.  Its filename is
     hfsplus-add-necessary-declarations-for-posix-acls-support.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfsplus-add-necessary-declarations-for-posix-acls-support.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-add-necessary-declarations-for-posix-acls-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: hfsplus: add necessary declarations for POSIX ACLs support

This patchset implements POSIX ACLs support in hfsplus driver.

Mac OS X beginning with version 10.4 ("Tiger") support NFSv4 ACLs, which
are part of the NFSv4 standard.  HFS+ stores ACLs in the form of specially
named extended attributes (com.apple.system.Security).

But this patchset doesn't use "com.apple.system.Security" extended
attributes.  It implements support of POSIX ACLs in the form of extended
attributes with names "system.posix_acl_access" and
"system.posix_acl_default".  These xattrs are treated only under Linux. 
POSIX ACLs doesn't mean something under Mac OS X.  Thereby, this patch set
provides opportunity to use POSIX ACLs under Linux on HFS+ filesystem.


This patch:

Add CONFIG_HFSPLUS_FS_POSIX_ACL kernel configuration option, DBG_ACL_MOD
debugging flag and acl.h file with declaration of essential functions for
support POSIX ACLs in hfsplus driver.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/Kconfig      |   18 ++++++++++++++++++
 fs/hfsplus/acl.h        |   30 ++++++++++++++++++++++++++++++
 fs/hfsplus/hfsplus_fs.h |    1 +
 3 files changed, 49 insertions(+)

diff -puN fs/hfsplus/Kconfig~hfsplus-add-necessary-declarations-for-posix-acls-support fs/hfsplus/Kconfig
--- a/fs/hfsplus/Kconfig~hfsplus-add-necessary-declarations-for-posix-acls-support
+++ a/fs/hfsplus/Kconfig
@@ -11,3 +11,21 @@ config HFSPLUS_FS
 	  MacOS 8. It includes all Mac specific filesystem data such as
 	  data forks and creator codes, but it also has several UNIX
 	  style features such as file ownership and permissions.
+
+config HFSPLUS_FS_POSIX_ACL
+	bool "HFS+ POSIX Access Control Lists"
+	depends on HFSPLUS_FS
+	select FS_POSIX_ACL
+	help
+	  POSIX Access Control Lists (ACLs) support permissions for users and
+	  groups beyond the owner/group/world scheme.
+
+	  To learn more about Access Control Lists, visit the POSIX ACLs for
+	  Linux website <http://acl.bestbits.at/>.
+
+	  It needs to understand that POSIX ACLs are treated only under
+	  Linux. POSIX ACLs doesn't mean something under Mac OS X.
+	  Mac OS X beginning with version 10.4 ("Tiger") support NFSv4 ACLs,
+	  which are part of the NFSv4 standard.
+
+	  If you don't know what Access Control Lists are, say N
diff -puN /dev/null fs/hfsplus/acl.h
--- /dev/null
+++ a/fs/hfsplus/acl.h
@@ -0,0 +1,30 @@
+/*
+ * linux/fs/hfsplus/acl.h
+ *
+ * Vyacheslav Dubeyko <slava@dubeyko.com>
+ *
+ * Handler for Posix Access Control Lists (ACLs) support.
+ */
+
+#include <linux/posix_acl_xattr.h>
+
+#ifdef CONFIG_HFSPLUS_FS_POSIX_ACL
+
+/* posix_acl.c */
+struct posix_acl *hfsplus_get_posix_acl(struct inode *inode, int type);
+extern int hfsplus_posix_acl_chmod(struct inode *);
+extern int hfsplus_init_posix_acl(struct inode *, struct inode *);
+
+#else  /* CONFIG_HFSPLUS_FS_POSIX_ACL */
+#define hfsplus_get_posix_acl NULL
+
+static inline int hfsplus_posix_acl_chmod(struct inode *inode)
+{
+	return 0;
+}
+
+static inline int hfsplus_init_posix_acl(struct inode *inode, struct inode *dir)
+{
+	return 0;
+}
+#endif  /* CONFIG_HFSPLUS_FS_POSIX_ACL */
diff -puN fs/hfsplus/hfsplus_fs.h~hfsplus-add-necessary-declarations-for-posix-acls-support fs/hfsplus/hfsplus_fs.h
--- a/fs/hfsplus/hfsplus_fs.h~hfsplus-add-necessary-declarations-for-posix-acls-support
+++ a/fs/hfsplus/hfsplus_fs.h
@@ -30,6 +30,7 @@
 #define DBG_EXTENT	0x00000020
 #define DBG_BITMAP	0x00000040
 #define DBG_ATTR_MOD	0x00000080
+#define DBG_ACL_MOD	0x00000100
 
 #if 0
 #define DBG_MASK	(DBG_EXTENT|DBG_INODE|DBG_BNODE_MOD)
_

Patches currently in -mm which might be from slava@dubeyko.com are

hfsplus-add-necessary-declarations-for-posix-acls-support.patch
hfsplus-implement-posix-acls-support.patch
hfsplus-integrate-posix-acls-support-into-driver.patch

