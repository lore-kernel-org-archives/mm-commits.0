From: akpm@linux-foundation.org
Subject: + lockdep-check-that-no-locks-held-at-freeze-time.patch added to -mm tree
Date: Fri, 15 Feb 2013 15:32:56 -0800
Message-ID: <20130215233256.6CE595A41F0@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:53534 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab3BOXc5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Feb 2013 18:32:57 -0500
Received: by mail-qe0-f73.google.com with SMTP id 7so388621qeb.4
        for <mm-commits@vger.kernel.org>; Fri, 15 Feb 2013 15:32:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: msb@chromium.org, benchan@chromium.org, mingo@redhat.com, oleg@redhat.com, rjw@sisk.pl, tj@kernel.org


The patch titled
     Subject: lockdep: check that no locks held at freeze time
has been added to the -mm tree.  Its filename is
     lockdep-check-that-no-locks-held-at-freeze-time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mandeep Singh Baines <msb@chromium.org>
Subject: lockdep: check that no locks held at freeze time

We shouldn't try_to_freeze if locks are held.  Verified that I get no
lockdep warnings after applying this patch and "vfork: don't
freezer_count() for in-kernel users of CLONE_VFORK".

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Ben Chan <benchan@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/freezer.h |    2 ++
 kernel/lockdep.c        |    6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN include/linux/freezer.h~lockdep-check-that-no-locks-held-at-freeze-time include/linux/freezer.h
--- a/include/linux/freezer.h~lockdep-check-that-no-locks-held-at-freeze-time
+++ a/include/linux/freezer.h
@@ -3,6 +3,7 @@
 #ifndef FREEZER_H_INCLUDED
 #define FREEZER_H_INCLUDED
 
+#include <linux/debug_locks.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
 #include <linux/atomic.h>
@@ -48,6 +49,7 @@ extern void thaw_kernel_threads(void);
 
 static inline bool try_to_freeze(void)
 {
+	debug_check_no_locks_held(current);
 	might_sleep();
 	if (likely(!freezing(current)))
 		return false;
diff -puN kernel/lockdep.c~lockdep-check-that-no-locks-held-at-freeze-time kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-check-that-no-locks-held-at-freeze-time
+++ a/kernel/lockdep.c
@@ -4098,10 +4098,10 @@ static void print_held_locks_bug(struct 
 		return;
 
 	printk("\n");
-	printk("=====================================\n");
-	printk("[ BUG: lock held at task exit time! ]\n");
+	printk("=======================================\n");
+	printk("[ BUG: lock held at exit/freeze time! ]\n");
 	print_kernel_ident();
-	printk("-------------------------------------\n");
+	printk("---------------------------------------\n");
 	printk("%s/%d is exiting with locks still held!\n",
 		curr->comm, task_pid_nr(curr));
 	lockdep_print_held_locks(curr);
_

Patches currently in -mm which might be from msb@chromium.org are

vfork-dont-freezer_count-for-in-kernel-users-of-clone_vfork.patch
lockdep-check-that-no-locks-held-at-freeze-time.patch
coredump-cleanup-the-waiting-for-coredump_finish-code.patch
coredump-use-a-freezable_schedule-for-the-coredump_finish-wait.patch
coredump-abort-core-dump-piping-only-due-to-a-fatal-signal.patch

