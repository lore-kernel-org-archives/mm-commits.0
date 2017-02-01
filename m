From: akpm@linux-foundation.org
Subject: + parisc-use-generic-currenth.patch added to -mm tree
Date: Wed, 01 Feb 2017 15:53:49 -0800
Message-ID: <5892750d.OQPpRZl7xiL/p+Cs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46928 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750737AbdBAXxu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Feb 2017 18:53:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, deller@gmx.de, jejb@parisc-linux.org, mm-commits@vger.kernel.org


The patch titled
     Subject: parisc: use generic current.h
has been added to the -mm tree.  Its filename is
     parisc-use-generic-currenth.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/parisc-use-generic-currenth.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/parisc-use-generic-currenth.patch

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
@@ -3,6 +3,7 @@ generic-y += auxvec.h
 generic-y += barrier.h
 generic-y += clkdev.h
 generic-y += cputime.h
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
