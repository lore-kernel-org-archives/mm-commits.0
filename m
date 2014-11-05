From: akpm@linux-foundation.org
Subject: + mm-memoryc-share-the-i_mmap_rwsem.patch added to -mm tree
Date: Wed, 05 Nov 2014 13:17:16 -0800
Message-ID: <545a93dc./7t7NXDgkf+A6Yrp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35240 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbaKEVRP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Nov 2014 16:17:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, hughd@google.com, kirill@shutemov.name, oleg@redhat.com, peterz@infradead.org, riel@redhat.com, srikar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: share the i_mmap_rwsem
has been added to the -mm tree.  Its filename is
     mm-memoryc-share-the-i_mmap_rwsem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memoryc-share-the-i_mmap_rwsem.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-memoryc-share-the-i_mmap_rwsem.patch

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
Subject: mm/memory.c: share the i_mmap_rwsem

The unmap_mapping_range family of functions do the unmapping of user pages
(ultimately via zap_page_range_single) without touching the actual
interval tree, thus share the lock.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Hugh Dickins <hughd@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~mm-memoryc-share-the-i_mmap_rwsem mm/memory.c
--- a/mm/memory.c~mm-memoryc-share-the-i_mmap_rwsem
+++ a/mm/memory.c
@@ -2392,12 +2392,12 @@ void unmap_mapping_range(struct address_
 		details.last_index = ULONG_MAX;
 
 
-	i_mmap_lock_write(mapping);
+	i_mmap_lock_read(mapping);
 	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap)))
 		unmap_mapping_range_tree(&mapping->i_mmap, &details);
 	if (unlikely(!list_empty(&mapping->i_mmap_nonlinear)))
 		unmap_mapping_range_list(&mapping->i_mmap_nonlinear, &details);
-	i_mmap_unlock_write(mapping);
+	i_mmap_unlock_read(mapping);
 }
 EXPORT_SYMBOL(unmap_mapping_range);
 
_

Patches currently in -mm which might be from dave@stgolabs.net are

mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
mm-memoryc-share-the-i_mmap_rwsem.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-semc-increase-semmsl-semmni-semopm.patch
ipc-msg-increase-msgmni-remove-scaling.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
linux-next.patch

