From: akpm@linux-foundation.org
Subject: + timerremove-clockevents_unregister_notifier.patch added to -mm tree
Date: Thu, 09 Aug 2007 13:42:21 -0700
Message-ID: <200708092042.l79KgLYj018477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50067 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757433AbXHIUnU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 16:43:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: miaox@cn.fujitsu.com, tglx@linutronix.de


The patch titled
     timer: remove clockevents_unregister_notifier
has been added to the -mm tree.  Its filename is
     timerremove-clockevents_unregister_notifier.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: timer: remove clockevents_unregister_notifier
From: Miao Xie <miaox@cn.fujitsu.com>

I find a function(clockevents_unregister_notifier) which is not called by
anything in tree.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/clockchips.h |    1 -
 kernel/time/clockevents.c  |   10 ----------
 2 files changed, 11 deletions(-)

diff -puN include/linux/clockchips.h~timerremove-clockevents_unregister_notifier include/linux/clockchips.h
--- a/include/linux/clockchips.h~timerremove-clockevents_unregister_notifier
+++ a/include/linux/clockchips.h
@@ -123,7 +123,6 @@ extern void clockevents_exchange_device(
 extern void clockevents_set_mode(struct clock_event_device *dev,
 				 enum clock_event_mode mode);
 extern int clockevents_register_notifier(struct notifier_block *nb);
-extern void clockevents_unregister_notifier(struct notifier_block *nb);
 extern int clockevents_program_event(struct clock_event_device *dev,
 				     ktime_t expires, ktime_t now);
 
diff -puN kernel/time/clockevents.c~timerremove-clockevents_unregister_notifier kernel/time/clockevents.c
--- a/kernel/time/clockevents.c~timerremove-clockevents_unregister_notifier
+++ a/kernel/time/clockevents.c
@@ -113,16 +113,6 @@ int clockevents_register_notifier(struct
 	return ret;
 }
 
-/**
- * clockevents_unregister_notifier - unregister a clock events change listener
- */
-void clockevents_unregister_notifier(struct notifier_block *nb)
-{
-	spin_lock(&clockevents_lock);
-	raw_notifier_chain_unregister(&clockevents_chain, nb);
-	spin_unlock(&clockevents_lock);
-}
-
 /*
  * Notify about a clock event change. Called with clockevents_lock
  * held.
_

Patches currently in -mm which might be from miaox@cn.fujitsu.com are

timerremove-clockevents_unregister_notifier.patch
