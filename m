From: akpm@linux-foundation.org
Subject: [merged] spinlock_debug-print-offset-in-addition-to-symbol-name.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:51:28 -0700
Message-ID: <20120731185128.B022410007F@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33060 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321Ab2GaSv3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:51:29 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4676512obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:51:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sboyd@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: spinlock_debug: print offset in addition to symbol name
has been removed from the -mm tree.  Its filename was
     spinlock_debug-print-offset-in-addition-to-symbol-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Boyd <sboyd@codeaurora.org>
Subject: spinlock_debug: print offset in addition to symbol name

If there are two spinlocks embedded in a structure that kallsyms knows
about and one of the spinlocks locks up we will print the name of the
containing structure instead of the address of the lock.  This is quite
bad, so let's use %pS instead of %ps so we get an offset in addition to
the symbol so we can determine which particular lock is having problems.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/spinlock_debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/spinlock_debug.c~spinlock_debug-print-offset-in-addition-to-symbol-name lib/spinlock_debug.c
--- a/lib/spinlock_debug.c~spinlock_debug-print-offset-in-addition-to-symbol-name
+++ a/lib/spinlock_debug.c
@@ -58,7 +58,7 @@ static void spin_dump(raw_spinlock_t *lo
 	printk(KERN_EMERG "BUG: spinlock %s on CPU#%d, %s/%d\n",
 		msg, raw_smp_processor_id(),
 		current->comm, task_pid_nr(current));
-	printk(KERN_EMERG " lock: %ps, .magic: %08x, .owner: %s/%d, "
+	printk(KERN_EMERG " lock: %pS, .magic: %08x, .owner: %s/%d, "
 			".owner_cpu: %d\n",
 		lock, lock->magic,
 		owner ? owner->comm : "<none>",
_

Patches currently in -mm which might be from sboyd@codeaurora.org are

origin.patch

