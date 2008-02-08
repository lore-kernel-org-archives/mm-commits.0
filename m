From: akpm@linux-foundation.org
Subject: + tty-bkl-pushdown-fix1.patch added to -mm tree
Date: Fri, 08 Feb 2008 14:08:40 -0800
Message-ID: <200802082208.m18M8ev6015981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45346 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761604AbYBHWJj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 17:09:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     tty: BKL pushdown fix1
has been added to the -mm tree.  Its filename is
     tty-bkl-pushdown-fix1.patch

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
Subject: tty: BKL pushdown fix1
From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat_ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/compat_ioctl.c~tty-bkl-pushdown-fix1 fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~tty-bkl-pushdown-fix1
+++ a/fs/compat_ioctl.c
@@ -1046,7 +1046,7 @@ static int vt_check(struct file *file)
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct vc_data *vc;
 	
-	if (file->f_op->ioctl != tty_ioctl)
+	if (file->f_op->unlocked_ioctl != tty_ioctl)
 		return -EINVAL;
 	                
 	tty = (struct tty_struct *)file->private_data;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
git-watchdog.patch
tty-bkl-pushdown-fix1.patch
mxser-convert-large-macros-to-functions.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
