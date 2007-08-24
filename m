From: akpm@linux-foundation.org
Subject: - futex_unlock_pi-hurts-my-brain-and-may-cause.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:55:21 -0700
Message-ID: <200708242055.l7OKtLB0013955@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46457 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756799AbXHXU4M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 16:56:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, mingo@elte.hu, rostedt@goodmis.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     futex_unlock_pi() hurts my brain and may cause application deadlock
has been removed from the -mm tree.  Its filename was
     futex_unlock_pi-hurts-my-brain-and-may-cause.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: futex_unlock_pi() hurts my brain and may cause application deadlock
From: john stultz <johnstul@us.ibm.com>

Avoid futex_unlock_pi returning -EFAULT (which results in deadlock), by
clearing uval before jumping to retry_locked.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN kernel/futex.c~futex_unlock_pi-hurts-my-brain-and-may-cause kernel/futex.c
--- a/kernel/futex.c~futex_unlock_pi-hurts-my-brain-and-may-cause
+++ a/kernel/futex.c
@@ -1670,6 +1670,7 @@ pi_faulted:
 					 attempt);
 		if (ret)
 			goto out;
+		uval = 0;
 		goto retry_unlocked;
 	}
 
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

origin.patch
git-acpi.patch
geode-mfgpt-clock-event-device-support.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
kernel-time-timekeepingc-cleanups.patch
use-num_possible_cpus-instead-of-nr_cpus-for-timer.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
