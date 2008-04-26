From: akpm@linux-foundation.org
Subject: - convert-drivers-char-agp-frontendc-to-use-unlocked_ioctl.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:40:12 -0700
Message-ID: <200804261640.m3QGeCnx031009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43532 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758366AbYDZQtj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:49:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.segaud@regala.cx, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     Convert drivers/char/agp/frontend.c to use unlocked_ioctl
has been removed from the -mm tree.  Its filename was
     convert-drivers-char-agp-frontendc-to-use-unlocked_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Convert drivers/char/agp/frontend.c to use unlocked_ioctl
From: Mathieu Segaud <mathieu.segaud@regala.cx>

As of now, agp_compat_ioctl already runs without the BKL.  Mutual exclusion
is enforced by agp_fe.agp_mutex in agp_ioctl() and agp_compat_ioctl(). 
Apply the same locking rationale to the two functions allowing BKL cleanup.

Signed-off-by: Mathieu Segaud <mathieu.segaud@regala.cx>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/frontend.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/agp/frontend.c~convert-drivers-char-agp-frontendc-to-use-unlocked_ioctl drivers/char/agp/frontend.c
--- a/drivers/char/agp/frontend.c~convert-drivers-char-agp-frontendc-to-use-unlocked_ioctl
+++ a/drivers/char/agp/frontend.c
@@ -967,7 +967,7 @@ int agpioc_chipset_flush_wrap(struct agp
 	return 0;
 }
 
-static int agp_ioctl(struct inode *inode, struct file *file,
+static long agp_ioctl(struct file *file,
 		     unsigned int cmd, unsigned long arg)
 {
 	struct agp_file_private *curr_priv = file->private_data;
@@ -1058,7 +1058,7 @@ static const struct file_operations agp_
 	.llseek		= no_llseek,
 	.read		= agp_read,
 	.write		= agp_write,
-	.ioctl		= agp_ioctl,
+	.unlocked_ioctl	= agp_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= compat_agp_ioctl,
 #endif
_

Patches currently in -mm which might be from mathieu.segaud@regala.cx are

git-agpgart.patch

