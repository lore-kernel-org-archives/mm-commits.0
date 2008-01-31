From: akpm@linux-foundation.org
Subject: + convert-drivers-char-agp-frontendc-to-use-unlocked_ioctl.patch added to -mm tree
Date: Thu, 31 Jan 2008 15:50:48 -0800
Message-ID: <200801312350.m0VNonfH017694@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45310 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756184AbYAaXu6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jan 2008 18:50:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.segaud@regala.cx, airlied@linux.ie


The patch titled
     Convert drivers/char/agp/frontend.c to use unlocked_ioctl
has been added to the -mm tree.  Its filename is
     convert-drivers-char-agp-frontendc-to-use-unlocked_ioctl.patch

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

origin.patch
convert-drivers-char-agp-frontendc-to-use-unlocked_ioctl.patch
