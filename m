From: akpm@linux-foundation.org
Subject: [merged]
 sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs.patch removed from
 -mm tree
Date: Mon, 09 Jun 2014 12:40:17 -0700
Message-ID: <53960da1.N0DvfbU/Ard8ZjEw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54341 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbaFITkS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:40:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, richard@nod.at, rdunlap@infradead.org, paulmck@linux.vnet.ibm.com, cxie@redhat.com, riel@redhat.com

Subject: [merged] sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs.patch removed from -mm tree
To: riel@redhat.com,cxie@redhat.com,paulmck@linux.vnet.ibm.com,rdunlap@infradead.org,richard@nod.at,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:40:17 -0700


The patch titled
     Subject: sysrq,rcu: suppress RCU stall warnings while sysrq runs
has been removed from the -mm tree.  Its filename was
     sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: sysrq,rcu: suppress RCU stall warnings while sysrq runs

Some sysrq handlers can run for a long time, because they dump a lot of
data onto a serial console.  Having RCU stall warnings pop up in the
middle of them only makes the problem worse.

This patch temporarily disables RCU stall warnings while a sysrq request
is handled.

Signed-off-by: Rik van Riel <riel@redhat.com>
Suggested-by: Paul McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Madper Xie <cxie@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/sysrq.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/tty/sysrq.c~sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs drivers/tty/sysrq.c
--- a/drivers/tty/sysrq.c~sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs
+++ a/drivers/tty/sysrq.c
@@ -46,6 +46,7 @@
 #include <linux/jiffies.h>
 #include <linux/syscalls.h>
 #include <linux/of.h>
+#include <linux/rcupdate.h>
 
 #include <asm/ptrace.h>
 #include <asm/irq_regs.h>
@@ -511,6 +512,7 @@ void __handle_sysrq(int key, bool check_
 	int orig_log_level;
 	int i;
 
+	rcu_sysrq_start();
 	rcu_read_lock();
 	/*
 	 * Raise the apparent loglevel to maximum so that the sysrq header
@@ -554,6 +556,7 @@ void __handle_sysrq(int key, bool check_
 		console_loglevel = orig_log_level;
 	}
 	rcu_read_unlock();
+	rcu_sysrq_end();
 }
 
 void handle_sysrq(int key)
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

