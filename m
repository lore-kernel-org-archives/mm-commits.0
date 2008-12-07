From: akpm@linux-foundation.org
Subject: - fix-block-dev-compat-ioctl-handling.patch removed from -mm tree
Date: Sat, 06 Dec 2008 16:06:01 -0800
Message-ID: <200812070006.mB7061vY021725@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753594AbYLGAGG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 6 Dec 2008 19:06:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: schwab@suse.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Fix block dev compat ioctl handling
has been removed from the -mm tree.  Its filename was
     fix-block-dev-compat-ioctl-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

