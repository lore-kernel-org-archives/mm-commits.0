From: akpm@linux-foundation.org
Subject: + autofs-non-functional-header-inclusion-cleanup.patch added to
 -mm tree
Date: Thu, 17 Aug 2017 15:47:55 -0700
Message-ID: <59961d1b.cTYataXW48sGZEou%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51378 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753005AbdHQWr4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Aug 2017 18:47:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tkusumi@tuxera.com, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: non functional header inclusion cleanup
has been added to the -mm tree.  Its filename is
     autofs-non-functional-header-inclusion-cleanup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-non-functional-header-inclusion-cleanup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-non-functional-header-inclusion-cleanup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tomohiro Kusumi <tkusumi@tuxera.com>
Subject: autofs: non functional header inclusion cleanup

Having header includes before any macro (without any dependency) simply
looks normal.  No reason to have these macros in between.

Link: http://lkml.kernel.org/r/150285068011.4670.10271483982093996996.stgit@pluto.themaw.net
Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/autofs_i.h |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN fs/autofs4/autofs_i.h~autofs-non-functional-header-inclusion-cleanup fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~autofs-non-functional-header-inclusion-cleanup
+++ a/fs/autofs4/autofs_i.h
@@ -11,10 +11,21 @@
 
 #include <linux/auto_fs4.h>
 #include <linux/auto_dev-ioctl.h>
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/time.h>
+#include <linux/string.h>
+#include <linux/wait.h>
+#include <linux/sched.h>
+#include <linux/mount.h>
+#include <linux/namei.h>
+#include <linux/uaccess.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>
 #include <linux/completion.h>
+#include <asm/current.h>
 
 /* This is the range of ioctl() numbers we claim as ours */
 #define AUTOFS_IOC_FIRST     AUTOFS_IOC_READY
@@ -24,17 +35,6 @@
 #define AUTOFS_DEV_IOCTL_IOC_COUNT \
 	(AUTOFS_DEV_IOCTL_ISMOUNTPOINT_CMD - AUTOFS_DEV_IOCTL_VERSION_CMD)
 
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/time.h>
-#include <linux/string.h>
-#include <linux/wait.h>
-#include <linux/sched.h>
-#include <linux/mount.h>
-#include <linux/namei.h>
-#include <asm/current.h>
-#include <linux/uaccess.h>
