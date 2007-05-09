From: akpm@linux-foundation.org
Subject: - revoke-core-code-move-magic.patch removed from -mm tree
Date: Wed, 09 May 2007 02:55:42 -0700
Message-ID: <200705090955.l499tgZh020518@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757235AbXEIJz5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:55:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     revoke: move magic
has been removed from the -mm tree.  Its filename was
     revoke-core-code-move-magic.patch

This patch was dropped because it was folded into revoke-core-code.patch

------------------------------------------------------
Subject: revoke: move magic
From: Pekka Enberg <penberg@cs.helsinki.fi>

Move REVOKEFS_MAGIC to <linux/magic.h> where it belongs.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/revoke.c                  |    1 +
 include/linux/magic.h        |    1 +
 include/linux/revoked_fs_i.h |    2 --
 3 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/revoke.c~revoke-core-code-move-magic fs/revoke.c
--- a/fs/revoke.c~revoke-core-code-move-magic
+++ a/fs/revoke.c
@@ -9,6 +9,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/namei.h>
+#include <linux/magic.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
 #include <linux/module.h>
diff -puN include/linux/magic.h~revoke-core-code-move-magic include/linux/magic.h
--- a/include/linux/magic.h~revoke-core-code-move-magic
+++ a/include/linux/magic.h
@@ -35,6 +35,7 @@
 #define REISERFS_SUPER_MAGIC_STRING	"ReIsErFs"
 #define REISER2FS_SUPER_MAGIC_STRING	"ReIsEr2Fs"
 #define REISER2FS_JR_SUPER_MAGIC_STRING	"ReIsEr3Fs"
+#define REVOKEFS_MAGIC		0x5245564B      /* REVK */
 
 #define UNIONFS_SUPER_MAGIC 0xf15f083d
 
diff -puN include/linux/revoked_fs_i.h~revoke-core-code-move-magic include/linux/revoked_fs_i.h
--- a/include/linux/revoked_fs_i.h~revoke-core-code-move-magic
+++ a/include/linux/revoked_fs_i.h
@@ -1,8 +1,6 @@
 #ifndef _LINUX_REVOKED_FS_I_H
 #define _LINUX_REVOKED_FS_I_H
 
-#define REVOKEFS_MAGIC 0x5245564B      /* REVK */
-
 struct revokefs_inode_info {
 	struct task_struct *owner;
 	struct file *file;
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

origin.patch
krealloc-fix-kerneldoc-comments.patch
slab-use-cpu_lock_.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
unionfs-fix-slab-abuses-with-krealloc.patch
revoke-special-mmap-handling.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
revoke-core-code.patch
revoke-core-code-move-magic.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
revoke-core-code-fix-shared-mapping-revoke-revoke-only-revoke-mappings-for-the-given-inode.patch
revoke-core-code-break-cow-for-private-mappings.patch
revoke-core-code-generic_file_revoke-stub-for-nommu.patch
revoke-core-code-break-cow-fixes.patch
revoke-core-code-mapping-revocation.patch
revoke-core-code-only-fput-unused-files.patch
revoke-core-code-rename-to-can_revoke_filevma.patch
revoke-core-code-change-revoke_table-to-fileset-and-revoke_details.patch
revoke-core-code-do_revoke-error-handling.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
slab-leaks3-default-y.patch
