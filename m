From: akpm@linux-foundation.org
Subject: - ecryptfs-move-ecryptfs-docs-into-documentation-filesystems.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:05:21 -0700
Message-ID: <200707172305.l6HN5LJn011914@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45255 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762199AbXGQXPc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: Move ecryptfs docs into Documentation/filesystems/
has been removed from the -mm tree.  Its filename was
     ecryptfs-move-ecryptfs-docs-into-documentation-filesystems.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: eCryptfs: Move ecryptfs docs into Documentation/filesystems/
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
Acked-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ecryptfs.txt             |   77 -----------------------
 Documentation/filesystems/ecryptfs.txt |   77 +++++++++++++++++++++++
 2 files changed, 77 insertions(+), 77 deletions(-)

diff -puN Documentation/ecryptfs.txt~ecryptfs-move-ecryptfs-docs-into-documentation-filesystems /dev/null
--- a/Documentation/ecryptfs.txt
+++ /dev/null
@@ -1,77 +0,0 @@
-eCryptfs: A stacked cryptographic filesystem for Linux
-
-eCryptfs is free software. Please see the file COPYING for details.
-For documentation, please see the files in the doc/ subdirectory.  For
-building and installation instructions please see the INSTALL file.
-
-Maintainer: Phillip Hellewell
-Lead developer: Michael A. Halcrow <mhalcrow@us.ibm.com>
-Developers: Michael C. Thompson
-            Kent Yoder
-Web Site: http://ecryptfs.sf.net
-
-This software is currently undergoing development. Make sure to
-maintain a backup copy of any data you write into eCryptfs.
-
-eCryptfs requires the userspace tools downloadable from the
-SourceForge site:
-
-http://sourceforge.net/projects/ecryptfs/
-
-Userspace requirements include:
- - David Howells' userspace keyring headers and libraries (version
-   1.0 or higher), obtainable from
-   http://people.redhat.com/~dhowells/keyutils/
- - Libgcrypt
-
-
-NOTES
-
-In the beta/experimental releases of eCryptfs, when you upgrade
-eCryptfs, you should copy the files to an unencrypted location and
-then copy the files back into the new eCryptfs mount to migrate the
-files.
-
-
-MOUNT-WIDE PASSPHRASE
-
-Create a new directory into which eCryptfs will write its encrypted
-files (i.e., /root/crypt).  Then, create the mount point directory
-(i.e., /mnt/crypt).  Now it's time to mount eCryptfs:
-
-mount -t ecryptfs /root/crypt /mnt/crypt
-
-You should be prompted for a passphrase and a salt (the salt may be
-blank).
-
-Try writing a new file:
-
-echo "Hello, World" > /mnt/crypt/hello.txt
-
-The operation will complete.  Notice that there is a new file in
-/root/crypt that is at least 12288 bytes in size (depending on your
-host page size).  This is the encrypted underlying file for what you
-just wrote.  To test reading, from start to finish, you need to clear
-the user session keyring:
-
-keyctl clear @u
-
-Then umount /mnt/crypt and mount again per the instructions given
-above.
-
-cat /mnt/crypt/hello.txt
-
-
-NOTES
-
-eCryptfs version 0.1 should only be mounted on (1) empty directories
-or (2) directories containing files only created by eCryptfs. If you
-mount a directory that has pre-existing files not created by eCryptfs,
-then behavior is undefined. Do not run eCryptfs in higher verbosity
-levels unless you are doing so for the sole purpose of debugging or
-development, since secret values will be written out to the system log
-in that case.
-
-
-Mike Halcrow
-mhalcrow@us.ibm.com
diff -puN /dev/null Documentation/filesystems/ecryptfs.txt
--- /dev/null
+++ a/Documentation/filesystems/ecryptfs.txt
@@ -0,0 +1,77 @@
+eCryptfs: A stacked cryptographic filesystem for Linux
+
+eCryptfs is free software. Please see the file COPYING for details.
+For documentation, please see the files in the doc/ subdirectory.  For
+building and installation instructions please see the INSTALL file.
+
+Maintainer: Phillip Hellewell
+Lead developer: Michael A. Halcrow <mhalcrow@us.ibm.com>
+Developers: Michael C. Thompson
+            Kent Yoder
+Web Site: http://ecryptfs.sf.net
+
+This software is currently undergoing development. Make sure to
+maintain a backup copy of any data you write into eCryptfs.
+
+eCryptfs requires the userspace tools downloadable from the
+SourceForge site:
+
+http://sourceforge.net/projects/ecryptfs/
+
+Userspace requirements include:
+ - David Howells' userspace keyring headers and libraries (version
+   1.0 or higher), obtainable from
+   http://people.redhat.com/~dhowells/keyutils/
+ - Libgcrypt
+
+
+NOTES
+
+In the beta/experimental releases of eCryptfs, when you upgrade
+eCryptfs, you should copy the files to an unencrypted location and
+then copy the files back into the new eCryptfs mount to migrate the
+files.
+
+
+MOUNT-WIDE PASSPHRASE
+
+Create a new directory into which eCryptfs will write its encrypted
+files (i.e., /root/crypt).  Then, create the mount point directory
+(i.e., /mnt/crypt).  Now it's time to mount eCryptfs:
+
+mount -t ecryptfs /root/crypt /mnt/crypt
+
+You should be prompted for a passphrase and a salt (the salt may be
+blank).
+
+Try writing a new file:
+
+echo "Hello, World" > /mnt/crypt/hello.txt
+
+The operation will complete.  Notice that there is a new file in
+/root/crypt that is at least 12288 bytes in size (depending on your
+host page size).  This is the encrypted underlying file for what you
+just wrote.  To test reading, from start to finish, you need to clear
+the user session keyring:
+
+keyctl clear @u
+
+Then umount /mnt/crypt and mount again per the instructions given
+above.
+
+cat /mnt/crypt/hello.txt
+
+
+NOTES
+
+eCryptfs version 0.1 should only be mounted on (1) empty directories
+or (2) directories containing files only created by eCryptfs. If you
+mount a directory that has pre-existing files not created by eCryptfs,
+then behavior is undefined. Do not run eCryptfs in higher verbosity
+levels unless you are doing so for the sole purpose of debugging or
+development, since secret values will be written out to the system log
+in that case.
+
+
+Mike Halcrow
+mhalcrow@us.ibm.com
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

origin.patch
git-unionfs.patch
git-block-vs-git-unionfs.patch
fs-introduce-vfs_path_lookup.patch
sunrpc-use-vfs_path_lookup.patch
nfsctl-use-vfs_path_lookup.patch
fs-mark-link_path_walk-static.patch
fs-remove-path_walk-export.patch
