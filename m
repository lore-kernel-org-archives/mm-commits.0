From: akpm@linux-foundation.org
Subject: [merged] parisc-use-generic-currenth.patch removed from -mm tree
Date: Thu, 23 Feb 2017 13:11:59 -0800
Message-ID: <58af501f.OQRoyc24JFacDi3p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39118 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751201AbdBWVMK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:12:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, deller@gmx.de, jejb@parisc-linux.org, mm-commits@vger.kernel.org


The patch titled
     Subject: parisc: use generic current.h
has been removed from the -mm tree.  Its filename was
     parisc-use-generic-currenth.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: parisc: use generic current.h

Given that the arch does not add its own implementations, simply use the
asm-generic/current.h (generic-y) header instead of duplicating code.

Link: http://lkml.kernel.org/r/1485992878-4780-4-git-send-email-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/include/asm/Kbuild    |    1 +
 arch/parisc/include/asm/current.h |   15 ---------------
 2 files changed, 1 insertion(+), 15 deletions(-)

diff -puN arch/parisc/include/asm/Kbuild~parisc-use-generic-currenth arch/parisc/include/asm/Kbuild
--- a/arch/parisc/include/asm/Kbuild~parisc-use-generic-currenth
+++ a/arch/parisc/include/asm/Kbuild
@@ -2,6 +2,7 @@
 generic-y += auxvec.h
 generic-y += barrier.h
 generic-y += clkdev.h
+generic-y += current.h
 generic-y += device.h
 generic-y += div64.h
 generic-y += emergency-restart.h
diff -puN arch/parisc/include/asm/current.h~parisc-use-generic-currenth /dev/null
--- a/arch/parisc/include/asm/current.h
+++ /dev/null
@@ -1,15 +0,0 @@
-#ifndef _PARISC_CURRENT_H
-#define _PARISC_CURRENT_H
-
-#include <linux/thread_info.h>
-
-struct task_struct;
-
-static inline struct task_struct * get_current(void)
-{
-	return current_thread_info()->task;
-}
- 
-#define current get_current()
