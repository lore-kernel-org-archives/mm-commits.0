From: akpm@linux-foundation.org
Subject: - xfs-remove-the-sema_t-from-xfs.patch removed from -mm tree
Date: Thu, 14 Aug 2008 16:54:18 -0700
Message-ID: <200808142354.m7ENsImC003926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60277 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752033AbYHNXyW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Aug 2008 19:54:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@fromorbit.com, lachlan@sgi.com, tes@sgi.com, mm-commits@vger.kernel.org


The patch titled
     xfs: remove the sema_t from XFS.
has been removed from the -mm tree.  Its filename was
     xfs-remove-the-sema_t-from-xfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 fs/xfs/linux-2.6/sema.h      |   52 ---------------------------------
 fs/xfs/linux-2.6/xfs_linux.h |    2 -
 2 files changed, 1 insertion(+), 53 deletions(-)

diff -puN fs/xfs/linux-2.6/sema.h~xfs-remove-the-sema_t-from-xfs /dev/null
--- a/fs/xfs/linux-2.6/sema.h
+++ /dev/null
@@ -1,52 +0,0 @@
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
-	return down_trylock(sp) || (up(sp), 0);
-}
-
-/*
- * Map cpsema (try to get the sema) to down_trylock. We need to switch
- * the return values since cpsema returns 1 (acquired) 0 (failed) and
- * down_trylock returns the reverse 0 (acquired) 1 (failed).
- */
-static inline int cpsema(sema_t *sp)
-{
-	return down_trylock(sp) ? 0 : 1;
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

origin.patch
completions-un-inline-try_wait_for_completion-and-completion_done.patch
linux-next.patch

