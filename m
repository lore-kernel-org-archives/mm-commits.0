From: akpm@linux-foundation.org
Subject: + tty-fix-leakage-of-erestartsys-to-userland.patch added to -mm tree
Date: Wed, 30 May 2007 11:05:19 -0700
Message-ID: <200705301805.l4UI5Jru001290@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57856 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758635AbXE3SF6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 14:05:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, alan@lxorguk.ukuu.org.uk, roland@redhat.com, stable@kernel.org, takeuchi_satoru@jp.fujitsu.com


The patch titled
     tty: fix leakage of -ERESTARTSYS to userland
has been added to the -mm tree.  Its filename is
     tty-fix-leakage-of-erestartsys-to-userland.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tty: fix leakage of -ERESTARTSYS to userland
From: Oleg Nesterov <oleg@tv-sign.ru>

Spotted by Satoru Takeuchi.

kill_pgrp(task_pgrp(current)) sends the signal to the current's thread
group, but can choose any sub-thread as a target for signal_wake_up(). 
This means that job_control() and tty_check_change() may return
-ERESTARTSYS without signal_pending().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_tty.c  |    1 +
 drivers/char/tty_io.c |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/char/n_tty.c~tty-fix-leakage-of-erestartsys-to-userland drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~tty-fix-leakage-of-erestartsys-to-userland
+++ a/drivers/char/n_tty.c
@@ -1191,6 +1191,7 @@ static int job_control(struct tty_struct
 			    is_current_pgrp_orphaned())
 				return -EIO;
 			kill_pgrp(task_pgrp(current), SIGTTIN, 1);
+			set_thread_flag(TIF_SIGPENDING);
 			return -ERESTARTSYS;
 		}
 	}
diff -puN drivers/char/tty_io.c~tty-fix-leakage-of-erestartsys-to-userland drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty-fix-leakage-of-erestartsys-to-userland
+++ a/drivers/char/tty_io.c
@@ -1148,7 +1148,8 @@ int tty_check_change(struct tty_struct *
 		return 0;
 	if (is_current_pgrp_orphaned())
 		return -EIO;
-	(void) kill_pgrp(task_pgrp(current), SIGTTOU, 1);
+	kill_pgrp(task_pgrp(current), SIGTTOU, 1);
+	set_thread_flag(TIF_SIGPENDING);
 	return -ERESTARTSYS;
 }
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

libata-core-convert-to-use-cancel_rearming_delayed_work.patch
tty-fix-leakage-of-erestartsys-to-userland.patch
freezer-run-show_state-when-freezing-times-out.patch
hibernation-prepare-to-enter-the-low-power-state.patch
freezer-avoid-freezing-kernel-threads-prematurely.patch
freezer-use-__set_current_state-in-refrigerator.patch
freezer-return-int-from-freeze_processes.patch
freezer-remove-redundant-check-in-try_to_freeze_tasks.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
use-write_trylock_irqsave-in-ptrace_attach.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
