From: akpm@linux-foundation.org
Subject: - dont-prefer-unsuited-consoles-on-registration.patch removed from -mm tree
Date: Fri, 01 Feb 2008 14:30:55 -0800
Message-ID: <200802012230.m11MUt62001949@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34419 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757460AbYBAWsm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 17:48:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@web.de, jason.wessel@windriver.com, kraxel@suse.de, michael@ellerman.id.au, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     don't prefer unsuited consoles on registration
has been removed from the -mm tree.  Its filename was
     dont-prefer-unsuited-consoles-on-registration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-sched.patch
git-x86.patch
