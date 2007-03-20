From: akpm@linux-foundation.org
Subject: + mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix.patch added to -mm tree
Date: Mon, 19 Mar 2007 21:32:10 -0800
Message-ID: <200703200532.l2K5WAbn026743@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47584 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933404AbXCTFcM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Mar 2007 01:32:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nickpiggin@yahoo.com.au


The patch titled
     mm-dnp-invp-race-fix2
has been added to the -mm tree.  Its filename is
     mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm-dnp-invp-race-fix2
From: Nick Piggin <nickpiggin@yahoo.com.au>

The nopage vs invalidate race fix patch did not take care of truncating
private COW pages. Mind you, I'm pretty sure this was previously racy
even for regular truncate, not to mention vmtruncate_range.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN mm/memory.c~mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix mm/memory.c
--- a/mm/memory.c~mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix
+++ a/mm/memory.c
@@ -1905,7 +1905,18 @@ int vmtruncate(struct inode * inode, lof
 	if (IS_SWAPFILE(inode))
 		goto out_busy;
 	i_size_write(inode, offset);
+
+	/*
+	 * unmap_mapping_range is called twice, first simply for efficiency
+	 * so that truncate_inode_pages does fewer single-page unmaps. However
+	 * after this first call, and before truncate_inode_pages finishes,
+	 * it is possible for private pages to be COWed, which remain after
+	 * truncate_inode_pages finishes, hence the second unmap_mapping_range
+	 * call must be made for correctness.
+	 */
+	unmap_mapping_range(mapping, offset + PAGE_SIZE - 1, 0, 1);
 	truncate_inode_pages(mapping, offset);
+	unmap_mapping_range(mapping, offset + PAGE_SIZE - 1, 0, 1);
 	goto out_truncate;
 
 do_expand:
@@ -1943,7 +1954,9 @@ int vmtruncate_range(struct inode *inode
 
 	mutex_lock(&inode->i_mutex);
 	down_write(&inode->i_alloc_sem);
+	unmap_mapping_range(mapping, offset, (end - offset), 1);
 	truncate_inode_pages_range(mapping, offset, end);
+	unmap_mapping_range(mapping, offset, (end - offset), 1);
 	inode->i_op->truncate_range(inode, offset, end);
 	up_write(&inode->i_alloc_sem);
 	mutex_unlock(&inode->i_mutex);
_

Patches currently in -mm which might be from nickpiggin@yahoo.com.au are

origin.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix.patch
mm-merge-nopfn-into-fault-fix.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
splice-partial-write-handling-fix.patch
as-fix-antic_expire-check.patch
kblockd-use-flush_work.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
sched-optimize-siblings-status-check-logic-in-wake_idle.patch
sched2-sched-domain-sysctl.patch
lists-add-list-splice-tail.patch
sched-remove-sleepavg-from-proc.patch
sched-remove-noninteractive-flag.patch
sched-implement-rsdl-cpu-scheduler.patch
sched-document-rsdl-cpu-scheduler.patch
