From: akpm@osdl.org
Subject: + unionfs-documentation.patch added to -mm tree
Date: Mon, 08 Jan 2007 13:08:12 -0800
Message-ID: <200701082108.l08L8DQe018871@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43321 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbXAHVI3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 16:08:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jsipek@cs.sunysb.edu, dquigley@fsl.cs.sunysb.edu, ezk@cs.sunysb.edu


The patch titled
     unionfs: documentation
has been added to the -mm tree.  Its filename is
     unionfs-documentation.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: unionfs: documentation
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

Documentation for Unionfs.  You will find several files outlining basic
unification concepts and rename semantics.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: David Quigley <dquigley@fsl.cs.sunysb.edu>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/filesystems/00-INDEX             |    2 
 Documentation/filesystems/unionfs/00-INDEX     |    8 +
 Documentation/filesystems/unionfs/concepts.txt |   70 +++++++++++++++
 Documentation/filesystems/unionfs/rename.txt   |   31 ++++++
 Documentation/filesystems/unionfs/usage.txt    |   42 +++++++++
 5 files changed, 153 insertions(+)

diff -puN Documentation/filesystems/00-INDEX~unionfs-documentation Documentation/filesystems/00-INDEX
--- a/Documentation/filesystems/00-INDEX~unionfs-documentation
+++ a/Documentation/filesystems/00-INDEX
@@ -82,6 +82,8 @@ udf.txt
 	- info and mount options for the UDF filesystem.
 ufs.txt
 	- info on the ufs filesystem.
+unionfs/
+	- info on the unionfs filesystem
 v9fs.txt
 	- v9fs is a Unix implementation of the Plan 9 9p remote fs protocol.
 vfat.txt
