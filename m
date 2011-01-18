From: akpm@linux-foundation.org
Subject: [merged] fs-fs_posix_acl-does-not-depend-on-block.patch removed from -mm tree
Date: Tue, 18 Jan 2011 12:30:22 -0800
Message-ID: <201101182030.p0IKUMbu003553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43889 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753274Ab1ARUok (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Jan 2011 15:44:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs: FS_POSIX_ACL does not depend on BLOCK
has been removed from the -mm tree.  Its filename was
     fs-fs_posix_acl-does-not-depend-on-block.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: FS_POSIX_ACL does not depend on BLOCK
From: Randy Dunlap <randy.dunlap@oracle.com>

- Fix a kconfig unmet dependency warning.
- Remove the comment that identifies which filesystems use POSIX ACL
  utility routines.
- Move the FS_POSIX_ACL symbol outside of the BLOCK symbol if/endif block
  because its functions do not depend on BLOCK and some of the filesystems
  that use it do not depend on BLOCK.

warning: (GENERIC_ACL && JFFS2_FS_POSIX_ACL && NFSD_V4 && NFS_ACL_SUPPORT && 9P_FS_POSIX_ACL) selects FS_POSIX_ACL which has unmet direct dependencies (BLOCK)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN fs/Kconfig~fs-fs_posix_acl-does-not-depend-on-block fs/Kconfig
--- a/fs/Kconfig~fs-fs_posix_acl-does-not-depend-on-block
+++ a/fs/Kconfig
@@ -30,15 +30,6 @@ config FS_MBCACHE
 source "fs/reiserfs/Kconfig"
 source "fs/jfs/Kconfig"
 
-config FS_POSIX_ACL
-# Posix ACL utility routines (for now, only ext2/ext3/jfs/reiserfs/nfs4)
-#
-# NOTE: you can implement Posix ACLs without these helpers (XFS does).
-# 	Never use this symbol for ifdefs.
-#
-	bool
-	default n
-
 source "fs/xfs/Kconfig"
 source "fs/gfs2/Kconfig"
 source "fs/ocfs2/Kconfig"
@@ -47,6 +38,14 @@ source "fs/nilfs2/Kconfig"
 
 endif # BLOCK
 
+# Posix ACL utility routines
+#
+# Note: Posix ACLs can be implemented without these helpers.  Never use
+# this symbol for ifdefs in core code.
+#
+config FS_POSIX_ACL
+	def_bool n
+
 config EXPORTFS
 	tristate
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
backlight-fix-88pm860x_bl-macro-collision.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

