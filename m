From: akpm@linux-foundation.org
Subject: - ibmasr-remove-unnecessary-spin_unlock.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:49:43 -0700
Message-ID: <200810012149.m91Lni8T005715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753504AbYJAVuM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:50:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, pazke@donpac.ru, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     ibmasr: remove unnecessary spin_unlock()
has been removed from the -mm tree.  Its filename was
     ibmasr-remove-unnecessary-spin_unlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ibmasr: remove unnecessary spin_unlock()
From: Akinobu Mita <akinobu.mita@gmail.com>

__asr_toggle() is always called with asr_lock held.
But there is unnecessary spin_unlock() call in __asr_toggle().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Acked-by: Andrey Panin <pazke@donpac.ru>
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

git-cpufreq.patch
anysee-initialize-anysee_usb_mutex-statically.patch
ipr-use-memory_read_from_buffer.patch

