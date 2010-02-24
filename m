From: akpm@linux-foundation.org
Subject: + kernelh-intr_sqrt-cleanup.patch added to -mm tree
Date: Wed, 24 Feb 2010 13:08:15 -0800
Message-ID: <201002242108.o1OL8F24020499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757740Ab0BXVIS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 16:08:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com


The patch titled
     kernel.h: intr_sqrt cleanup
has been added to the -mm tree.  Its filename is
     kernelh-intr_sqrt-cleanup.patch

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
Subject: kernel.h: intr_sqrt cleanup
From: Dave Young <hidave.darkstar@gmail.com>

int_sqrt in kernel.h should be put into a standalone head file

cleanup int_sqrt declarations in kernel.h, put them into int_sqrt.h
include int_sqrt.h in every file which need it

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/pt1/va1j5jf8007s.c     |    1 +
 drivers/media/video/cx88/cx88-dsp.c      |    1 +
 drivers/net/wireless/b43/phy_lp.c        |    1 +
 drivers/staging/comedi/drivers/vmk80xx.c |    1 +
 drivers/video/fbmon.c                    |    1 +
 fs/nfs/write.c                           |    1 +
 include/linux/int_sqrt.h                 |    6 ++++++
 lib/int_sqrt.c                           |    1 +
 mm/memcontrol.c                          |    1 +
 mm/oom_kill.c                            |    1 +
 mm/page_alloc.c                          |    1 +
 net/ipv4/route.c                         |    1 +
 12 files changed, 17 insertions(+)

diff -puN drivers/media/dvb/pt1/va1j5jf8007s.c~kernelh-intr_sqrt-cleanup drivers/media/dvb/pt1/va1j5jf8007s.c
--- a/drivers/media/dvb/pt1/va1j5jf8007s.c~kernelh-intr_sqrt-cleanup
+++ a/drivers/media/dvb/pt1/va1j5jf8007s.c
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
+#include <linux/int_sqrt.h>
 #include "dvb_frontend.h"
 #include "va1j5jf8007s.h"
 
diff -puN drivers/media/video/cx88/cx88-dsp.c~kernelh-intr_sqrt-cleanup drivers/media/video/cx88/cx88-dsp.c
--- a/drivers/media/video/cx88/cx88-dsp.c~kernelh-intr_sqrt-cleanup
+++ a/drivers/media/video/cx88/cx88-dsp.c
@@ -22,6 +22,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/jiffies.h>
+#include <linux/int_sqrt.h>
 #include <asm/div64.h>
 
 #include "cx88.h"
diff -puN drivers/net/wireless/b43/phy_lp.c~kernelh-intr_sqrt-cleanup drivers/net/wireless/b43/phy_lp.c
--- a/drivers/net/wireless/b43/phy_lp.c~kernelh-intr_sqrt-cleanup
+++ a/drivers/net/wireless/b43/phy_lp.c
@@ -23,6 +23,7 @@
 
 */
 
+#include <linux/int_sqrt.h>
 #include "b43.h"
 #include "main.h"
 #include "phy_lp.h"
diff -puN drivers/staging/comedi/drivers/vmk80xx.c~kernelh-intr_sqrt-cleanup drivers/staging/comedi/drivers/vmk80xx.c
--- a/drivers/staging/comedi/drivers/vmk80xx.c~kernelh-intr_sqrt-cleanup
+++ a/drivers/staging/comedi/drivers/vmk80xx.c
@@ -61,6 +61,7 @@ Changelog:
 #include <linux/poll.h>
 #include <linux/usb.h>
 #include <linux/uaccess.h>
+#include <linux/int_sqrt.h>
 
 #include "../comedidev.h"
 
diff -puN drivers/video/fbmon.c~kernelh-intr_sqrt-cleanup drivers/video/fbmon.c
--- a/drivers/video/fbmon.c~kernelh-intr_sqrt-cleanup
+++ a/drivers/video/fbmon.c
@@ -29,6 +29,7 @@
 #include <linux/fb.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/int_sqrt.h>
 #include <video/edid.h>
 #ifdef CONFIG_PPC_OF
 #include <asm/prom.h>
