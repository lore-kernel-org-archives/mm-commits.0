From: akpm@linux-foundation.org
Subject: [merged] timerfd-export-defines-to-userspace.patch removed from
 -mm tree
Date: Wed, 11 Jan 2017 14:28:48 -0800
Message-ID: <5876b1a0.EoT4oTlDrh7fZGZn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51542 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933263AbdAKW2t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2017 17:28:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: timerfd: export defines to userspace
has been removed from the -mm tree.  Its filename was
     timerfd-export-defines-to-userspace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Frysinger <vapier@gentoo.org>
Subject: timerfd: export defines to userspace

Since userspace is expected to call timerfd syscalls directly with these
flags/ioctls, make sure we export them so they don't have to duplicate
the values themselves.

Link: http://lkml.kernel.org/r/20161219064052.7196-1-vapier@gentoo.org
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/timerfd.h      |   20 ------------------
 include/uapi/linux/Kbuild    |    1 
 include/uapi/linux/timerfd.h |   36 +++++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 19 deletions(-)

diff -puN include/linux/timerfd.h~timerfd-export-defines-to-userspace include/linux/timerfd.h
--- a/include/linux/timerfd.h~timerfd-export-defines-to-userspace
+++ a/include/linux/timerfd.h
@@ -8,23 +8,7 @@
 #ifndef _LINUX_TIMERFD_H
 #define _LINUX_TIMERFD_H
 
-/* For O_CLOEXEC and O_NONBLOCK */
-#include <linux/fcntl.h>
-
-/* For _IO helpers */
-#include <linux/ioctl.h>
-
-/*
- * CAREFUL: Check include/asm-generic/fcntl.h when defining
- * new flags, since they might collide with O_* ones. We want
- * to re-use O_* flags that couldn't possibly have a meaning
- * from eventfd, in order to leave a free define-space for
- * shared O_* flags.
- */
-#define TFD_TIMER_ABSTIME (1 << 0)
-#define TFD_TIMER_CANCEL_ON_SET (1 << 1)
-#define TFD_CLOEXEC O_CLOEXEC
-#define TFD_NONBLOCK O_NONBLOCK
+#include <uapi/linux/timerfd.h>
 
 #define TFD_SHARED_FCNTL_FLAGS (TFD_CLOEXEC | TFD_NONBLOCK)
 /* Flags for timerfd_create.  */
@@ -32,6 +16,4 @@
 /* Flags for timerfd_settime.  */
 #define TFD_SETTIME_FLAGS (TFD_TIMER_ABSTIME | TFD_TIMER_CANCEL_ON_SET)
 
-#define TFD_IOC_SET_TICKS	_IOW('T', 0, u64)
-
 #endif /* _LINUX_TIMERFD_H */
diff -puN include/uapi/linux/Kbuild~timerfd-export-defines-to-userspace include/uapi/linux/Kbuild
--- a/include/uapi/linux/Kbuild~timerfd-export-defines-to-userspace
+++ a/include/uapi/linux/Kbuild
@@ -414,6 +414,7 @@ header-y += telephony.h
 header-y += termios.h
 header-y += thermal.h
 header-y += time.h
+header-y += timerfd.h
 header-y += times.h
 header-y += timex.h
 header-y += tiocl.h
diff -puN /dev/null include/uapi/linux/timerfd.h
--- /dev/null
+++ a/include/uapi/linux/timerfd.h
@@ -0,0 +1,36 @@
+/*
+ *  include/linux/timerfd.h
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
+ *
+ */
+
+#ifndef _UAPI_LINUX_TIMERFD_H
+#define _UAPI_LINUX_TIMERFD_H
+
+#include <linux/types.h>
+
+/* For O_CLOEXEC and O_NONBLOCK */
+#include <linux/fcntl.h>
+
+/* For _IO helpers */
+#include <linux/ioctl.h>
+
+/*
+ * CAREFUL: Check include/asm-generic/fcntl.h when defining
+ * new flags, since they might collide with O_* ones. We want
+ * to re-use O_* flags that couldn't possibly have a meaning
+ * from eventfd, in order to leave a free define-space for
+ * shared O_* flags.
+ *
+ * Also make sure to update the masks in include/linux/timerfd.h
+ * when adding new flags.
+ */
+#define TFD_TIMER_ABSTIME (1 << 0)
+#define TFD_TIMER_CANCEL_ON_SET (1 << 1)
+#define TFD_CLOEXEC O_CLOEXEC
+#define TFD_NONBLOCK O_NONBLOCK
+
+#define TFD_IOC_SET_TICKS	_IOW('T', 0, __u64)
+
+#endif /* _UAPI_LINUX_TIMERFD_H */
_

Patches currently in -mm which might be from vapier@gentoo.org are


