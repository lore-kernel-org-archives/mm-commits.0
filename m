From: akpm@linux-foundation.org
Subject: + fix-block-dev-compat-ioctl-handling.patch added to -mm tree
Date: Fri, 07 Nov 2008 12:58:15 -0800
Message-ID: <200811072058.mA7KwFDa018060@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49961 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750774AbYKGU6u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Nov 2008 15:58:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: schwab@suse.de, viro@zeniv.linux.org.uk


The patch titled
     Fix block dev compat ioctl handling
has been added to the -mm tree.  Its filename is
     fix-block-dev-compat-ioctl-handling.patch

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
Subject: Fix block dev compat ioctl handling
From: Andreas Schwab <schwab@suse.de>

Commit 33c2dca4957bd0da3e1af7b96d0758d97e708ef6 ("trim file propagation in
block/compat_ioctl.c") removed the handling of some ioctls from
compat_blkdev_driver_ioctl.  That caused them to be rejected as unknown by
the compat layer.

Signed-off-by: Andreas Schwab <schwab@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/compat_ioctl.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff -puN block/compat_ioctl.c~fix-block-dev-compat-ioctl-handling block/compat_ioctl.c
--- a/block/compat_ioctl.c~fix-block-dev-compat-ioctl-handling
+++ a/block/compat_ioctl.c
@@ -677,6 +677,29 @@ static int compat_blkdev_driver_ioctl(st
 	case DVD_WRITE_STRUCT:
 	case DVD_AUTH:
 		arg = (unsigned long)compat_ptr(arg);
+	/* These intepret arg as an unsigned long, not as a pointer,
+	 * so we must not do compat_ptr() conversion. */
+	case HDIO_SET_MULTCOUNT:
+	case HDIO_SET_UNMASKINTR:
+	case HDIO_SET_KEEPSETTINGS:
+	case HDIO_SET_32BIT:
+	case HDIO_SET_NOWERR:
+	case HDIO_SET_DMA:
+	case HDIO_SET_PIO_MODE:
+	case HDIO_SET_NICE:
+	case HDIO_SET_WCACHE:
+	case HDIO_SET_ACOUSTIC:
+	case HDIO_SET_BUSSTATE:
+	case HDIO_SET_ADDRESS:
+	case CDROMEJECT_SW:
+	case CDROM_SET_OPTIONS:
+	case CDROM_CLEAR_OPTIONS:
+	case CDROM_SELECT_SPEED:
+	case CDROM_SELECT_DISC:
+	case CDROM_MEDIA_CHANGED:
+	case CDROM_DRIVE_STATUS:
+	case CDROM_LOCKDOOR:
+	case CDROM_DEBUG:
 		break;
 	default:
 		/* unknown ioctl number */
_

Patches currently in -mm which might be from schwab@suse.de are

fix-block-dev-compat-ioctl-handling.patch

