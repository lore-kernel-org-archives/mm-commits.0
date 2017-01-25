From: akpm@linux-foundation.org
Subject: [merged] panic-add-missing-n.patch removed from -mm tree
Date: Wed, 25 Jan 2017 14:04:58 -0800
Message-ID: <5889210a.pP7tixgm5GcfOf2D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42106 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752213AbdAYWFE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2017 17:05:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/panic.c: add missing 

has been removed from the -mm tree.  Its filename was
     panic-add-missing-n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiri Slaby <jslaby@suse.cz>
Subject: kernel/panic.c: add missing \n

When a system panics, the "Rebooting in X seconds.." message is never
printed because it lacks a new line. Fix it.

Link: http://lkml.kernel.org/r/20170119114751.2724-1-jslaby@suse.cz
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/panic.c~panic-add-missing-n kernel/panic.c
--- a/kernel/panic.c~panic-add-missing-n
+++ a/kernel/panic.c
@@ -249,7 +249,7 @@ void panic(const char *fmt, ...)
 		 * Delay timeout seconds before rebooting the machine.
 		 * We can't use the "normal" timers since we just panicked.
 		 */
-		pr_emerg("Rebooting in %d seconds..", panic_timeout);
+		pr_emerg("Rebooting in %d seconds..\n", panic_timeout);
 
 		for (i = 0; i < panic_timeout * 1000; i += PANIC_TIMER_STEP) {
 			touch_nmi_watchdog();
_

Patches currently in -mm which might be from jslaby@suse.cz are


