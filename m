From: akpm@linux-foundation.org
Subject: + do_sigaction-remove-now-unneeded-recalc_sigpending.patch added to -mm tree
Date: Thu, 02 Aug 2007 16:00:47 -0700
Message-ID: <200708022300.l72N0lGo013576@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46017 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750864AbXHBXBx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Aug 2007 19:01:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, mingo@elte.hu, roland@redhat.com


The patch titled
     do_sigaction: remove now unneeded recalc_sigpending()
has been added to the -mm tree.  Its filename is
     do_sigaction-remove-now-unneeded-recalc_sigpending.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: do_sigaction: remove now unneeded recalc_sigpending()
From: Oleg Nesterov <oleg@tv-sign.ru>

With the recent changes, do_sigaction()->recalc_sigpending_and_wake() can
never clear TIF_SIGPENDING. Instead, it can set this flag and wake up the
thread without any reason. Harmless, but unneeded and wastes CPU.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN kernel/signal.c~do_sigaction-remove-now-unneeded-recalc_sigpending kernel/signal.c
--- a/kernel/signal.c~do_sigaction-remove-now-unneeded-recalc_sigpending
+++ a/kernel/signal.c
@@ -2332,7 +2332,6 @@ int do_sigaction(int sig, struct k_sigac
 			rm_from_queue_full(&mask, &t->signal->shared_pending);
 			do {
 				rm_from_queue_full(&mask, &t->pending);
-				recalc_sigpending_and_wake(t);
 				t = next_thread(t);
 			} while (t != current);
 		}
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
fix-theoretical-ccids_readwrite_lock-race.patch
i386-remove-unnecessary-code.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
do_sys_poll-simplify-playing-with-on-stack-data.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
do_poll-return-eintr-when-signalled.patch
pi-futex-set-pf_exiting-without-taking-pi_lock.patch
do_sigaction-remove-now-unneeded-recalc_sigpending.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
cpu-hotplug-topology-remove-topology_dev_map.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-cpuid-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
