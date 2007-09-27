From: akpm@linux-foundation.org
Subject: - usb-skeleton-leaking-locks-on-open.patch removed from -mm tree
Date: Wed, 26 Sep 2007 18:44:07 -0700
Message-ID: <200709270144.l8R1i7Hj014019@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34999 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752276AbXI0Buz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 21:50:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgross@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     usb-skeleton leaking locks on open
has been removed from the -mm tree.  Its filename was
     usb-skeleton-leaking-locks-on-open.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: usb-skeleton leaking locks on open
From: Mark Gross <mgross@linux.intel.com>

The code path through skel_open can grap the driver's io_mutex lock and
forget to release it.

Signed-off-by: Mark Gross <mgross@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/usb-skeleton.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/usb/usb-skeleton.c~usb-skeleton-leaking-locks-on-open drivers/usb/usb-skeleton.c
--- a/drivers/usb/usb-skeleton.c~usb-skeleton-leaking-locks-on-open
+++ a/drivers/usb/usb-skeleton.c
@@ -125,6 +125,7 @@ static int skel_open(struct inode *inode
 
 	/* save our object in the file's private structure */
 	file->private_data = dev;
+	mutex_unlock(&dev->io_mutex);
 
 exit:
 	return retval;
_

Patches currently in -mm which might be from mgross@linux.intel.com are
