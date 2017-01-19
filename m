From: akpm@linux-foundation.org
Subject: + panic-add-missing-n.patch added to -mm tree
Date: Thu, 19 Jan 2017 12:50:51 -0800
Message-ID: <588126ab.Fgjy2ZVZ3AC+TseP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56890 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751544AbdASU6b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2017 15:58:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/panic.c: add missing \n
has been added to the -mm tree.  Its filename is
     panic-add-missing-n.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/panic-add-missing-n.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/panic-add-missing-n.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

panic-add-missing-n.patch

