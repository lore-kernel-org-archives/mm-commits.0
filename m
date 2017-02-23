From: akpm@linux-foundation.org
Subject: [merged] m32r-use-generic-currenth.patch removed from -mm tree
Date: Thu, 23 Feb 2017 13:11:47 -0800
Message-ID: <58af5013.8fEMgVEwprppY8s/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38588 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751201AbdBWVLu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:11:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: m32r: use generic current.h
has been removed from the -mm tree.  Its filename was
     m32r-use-generic-currenth.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: m32r: use generic current.h

Given that the arch does not add its own implementations, simply
use the asm-generic/current.h (generic-y) header instead of
duplicating code.

Link: http://lkml.kernel.org/r/1482896994-25863-1-git-send-email-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/include/asm/Kbuild    |    1 +
 arch/m32r/include/asm/current.h |   15 ---------------
 2 files changed, 1 insertion(+), 15 deletions(-)

diff -puN arch/m32r/include/asm/Kbuild~m32r-use-generic-currenth arch/m32r/include/asm/Kbuild
--- a/arch/m32r/include/asm/Kbuild~m32r-use-generic-currenth
+++ a/arch/m32r/include/asm/Kbuild
@@ -1,5 +1,6 @@
 
 generic-y += clkdev.h
+generic-y += current.h
 generic-y += exec.h
 generic-y += irq_work.h
 generic-y += kvm_para.h
diff -puN arch/m32r/include/asm/current.h~m32r-use-generic-currenth /dev/null
--- a/arch/m32r/include/asm/current.h
+++ /dev/null
@@ -1,15 +0,0 @@
-#ifndef _ASM_M32R_CURRENT_H
-#define _ASM_M32R_CURRENT_H
-
-#include <linux/thread_info.h>
-
-struct task_struct;
-
-static __inline__ struct task_struct *get_current(void)
-{
-	return current_thread_info()->task;
-}
-
-#define current	(get_current())
