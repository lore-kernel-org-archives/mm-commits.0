From: akpm@linux-foundation.org
Subject: [merged] autofs4-fix-kernel-includes.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:41:42 -0700
Message-ID: <200904011841.n31Ifggu009455@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932454AbZDAS4A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:56:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     autofs4: fix kernel includes
has been removed from the -mm tree.  Its filename was
     autofs4-fix-kernel-includes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: fix kernel includes
From: Ian Kent <raven@themaw.net>

autofs_dev-ioctl.h is included by both the kernel module and user space tools
and it includes two kernel header files.  Compiles work if the kernel headers
are installed but fail otherwise.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/auto_dev-ioctl.h |    7 ++++++-
 include/linux/auto_fs.h        |    6 ++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

diff -puN include/linux/auto_dev-ioctl.h~autofs4-fix-kernel-includes include/linux/auto_dev-ioctl.h
--- a/include/linux/auto_dev-ioctl.h~autofs4-fix-kernel-includes
+++ a/include/linux/auto_dev-ioctl.h
@@ -10,8 +10,13 @@
 #ifndef _LINUX_AUTO_DEV_IOCTL_H
 #define _LINUX_AUTO_DEV_IOCTL_H
 
+#include <linux/auto_fs.h>
+
+#ifdef __KERNEL__
 #include <linux/string.h>
-#include <linux/types.h>
+#else
+#include <string.h>
+#endif /* __KERNEL__ */
 
 #define AUTOFS_DEVICE_NAME		"autofs"
 
diff -puN include/linux/auto_fs.h~autofs4-fix-kernel-includes include/linux/auto_fs.h
--- a/include/linux/auto_fs.h~autofs4-fix-kernel-includes
+++ a/include/linux/auto_fs.h
@@ -17,11 +17,13 @@
 #ifdef __KERNEL__
 #include <linux/fs.h>
 #include <linux/limits.h>
+#include <linux/types.h>
+#include <linux/ioctl.h>
+#else
 #include <asm/types.h>
+#include <sys/ioctl.h>
 #endif /* __KERNEL__ */
 
-#include <linux/ioctl.h>