diff -puN fs/nfs/write.c~kernelh-intr_sqrt-cleanup fs/nfs/write.c
--- a/fs/nfs/write.c~kernelh-intr_sqrt-cleanup
+++ a/fs/nfs/write.c
@@ -20,6 +20,7 @@
 #include <linux/nfs_mount.h>
 #include <linux/nfs_page.h>
 #include <linux/backing-dev.h>
+#include <linux/int_sqrt.h>
 
 #include <asm/uaccess.h>
 
diff -puN /dev/null include/linux/int_sqrt.h
--- /dev/null
+++ a/include/linux/int_sqrt.h
@@ -0,0 +1,6 @@
+#ifndef _INT_SQRT_H
+#define _INT_SQRT_H
+
+extern unsigned long int_sqrt(unsigned long);
+
+#endif
diff -puN lib/int_sqrt.c~kernelh-intr_sqrt-cleanup lib/int_sqrt.c
--- a/lib/int_sqrt.c~kernelh-intr_sqrt-cleanup
+++ a/lib/int_sqrt.c
@@ -1,6 +1,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/int_sqrt.h>
 
 /**
  * int_sqrt - rough approximation to sqrt
diff -puN mm/memcontrol.c~kernelh-intr_sqrt-cleanup mm/memcontrol.c
--- a/mm/memcontrol.c~kernelh-intr_sqrt-cleanup
+++ a/mm/memcontrol.c
@@ -39,6 +39,7 @@
 #include <linux/mm_inline.h>
 #include <linux/page_cgroup.h>
 #include <linux/cpu.h>
+#include <linux/int_sqrt.h>
 #include "internal.h"
 
 #include <asm/uaccess.h>
diff -puN mm/oom_kill.c~kernelh-intr_sqrt-cleanup mm/oom_kill.c
--- a/mm/oom_kill.c~kernelh-intr_sqrt-cleanup
+++ a/mm/oom_kill.c
@@ -27,6 +27,7 @@
 #include <linux/notifier.h>
 #include <linux/memcontrol.h>
 #include <linux/security.h>
+#include <linux/int_sqrt.h>
 
 int sysctl_panic_on_oom;
 int sysctl_oom_kill_allocating_task;
diff -puN mm/page_alloc.c~kernelh-intr_sqrt-cleanup mm/page_alloc.c
--- a/mm/page_alloc.c~kernelh-intr_sqrt-cleanup
+++ a/mm/page_alloc.c
@@ -49,6 +49,7 @@
 #include <linux/debugobjects.h>
 #include <linux/kmemleak.h>
 #include <linux/memory.h>
+#include <linux/int_sqrt.h>
 #include <trace/events/kmem.h>
 #include <linux/ftrace_event.h>
 
diff -puN net/ipv4/route.c~kernelh-intr_sqrt-cleanup net/ipv4/route.c
--- a/net/ipv4/route.c~kernelh-intr_sqrt-cleanup
+++ a/net/ipv4/route.c
@@ -104,6 +104,7 @@
 #include <net/xfrm.h>
 #include <net/netevent.h>
 #include <net/rtnetlink.h>
+#include <linux/int_sqrt.h>
 #ifdef CONFIG_SYSCTL
 #include <linux/sysctl.h>
 #endif
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

linux-next.patch
kernelh-intr_sqrt-cleanup.patch
kernelh-printk-panic-string-cleanup.patch
documentation-email-clientstxt-update-gmail-information.patch
sysctl-extern-cleanup-c_a_d.patch
sysctl-extern-cleanup-signal.patch
sysctl-extern-cleanup-binfmts.patch
sysctl-extern-cleanup-pid.patch
sysctl-extern-cleanup-mm.patch
sysctl-extern-cleanup-compat.patch
sysctl-extern-cleanup-latencytop.patch
sysctl-extern-cleanup-file-nr.patch
sysctl-extern-cleanup-rcu.patch
sysctl-extern-cleanup-block-iopoll.patch
sysctl-extern-cleanup-module.patch
sysctl-extern-cleanup-sg.patch
sysctl-extern-cleanup-acct.patch
sysctl-extern-cleanup-rtmutex.patch
sysctl-extern-cleanup-lockdep.patch
sysctl-extern-cleanup-poll.patch
sysctl-extern-cleanup-inotify.patch

