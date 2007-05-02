From: akpm@linux-foundation.org
Subject: + fix-error-handling-in-hdio_getgeo-compat-wrapper.patch added to -mm tree
Date: Tue, 01 May 2007 17:35:05 -0700
Message-ID: <200705020035.l420Z5wR010257@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946072AbXEBAfJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 May 2007 20:35:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: schwab@suse.de


The patch titled
     Fix error handling in HDIO_GETGEO compat wrapper
has been added to the -mm tree.  Its filename is
     fix-error-handling-in-hdio_getgeo-compat-wrapper.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix error handling in HDIO_GETGEO compat wrapper
From: Andreas Schwab <schwab@suse.de>

Don't clobber error from sys_ioctl in HDIO_GETGEO compat wrapper.

Signed-off-by: Andreas Schwab <schwab@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat_ioctl.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/compat_ioctl.c~fix-error-handling-in-hdio_getgeo-compat-wrapper fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~fix-error-handling-in-hdio_getgeo-compat-wrapper
+++ a/fs/compat_ioctl.c
@@ -684,8 +684,10 @@ static int hdio_getgeo(unsigned int fd, 
 	if (!err) {
 		err = copy_to_user (ugeo, &geo, 4);
 		err |= __put_user (geo.start, &ugeo->start);
+		if (err)
+			err = -EFAULT;
 	}
-	return err ? -EFAULT : 0;
+	return err;
 }
 
 static int hdio_ioctl_trans(unsigned int fd, unsigned int cmd, unsigned long arg)
_

Patches currently in -mm which might be from schwab@suse.de are

fat_dont-use_free_clusters-for-fat32.patch
fix-error-handling-in-hdio_getgeo-compat-wrapper.patch
