Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99B39C61D9A
	for <mm-commits@archiver.kernel.org>; Tue, 21 Nov 2023 23:11:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234878AbjKUXL5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Nov 2023 18:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjKUXLz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Nov 2023 18:11:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3DF0D4F
        for <mm-commits@vger.kernel.org>; Tue, 21 Nov 2023 15:11:49 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7F4C433CB;
        Tue, 21 Nov 2023 23:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700608309;
        bh=mGHRQ2Tbu15LFd1g0TF/mfpvp32eaQgu3Lhk+5ODKXE=;
        h=Date:To:From:Subject:From;
        b=WwrvwptAomlmFCWaNYPYX1eKqJzQuAgQLCguwYKV7iMtWH/9YIURboL1dNs2MOdH1
         JzGMp6b8aY7eDX79qpglXJvw0HqEng7y6pk59xUReiQQ+0L5xGdddIHnPTzLy5jB1f
         Kt/7jJEZJYGqo2tFDn3glLs3mYDjVm8+1b8Ff+r8=
Date:   Tue, 21 Nov 2023 15:11:48 -0800
To:     mm-commits@vger.kernel.org, zhangpeng362@huawei.com,
        willy@infradead.org, viro@zeniv.linux.org.uk, surenb@google.com,
        shuah@kernel.org, rppt@kernel.org, peterx@redhat.com,
        ngeoffray@google.com, mhocko@suse.com, lokeshgidra@google.com,
        Liam.Howlett@oracle.com, kaleshsingh@google.com, jannh@google.com,
        hughd@google.com, david@redhat.com, brauner@kernel.org,
        bgeffon@google.com, axelrasmussen@google.com, aarcange@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-support-move-to-different-root-anon_vma-in-folio_move_anon_rmap.patch added to mm-unstable branch
Message-Id: <20231121231149.2B7F4C433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: support move to different root anon_vma in folio_move_anon_rmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-support-move-to-different-root-anon_vma-in-folio_move_anon_rmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-support-move-to-different-root-anon_vma-in-folio_move_anon_rmap.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm/rmap: support move to different root anon_vma in folio_move_anon_rmap()
Date: Tue, 21 Nov 2023 09:16:34 -0800

Patch series "userfaultfd move option", v5.

This patch series introduces UFFDIO_MOVE feature to userfaultfd, which has
long been implemented and maintained by Andrea in his local tree [1], but
was not upstreamed due to lack of use cases where this approach would be
better than allocating a new page and copying the contents.  Previous
upstraming attempts could be found at [6] and [7].

UFFDIO_COPY performs ~20% better than UFFDIO_MOVE when the application
needs pages to be allocated [2].  However, with UFFDIO_MOVE, if pages are
available (in userspace) for recycling, as is usually the case in heap
compaction algorithms, then we can avoid the page allocation and memcpy
(done by UFFDIO_COPY).  Also, since the pages are recycled in the
userspace, we avoid the need to release (via madvise) the pages back to
the kernel [3].

We see over 40% reduction (on a Google pixel 6 device) in the compacting
thread's completion time by using UFFDIO_MOVE vs.  UFFDIO_COPY.  This was
measured using a benchmark that emulates a heap compaction implementation
using userfaultfd (to allow concurrent accesses by application threads). 
More details of the usecase are explained in [3].

Furthermore, UFFDIO_MOVE enables moving swapped-out pages without touching
them within the same vma.  Today, it can only be done by mremap, however
it forces splitting the vma.

TODOs for follow-up improvements:
- cross-mm support. Known differences from single-mm and missing pieces:
	- memcg recharging (might need to isolate pages in the process)
	- mm counters
	- cross-mm deposit table moves
	- cross-mm test
	- document the address space where src and dest reside in struct
	  uffdio_move

- TLB flush batching. Will require extensive changes to PTL locking in
move_pages_pte(). OTOH that might let us reuse parts of mremap code.


This patch (of 5):


For now, folio_move_anon_rmap() was only used to move a folio to a
different anon_vma after fork(), whereby the root anon_vma stayed
unchanged.  For that, it was sufficient to hold the folio lock when
calling folio_move_anon_rmap().

However, we want to make use of folio_move_anon_rmap() to move folios
between VMAs that have a different root anon_vma.  As folio_referenced()
performs an RMAP walk without holding the folio lock but only holding the
anon_vma in read mode, holding the folio lock is insufficient.

When moving to an anon_vma with a different root anon_vma, we'll have to
hold both, the folio lock and the anon_vma lock in write mode. 
Consequently, whenever we succeeded in folio_lock_anon_vma_read() to
read-lock the anon_vma, we have to re-check if the mapping was changed in
the meantime.  If that was the case, we have to retry.

Note that folio_move_anon_rmap() must only be called if the anon page is
exclusive to a process, and must not be called on KSM folios.

This is a preparation for UFFDIO_MOVE, which will hold the folio lock, the
anon_vma lock in write mode, and the mmap_lock in read mode.

Link: https://lkml.kernel.org/r/20231121171643.3719880-1-surenb@google.com
Link: https://lkml.kernel.org/r/20231121171643.3719880-2-surenb@google.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>,
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Nicolas Geoffray <ngeoffray@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: ZhangPeng <zhangpeng362@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/mm/rmap.c~mm-rmap-support-move-to-different-root-anon_vma-in-folio_move_anon_rmap
+++ a/mm/rmap.c
@@ -542,6 +542,7 @@ struct anon_vma *folio_lock_anon_vma_rea
 	struct anon_vma *root_anon_vma;
 	unsigned long anon_mapping;
 
+retry:
 	rcu_read_lock();
 	anon_mapping = (unsigned long)READ_ONCE(folio->mapping);
 	if ((anon_mapping & PAGE_MAPPING_FLAGS) != PAGE_MAPPING_ANON)
@@ -553,6 +554,17 @@ struct anon_vma *folio_lock_anon_vma_rea
 	root_anon_vma = READ_ONCE(anon_vma->root);
 	if (down_read_trylock(&root_anon_vma->rwsem)) {
 		/*
+		 * folio_move_anon_rmap() might have changed the anon_vma as we
+		 * might not hold the folio lock here.
+		 */
+		if (unlikely((unsigned long)READ_ONCE(folio->mapping) !=
+			     anon_mapping)) {
+			up_read(&root_anon_vma->rwsem);
+			rcu_read_unlock();
+			goto retry;
+		}
+
+		/*
 		 * If the folio is still mapped, then this anon_vma is still
 		 * its anon_vma, and holding the mutex ensures that it will
 		 * not go away, see anon_vma_free().
@@ -586,6 +598,18 @@ struct anon_vma *folio_lock_anon_vma_rea
 	rcu_read_unlock();
 	anon_vma_lock_read(anon_vma);
 
+	/*
+	 * folio_move_anon_rmap() might have changed the anon_vma as we might
+	 * not hold the folio lock here.
+	 */
+	if (unlikely((unsigned long)READ_ONCE(folio->mapping) !=
+		     anon_mapping)) {
+		anon_vma_unlock_read(anon_vma);
+		put_anon_vma(anon_vma);
+		anon_vma = NULL;
+		goto retry;
+	}
+
 	if (atomic_dec_and_test(&anon_vma->refcount)) {
 		/*
 		 * Oops, we held the last refcount, release the lock
_

Patches currently in -mm which might be from aarcange@redhat.com are

mm-rmap-support-move-to-different-root-anon_vma-in-folio_move_anon_rmap.patch
userfaultfd-uffdio_move-uabi.patch

