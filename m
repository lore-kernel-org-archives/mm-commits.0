From: akpm@linux-foundation.org
Subject: - time-fix-formatting-in-proc-timer_list.patch removed from -mm tree
Date: Sun, 25 Mar 2007 17:05:37 -0800
Message-ID: <200703260105.l2Q15bRv008722@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38553 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933387AbXCZBFx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 21:05:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmorris@namei.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     time: fix formatting in /proc/timer_list
has been removed from the -mm tree.  Its filename was
     time-fix-formatting-in-proc-timer_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: time: fix formatting in /proc/timer_list
From: James Morris <jmorris@namei.org>

Fix the print formatting of three unsigned long fields in /proc/timer_list,
which are currently being formatted as signed long.

Signed-off-by: James Morris <jmorris@namei.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timer_list.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/time/timer_list.c~time-fix-formatting-in-proc-timer_list kernel/time/timer_list.c
--- a/kernel/time/timer_list.c~time-fix-formatting-in-proc-timer_list
+++ a/kernel/time/timer_list.c
@@ -194,9 +194,9 @@ print_tickdevice(struct seq_file *m, str
 		return;
 	}
 	SEQ_printf(m, "%s\n", dev->name);
-	SEQ_printf(m, " max_delta_ns:   %ld\n", dev->max_delta_ns);
-	SEQ_printf(m, " min_delta_ns:   %ld\n", dev->min_delta_ns);
-	SEQ_printf(m, " mult:           %ld\n", dev->mult);
+	SEQ_printf(m, " max_delta_ns:   %lu\n", dev->max_delta_ns);
+	SEQ_printf(m, " min_delta_ns:   %lu\n", dev->min_delta_ns);
+	SEQ_printf(m, " mult:           %lu\n", dev->mult);
 	SEQ_printf(m, " shift:          %d\n", dev->shift);
 	SEQ_printf(m, " mode:           %d\n", dev->mode);
 	SEQ_printf(m, " next_event:     %Ld nsecs\n",
_

Patches currently in -mm which might be from jmorris@namei.org are

return-eperm-not-echild-on-security_task_wait-failure.patch
git-net.patch
git-selinux.patch
lguest-documentatation-and-example-launcher-bridging-support-in-example-code.patch
lguest-documentatation-and-example-launcher-bridging-support-in-example-codelguest-documentation-fixes.patch
implement-file-posix-capabilities.patch
file-capabilities-accomodate-future-64-bit-caps.patch
allow-access-to-proc-pid-fd-after-setuid.patch
tty-introduce-no_tty-and-use-it-in-selinux.patch
mprotect-patch-for-use-by-slim.patch
integrity-service-api-and-dummy-provider.patch
slim-main-patch.patch
slim-secfs-patch.patch
slim-make-and-config-stuff.patch
slim-debug-output.patch
slim-documentation.patch
