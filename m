From: akpm@linux-foundation.org
Subject: + framebuffer-compat_ioctl-deadlock.patch added to -mm tree
Date: Tue, 28 Oct 2008 14:34:46 -0700
Message-ID: <200810282134.m9SLYkhU009617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752381AbYJ1VfZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 17:35:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpatocka@redhat.com, alan@lxorguk.ukuu.org.uk


The patch titled
     framebuffer compat_ioctl deadlock
has been added to the -mm tree.  Its filename is
     framebuffer-compat_ioctl-deadlock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: framebuffer compat_ioctl deadlock
From: Mikulas Patocka <mpatocka@redhat.com>

Fix deadlock in fb_compat_ioctl.  fb_compat_ioctl acquires a mutex and
calls fb_ioctl that tries to acquire that mutex too.  A regression added
during BKL removal.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/fbmem.c~framebuffer-compat_ioctl-deadlock drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~framebuffer-compat_ioctl-deadlock
+++ a/drivers/video/fbmem.c
@@ -1262,8 +1262,8 @@ fb_compat_ioctl(struct file *file, unsig
 	case FBIOPUT_CON2FBMAP:
 		arg = (unsigned long) compat_ptr(arg);
 	case FBIOBLANK:
-		ret = fb_ioctl(file, cmd, arg);
-		break;
+		mutex_unlock(&info->lock);
+		return fb_ioctl(file, cmd, arg);
 
 	case FBIOGET_FSCREENINFO:
 		ret = fb_get_fscreeninfo(inode, file, cmd, arg);
_

Patches currently in -mm which might be from mpatocka@redhat.com are

framebuffer-compat_ioctl-deadlock.patch

