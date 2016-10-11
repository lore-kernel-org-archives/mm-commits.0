From: akpm@linux-foundation.org
Subject: [patch 042/102] autofs: fix dev ioctl number range check
Date: Tue, 11 Oct 2016 13:53:02 -0700
Message-ID: <57fd512e.MtWwlhg9zGTxEotW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37921 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752431AbcJKUxG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:53:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, raven@themaw.net, kusumi.tomohiro@gmail.com

From: Ian Kent <raven@themaw.net>
Subject: autofs: fix dev ioctl number range check

The count of miscellaneous device ioctls in fs/autofs4/autofs_i.h is wrong.

The number of ioctls is the difference between AUTOFS_DEV_IOCTL_VERSION_CMD
and AUTOFS_DEV_IOCTL_ISMOUNTPOINT_CMD (14) not the difference between
AUTOFS_IOC_COUNT and 11 (21).

[kusumi.tomohiro@gmail.com: fix typo that made the count macro negative]
 Link: http://lkml.kernel.org/r/20160831033420.9910.16809.stgit@pluto.themaw.net
Link: http://lkml.kernel.org/r/20160812024841.12352.11975.stgit@pluto.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/autofs_i.h  |    3 ++-
 fs/autofs4/dev-ioctl.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/autofs4/autofs_i.h~autofs-fix-dev-ioctl-number-range-check fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~autofs-fix-dev-ioctl-number-range-check
+++ a/fs/autofs4/autofs_i.h
@@ -20,7 +20,8 @@
 #define AUTOFS_IOC_COUNT     32
 
 #define AUTOFS_DEV_IOCTL_IOC_FIRST	(AUTOFS_DEV_IOCTL_VERSION)
-#define AUTOFS_DEV_IOCTL_IOC_COUNT	(AUTOFS_IOC_COUNT - 11)
+#define AUTOFS_DEV_IOCTL_IOC_COUNT \
+	(AUTOFS_DEV_IOCTL_ISMOUNTPOINT_CMD - AUTOFS_DEV_IOCTL_VERSION_CMD)
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
diff -puN fs/autofs4/dev-ioctl.c~autofs-fix-dev-ioctl-number-range-check fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~autofs-fix-dev-ioctl-number-range-check
+++ a/fs/autofs4/dev-ioctl.c
@@ -642,7 +642,7 @@ static int _autofs_dev_ioctl(unsigned in
 	cmd = _IOC_NR(command);
 
 	if (_IOC_TYPE(command) != _IOC_TYPE(AUTOFS_DEV_IOCTL_IOC_FIRST) ||
-	    cmd - cmd_first >= AUTOFS_DEV_IOCTL_IOC_COUNT) {
+	    cmd - cmd_first > AUTOFS_DEV_IOCTL_IOC_COUNT) {
 		return -ENOTTY;
 	}
 
_
