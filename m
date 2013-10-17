From: akpm@linux-foundation.org
Subject: [merged]
 mm-compactionc-periodically-schedule-when-freeing-pages.patch removed from
 -mm tree
Date: Thu, 17 Oct 2013 11:12:11 -0700
Message-ID: <5260287b.IcrVk12pBuY0XSid%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44173 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757608Ab3JQSMM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Oct 2013 14:12:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mgorman@suse.de, liwanp@linux.vnet.ibm.com, rientjes@google.com

Subject: [merged] mm-compactionc-periodically-schedule-when-freeing-pages.patch removed from -mm tree
To: rientjes@google.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 17 Oct 2013 11:12:11 -0700


The patch titled
     Subject: mm/compaction.c: periodically schedule when freeing pages
has been removed from the -mm tree.  Its filename was
     mm-compactionc-periodically-schedule-when-freeing-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm/compaction.c: periodically schedule when freeing pages

We've been getting warnings about an excessive amount of time spent
allocating pages for migration during memory compaction without
scheduling.  isolate_freepages_block() already periodically checks for
contended locks or the need to schedule, but isolate_freepages() never
does.

When a zone is massively long and no suitable targets can be found, this
iteration can be quite expensive without ever doing cond_resched().

Check periodically for the need to reschedule while the compaction free
scanner iterates.

Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/compaction.c~mm-compactionc-periodically-schedule-when-freeing-pages mm/compaction.c
--- a/mm/compaction.c~mm-compactionc-periodically-schedule-when-freeing-pages
+++ a/mm/compaction.c
@@ -677,6 +677,13 @@ static void isolate_freepages(struct zon
 					pfn -= pageblock_nr_pages) {
 		unsigned long isolated;
 
+		/*
+		 * This can iterate a massively long zone without finding any
+		 * suitable migration targets, so periodically check if we need
+		 * to schedule.
+		 */
+		cond_resched();
+
 		if (!pfn_valid(pfn))
 			continue;
 
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
kthread-make-kthread_create-killable.patch
x86-srat-use-numa_no_node.patch
mm-vmalloc-use-numa_no_node.patch
mm-add-a-helper-function-to-check-may-oom-condition.patch
mm-arch-use-numa_no_node.patch
mm-mempolicy-make-mpol_to_str-robust-and-always-succeed.patch
mm-vmalloc-dont-set-area-caller-twice.patch
mm-vmalloc-fix-show-vmap_area-information-race-with-vmap_area-tear-down.patch
mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info.patch
revert-mm-vmallocc-emit-the-failure-message-before-return.patch
mm-mempolicy-use-numa_no_node.patch
mm-rearrange-madvise-code-to-allow-for-reuse.patch
mm-add-a-field-to-store-names-for-private-anonymous-memory.patch

