From: akpm@linux-foundation.org
Subject: + futex_unlock_pi-hurts-my-brain-and-may-cause.patch added to -mm tree
Date: Wed, 01 Aug 2007 15:24:56 -0700
Message-ID: <200708012224.l71MOuJK020563@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53413 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753631AbXHAWZ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2007 18:25:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, mingo@elte.hu, rostedt@goodmis.org, tglx@linutronix.de


The patch titled
     futex_unlock_pi() hurts my brain and may cause application deadlock
has been added to the -mm tree.  Its filename is
     futex_unlock_pi-hurts-my-brain-and-may-cause.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
geode-mfgpt-clock-event-device-support.patch
futex_unlock_pi-hurts-my-brain-and-may-cause.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
