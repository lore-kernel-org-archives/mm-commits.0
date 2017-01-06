From: akpm@linux-foundation.org
Subject: + m32r-use-generic-currenth.patch added to -mm tree
Date: Thu, 05 Jan 2017 17:16:03 -0800
Message-ID: <586eefd3.QMJagjS9qNbIAmsy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42348 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751177AbdAFBgm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2017 20:36:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: m32r: use generic current.h
has been added to the -mm tree.  Its filename is
     m32r-use-generic-currenth.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/m32r-use-generic-currenth.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/m32r-use-generic-currenth.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1,6 +1,7 @@
 
 generic-y += clkdev.h
 generic-y += cputime.h
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
