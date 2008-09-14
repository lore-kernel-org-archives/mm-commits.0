From: akpm@linux-foundation.org
Subject: + ibmasr-remove-unnecessary-spin_unlock.patch added to -mm tree
Date: Sat, 13 Sep 2008 17:25:30 -0700
Message-ID: <200809140025.m8E0PUSk028235@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47867 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752527AbYINAZw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 13 Sep 2008 20:25:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, pazke@donpac.ru, wim@iguana.be


The patch titled
     ibmasr: remove unnecessary spin_unlock()
has been added to the -mm tree.  Its filename is
     ibmasr-remove-unnecessary-spin_unlock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ibmasr: remove unnecessary spin_unlock()
From: Akinobu Mita <akinobu.mita@gmail.com>

__asr_toggle() is always called with asr_lock held.
But there is unnecessary spin_unlock() call in __asr_toggle().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Andrey Panin <pazke@donpac.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/ibmasr.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/watchdog/ibmasr.c~ibmasr-remove-unnecessary-spin_unlock drivers/watchdog/ibmasr.c
--- a/drivers/watchdog/ibmasr.c~ibmasr-remove-unnecessary-spin_unlock
+++ a/drivers/watchdog/ibmasr.c
@@ -85,7 +85,6 @@ static void __asr_toggle(void)
 
 	outb(reg & ~asr_toggle_mask, asr_write_addr);
 	reg = inb(asr_read_addr);
-	spin_unlock(&asr_lock);
 }
 
 static void asr_toggle(void)
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

ibmasr-remove-unnecessary-spin_unlock.patch
linux-next.patch
ipr-use-memory_read_from_buffer.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch

