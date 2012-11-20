From: akpm@linux-foundation.org
Subject: + watchdog-trigger-all-cpu-backtrace-when-locked-up-and-going-to-panic.patch added to -mm tree
Date: Mon, 19 Nov 2012 16:19:28 -0800
Message-ID: <20121120001929.1564220004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:37932 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab2KTATb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Nov 2012 19:19:31 -0500
Received: by mail-la0-f74.google.com with SMTP id v3so357075lag.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Nov 2012 16:19:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sasha.levin@oracle.com, mingo@elte.hu


The patch titled
     Subject: watchdog: trigger all-cpu backtrace when locked up and going to panic
has been added to the -mm tree.  Its filename is
     watchdog-trigger-all-cpu-backtrace-when-locked-up-and-going-to-panic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: watchdog: trigger all-cpu backtrace when locked up and going to panic

Send an NMI to all CPUs when a lockup is detected and the lockup watchdog
code is configured to panic.  This gives us a fairly uptodate snapshot of
all CPUs in the system.

This lets us get stack trace of all CPUs which makes life easier trying to
debug a deadlock, and the NMI doesn't change anything since the next step
is a kernel panic.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN kernel/watchdog.c~watchdog-trigger-all-cpu-backtrace-when-locked-up-and-going-to-panic kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-trigger-all-cpu-backtrace-when-locked-up-and-going-to-panic
+++ a/kernel/watchdog.c
@@ -239,10 +239,12 @@ static void watchdog_overflow_callback(s
 		if (__this_cpu_read(hard_watchdog_warn) == true)
 			return;
 
-		if (hardlockup_panic)
+		if (hardlockup_panic) {
+			trigger_all_cpu_backtrace();
 			panic("Watchdog detected hard LOCKUP on cpu %d", this_cpu);
-		else
+		} else {
 			WARN(1, "Watchdog detected hard LOCKUP on cpu %d", this_cpu);
+		}
 
 		__this_cpu_write(hard_watchdog_warn, true);
 		return;
@@ -323,8 +325,10 @@ static enum hrtimer_restart watchdog_tim
 		else
 			dump_stack();
 
-		if (softlockup_panic)
+		if (softlockup_panic) {
+			trigger_all_cpu_backtrace();
 			panic("softlockup: hung tasks");
+		}
 		__this_cpu_write(soft_watchdog_warn, true);
 	} else
 		__this_cpu_write(soft_watchdog_warn, false);
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

linux-next.patch
watchdog-trigger-all-cpu-backtrace-when-locked-up-and-going-to-panic.patch
slub-drop-mutex-before-deleting-sysfs-entry.patch
mm-augment-vma-rbtree-with-rb_subtree_gap-ensure-safe-rb_subtree_gap-update-when-inserting-new-vma.patch
mm-augment-vma-rbtree-with-rb_subtree_gap-ensure-safe-rb_subtree_gap-update-when-removing-vma.patch
mm-augment-vma-rbtree-with-rb_subtree_gap--debug-code-to-verify-rb_subtree_gap-updates-are-safe.patch

