From: akpm@linux-foundation.org
Subject: + mm-memory-failure-share-the-i_mmap_rwsem.patch added to -mm
 tree
Date: Tue, 04 Nov 2014 15:04:54 -0800
Message-ID: <54595b96.jmSi3mMCPSb9QHmW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48610 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbaKDXEx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2014 18:04:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, hughd@google.com, kirill.shutemov@intel.linux.com, oleg@redhat.com, peterz@infradead.org, riel@redhat.com, srikar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: share the i_mmap_rwsem
has been added to the -mm tree.  Its filename is
     mm-memory-failure-share-the-i_mmap_rwsem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failure-share-the-i_mmap_rwsem.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failure-share-the-i_mmap_rwsem.patch

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
Subject: mm/memory-failure: share the i_mmap_rwsem

No brainer conversion: collect_procs_file() only schedules a process for
later kill, share the lock, similarly to the anon vma variant.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Kirill A. Shutemov <kirill.shutemov@intel.linux.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory-failure.c~mm-memory-failure-share-the-i_mmap_rwsem mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failure-share-the-i_mmap_rwsem
+++ a/mm/memory-failure.c
@@ -466,7 +466,7 @@ static void collect_procs_file(struct pa
 	struct task_struct *tsk;
 	struct address_space *mapping = page->mapping;
 
-	i_mmap_lock_write(mapping);
+	i_mmap_lock_read(mapping);
 	read_lock(&tasklist_lock);
 	for_each_process(tsk) {
 		pgoff_t pgoff = page_to_pgoff(page);
@@ -488,7 +488,7 @@ static void collect_procs_file(struct pa
 		}
 	}
 	read_unlock(&tasklist_lock);
-	i_mmap_unlock_write(mapping);
+	i_mmap_unlock_read(mapping);
 }
 
 /*
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
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-semc-increase-semmsl-semmni-semopm.patch
ipc-msg-increase-msgmni-remove-scaling.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch

