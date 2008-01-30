From: akpm@linux-foundation.org
Subject: + dont-prefer-unsuited-consoles-on-registration.patch added to -mm tree
Date: Wed, 30 Jan 2008 15:47:05 -0800
Message-ID: <200801302347.m0UNl5BL030956@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47031 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754624AbYA3Xrz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jan 2008 18:47:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jan.kiszka@web.de, jason.wessel@windriver.com, kraxel@suse.de, michael@ellerman.id.au, mingo@elte.hu


The patch titled
     don't prefer unsuited consoles on registration
has been added to the -mm tree.  Its filename is
     dont-prefer-unsuited-consoles-on-registration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: don't prefer unsuited consoles on registration
From: Jan Kiszka <jan.kiszka@web.de>

KGDB triggers a (probably so far theoretical) issue of the automatic init
console election: If some console happens to be registered first which does
not provide a tty binding (!console->device), it prevents that more suited
consoles which are registered later on can enter the candidate pool for
console_device().  This is observable with KGDB's console which may already
be registered (and exploited!) during early debugger connections, that is
before any regular console registration.

This patch fixes the issue by postponing the final, automated
preferred_console selection until someone with a non-NULL device handler
comes around.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Gerd Hoffmann <kraxel@suse.de>
Cc: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN kernel/printk.c~dont-prefer-unsuited-consoles-on-registration kernel/printk.c
--- a/kernel/printk.c~dont-prefer-unsuited-consoles-on-registration
+++ a/kernel/printk.c
@@ -1119,8 +1119,11 @@ void register_console(struct console *co
 			console->index = 0;
 		if (console->setup == NULL ||
 		    console->setup(console, NULL) == 0) {
-			console->flags |= CON_ENABLED | CON_CONSDEV;
-			preferred_console = 0;
+			console->flags |= CON_ENABLED;
+			if (console->device) {
+				console->flags |= CON_CONSDEV;
+				preferred_console = 0;
+			}
 		}
 	}
 
_

Patches currently in -mm which might be from jan.kiszka@web.de are

git-x86.patch
dont-prefer-unsuited-consoles-on-registration.patch
