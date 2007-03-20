From: akpm@linux-foundation.org
Subject: + mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix-2.patch added to -mm tree
Date: Mon, 19 Mar 2007 22:20:18 -0800
Message-ID: <200703200620.l2K6KIk7027489@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48956 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791AbXCTGUU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Mar 2007 02:20:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nickpiggin@yahoo.com.au


The patch titled
     mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix 2
has been added to the -mm tree.  Its filename is
     mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix 2
From: Nick Piggin <nickpiggin@yahoo.com.au>

Fix typo in do_no_page vs invalidate race fix patch.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/truncate.c~mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix-2 mm/truncate.c
--- a/mm/truncate.c~mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix-2
+++ a/mm/truncate.c
@@ -235,7 +235,7 @@ void truncate_inode_pages_range(struct a
 			wait_on_page_writeback(page);
 			if (page_mapped(page)) {
 				unmap_mapping_range(mapping,
-				  (loff_t)page_index<<PAGE_CACHE_SHIFT,
+				  (loff_t)page->index<<PAGE_CACHE_SHIFT,
 				  PAGE_CACHE_SIZE, 0);
 			}
 			if (page->index > next)
_

Patches currently in -mm which might be from nickpiggin@yahoo.com.au are

origin.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix-2.patch
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
