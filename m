From: akpm@linux-foundation.org
Subject: + mmvmacache-count-number-of-system-wide-flushes.patch added to
 -mm tree
Date: Tue, 25 Nov 2014 13:46:32 -0800
Message-ID: <5474f8b8.oC3HFF3LACbl/CGI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50715 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaKYVqd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Nov 2014 16:46:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,vmacache: count number of system-wide flushes
has been added to the -mm tree.  Its filename is
     mmvmacache-count-number-of-system-wide-flushes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmvmacache-count-number-of-system-wide-flushes.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mmvmacache-count-number-of-system-wide-flushes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -91,6 +91,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
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
@@ -901,6 +901,7 @@ const char * const vmstat_text[] = {
 #ifdef CONFIG_DEBUG_VM_VMACACHE
 	"vmacache_find_calls",
 	"vmacache_find_hits",
+	"vmacache_full_flushes",
 #endif
 #endif /* CONFIG_VM_EVENTS_COUNTERS */
 };
_

Patches currently in -mm which might be from dave@stgolabs.net are

ipc-semc-fully-initialize-sem_array-before-making-it-visible.patch
mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-convert-i_mmap_mutex-to-rwsem-fix.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
mm-memoryc-share-the-i_mmap_rwsem.patch
mm-rmap-calculate-page-offset-when-needed.patch
hugetlb-fix-hugepages=-entry-in-kernel-parameterstxt.patch
hugetlb-alloc_bootmem_huge_page-use-is_aligned.patch
hugetlb-hugetlb_register_all_nodes-add-__init-marker.patch
mmvmacache-count-number-of-system-wide-flushes.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-semc-increase-semmsl-semmni-semopm.patch
ipc-msg-increase-msgmni-remove-scaling.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
mm-fix-overly-aggressive-shmdt-when-calls-span-multiple-segments.patch
shmdt-use-i_size_read-instead-of-i_size.patch
linux-next.patch

