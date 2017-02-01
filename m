From: akpm@linux-foundation.org
Subject: + alpha-use-generic-currenth.patch added to -mm tree
Date: Wed, 01 Feb 2017 15:53:45 -0800
Message-ID: <58927509.y5PLxo3FaqmENAGK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46912 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750737AbdBAXxr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Feb 2017 18:53:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, ink@jurassic.park.msu.ru, mattst88@gmail.com, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     Subject: alpha: use generic current.h
has been added to the -mm tree.  Its filename is
     alpha-use-generic-currenth.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/alpha-use-generic-currenth.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/alpha-use-generic-currenth.patch

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
Subject: alpha: use generic current.h

Given that the arch does not add its own implementations, simply use the
asm-generic/current.h (generic-y) header instead of duplicating code.

Link: http://lkml.kernel.org/r/1485992878-4780-2-git-send-email-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/Kbuild    |    1 +
 arch/alpha/include/asm/current.h |    9 ---------
 2 files changed, 1 insertion(+), 9 deletions(-)

diff -puN arch/alpha/include/asm/Kbuild~alpha-use-generic-currenth arch/alpha/include/asm/Kbuild
--- a/arch/alpha/include/asm/Kbuild~alpha-use-generic-currenth
+++ a/arch/alpha/include/asm/Kbuild
@@ -10,3 +10,4 @@ generic-y += mm-arch-hooks.h
 generic-y += preempt.h
 generic-y += sections.h
 generic-y += trace_clock.h
+generic-y += current.h
diff -puN arch/alpha/include/asm/current.h~alpha-use-generic-currenth /dev/null
--- a/arch/alpha/include/asm/current.h
+++ /dev/null
@@ -1,9 +0,0 @@
-#ifndef _ALPHA_CURRENT_H
-#define _ALPHA_CURRENT_H
-
-#include <linux/thread_info.h>
-
-#define get_current()	(current_thread_info()->task)
-#define current		get_current()
