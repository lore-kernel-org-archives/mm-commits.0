From: akpm@linux-foundation.org
Subject: [merged] score-remove-asm-currenth.patch removed from -mm tree
Date: Thu, 23 Feb 2017 13:11:51 -0800
Message-ID: <58af5017.4B2uFMhdFWL8/4CZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38758 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751201AbdBWVLy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:11:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, lennox.wu@gmail.com, liqin.linux@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: score: remove asm/current.h
has been removed from the -mm tree.  Its filename was
     score-remove-asm-currenth.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 arch/score/include/asm/Kbuild    |    2 +-
 arch/score/include/asm/current.h |    6 ------
 2 files changed, 1 insertion(+), 7 deletions(-)

diff -puN arch/score/include/asm/Kbuild~score-remove-asm-currenth arch/score/include/asm/Kbuild
--- a/arch/score/include/asm/Kbuild~score-remove-asm-currenth
+++ a/arch/score/include/asm/Kbuild
@@ -1,9 +1,9 @@
 
 header-y +=
 
-
 generic-y += barrier.h
 generic-y += clkdev.h
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
