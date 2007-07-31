From: akpm@linux-foundation.org
Subject: - remove-isdn_-is-defined-but-unused-warnings.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:59:11 -0700
Message-ID: <200707312359.l6VNxBGJ029630@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51800 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759633AbXHAAQe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:16:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: masterdriverz@gentoo.org, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     Remove 'isdn_* is defined but unused' warnings
has been removed from the -mm tree.  Its filename was
     remove-isdn_-is-defined-but-unused-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove 'isdn_* is defined but unused' warnings
From: Charlie Shepherd <masterdriverz@gentoo.org>

Move the #ifdef guard above these functions to remove the warnings.

Signed-off-by: Charlie Shepherd <masterdriverz@gentoo.org>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/divert/divert_procfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/isdn/divert/divert_procfs.c~remove-isdn_-is-defined-but-unused-warnings drivers/isdn/divert/divert_procfs.c
--- a/drivers/isdn/divert/divert_procfs.c~remove-isdn_-is-defined-but-unused-warnings
+++ a/drivers/isdn/divert/divert_procfs.c
@@ -70,6 +70,8 @@ put_info_buffer(char *cp)
 	wake_up_interruptible(&(rd_queue));
 }				/* put_info_buffer */
 
+#ifdef CONFIG_PROC_FS
+
 /**********************************/
 /* deflection device read routine */
 /**********************************/
@@ -253,8 +255,6 @@ isdn_divert_ioctl(struct inode *inode, s
 	return copy_to_user((void __user *)arg, &dioctl, sizeof(dioctl)) ? -EFAULT : 0;
 }				/* isdn_divert_ioctl */
 
-
-#ifdef CONFIG_PROC_FS
 static const struct file_operations isdn_fops =
 {
 	.owner          = THIS_MODULE,
_

Patches currently in -mm which might be from masterdriverz@gentoo.org are

origin.patch
