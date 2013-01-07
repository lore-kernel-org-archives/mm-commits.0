From: akpm@linux-foundation.org
Subject: + ipmi-remove-superfluous-kernel-userspace-explanation.patch added to -mm tree
Date: Mon, 07 Jan 2013 15:44:10 -0800
Message-ID: <20130107234411.504B110015C@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:42069 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab3AGXoM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 18:44:12 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so2154264vbi.1
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 15:44:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, cminyard@mvista.com


The patch titled
     Subject: ipmi: remove superfluous kernel/userspace explanation
has been added to the -mm tree.  Its filename is
     ipmi-remove-superfluous-kernel-userspace-explanation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
