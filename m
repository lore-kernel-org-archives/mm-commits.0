From: akpm@osdl.org
Subject: - cdrom-longer-timeout-for-read-track-info-command.patch removed from -mm tree
Date: Thu, 04 Jan 2007 15:43:17 -0800
Message-ID: <200701042343.l04NhHQm002887@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp0.osdl.org ([65.172.181.24]:36890 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030272AbXADXng (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 18:43:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@sgi.com, alan@lxorguk.ukuu.org.uk, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     cdrom: longer timeout for "Read Track Info" command
has been removed from the -mm tree.  Its filename was
     cdrom-longer-timeout-for-read-track-info-command.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cdrom: longer timeout for "Read Track Info" command
From: Jeremy Higdon <jeremy@sgi.com>,
      Jens Axboe <jens.axboe@oracle.com>

I have a DVD combo drive and a CD in which the "READ TRACK INFORMATION"
command (implemented in the cdrom_get_track_info() function) takes about 7
seconds to run.  The current implementation of cdrom_get_track_info() uses the
default timeout of 5 seconds.  So here's a patch that increases the timeout
from 5 to 15 seconds.

The drive in question is a TSSTcorpCD/DVDW SN-S082D, and I have a Silicon
Image 680A adapter, in case that's of interest.

Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/cdrom/cdrom.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/cdrom/cdrom.c~cdrom-longer-timeout-for-read-track-info-command drivers/cdrom/cdrom.c
--- a/drivers/cdrom/cdrom.c~cdrom-longer-timeout-for-read-track-info-command
+++ a/drivers/cdrom/cdrom.c
@@ -337,6 +337,12 @@ static const char *mrw_address_space[] =
 /* used in the audio ioctls */
 #define CHECKAUDIO if ((ret=check_for_audio_disc(cdi, cdo))) return ret
 
+/*
+ * Another popular OS uses 7 seconds as the hard timeout for default
+ * commands, so it is a good choice for us as well.
+ */
+#define CDROM_DEF_TIMEOUT	(7 * HZ)
+
 /* Not-exported routines. */
 static int open_for_data(struct cdrom_device_info * cdi);
 static int check_for_audio_disc(struct cdrom_device_info * cdi,
@@ -1528,7 +1534,7 @@ void init_cdrom_command(struct packet_co
 	cgc->buffer = (char *) buf;
 	cgc->buflen = len;
 	cgc->data_direction = type;
-	cgc->timeout = 5*HZ;
+	cgc->timeout = CDROM_DEF_TIMEOUT;
 }
 
 /* DVD handling */
_

Patches currently in -mm which might be from jeremy@sgi.com are
