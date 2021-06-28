Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0315CC11F64
	for <mm-commits@archiver.kernel.org>; Mon, 28 Jun 2021 20:17:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2CE061CCD
	for <mm-commits@archiver.kernel.org>; Mon, 28 Jun 2021 20:17:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237362AbhF1UUP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 16:20:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:32928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236965AbhF1UUN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 16:20:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EDCB61CCA;
        Mon, 28 Jun 2021 20:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624911467;
        bh=AZ92uBPIie2K/in4B4//Dvj65cwq+256/9fjrQB3AAk=;
        h=Date:From:To:Subject:From;
        b=0om2dHAGCcNWLhIjs8SY0Iv9QMXjPVusDuzVHD0npubeckfwVC+MrY8Nxeiko7+1U
         Kodcv7VuyzzMw9HI0NaHHi0gawYANUUyO1aiGpDa6rPY1Tp4yBxwCBbWOOlsQKj3W2
         iv53N2hisbdALyS8yEJ1aS0yl6iP3Jg7289KQ/Ik=
Date:   Mon, 28 Jun 2021 13:17:46 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20210628201746.N4G9oiZTF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/kernel/signal.c~linux-next-git-rejects
+++ a/kernel/signal.c
@@ -430,10 +430,6 @@ __sigqueue_alloc(int sig, struct task_st
 		ucounts = get_ucounts(ucounts);
 	rcu_read_unlock();
 
-<<<<<<< HEAD
-	if (override_rlimit || likely(sigpending <= task_rlimit(t, RLIMIT_SIGPENDING))) {
-		q = kmem_cache_alloc(sigqueue_cachep, gfp_flags);
-=======
 	if (override_rlimit || (sigpending < LONG_MAX && sigpending <= task_rlimit(t, RLIMIT_SIGPENDING))) {
 		/*
 		 * Preallocation does not hold sighand::siglock so it can't
@@ -451,7 +447,6 @@ __sigqueue_alloc(int sig, struct task_st
 			q = kmem_cache_alloc(sigqueue_cachep, gfp_flags);
 		else
 			WRITE_ONCE(t->sigqueue_cache, NULL);
->>>>>>> linux-next/akpm-base
 	} else {
 		print_dropped_signal(sig);
 	}
@@ -471,17 +466,11 @@ static void __sigqueue_free(struct sigqu
 {
 	if (q->flags & SIGQUEUE_PREALLOC)
 		return;
-<<<<<<< HEAD
-	if (atomic_dec_and_test(&q->user->sigpending))
-		free_uid(q->user);
-	kmem_cache_free(sigqueue_cachep, q);
-=======
 	if (q->ucounts && dec_rlimit_ucounts(q->ucounts, UCOUNT_RLIMIT_SIGPENDING, 1)) {
 		put_ucounts(q->ucounts);
 		q->ucounts = NULL;
 	}
 	sigqueue_cache_or_free(q);
->>>>>>> linux-next/akpm-base
 }
 
 void flush_sigqueue(struct sigpending *queue)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-fix-memory-map-initialization-for-descending-nodes-checkpatch-fixes.patch
mm.patch
mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
slub-force-on-no_hash_pointers-when-slub_debug-is-enabled-fix.patch
fs-remove-noop_set_page_dirty-fix.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
mmmemory_hotplug-drop-unneeded-locking-fix.patch
fs-proc-kcorec-add-mmap-interface-fix.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
lib-math-rational-add-kunit-test-cases-fix.patch
lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
ipc-utilc-use-binary-search-for-max_idx-fix.patch
linux-next-pre.patch
linux-next-post.patch
linux-next-rejects.patch
kernel-cgroup-cgroupc-dont-export-cgroup_get_e_css-twice.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

