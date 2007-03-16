From: akpm@linux-foundation.org
Subject: + revoke-core-code-move-magic.patch added to -mm tree
Date: Fri, 16 Mar 2007 03:28:34 -0800
Message-ID: <200703161128.l2GBSYuI009960@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41792 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753492AbXCPL2n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Mar 2007 07:28:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penberg@cs.helsinki.fi


The patch titled
     revoke: move magic
has been added to the -mm tree.  Its filename is
     revoke-core-code-move-magic.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -34,6 +34,7 @@
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

slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
unionfs-fix-slab-abuses-with-krealloc.patch
slab-ensure-cache_alloc_refill-terminates.patch
module-use-krealloc.patch
slab-use-cpu_lock_.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-core-code-misc-fixes.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-core-code-move-magic.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
slab-leaks3-default-y.patch
