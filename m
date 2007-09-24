From: akpm@linux-foundation.org
Subject: + usb-skeleton-leaking-locks-on-open.patch added to -mm tree
Date: Mon, 24 Sep 2007 14:50:04 -0700
Message-ID: <200709242150.l8OLo40G019424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37908 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751557AbXIXVuj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Sep 2007 17:50:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgross@linux.intel.com


The patch titled
     usb-skeleton leaking locks on open
has been added to the -mm tree.  Its filename is
     usb-skeleton-leaking-locks-on-open.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

usb-skeleton-leaking-locks-on-open.patch
