From: akpm@linux-foundation.org
Subject: - deprecate-smbfs-in-favour-of-cifs-docs.patch removed from -mm tree
Date: Mon, 30 Apr 2007 12:23:41 -0700
Message-ID: <200704301923.l3UJNfmO012757@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946714AbXD3TX7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:23:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olecom@flower.upol.cz, sfrench@us.ibm.com, urban@teststation.com, mm-commits@vger.kernel.org


The patch titled
     deprecate-smbfs-in-favour-of-cifs docs
has been removed from the -mm tree.  Its filename was
     deprecate-smbfs-in-favour-of-cifs-docs.patch

This patch was dropped because it was folded into deprecate-smbfs-in-favour-of-cifs.patch

------------------------------------------------------
Subject: deprecate-smbfs-in-favour-of-cifs docs
From: Oleg Verych <olecom@flower.upol.cz>

Signed-off-by: Oleg Verych <olecom@flower.upol.cz>
Cc: Urban Widmark <urban@teststation.com>
Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN fs/Kconfig~deprecate-smbfs-in-favour-of-cifs-docs fs/Kconfig
--- a/fs/Kconfig~deprecate-smbfs-in-favour-of-cifs-docs
+++ a/fs/Kconfig
@@ -1175,7 +1175,7 @@ config BEFS_DEBUG
 	depends on BEFS_FS
 	help
 	  If you say Y here, you can use the 'debug' mount option to enable
-	  debugging output from the driver. 
+	  debugging output from the driver.
 
 config BFS_FS
 	tristate "BFS file system support (EXPERIMENTAL)"
@@ -1278,7 +1278,7 @@ config JFFS2_FS_XATTR
 	  Extended attributes are name:value pairs associated with inodes by
 	  the kernel or by users (see the attr(5) manual page, or visit
 	  <http://acl.bestbits.at/> for details).
-	  
+
 	  If unsure, say N.
 
 config JFFS2_FS_POSIX_ACL
@@ -1289,10 +1289,10 @@ config JFFS2_FS_POSIX_ACL
 	help
 	  Posix Access Control Lists (ACLs) support permissions for users and
 	  groups beyond the owner/group/world scheme.
-	  
+
 	  To learn more about Access Control Lists, visit the Posix ACLs for
 	  Linux website <http://acl.bestbits.at/>.
-	  
+
 	  If you don't know what Access Control Lists are, say N
 
 config JFFS2_FS_SECURITY
@@ -1304,7 +1304,7 @@ config JFFS2_FS_SECURITY
 	  implemented by security modules like SELinux.  This option
 	  enables an extended attribute handler for file security
 	  labels in the jffs2 filesystem.
-	  
+
 	  If you are not using a security module that requires using
 	  extended attributes for file security labels, say N.
 
@@ -1796,7 +1796,7 @@ config RPCSEC_GSS_SPKM3
 	  If unsure, say N.
 
 config SMB_FS
-	tristate "SMB file system support (to mount Windows shares etc.)"
+	tristate "SMB file system support (OBSOLETE, please use CIFS)"
 	depends on INET
 	select NLS
 	help
@@ -1819,8 +1819,8 @@ config SMB_FS
 	  General information about how to connect Linux, Windows machines and
 	  Macs is on the WWW at <http://www.eats.com/linux_mac_win.html>.
 
-	  To compile the SMB support as a module, choose M here: the module will
-	  be called smbfs.  Most people say N, however.
+	  To compile the SMB support as a module, choose M here:
+	  the module will be called smbfs.  Most people say N, however.
 
 config SMB_NLS_DEFAULT
 	bool "Use a default NLS"
@@ -1852,7 +1852,7 @@ config SMB_NLS_REMOTE
 	  smbmount from samba 2.2.0 or later supports this.
 
 config CIFS
-	tristate "CIFS support (advanced network filesystem for Samba, Window and other CIFS compliant servers)"
+	tristate "CIFS support (advanced network filesystem, SMBFS successor)"
 	depends on INET
 	select NLS
 	help
@@ -1907,16 +1907,16 @@ config CIFS_WEAK_PW_HASH
 	  LANMAN based servers such as OS/2 and Windows 95, but such
 	  mounts may be less secure than mounts using NTLM or more recent
 	  security mechanisms if you are on a public network.  Unless you
-	  have a need to access old SMB servers (and are on a private 
+	  have a need to access old SMB servers (and are on a private
 	  network) you probably want to say N.  Even if this support
 	  is enabled in the kernel build, they will not be used
 	  automatically. At runtime LANMAN mounts are disabled but
 	  can be set to required (or optional) either in
 	  /proc/fs/cifs (see fs/cifs/README for more detail) or via an
-	  option on the mount command. This support is disabled by 
+	  option on the mount command. This support is disabled by
 	  default in order to reduce the possibility of a downgrade
 	  attack.
- 
+
 	  If unsure, say N.
 
 config CIFS_XATTR
@@ -1957,7 +1957,7 @@ config CIFS_DEBUG2
 	   messages in some error paths, slowing performance. This
 	   option can be turned off unless you are debugging
 	   cifs problems.  If unsure, say N.
-	   
+
 config CIFS_EXPERIMENTAL
 	  bool "CIFS Experimental Features (EXPERIMENTAL)"
 	  depends on CIFS && EXPERIMENTAL
@@ -2038,7 +2038,7 @@ config CODA_FS_OLD_API
 	  However this new API is not backward compatible with older
 	  clients. If you really need to run the old Coda userspace
 	  cache manager then say Y.
-	  
+
 	  For most cases you probably want to say N.
 
 config AFS_FS
_

Patches currently in -mm which might be from olecom@flower.upol.cz are

deprecate-smbfs-in-favour-of-cifs.patch
deprecate-smbfs-in-favour-of-cifs-docs.patch
