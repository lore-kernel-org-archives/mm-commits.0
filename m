From: akpm@linux-foundation.org
Subject: [patch 16/26] kernel/panic.c: add missing \n
Date: Tue, 24 Jan 2017 15:18:29 -0800
Message-ID: <5887e0c5.TESk1yUwWmzjiufT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41478 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751002AbdAXXSa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2017 18:18:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jslaby@suse.cz

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