diff -puN /dev/null Documentation/filesystems/unionfs/00-INDEX
--- /dev/null
+++ a/Documentation/filesystems/unionfs/00-INDEX
@@ -0,0 +1,8 @@
+00-INDEX
+	- this file.
+concepts.txt
+	- A brief introduction of concepts
+rename.txt
+	- Information regarding rename operations
+usage.txt
+	- Usage and known limitations
diff -puN /dev/null Documentation/filesystems/unionfs/concepts.txt
--- /dev/null
+++ a/Documentation/filesystems/unionfs/concepts.txt
@@ -0,0 +1,70 @@
+This file describes the concepts needed by a namespace unification file
+system.
+
+Branch Priority:
+================
+
+Each branch is assigned a unique priority - starting from 0 (highest
+priority).  No two branches can have the same priority.
+
+
+Branch Mode:
+============
+
+Each branch is assigned a mode - read-write or read-only. This allows
+directories on media mounted read-write to be used in a read-only manner.
+
+
+Whiteouts:
+==========
+
+A whiteout removes a file name from the namespace. Whiteouts are needed when
+one attempts to remove a file on a read-only branch.
+
+Suppose we have a two-branch union, where branch 0 is read-write and branch
+1 is read-only. And a file 'foo' on branch 1:
+
+./b0/
+./b1/
+./b1/foo
+
+The unified view would simply be:
+
+./union/
+./union/foo
+
+Since 'foo' is stored on a read-only branch, it cannot be removed. A
+whiteout is used to remove the name 'foo' from the unified namespace. Again,
+since branch 1 is read-only, the whiteout cannot be created there. So, we
+try on a higher priority (lower numerically) branch and create the whiteout
+there.
+
+./b0/
+./b0/.wh.foo
+./b1/
+./b1/foo
+
+Later, when Unionfs traverses branches (due to lookup or readdir), it
+eliminate 'foo' from the namespace (as well as the whiteout itself.)
+
+
+Duplicate Elimination:
+======================
+
+It is possible for files on different branches to have the same name.
+Unionfs then has to select which instance of the file to show to the user.
+Given the fact that each branch has a priority associated with it, the
+simplest solution is to take the instance from the highest priority
+(numerically lowest value) and "hide" the others.
+
+
+Copyup:
+=======
+
+When a change is made to the contents of a file's data or meta-data, they
+have to be stored somewhere. The best way is to create a copy of the
+original file on a branch that is writable, and then redirect the write
+though to this copy. The copy must be made on a higher priority branch so
+that lookup and readdir return this newer "version" of the file rather than
+the original (see duplicate elimination).
+
diff -puN /dev/null Documentation/filesystems/unionfs/rename.txt
--- /dev/null
+++ a/Documentation/filesystems/unionfs/rename.txt
@@ -0,0 +1,31 @@
+Rename is a complex beast. The following table shows which rename(2) operations
+should succeed and which should fail.
+
+o: success
+E: error (either unionfs or vfs)
+X: EXDEV
+
+none = file does not exist
+file = file is a file
+dir  = file is a empty directory
+child= file is a non-empty directory
+wh   = file is a directory containing only whiteouts; this makes it logically
+		empty
+
+                      none    file    dir     child   wh
+file                  o       o       E       E       E
+dir                   o       E       o       E       o
+child                 X       E       X       E       X
+wh                    o       E       o       E       o
+
+
+Renaming directories:
+=====================
+
+Whenever a empty (either physically or logically) directory is being renamed,
+the following sequence of events should take place:
+
+1) Remove whiteouts from both source and destination directory
+2) Rename source to destination
+3) Make destination opaque to prevent anything under it from showing up
+
diff -puN /dev/null Documentation/filesystems/unionfs/usage.txt
--- /dev/null
+++ a/Documentation/filesystems/unionfs/usage.txt
@@ -0,0 +1,42 @@
+Unionfs is a stackable unification file system, which can appear to merge
+the contents of several directories (branches), while keeping their physical
+content separate. Unionfs is useful for unified source tree management,
+merged contents of split CD-ROM, merged separate software package
+directories, data grids, and more. Unionfs allows any mix of read-only and
+read-write branches, as well as insertion and deletion of branches anywhere
+in the fan-out. To maintain unix semantics, Unionfs handles elimination of
+duplicates, partial-error conditions, and more.
+
+mount -t unionfs -o branch-option[,union-options[,...]] none MOUNTPOINT
+
+The available branch-option for the mount command is:
+
+dirs=branch[=ro|=rw][:...]
+specifies a separated list of which directories compose the union.
+Directories that come earlier in the list have a higher precedence than
+those which come later. Additionally, read-only or read-write permissions of
+the branch can be specified by appending =ro or =rw (default) to each
+directory.
+
+Syntax:
+dirs=/branch1[=ro|=rw]:/branch2[=ro|=rw]:...:/branchN[=ro|=rw]
+
+Example:
+dirs=/writable_branch=rw:/read-only_branch=ro
+
+
+KNOWN ISSUES:
+=============
+
+The NFS server returns -EACCES for read-only exports, instead of -EROFS.
+This means we can't reliably detect a read-only NFS export.
+
+Modifying a Unionfs branch directly, while the union is mounted, is
+currently unsupported.  Any such change can cause Unionfs to oops, or stay
+silent and even RESULT IN DATA LOSS.
+
+Unionfs should not use lookup_one_len() on the underlying fs as it confuses
+NFS. Currently, unionfs_lookup() passes lookup intents to the lower
+filesystem, this eliminates part of the problem. The remaining calls to
+lookup_one_len may need to be changed to pass an intent.
+
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

unionfs-documentation.patch
lookup_one_len_nd-lookup_one_len-with-nameidata-argument.patch
unionfs-branch-management-functionality.patch
unionfs-common-file-operations.patch
unionfs-copyup-functionality.patch
unionfs-dentry-operations.patch
unionfs-file-operations.patch
unionfs-directory-file-operations.patch
unionfs-directory-manipulation-helper-functions.patch
unionfs-inode-operations.patch
unionfs-lookup-helper-functions.patch
unionfs-main-module-functions.patch
unionfs-readdir-state.patch
unionfs-rename.patch
unionfs-privileged-operations-workqueue.patch
unionfs-handling-of-stale-inodes.patch
unionfs-miscellaneous-helper-functions.patch
unionfs-superblock-operations.patch
unionfs-helper-macros-inlines.patch
unionfs-internal-include-file.patch
unionfs-include-file.patch
unionfs-unlink.patch
unionfs-kconfig-and-makefile.patch
unionfs-extended-attributes-support.patch
