From: akpm@linux-foundation.org
Subject: + autofs4-fix-kernel-includes.patch added to -mm tree
Date: Sun, 22 Mar 2009 18:08:36 -0700
Message-ID: <200903230112.n2N1Cs3W003200@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37544 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756332AbZCWBOH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 22 Mar 2009 21:14:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net


The patch titled
     autofs4: fix kernel includes
has been added to the -mm tree.  Its filename is
     autofs4-fix-kernel-includes.patch

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
