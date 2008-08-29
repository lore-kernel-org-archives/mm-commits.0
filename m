From: akpm@linux-foundation.org
Subject: + fs-kconfig-move-cifs-out.patch added to -mm tree
Date: Fri, 29 Aug 2008 13:11:29 -0700
Message-ID: <200808292011.m7TKBTst002205@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752498AbYH2ULe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Aug 2008 16:11:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, sfrench@us.ibm.com


The patch titled
     fs/Kconfig: move CIFS out
has been added to the -mm tree.  Its filename is
     fs-kconfig-move-cifs-out.patch

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
Subject: fs/Kconfig: move CIFS out
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig      |  143 ----------------------------------------------
 fs/cifs/Kconfig |  142 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 143 insertions(+), 142 deletions(-)

diff -puN fs/Kconfig~fs-kconfig-move-cifs-out fs/Kconfig
--- a/fs/Kconfig~fs-kconfig-move-cifs-out
+++ a/fs/Kconfig
@@ -1414,148 +1414,7 @@ config SMB_NLS_REMOTE
 
 	  smbmount from samba 2.2.0 or later supports this.
 
-config CIFS
-	tristate "CIFS support (advanced network filesystem, SMBFS successor)"
-	depends on INET
-	select NLS
-	help
-	  This is the client VFS module for the Common Internet File System
-	  (CIFS) protocol which is the successor to the Server Message Block 
-	  (SMB) protocol, the native file sharing mechanism for most early
-	  PC operating systems.  The CIFS protocol is fully supported by 
-	  file servers such as Windows 2000 (including Windows 2003, NT 4  
-	  and Windows XP) as well by Samba (which provides excellent CIFS
-	  server support for Linux and many other operating systems). Limited
-	  support for OS/2 and Windows ME and similar servers is provided as
-	  well.
-
-	  The cifs module provides an advanced network file system
-	  client for mounting to CIFS compliant servers.  It includes
-	  support for DFS (hierarchical name space), secure per-user
-	  session establishment via Kerberos or NTLM or NTLMv2,
-	  safe distributed caching (oplock), optional packet
-	  signing, Unicode and other internationalization improvements.
-	  If you need to mount to Samba or Windows from this machine, say Y.
-
-config CIFS_STATS
-        bool "CIFS statistics"
-        depends on CIFS
-        help
-          Enabling this option will cause statistics for each server share
-	  mounted by the cifs client to be displayed in /proc/fs/cifs/Stats
-
-config CIFS_STATS2
-	bool "Extended statistics"
-	depends on CIFS_STATS
-	help
-	  Enabling this option will allow more detailed statistics on SMB
-	  request timing to be displayed in /proc/fs/cifs/DebugData and also
-	  allow optional logging of slow responses to dmesg (depending on the
-	  value of /proc/fs/cifs/cifsFYI, see fs/cifs/README for more details).
-	  These additional statistics may have a minor effect on performance
-	  and memory utilization.
-
-	  Unless you are a developer or are doing network performance analysis
-	  or tuning, say N.
-
-config CIFS_WEAK_PW_HASH
-	bool "Support legacy servers which use weaker LANMAN security"
-	depends on CIFS
-	help
-	  Modern CIFS servers including Samba and most Windows versions
-	  (since 1997) support stronger NTLM (and even NTLMv2 and Kerberos)
-	  security mechanisms. These hash the password more securely
-	  than the mechanisms used in the older LANMAN version of the
-	  SMB protocol but LANMAN based authentication is needed to
-	  establish sessions with some old SMB servers.
-
-	  Enabling this option allows the cifs module to mount to older
-	  LANMAN based servers such as OS/2 and Windows 95, but such
-	  mounts may be less secure than mounts using NTLM or more recent
-	  security mechanisms if you are on a public network.  Unless you
-	  have a need to access old SMB servers (and are on a private
-	  network) you probably want to say N.  Even if this support
-	  is enabled in the kernel build, LANMAN authentication will not be
-	  used automatically. At runtime LANMAN mounts are disabled but
-	  can be set to required (or optional) either in
-	  /proc/fs/cifs (see fs/cifs/README for more detail) or via an
-	  option on the mount command. This support is disabled by
-	  default in order to reduce the possibility of a downgrade
-	  attack.
-
-	  If unsure, say N.
-
-config CIFS_UPCALL
-	  bool "Kerberos/SPNEGO advanced session setup"
-	  depends on CIFS && KEYS
-	  help
-	    Enables an upcall mechanism for CIFS which accesses
-	    userspace helper utilities to provide SPNEGO packaged (RFC 4178)
-	    Kerberos tickets which are needed to mount to certain secure servers
-	    (for which more secure Kerberos authentication is required). If
-	    unsure, say N.
-
-config CIFS_XATTR
-        bool "CIFS extended attributes"
-        depends on CIFS
-        help
-          Extended attributes are name:value pairs associated with inodes by
-          the kernel or by users (see the attr(5) manual page, or visit
-          <http://acl.bestbits.at/> for details).  CIFS maps the name of
-          extended attributes beginning with the user namespace prefix
-          to SMB/CIFS EAs. EAs are stored on Windows servers without the
-          user namespace prefix, but their names are seen by Linux cifs clients
-          prefaced by the user namespace prefix. The system namespace
-          (used by some filesystems to store ACLs) is not supported at
-          this time.
-
-          If unsure, say N.
-
-config CIFS_POSIX
-        bool "CIFS POSIX Extensions"
-        depends on CIFS_XATTR
-        help
-          Enabling this option will cause the cifs client to attempt to
-	  negotiate a newer dialect with servers, such as Samba 3.0.5
-	  or later, that optionally can handle more POSIX like (rather
-	  than Windows like) file behavior.  It also enables
-	  support for POSIX ACLs (getfacl and setfacl) to servers
-	  (such as Samba 3.10 and later) which can negotiate
-	  CIFS POSIX ACL support.  If unsure, say N.
-
-config CIFS_DEBUG2
-	bool "Enable additional CIFS debugging routines"
-	depends on CIFS
-	help
-	   Enabling this option adds a few more debugging routines
-	   to the cifs code which slightly increases the size of
-	   the cifs module and can cause additional logging of debug
-	   messages in some error paths, slowing performance. This
-	   option can be turned off unless you are debugging
-	   cifs problems.  If unsure, say N.
-
-config CIFS_EXPERIMENTAL
-	  bool "CIFS Experimental Features (EXPERIMENTAL)"
-	  depends on CIFS && EXPERIMENTAL
-	  help
-	    Enables cifs features under testing. These features are
-	    experimental and currently include DFS support and directory 
-	    change notification ie fcntl(F_DNOTIFY), as well as the upcall
-	    mechanism which will be used for Kerberos session negotiation
-	    and uid remapping.  Some of these features also may depend on 
-	    setting a value of 1 to the pseudo-file /proc/fs/cifs/Experimental
-	    (which is disabled by default). See the file fs/cifs/README 
-	    for more details.  If unsure, say N.
-
-config CIFS_DFS_UPCALL
-	  bool "DFS feature support (EXPERIMENTAL)"
-	  depends on CIFS_EXPERIMENTAL
-	  depends on KEYS
-	  help
-	    Enables an upcall mechanism for CIFS which contacts userspace
-	    helper utilities to provide server name resolution (host names to
-	    IP addresses) which is needed for implicit mounts of DFS junction
-	    points. If unsure, say N.
+source "fs/cifs/Kconfig"
 
 config NCP_FS
 	tristate "NCP file system support (to mount NetWare volumes)"
diff -puN /dev/null fs/cifs/Kconfig
--- /dev/null
+++ a/fs/cifs/Kconfig
@@ -0,0 +1,142 @@
+config CIFS
+	tristate "CIFS support (advanced network filesystem, SMBFS successor)"
+	depends on INET
+	select NLS
+	help
+	  This is the client VFS module for the Common Internet File System
+	  (CIFS) protocol which is the successor to the Server Message Block
+	  (SMB) protocol, the native file sharing mechanism for most early
+	  PC operating systems.  The CIFS protocol is fully supported by
+	  file servers such as Windows 2000 (including Windows 2003, NT 4
+	  and Windows XP) as well by Samba (which provides excellent CIFS
+	  server support for Linux and many other operating systems). Limited
+	  support for OS/2 and Windows ME and similar servers is provided as
+	  well.
+
+	  The cifs module provides an advanced network file system
+	  client for mounting to CIFS compliant servers.  It includes
+	  support for DFS (hierarchical name space), secure per-user
+	  session establishment via Kerberos or NTLM or NTLMv2,
+	  safe distributed caching (oplock), optional packet
+	  signing, Unicode and other internationalization improvements.
+	  If you need to mount to Samba or Windows from this machine, say Y.
+
+config CIFS_STATS
+        bool "CIFS statistics"
+        depends on CIFS
+        help
+          Enabling this option will cause statistics for each server share
+	  mounted by the cifs client to be displayed in /proc/fs/cifs/Stats
+
+config CIFS_STATS2
+	bool "Extended statistics"
+	depends on CIFS_STATS
+	help
+	  Enabling this option will allow more detailed statistics on SMB
+	  request timing to be displayed in /proc/fs/cifs/DebugData and also
+	  allow optional logging of slow responses to dmesg (depending on the
+	  value of /proc/fs/cifs/cifsFYI, see fs/cifs/README for more details).
+	  These additional statistics may have a minor effect on performance
+	  and memory utilization.
+
+	  Unless you are a developer or are doing network performance analysis
+	  or tuning, say N.
+
+config CIFS_WEAK_PW_HASH
+	bool "Support legacy servers which use weaker LANMAN security"
+	depends on CIFS
+	help
+	  Modern CIFS servers including Samba and most Windows versions
+	  (since 1997) support stronger NTLM (and even NTLMv2 and Kerberos)
+	  security mechanisms. These hash the password more securely
+	  than the mechanisms used in the older LANMAN version of the
+	  SMB protocol but LANMAN based authentication is needed to
+	  establish sessions with some old SMB servers.
+
+	  Enabling this option allows the cifs module to mount to older
+	  LANMAN based servers such as OS/2 and Windows 95, but such
+	  mounts may be less secure than mounts using NTLM or more recent
+	  security mechanisms if you are on a public network.  Unless you
+	  have a need to access old SMB servers (and are on a private
+	  network) you probably want to say N.  Even if this support
+	  is enabled in the kernel build, LANMAN authentication will not be
+	  used automatically. At runtime LANMAN mounts are disabled but
+	  can be set to required (or optional) either in
+	  /proc/fs/cifs (see fs/cifs/README for more detail) or via an
+	  option on the mount command. This support is disabled by
+	  default in order to reduce the possibility of a downgrade
+	  attack.
+
+	  If unsure, say N.
+
+config CIFS_UPCALL
+	  bool "Kerberos/SPNEGO advanced session setup"
+	  depends on CIFS && KEYS
+	  help
+	    Enables an upcall mechanism for CIFS which accesses
+	    userspace helper utilities to provide SPNEGO packaged (RFC 4178)
+	    Kerberos tickets which are needed to mount to certain secure servers
+	    (for which more secure Kerberos authentication is required). If
+	    unsure, say N.
+
+config CIFS_XATTR
+        bool "CIFS extended attributes"
+        depends on CIFS
+        help
+          Extended attributes are name:value pairs associated with inodes by
+          the kernel or by users (see the attr(5) manual page, or visit
+          <http://acl.bestbits.at/> for details).  CIFS maps the name of
+          extended attributes beginning with the user namespace prefix
+          to SMB/CIFS EAs. EAs are stored on Windows servers without the
+          user namespace prefix, but their names are seen by Linux cifs clients
+          prefaced by the user namespace prefix. The system namespace
+          (used by some filesystems to store ACLs) is not supported at
+          this time.
+
+          If unsure, say N.
+
+config CIFS_POSIX
+        bool "CIFS POSIX Extensions"
+        depends on CIFS_XATTR
+        help
+          Enabling this option will cause the cifs client to attempt to
+	  negotiate a newer dialect with servers, such as Samba 3.0.5
+	  or later, that optionally can handle more POSIX like (rather
+	  than Windows like) file behavior.  It also enables
+	  support for POSIX ACLs (getfacl and setfacl) to servers
+	  (such as Samba 3.10 and later) which can negotiate
+	  CIFS POSIX ACL support.  If unsure, say N.
+
+config CIFS_DEBUG2
+	bool "Enable additional CIFS debugging routines"
+	depends on CIFS
+	help
+	   Enabling this option adds a few more debugging routines
+	   to the cifs code which slightly increases the size of
+	   the cifs module and can cause additional logging of debug
+	   messages in some error paths, slowing performance. This
+	   option can be turned off unless you are debugging
+	   cifs problems.  If unsure, say N.
+
+config CIFS_EXPERIMENTAL
+	  bool "CIFS Experimental Features (EXPERIMENTAL)"
+	  depends on CIFS && EXPERIMENTAL
+	  help
+	    Enables cifs features under testing. These features are
+	    experimental and currently include DFS support and directory
+	    change notification ie fcntl(F_DNOTIFY), as well as the upcall
+	    mechanism which will be used for Kerberos session negotiation
+	    and uid remapping.  Some of these features also may depend on
+	    setting a value of 1 to the pseudo-file /proc/fs/cifs/Experimental
+	    (which is disabled by default). See the file fs/cifs/README
+	    for more details.  If unsure, say N.
+
+config CIFS_DFS_UPCALL
+	  bool "DFS feature support (EXPERIMENTAL)"
+	  depends on CIFS_EXPERIMENTAL
+	  depends on KEYS
+	  help
+	    Enables an upcall mechanism for CIFS which contacts userspace
+	    helper utilities to provide server name resolution (host names to
+	    IP addresses) which is needed for implicit mounts of DFS junction
+	    points. If unsure, say N.
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
less-softirq-vectors.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
anondev-init-idr-statically.patch
anondev-switch-to-ida.patch
cpuset-use-seq_cpumask-seq_nodemask.patch
sysctl-simplify-strategy.patch
fs-kconfig-move-ext2-ext3-ext4-jbd-jbd2-out.patch
fs-kconfig-move-autofs-autofs4-out.patch
fs-kconfig-move-jffs2-out.patch
fs-kconfig-move-cifs-out.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

