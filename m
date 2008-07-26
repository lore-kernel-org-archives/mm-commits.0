From: akpm@linux-foundation.org
Subject: - use-warn-in-fs.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:16:26 -0700
Message-ID: <200807262116.m6QLGQ6n019831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34090 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757692AbYGZVQ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:16:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Use WARN() in fs/
has been removed from the -mm tree.  Its filename was
     use-warn-in-fs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Use WARN() in fs/
From: Arjan van de Ven <arjan@linux.intel.com>

Use WARN() instead of a printk+WARN_ON() pair; this way the message
becomes part of the warning section for better reporting/collection.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c    |    3 +--
 fs/namespace.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/buffer.c~use-warn-in-fs fs/buffer.c
--- a/fs/buffer.c~use-warn-in-fs
+++ a/fs/buffer.c
@@ -1214,8 +1214,7 @@ void __brelse(struct buffer_head * buf)
 		put_bh(buf);
 		return;
 	}
-	printk(KERN_ERR "VFS: brelse: Trying to free free buffer\n");
-	WARN_ON(1);
+	WARN(1, KERN_ERR "VFS: brelse: Trying to free free buffer\n");
 }
 
 /*
diff -puN fs/namespace.c~use-warn-in-fs fs/namespace.c
--- a/fs/namespace.c~use-warn-in-fs
+++ a/fs/namespace.c
@@ -309,10 +309,9 @@ static void handle_write_count_underflow
 	 */
 	if ((atomic_read(&mnt->__mnt_writers) < 0) &&
 	    !(mnt->mnt_flags & MNT_IMBALANCED_WRITE_COUNT)) {
-		printk(KERN_DEBUG "leak detected on mount(%p) writers "
+		WARN(1, KERN_DEBUG "leak detected on mount(%p) writers "
 				"count: %d\n",
 			mnt, atomic_read(&mnt->__mnt_writers));
-		WARN_ON(1);
 		/* use the flag to keep the dmesg spam down */
 		mnt->mnt_flags |= MNT_IMBALANCED_WRITE_COUNT;
 	}
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch
linux-next.patch
via-velocity-fix-sleep-with-spinlock-bug-during-mtu-change.patch
modules-extend-initcall_debug-functionality-to-the-module-loader.patch
use-warn-in-kernel-lockdepc.patch
use-warn-in-arch-x86-mm-ioremapc.patch
use-warn-in-arch-x86-mm-pageattrc.patch
use-warn-in-arch-x86-kernel.patch

