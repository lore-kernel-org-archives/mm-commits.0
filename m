From: akpm@linux-foundation.org
Subject: + cris-use-generic-currenth.patch added to -mm tree
Date: Wed, 01 Feb 2017 15:53:47 -0800
Message-ID: <5892750b.frq4EDyAuxT5I7ea%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46918 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750737AbdBAXxs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Feb 2017 18:53:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, jesper.nilsson@axis.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cris: use generic current.h
has been added to the -mm tree.  Its filename is
     cris-use-generic-currenth.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cris-use-generic-currenth.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cris-use-generic-currenth.patch

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
Subject: cris: use generic current.h

Given that the arch does not add its own implementations, simply use the
asm-generic/current.h (generic-y) header instead of duplicating code.

Link: http://lkml.kernel.org/r/1485992878-4780-3-git-send-email-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/include/asm/Kbuild    |    1 +
 arch/cris/include/asm/current.h |   15 ---------------
 2 files changed, 1 insertion(+), 15 deletions(-)

diff -puN arch/cris/include/asm/Kbuild~cris-use-generic-currenth arch/cris/include/asm/Kbuild
--- a/arch/cris/include/asm/Kbuild~cris-use-generic-currenth
+++ a/arch/cris/include/asm/Kbuild
@@ -5,6 +5,7 @@ generic-y += bitsperlong.h
 generic-y += clkdev.h
 generic-y += cmpxchg.h
 generic-y += cputime.h
+generic-y += current.h
 generic-y += device.h
 generic-y += div64.h
 generic-y += errno.h
diff -puN arch/cris/include/asm/current.h~cris-use-generic-currenth /dev/null
--- a/arch/cris/include/asm/current.h
+++ /dev/null
@@ -1,15 +0,0 @@
-#ifndef _CRIS_CURRENT_H
-#define _CRIS_CURRENT_H
-
-#include <linux/thread_info.h>
-
-struct task_struct;
-
-static inline struct task_struct * get_current(void)
-{
-        return current_thread_info()->task;
-}
- 
-#define current get_current()
