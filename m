From: akpm@linux-foundation.org
Subject: - fs-kconfig-move-autofs-autofs4-out.patch removed from -mm tree
Date: Sat, 13 Sep 2008 00:44:48 -0700
Message-ID: <200809130744.m8D7im2q026718@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751215AbYIMHox (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 13 Sep 2008 03:44:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     fs/Kconfig: move autofs, autofs4 out
has been removed from the -mm tree.  Its filename was
     fs-kconfig-move-autofs-autofs4-out.patch

This patch was dropped because rejects, of course

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/Kconfig: move autofs, autofs4 out
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig         |   44 +------------------------------------------
 fs/autofs/Kconfig  |   21 ++++++++++++++++++++
 fs/autofs4/Kconfig |   20 +++++++++++++++++++
 3 files changed, 43 insertions(+), 42 deletions(-)

diff -puN fs/Kconfig~fs-kconfig-move-autofs-autofs4-out fs/Kconfig
--- a/fs/Kconfig~fs-kconfig-move-autofs-autofs4-out
+++ a/fs/Kconfig
@@ -350,48 +350,8 @@ config QUOTACTL
 	depends on XFS_QUOTA || QUOTA
 	default y
 
-config AUTOFS_FS
-	tristate "Kernel automounter support"
-	help
-	  The automounter is a tool to automatically mount remote file systems
-	  on demand. This implementation is partially kernel-based to reduce
-	  overhead in the already-mounted case; this is unlike the BSD
-	  automounter (amd), which is a pure user space daemon.
-
-	  To use the automounter you need the user-space tools from the autofs
-	  package; you can find the location in <file:Documentation/Changes>.
-	  You also want to answer Y to "NFS file system support", below.
-
-	  If you want to use the newer version of the automounter with more
-	  features, say N here and say Y to "Kernel automounter v4 support",
-	  below.
-
-	  To compile this support as a module, choose M here: the module will be
-	  called autofs.
-
-	  If you are not a part of a fairly large, distributed network, you
-	  probably do not need an automounter, and can say N here.
-
-config AUTOFS4_FS
-	tristate "Kernel automounter version 4 support (also supports v3)"
-	help
-	  The automounter is a tool to automatically mount remote file systems
-	  on demand. This implementation is partially kernel-based to reduce
-	  overhead in the already-mounted case; this is unlike the BSD
-	  automounter (amd), which is a pure user space daemon.
-
-	  To use the automounter you need the user-space tools from
-	  <ftp://ftp.kernel.org/pub/linux/daemons/autofs/v4/>; you also
-	  want to answer Y to "NFS file system support", below.
-
-	  To compile this support as a module, choose M here: the module will be
-	  called autofs4.  You will need to add "alias autofs autofs4" to your
-	  modules configuration file.
-
-	  If you are not a part of a fairly large, distributed network or
-	  don't have a laptop which needs to dynamically reconfigure to the
-	  local network, you probably do not need an automounter, and can say
-	  N here.
+source "fs/autofs/Kconfig"
+source "fs/autofs4/Kconfig"
 
 config FUSE_FS
 	tristate "Filesystem in Userspace support"
diff -puN /dev/null fs/autofs/Kconfig
--- /dev/null
+++ a/fs/autofs/Kconfig
@@ -0,0 +1,21 @@
+config AUTOFS_FS
+	tristate "Kernel automounter support"
+	help
+	  The automounter is a tool to automatically mount remote file systems
+	  on demand. This implementation is partially kernel-based to reduce
+	  overhead in the already-mounted case; this is unlike the BSD
+	  automounter (amd), which is a pure user space daemon.
+
+	  To use the automounter you need the user-space tools from the autofs
+	  package; you can find the location in <file:Documentation/Changes>.
+	  You also want to answer Y to "NFS file system support", below.
+
+	  If you want to use the newer version of the automounter with more
+	  features, say N here and say Y to "Kernel automounter v4 support",
+	  below.
+
+	  To compile this support as a module, choose M here: the module will be
+	  called autofs.
+
+	  If you are not a part of a fairly large, distributed network, you
+	  probably do not need an automounter, and can say N here.
diff -puN /dev/null fs/autofs4/Kconfig
--- /dev/null
+++ a/fs/autofs4/Kconfig
@@ -0,0 +1,20 @@
+config AUTOFS4_FS
+	tristate "Kernel automounter version 4 support (also supports v3)"
+	help
+	  The automounter is a tool to automatically mount remote file systems
+	  on demand. This implementation is partially kernel-based to reduce
+	  overhead in the already-mounted case; this is unlike the BSD
+	  automounter (amd), which is a pure user space daemon.
+
+	  To use the automounter you need the user-space tools from
+	  <ftp://ftp.kernel.org/pub/linux/daemons/autofs/v4/>; you also
+	  want to answer Y to "NFS file system support", below.
+
+	  To compile this support as a module, choose M here: the module will be
+	  called autofs4.  You will need to add "alias autofs autofs4" to your
+	  modules configuration file.
+
+	  If you are not a part of a fairly large, distributed network or
+	  don't have a laptop which needs to dynamically reconfigure to the
+	  local network, you probably do not need an automounter, and can say
+	  N here.
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-more-debugging-for-already-registered-case.patch
linux-next.patch
itimers-fix-itimer-many-thread-hang.patch
itimers-fix-itimer-many-thread-hang-checkpatch-fixes.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
cpuset-use-seq_cpumask-seq_nodemask.patch
compat_binfmt_elf-definition-tweak.patch
proc-move-sysrq-trigger-out-of-fs-proc.patch
proc-fix-return-value-of-proc_reg_open-in-too-late-case.patch
proc-proc_sys_root-tweak.patch
proc-remove-dummy-vmcore_open.patch
proc-remove-unused-get_dma_list.patch
sysctl-simplify-strategy.patch
fs-kconfig-move-ext2-ext3-ext4-jbd-jbd2-out.patch
fs-kconfig-move-autofs-autofs4-out.patch
fs-kconfig-move-cifs-out.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

