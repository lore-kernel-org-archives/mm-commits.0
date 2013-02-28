From: akpm@linux-foundation.org
Subject: [merged] ipmi-remove-superfluous-kernel-userspace-explanation.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:16:26 -0800
Message-ID: <20130228201626.CAD1C5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:35286 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759034Ab3B1UQ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:16:27 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so245234ggn.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:16:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, cminyard@mvista.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipmi: remove superfluous kernel/userspace explanation
has been removed from the -mm tree.  Its filename was
     ipmi-remove-superfluous-kernel-userspace-explanation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Robert P. J. Day <rpjday@crashcourse.ca>
Subject: ipmi: remove superfluous kernel/userspace explanation

Given the obvious distinction between kernel and userspace supported
by uapi/, it seems unnecessary to comment on that.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipmi.h      |    4 ----
 include/uapi/linux/ipmi.h |   10 +---------
 2 files changed, 1 insertion(+), 13 deletions(-)

diff -puN include/linux/ipmi.h~ipmi-remove-superfluous-kernel-userspace-explanation include/linux/ipmi.h
--- a/include/linux/ipmi.h~ipmi-remove-superfluous-kernel-userspace-explanation
+++ a/include/linux/ipmi.h
@@ -35,10 +35,6 @@
 
 #include <uapi/linux/ipmi.h>
 
-
-/*
- * The in-kernel interface.
- */
 #include <linux/list.h>
 #include <linux/proc_fs.h>
 
diff -puN include/uapi/linux/ipmi.h~ipmi-remove-superfluous-kernel-userspace-explanation include/uapi/linux/ipmi.h
--- a/include/uapi/linux/ipmi.h~ipmi-remove-superfluous-kernel-userspace-explanation
+++ a/include/uapi/linux/ipmi.h
@@ -59,15 +59,7 @@
  * if it becomes full and it is queried once a second to see if
  * anything is in it.  Incoming commands to the driver will get
  * delivered as commands.
- *
- * This driver provides two main interfaces: one for in-kernel
- * applications and another for userland applications.  The
- * capabilities are basically the same for both interface, although
- * the interfaces are somewhat different.  The stuff in the
- * #ifdef __KERNEL__ below is the in-kernel interface.  The userland
- * interface is defined later in the file.  */
-
