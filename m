From: akpm@linux-foundation.org
Subject: - documentation-document-hfsplus.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:56:05 -0700
Message-ID: <200707312356.l6VNu55m029292@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33543 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764087AbXHAARY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:17:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wyatt@banksresearch.com, rdunlap@xenotime.net, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Documentation: document HFSPlus
has been removed from the -mm tree.  Its filename was
     documentation-document-hfsplus.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Documentation: document HFSPlus
From: Wyatt Banks <wyatt@banksresearch.com>

Documentation: document HFSPlus filesystem and its mount options.

Signed-off-by: Wyatt Banks <wyatt@banksresearch.com>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/hfsplus.txt |   59 ++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff -puN /dev/null Documentation/filesystems/hfsplus.txt
--- /dev/null
+++ a/Documentation/filesystems/hfsplus.txt
@@ -0,0 +1,59 @@
+
+Macintosh HFSPlus Filesystem for Linux
+======================================
+
+HFSPlus is a filesystem first introduced in MacOS 8.1.
+HFSPlus has several extensions to HFS, including 32-bit allocation
+blocks, 255-character unicode filenames, and file sizes of 2^63 bytes.
+
+
+Mount options
+=============
+
+When mounting an HFSPlus filesystem, the following options are accepted:
+
+  creator=cccc, type=cccc
+	Specifies the creator/type values as shown by the MacOS finder
+	used for creating new files.  Default values: '????'.
+
+  uid=n, gid=n
+	Specifies the user/group that owns all files on the filesystem
+	that have uninitialized permissions structures.
+	Default:  user/group id of the mounting process.
+
+  umask=n
+	Specifies the umask (in octal) used for files and directories
+	that have uninitialized permissions structures.
+	Default:  umask of the mounting process.
+
+  session=n
+	Select the CDROM session to mount as HFSPlus filesystem.  Defaults to
+	leaving that decision to the CDROM driver.  This option will fail
+	with anything but a CDROM as underlying devices.
+
+  part=n
+	Select partition number n from the devices.  This option only makes
+	sense for CDROMs because they can't be partitioned under Linux.
+	For disk devices the generic partition parsing code does this
+	for us.  Defaults to not parsing the partition table at all.
+
+  decompose
+	Decompose file name characters.
+
+  nodecompose
+	Do not decompose file name characters.
+
+  force
+	Used to force write access to volumes that are marked as journalled
+	or locked.  Use at your own risk.
+
+  nls=cccc
+	Encoding to use when presenting file names.
+
+
+References
+==========
+
+kernel source:		<file:fs/hfsplus>
+
+Apple Technote 1150	http://developer.apple.com/technotes/tn/tn1150.html
_

Patches currently in -mm which might be from wyatt@banksresearch.com are

origin.patch
