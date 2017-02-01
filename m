From: akpm@linux-foundation.org
Subject: + score-remove-asm-currenth.patch added to -mm tree
Date: Wed, 01 Feb 2017 15:53:51 -0800
Message-ID: <5892750f.J9DI/JGLx9VIoDRn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46938 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750885AbdBAXxw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Feb 2017 18:53:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, lennox.wu@gmail.com, liqin.linux@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: score: remove asm/current.h
has been added to the -mm tree.  Its filename is
     score-remove-asm-currenth.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/score-remove-asm-currenth.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/score-remove-asm-currenth.patch

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
Subject: score: remove asm/current.h

...  it's already using the generic version anyways, so just drop the file
as do the other archs that do not implement their own version of the
current macro.

Link: http://lkml.kernel.org/r/1485992878-4780-5-git-send-email-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Chen Liqin <liqin.linux@gmail.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/score/include/asm/Kbuild    |    1 +
 arch/score/include/asm/current.h |    6 ------
 2 files changed, 1 insertion(+), 6 deletions(-)

diff -puN arch/score/include/asm/Kbuild~score-remove-asm-currenth arch/score/include/asm/Kbuild
--- a/arch/score/include/asm/Kbuild~score-remove-asm-currenth
+++ a/arch/score/include/asm/Kbuild
@@ -5,6 +5,7 @@ header-y +=
 generic-y += barrier.h
 generic-y += clkdev.h
 generic-y += cputime.h
+generic-y += current.h
 generic-y += irq_work.h
 generic-y += mcs_spinlock.h
 generic-y += mm-arch-hooks.h
diff -puN arch/score/include/asm/current.h~score-remove-asm-currenth /dev/null
--- a/arch/score/include/asm/current.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_CURRENT_H
-#define _ASM_SCORE_CURRENT_H
-
-#include <asm-generic/current.h>
