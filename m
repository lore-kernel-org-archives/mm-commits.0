From: akpm@linux-foundation.org
Subject: [merged] spinlock_debug-print-kallsyms-name-for-lock.patch removed from -mm tree
Date: Thu, 31 May 2012 12:20:09 -0700
Message-ID: <20120531192009.859CDA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:46086 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933105Ab2EaTUK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:20:10 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so76227wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:20:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sboyd@codeaurora.org, a.p.zijlstra@chello.nl, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: spinlock_debug: print kallsyms name for lock
has been removed from the -mm tree.  Its filename was
     spinlock_debug-print-kallsyms-name-for-lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Stephen Boyd <sboyd@codeaurora.org>
Subject: spinlock_debug: print kallsyms name for lock

When a spinlock warning is printed we usually get

 BUG: spinlock bad magic on CPU#0, modprobe/111
  lock: 0xdff09f38, .magic: 00000000, .owner: /0, .owner_cpu: 0

but it's nicer to print the symbol for the lock if we have it so that we
can avoid 'grep dff09f38 /proc/kallsyms' to find out which lock it was. 
Use kallsyms to print the symbol name so we get something a bit easier to
read

 BUG: spinlock bad magic on CPU#0, modprobe/112
  lock: test_lock, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0

If the lock is not in kallsyms %ps will fall back to printing the address
directly.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/spinlock_debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/spinlock_debug.c~spinlock_debug-print-kallsyms-name-for-lock lib/spinlock_debug.c
--- a/lib/spinlock_debug.c~spinlock_debug-print-kallsyms-name-for-lock
+++ a/lib/spinlock_debug.c
@@ -58,7 +58,7 @@ static void spin_dump(raw_spinlock_t *lo
 	printk(KERN_EMERG "BUG: spinlock %s on CPU#%d, %s/%d\n",
 		msg, raw_smp_processor_id(),
 		current->comm, task_pid_nr(current));
-	printk(KERN_EMERG " lock: %p, .magic: %08x, .owner: %s/%d, "
+	printk(KERN_EMERG " lock: %ps, .magic: %08x, .owner: %s/%d, "
 			".owner_cpu: %d\n",
 		lock, lock->magic,
 		owner ? owner->comm : "<none>",
_

Patches currently in -mm which might be from sboyd@codeaurora.org are

origin.patch

