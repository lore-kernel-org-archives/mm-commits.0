From: akpm@linux-foundation.org
Subject: +
 ipcsem-block-sem_lock-on-sma-lock-during-sma-initialization.patch added to
 -mm tree
Date: Fri, 21 Nov 2014 14:32:52 -0800
Message-ID: <546fbd94.rpKYHSW5pMY+z6W4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58094 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbaKUWcx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Nov 2014 17:32:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, aquini@redhat.com, dave@stgolabs.net, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc,sem block sem_lock on sma->lock during sma initialization
has been added to the -mm tree.  Its filename is
     ipcsem-block-sem_lock-on-sma-lock-during-sma-initialization.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipcsem-block-sem_lock-on-sma-lock-during-sma-initialization.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/ipcsem-block-sem_lock-on-sma-lock-during-sma-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: ipc,sem block sem_lock on sma->lock during sma initialization

When manipulating just one semaphore with semop, sem_lock only takes that
single semaphore's lock.  This creates a problem during initialization of
the semaphore array, when the data structures used by sem_lock have not
been set up yet.  The sma->lock is already held by newary, and we just
have to make sure everything else waits on that lock during
initialization.

Luckily it is easy to make sem_lock wait on the sma->lock, by pretending
there is a complex operation in progress while the sma is being
initialized.

The newary function already zeroes sma->complex_count before unlocking the
sma->lock.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN ipc/sem.c~ipcsem-block-sem_lock-on-sma-lock-during-sma-initialization ipc/sem.c
--- a/ipc/sem.c~ipcsem-block-sem_lock-on-sma-lock-during-sma-initialization
+++ a/ipc/sem.c
@@ -507,6 +507,9 @@ static int newary(struct ipc_namespace *
 		return retval;
 	}
 
+	/* Ensures sem_lock waits on &sma->lock until sma is ready. */
+	sma->complex_count = 1;
+
 	id = ipc_addid(&sem_ids(ns), &sma->sem_perm, ns->sc_semmni);
 	if (id < 0) {
 		ipc_rcu_putref(sma, sem_rcu_free);
_

Patches currently in -mm which might be from riel@redhat.com are

mm-do-not-overwrite-reserved-pages-counter-at-show_mem.patch
ipcsem-block-sem_lock-on-sma-lock-during-sma-initialization.patch
mm-introduce-single-zone-pcplists-drain.patch
mm-page_isolation-drain-single-zone-pcplists.patch
mm-cma-drain-single-zone-pcplists.patch
mm-memory_hotplug-failure-drain-single-zone-pcplists.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking-fix.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-defer-only-on-compact_complete.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-compaction-always-update-cached-scanner-positions-fix.patch
mm-compaction-more-focused-lru-and-pcplists-draining.patch
mm-compaction-more-focused-lru-and-pcplists-draining-fix.patch
mm-fix-a-spelling-mistake.patch
mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
mm-memoryc-share-the-i_mmap_rwsem.patch
mm-mincore-add-hwpoison-page-handle.patch
hugetlb-fix-hugepages=-entry-in-kernel-parameterstxt.patch
hugetlb-alloc_bootmem_huge_page-use-is_aligned.patch
hugetlb-hugetlb_register_all_nodes-add-__init-marker.patch
mm-page_alloc-store-updated-page-migratetype-to-avoid-misusing-stale-value.patch
mm-page_alloc-store-updated-page-migratetype-to-avoid-misusing-stale-value-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
exit-wait-cleanup-the-ptrace_reparented-checks.patch
exit-wait-cleanup-the-ptrace_reparented-checks-fix.patch
exit-wait-dont-use-zombie-real_parent.patch
exit-wait-drop-tasklist_lock-before-psig-c-accounting.patch
exit-release_task-fix-the-comment-about-group-leader-accounting.patch
exit-proc-dont-try-to-flush-proc-tgid-task-tgid.patch
linux-next.patch

