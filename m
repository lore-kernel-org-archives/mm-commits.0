From: akpm@linux-foundation.org
Subject: [merged] sysrq-rcu-ify-__handle_sysrq.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:40:13 -0700
Message-ID: <53960d9d.0wKZ490ucdBjBb2B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54335 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbaFITkN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:40:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, richard@nod.at, rdunlap@infradead.org, paulmck@linux.vnet.ibm.com, cxie@redhat.com, riel@redhat.com

Subject: [merged] sysrq-rcu-ify-__handle_sysrq.patch removed from -mm tree
To: riel@redhat.com,cxie@redhat.com,paulmck@linux.vnet.ibm.com,rdunlap@infradead.org,richard@nod.at,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:40:13 -0700


The patch titled
     Subject: sysrq: rcu-ify __handle_sysrq
has been removed from the -mm tree.  Its filename was
     sysrq-rcu-ify-__handle_sysrq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: sysrq: rcu-ify __handle_sysrq

Echoing values into /proc/sysrq-trigger seems to be a popular way to get
information out of the kernel.  However, dumping information about
thousands of processes, or hundreds of CPUs to serial console can result
in IRQs being blocked for minutes, resulting in various kinds of cascade
failures.

The most common failure is due to interrupts being blocked for a very long
time.  This can lead to things like failed IO requests, and other things
the system cannot easily recover from.

This problem is easily fixable by making __handle_sysrq use RCU instead of
spin_lock_irqsave.

This leaves the warning that RCU grace periods have not elapsed for a long
time, but the system will come back from that automatically.

It also leaves sysrq-from-irq-context when the sysrq keys are pressed, but
that is probably desired since people want that to work in situations
where the system is already hosed.

The callers of register_sysrq_key and unregister_sysrq_key appear to be
capable of sleeping.

Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Madper Xie <cxie@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/sysrq.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN drivers/tty/sysrq.c~sysrq-rcu-ify-__handle_sysrq drivers/tty/sysrq.c
--- a/drivers/tty/sysrq.c~sysrq-rcu-ify-__handle_sysrq
+++ a/drivers/tty/sysrq.c
@@ -510,9 +510,8 @@ void __handle_sysrq(int key, bool check_
 	struct sysrq_key_op *op_p;
 	int orig_log_level;
 	int i;
-	unsigned long flags;
 
-	spin_lock_irqsave(&sysrq_key_table_lock, flags);
+	rcu_read_lock();
 	/*
 	 * Raise the apparent loglevel to maximum so that the sysrq header
 	 * is shown to provide the user with positive feedback.  We do not
@@ -554,7 +553,7 @@ void __handle_sysrq(int key, bool check_
 		printk("\n");
 		console_loglevel = orig_log_level;
 	}
-	spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
+	rcu_read_unlock();
 }
 
 void handle_sysrq(int key)
@@ -1043,16 +1042,23 @@ static int __sysrq_swap_key_ops(int key,
                                 struct sysrq_key_op *remove_op_p)
 {
 	int retval;
-	unsigned long flags;
 
-	spin_lock_irqsave(&sysrq_key_table_lock, flags);
+	spin_lock(&sysrq_key_table_lock);
 	if (__sysrq_get_key_op(key) == remove_op_p) {
 		__sysrq_put_key_op(key, insert_op_p);
 		retval = 0;
 	} else {
 		retval = -1;
 	}
-	spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
+	spin_unlock(&sysrq_key_table_lock);
+
+	/*
+	 * A concurrent __handle_sysrq either got the old op or the new op.
+	 * Wait for it to go away before returning, so the code for an old
+	 * op is not freed (eg. on module unload) while it is in use.
+	 */
+	synchronize_rcu();
+
 	return retval;
 }
 
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
linux-next.patch

