From: akpm@linux-foundation.org
Subject: + time-fix-formatting-in-proc-timer_list.patch added to -mm tree
Date: Thu, 22 Mar 2007 00:34:32 -0800
Message-ID: <200703220834.l2M8YWek016063@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44413 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965854AbXCVIes (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 04:34:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jmorris@namei.org, mingo@elte.hu, tglx@linutronix.de


The patch titled
     time: fix formatting in /proc/timer_list
has been added to the -mm tree.  Its filename is
     time-fix-formatting-in-proc-timer_list.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: time: fix formatting in /proc/timer_list
From: James Morris <jmorris@namei.org>

Fix the print formatting of three unsigned long fields in /proc/timer_list,
which are currently being formatted as signed long.

Signed-off-by: James Morris <jmorris@namei.org>
Cc: Ingo Molnar <mingo@elte.hu>
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

time-fix-formatting-in-proc-timer_list.patch
return-eperm-not-echild-on-security_task_wait-failure.patch
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
