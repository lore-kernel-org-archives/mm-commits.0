From: akpm@linux-foundation.org
Subject: [to-be-updated] sysrq-rcu-ify-__handle_sysrq.patch removed from
 -mm tree
Date: Mon, 28 Apr 2014 16:05:18 -0700
Message-ID: <535edeae.teoq0+bLBXJTp6XJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50866 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaD1XFT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Apr 2014 19:05:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, peterz@infradead.org, jslaby@suse.cz, joern@logfs.org, gregkh@linuxfoundation.org, cxie@redhat.com, riel@redhat.com

Subject: [to-be-updated] sysrq-rcu-ify-__handle_sysrq.patch removed from -mm tree
To: riel@redhat.com,cxie@redhat.com,gregkh@linuxfoundation.org,joern@logfs.org,jslaby@suse.cz,peterz@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 28 Apr 2014 16:05:18 -0700


The patch titled
     Subject: sysrq: rcu-ify __handle_sysrq
has been removed from the -mm tree.  Its filename was
     sysrq-rcu-ify-__handle_sysrq.patch

This patch was dropped because an updated version will be merged

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
Cc: Joern Engel <joern@logfs.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Madper Xie <cxie@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
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
+	 * A concurrent __handle_sysrq eitehr got the old op or the new op.
+	 * Wait for it to go away before returning, so the code for an old
+	 * op is not freed (eg. on module unload) while it is in use.
+	 */
+	synchronize_rcu();
+
 	return retval;
 }
 
_

Patches currently in -mm which might be from riel@redhat.com are

mm-compaction-make-isolate_freepages-start-at-pageblock-boundary.patch
revert-mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low.patch
x86-require-x86-64-for-automatic-numa-balancing.patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels.patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2.patch
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
mm-add-pte_present-check-on-existing-hugetlb_entry-callbacks.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
mm-mmapc-replace-is_err-and-ptr_err-with-ptr_err_or_zero.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
mm-compaction-cleanup-isolate_freepages-fix-2.patch
mm-swapc-clean-up-lru_cache_add-functions.patch
mm-numa-add-migrated-transhuge-pages-to-lru-the-same-way-as-base-pages.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
sysrq-rcu-ify-__handle_sysrq-fix.patch
sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs.patch
linux-next.patch

