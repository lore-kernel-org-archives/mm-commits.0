From: akpm@linux-foundation.org
Subject: [nacked] printk-fix-spinlock-deadlock-in-printk-reenty.patch
 removed from -mm tree
Date: Wed, 30 Nov 2016 13:24:31 -0800
Message-ID: <583f438f.In6/g1vg0xBo5ChM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45660 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750831AbcK3VYQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2016 16:24:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kejinling@huawei.com, a.p.zijlstra@chello.nl, bp@suse.de, mingo@elte.hu, pmladek@suse.com, sergey.senozhatsky@gmail.com, tj@kernel.org, treding@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: fix spinlock deadlock in printk reenty
has been removed from the -mm tree.  Its filename was
     printk-fix-spinlock-deadlock-in-printk-reenty.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Jinling Ke <kejinling@huawei.com>
Subject: printk: fix spinlock deadlock in printk reenty

When Oops in printk, printk will call zap_locks() to reinitialize spinlock
to prevent deadlock.  In arm, arm64, x86 or other architecture smp cpu,
race condition will occur in printk spinlock logbuf_lock and then it will
result other cpu that is waiting printk spinlock in deadlock(in function
raw_spin_lock).  Because the cpus deadlock, you can see the error printk
log:

"SMP: failed to stop secondary CPUs"

In arm, arm64, x86 or other architecture, spinlock variable is divided
into 2 parts, for example they are 'owner' and 'next' in arm.  When get a
spinlock, the 'next' part will add 1 and wait 'next' being equal to
'owner'.  However, at this moment, the 'next' part is local variable, but
'owner' part value is get from global variable logbuf_lock. 
However,raw_spin_lock_init(&logbuf_lock) will set 'owner' part and 'next'
part to zero, the result is that cpu deadlock in function raw_spin_lock(
while loop in function arch_spin_lock ).

	struct of arm spinlock
	 	union {
			u32 slock;
			struct __raw_tickets {
				u16 owner;
				u16 next;
			} tickets;
		};
	} arch_spinlock_t;
	static inline void arch_spin_lock(arch_spinlock_t *lock)
	{...
		<--- At the moment, other cpu call zap_locks()->spin_lock_init(),
		<--- set the 'owner' part to zero, but lockval.tickets.next is a
	        <--- local variable
		while (lockval.tickets.next != lockval.tickets.owner) {
			lockval.tickets.owner = ACCESS_ONCE(lock->tickets.owner);
		}
	...
	}

The solution is that in zap_locks(), replace
raw_spin_lock_init(&logbuf_lock) with raw_spin_unlock(&logbuf_lock), to
let the spinlock stay in unlocked state.

Link: http://lkml.kernel.org/r/1480490119-63559-1-git-send-email-linyongting@huawei.com
Signed-off-by: Jinling Ke <kejinling@huawei.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thierry Reding <treding@nvidia.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/printk/printk.c~printk-fix-spinlock-deadlock-in-printk-reenty kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-fix-spinlock-deadlock-in-printk-reenty
+++ a/kernel/printk/printk.c
@@ -1603,7 +1603,7 @@ static void zap_locks(void)
 
 	debug_locks_off();
 	/* If a crash is occurring, make sure we can't deadlock */
-	raw_spin_lock_init(&logbuf_lock);
+	raw_spin_unlock(&logbuf_lock);
 	/* And make sure that we print immediately */
 	sema_init(&console_sem, 1);
 }
_

Patches currently in -mm which might be from kejinling@huawei.com are


