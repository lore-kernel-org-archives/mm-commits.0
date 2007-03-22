From: akpm@linux-foundation.org
Subject: + lockdep-debug_show_all_locks-debug_show_held_locks-vs-debug_locks.patch added to -mm tree
Date: Wed, 21 Mar 2007 23:42:19 -0800
Message-ID: <200703220742.l2M7gJ9X015115@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43088 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177AbXCVHmr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 03:42:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jarkao2@o2.pl, a.p.zijlstra@chello.nl, folkert@vanheusden.com, mingo@elte.hu, oleg@tv-sign.ru


The patch titled
     lockdep: debug_show_all_locks &  debug_show_held_locks vs. debug_locks
has been added to the -mm tree.  Its filename is
     lockdep-debug_show_all_locks-debug_show_held_locks-vs-debug_locks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lockdep: debug_show_all_locks &  debug_show_held_locks vs. debug_locks
From: Jarek Poplawski <jarkao2@o2.pl>

lockdep's data shouldn't be used when debug_locks == 0 because it's not
updated after this, so it's more misleading than helpful.

PS: probably lockdep's current-> fields should be reset after it turns
debug_locks off: so, after printing a bug report, but before return from
exported functions, but there are really a lot of these possibilities (e.g.
 after DEBUG_LOCKS_WARN_ON), so, something could be missed.  (Of course
direct use of this fields isn't recommended either.)

Reported-by: Folkert van Heusden <folkert@vanheusden.com>
Inspired-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/lockdep.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN kernel/lockdep.c~lockdep-debug_show_all_locks-debug_show_held_locks-vs-debug_locks kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-debug_show_all_locks-debug_show_held_locks-vs-debug_locks
+++ a/kernel/lockdep.c
@@ -2742,6 +2742,10 @@ void debug_show_all_locks(void)
 	int count = 10;
 	int unlock = 1;
 
+	if (unlikely(!debug_locks)) {
+		printk("INFO: lockdep is turned off.\n");
+		return;
+	}
 	printk("\nShowing all locks held in the system:\n");
 
 	/*
@@ -2785,6 +2789,10 @@ EXPORT_SYMBOL_GPL(debug_show_all_locks);
 
 void debug_show_held_locks(struct task_struct *task)
 {
+	if (unlikely(!debug_locks)) {
+		printk("INFO: lockdep is turned off.\n");
+		return;
+	}
 	lockdep_print_held_locks(task);
 }
 
_

Patches currently in -mm which might be from jarkao2@o2.pl are

lockdep-lockdep_depth-vs-debug_locks-re-bug-workqueue-leaked-lock.patch
lockdep-debug_show_all_locks-debug_show_held_locks-vs-debug_locks.patch
