From: akpm@linux-foundation.org
Subject: - convert-drivers-scsi-chc-to-use-unlocked_ioctl.patch removed from -mm tree
Date: Mon, 21 Jan 2008 15:13:36 -0800
Message-ID: <200801212313.m0LNDago024913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34483 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755467AbYAUXNp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jan 2008 18:13:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.segaud@regala.cx, James.Bottomley@steeleye.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Convert drivers/scsi/ch.c to use unlocked_ioctl
has been removed from the -mm tree.  Its filename was
     convert-drivers-scsi-chc-to-use-unlocked_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Convert drivers/scsi/ch.c to use unlocked_ioctl
From: Mathieu Segaud <mathieu.segaud@regala.cx>

As of now, compat_ioctl already runs without the BKL, whereas ioctl runs
with the BKL.  This patch first converts changer_fops to use a
.unlocked_ioctl member.  It applies the same locking rationale than
ch_ioctl_compat() uses to ch_ioctl().

Signed-off-by: Mathieu Segaud <mathieu.segaud@regala.cx>
Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ch.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN drivers/scsi/ch.c~convert-drivers-scsi-chc-to-use-unlocked_ioctl drivers/scsi/ch.c
--- a/drivers/scsi/ch.c~convert-drivers-scsi-chc-to-use-unlocked_ioctl
+++ a/drivers/scsi/ch.c
@@ -92,8 +92,7 @@ static int  ch_probe(struct device *);
 static int  ch_remove(struct device *);
 static int  ch_open(struct inode * inode, struct file * filp);
 static int  ch_release(struct inode * inode, struct file * filp);
-static int  ch_ioctl(struct inode * inode, struct file * filp,
-		     unsigned int cmd, unsigned long arg);
+static long ch_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
 #ifdef CONFIG_COMPAT
 static long ch_ioctl_compat(struct file * filp,
 			    unsigned int cmd, unsigned long arg);
@@ -130,12 +129,12 @@ static struct scsi_driver ch_template =
 
 static const struct file_operations changer_fops =
 {
-	.owner        = THIS_MODULE,
-	.open         = ch_open,
-	.release      = ch_release,
-	.ioctl        = ch_ioctl,
+	.owner		= THIS_MODULE,
+	.open		= ch_open,
+	.release	= ch_release,
+	.unlocked_ioctl	= ch_ioctl,
 #ifdef CONFIG_COMPAT
-	.compat_ioctl = ch_ioctl_compat,
+	.compat_ioctl	= ch_ioctl_compat,
 #endif
 };
 
@@ -626,7 +625,7 @@ ch_checkrange(scsi_changer *ch, unsigned
 	return 0;
 }
 
-static int ch_ioctl(struct inode * inode, struct file * file,
+static long ch_ioctl(struct file *file,
 		    unsigned int cmd, unsigned long arg)
 {
 	scsi_changer *ch = file->private_data;
@@ -887,8 +886,7 @@ static long ch_ioctl_compat(struct file 
 	case CHIOINITELEM:
 	case CHIOSVOLTAG:
 		/* compatible */
-		return ch_ioctl(NULL /* inode, unused */,
-				file, cmd, arg);
+		return ch_ioctl(file, cmd, arg);
 	case CHIOGSTATUS32:
 	{
 		struct changer_element_status32 ces32;
_

Patches currently in -mm which might be from mathieu.segaud@regala.cx are

git-scsi-misc.patch
