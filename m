From: akpm@linux-foundation.org
Subject: + use-warn-in-fs.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:45:36 -0700
Message-ID: <200807111851.m6BIpHXe031326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46374 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757346AbYGKSvT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:51:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com


The patch titled
     Use WARN() in fs/
has been added to the -mm tree.  Its filename is
     use-warn-in-fs.patch

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
@@ -312,10 +312,9 @@ static void handle_write_count_underflow
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

linux-next.patch
via-velocity-fix-sleep-with-spinlock-bug-during-mtu-change.patch
rename-warn-to-warning-to-clear-the-namespace.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
kernel-irq-managec-replace-a-printk-warn_on-to-a-warn.patch
example-use-of-warn.patch
use-warn-in-kernel-irq-managec.patch
use-warn-in-kernel-panicc.patch
use-warn-in-mm-vmallocc.patch
use-warn-in-kernel-lockdepc.patch
use-warn-in-kernel-irq-chipc.patch
use-warn-in-arch-x86-mm-ioremapc.patch
use-warn-in-arch-x86-mm-pageattrc.patch
use-warn-in-arch-x86-kernel.patch
use-warn-in-block.patch
use-warn-in-drivers-base.patch
use-warn-in-lib.patch
use-warn-in-fs.patch
usr-warn-in-fs-sysfs.patch
use-warn-in-fs-proc.patch

