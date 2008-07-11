From: akpm@linux-foundation.org
Subject: + xfs-remove-the-sema_t-from-xfs.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:39:18 -0700
Message-ID: <200807111844.m6BIixRL030919@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47575 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754721AbYGKSpF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:45:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@fromorbit.com, lachlan@sgi.com, tes@sgi.com


The patch titled
     xfs: remove the sema_t from XFS.
has been added to the -mm tree.  Its filename is
     xfs-remove-the-sema_t-from-xfs.patch

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
Subject: xfs: remove the sema_t from XFS.
From: Dave Chinner <david@fromorbit.com>

Now that all users of the sema_t are gone from XFS we can finally kill it.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Cc: Timothy Shimmin <tes@sgi.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/linux-2.6/sema.h      |   50 ---------------------------------
 fs/xfs/linux-2.6/xfs_linux.h |    2 -
 2 files changed, 1 insertion(+), 51 deletions(-)

diff -puN fs/xfs/linux-2.6/sema.h~xfs-remove-the-sema_t-from-xfs /dev/null
--- a/fs/xfs/linux-2.6/sema.h
+++ /dev/null
@@ -1,50 +0,0 @@
-/*
- * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_SUPPORT_SEMA_H__
-#define __XFS_SUPPORT_SEMA_H__
-
-#include <linux/time.h>
-#include <linux/wait.h>
-#include <linux/semaphore.h>
-#include <asm/atomic.h>
-
-/*
- * sema_t structure just maps to struct semaphore in Linux kernel.
- */
-
-typedef struct semaphore sema_t;
-
-#define initnsema(sp, val, name)	sema_init(sp, val)
-#define psema(sp, b)			down(sp)
-#define vsema(sp)			up(sp)
-#define freesema(sema)			do { } while (0)
-
-static inline int issemalocked(sema_t *sp)
-{
-	return !down_try(sp) || (up(sp), 0);
-}
-
-/*
- * Map cpsema (try to get the sema) to down_try.
- */
-static inline int cpsema(sema_t *sp)
-{
-	return down_try(sp);
-}
-
-#endif /* __XFS_SUPPORT_SEMA_H__ */
diff -puN fs/xfs/linux-2.6/xfs_linux.h~xfs-remove-the-sema_t-from-xfs fs/xfs/linux-2.6/xfs_linux.h
--- a/fs/xfs/linux-2.6/xfs_linux.h~xfs-remove-the-sema_t-from-xfs
+++ a/fs/xfs/linux-2.6/xfs_linux.h
@@ -45,13 +45,13 @@
 #include <mrlock.h>
 #include <sv.h>
 #include <mutex.h>
-#include <sema.h>
 #include <time.h>
 
 #include <support/ktrace.h>
 #include <support/debug.h>
 #include <support/uuid.h>
 
+#include <linux/semaphore.h>
 #include <linux/mm.h>
 #include <linux/kernel.h>
 #include <linux/blkdev.h>
_

Patches currently in -mm which might be from david@fromorbit.com are

xfs-clean-up-stale-references-to-semaphores.patch
xfs-replace-the-xfs-buf-iodone-semaphore-with-a-completion.patch
xfs-extend-completions-to-provide-xfs-object-flush-requirements.patch
xfs-replace-inode-flush-semaphore-with-a-completion.patch
xfs-replace-dquot-flush-semaphore-with-a-completion.patch
xfs-remove-the-sema_t-from-xfs.patch
xfs-fix-disabled-xfs-posix-acl-handling.patch

