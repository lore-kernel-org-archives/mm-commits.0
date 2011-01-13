From: akpm@linux-foundation.org
Subject: [merged] printk-use-rcu-to-prevent-potential-lock-contention-in-kmsg_dump.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:04:16 -0800
Message-ID: <201101132006.p0DK6vFT029786@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60382 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933639Ab1AMUHo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:07:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, mingo@elte.hu, paulmck@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     printk: use RCU to prevent potential lock contention in kmsg_dump
has been removed from the -mm tree.  Its filename was
     printk-use-rcu-to-prevent-potential-lock-contention-in-kmsg_dump.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: printk: use RCU to prevent potential lock contention in kmsg_dump
From: Huang Ying <ying.huang@intel.com>

dump_list_lock is used to protect dump_list in kmsg_dumper implementation,
kmsg_dump() uses it to traverse dump_list too.  But if there is contention
on the lock, kmsg_dump() will fail, and the valuable kernel message may be
lost.

This patch solves this issue with RCU.  Because kmsg_dump() only read the
list, no lock is needed in kmsg_dump().  So that kmsg_dump() will never
fail because of lock contention.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |   34 +++++++---------------------------
 1 file changed, 7 insertions(+), 27 deletions(-)

diff -puN kernel/printk.c~printk-use-rcu-to-prevent-potential-lock-contention-in-kmsg_dump kernel/printk.c
--- a/kernel/printk.c~printk-use-rcu-to-prevent-potential-lock-contention-in-kmsg_dump
+++ a/kernel/printk.c
@@ -39,6 +39,7 @@
 #include <linux/syslog.h>
 #include <linux/cpu.h>
 #include <linux/notifier.h>
+#include <linux/rculist.h>
 
 #include <asm/uaccess.h>
 
@@ -1502,7 +1503,7 @@ int kmsg_dump_register(struct kmsg_dumpe
 	/* Don't allow registering multiple times */
 	if (!dumper->registered) {
 		dumper->registered = 1;
-		list_add_tail(&dumper->list, &dump_list);
+		list_add_tail_rcu(&dumper->list, &dump_list);
 		err = 0;
 	}
 	spin_unlock_irqrestore(&dump_list_lock, flags);
@@ -1526,33 +1527,16 @@ int kmsg_dump_unregister(struct kmsg_dum
 	spin_lock_irqsave(&dump_list_lock, flags);
 	if (dumper->registered) {
 		dumper->registered = 0;
-		list_del(&dumper->list);
+		list_del_rcu(&dumper->list);
 		err = 0;
 	}
 	spin_unlock_irqrestore(&dump_list_lock, flags);
+	synchronize_rcu();
 
 	return err;
 }
 EXPORT_SYMBOL_GPL(kmsg_dump_unregister);
 
-static const char * const kmsg_reasons[] = {
-	[KMSG_DUMP_OOPS]	= "oops",
-	[KMSG_DUMP_PANIC]	= "panic",
-	[KMSG_DUMP_KEXEC]	= "kexec",
-	[KMSG_DUMP_RESTART]	= "restart",
-	[KMSG_DUMP_HALT]	= "halt",
-	[KMSG_DUMP_POWEROFF]	= "poweroff",
-	[KMSG_DUMP_EMERG]	= "emergency_restart",
-};
-
-static const char *kmsg_to_str(enum kmsg_dump_reason reason)
-{
-	if (reason >= ARRAY_SIZE(kmsg_reasons) || reason < 0)
-		return "unknown";
-
-	return kmsg_reasons[reason];
-}
-
 /**
  * kmsg_dump - dump kernel log to kernel message dumpers.
  * @reason: the reason (oops, panic etc) for dumping
@@ -1591,13 +1575,9 @@ void kmsg_dump(enum kmsg_dump_reason rea
 		l2 = chars;
 	}
 
-	if (!spin_trylock_irqsave(&dump_list_lock, flags)) {
-		printk(KERN_ERR "dump_kmsg: dump list lock is held during %s, skipping dump\n",
-				kmsg_to_str(reason));
-		return;
-	}
-	list_for_each_entry(dumper, &dump_list, list)
+	rcu_read_lock();
+	list_for_each_entry_rcu(dumper, &dump_list, list)
 		dumper->dump(dumper, reason, s1, l1, s2, l2);
-	spin_unlock_irqrestore(&dump_list_lock, flags);
+	rcu_read_unlock();
 }
 #endif
_

Patches currently in -mm which might be from ying.huang@intel.com are

origin.patch
linux-next.patch

