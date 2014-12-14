From: akpm@linux-foundation.org
Subject: [merged] mmvmacache-count-number-of-system-wide-flushes.patch
 removed from -mm tree
Date: Sat, 13 Dec 2014 20:08:04 -0800
Message-ID: <548d0d24.iZq6yKDxrF2IuJ1C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47677 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbaLNEH4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:07:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,vmacache: count number of system-wide flushes
has been removed from the -mm tree.  Its filename was
     mmvmacache-count-number-of-system-wide-flushes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: mm,vmacache: count number of system-wide flushes

These flushes deal with sequence number overflows, such as for long lived
threads.  These are rare, but interesting from a debugging PoV.  As such,
display the number of flushes when vmacache debugging is enabled.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    1 +
 mm/vmacache.c                 |    2 ++
 mm/vmstat.c                   |    1 +
 3 files changed, 4 insertions(+)

diff -puN include/linux/vm_event_item.h~mmvmacache-count-number-of-system-wide-flushes include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~mmvmacache-count-number-of-system-wide-flushes
+++ a/include/linux/vm_event_item.h
@@ -90,6 +90,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 #ifdef CONFIG_DEBUG_VM_VMACACHE
 		VMACACHE_FIND_CALLS,
 		VMACACHE_FIND_HITS,
+		VMACACHE_FULL_FLUSHES,
 #endif
 		NR_VM_EVENT_ITEMS
 };
diff -puN mm/vmacache.c~mmvmacache-count-number-of-system-wide-flushes mm/vmacache.c
--- a/mm/vmacache.c~mmvmacache-count-number-of-system-wide-flushes
+++ a/mm/vmacache.c
@@ -17,6 +17,8 @@ void vmacache_flush_all(struct mm_struct
 {
 	struct task_struct *g, *p;
 
+	count_vm_vmacache_event(VMACACHE_FULL_FLUSHES);
+
 	/*
 	 * Single threaded tasks need not iterate the entire
 	 * list of process. We can avoid the flushing as well
diff -puN mm/vmstat.c~mmvmacache-count-number-of-system-wide-flushes mm/vmstat.c
--- a/mm/vmstat.c~mmvmacache-count-number-of-system-wide-flushes
+++ a/mm/vmstat.c
@@ -900,6 +900,7 @@ const char * const vmstat_text[] = {
 #ifdef CONFIG_DEBUG_VM_VMACACHE
 	"vmacache_find_calls",
 	"vmacache_find_hits",
+	"vmacache_full_flushes",
 #endif
 #endif /* CONFIG_VM_EVENTS_COUNTERS */
 };
_

Patches currently in -mm which might be from dave@stgolabs.net are

origin.patch

