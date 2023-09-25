Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E65BCE7A8C
	for <mm-commits@archiver.kernel.org>; Mon, 25 Sep 2023 15:37:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbjIYPhe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Sep 2023 11:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjIYPhe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Sep 2023 11:37:34 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 241A9FF
        for <mm-commits@vger.kernel.org>; Mon, 25 Sep 2023 08:37:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D80C433C8;
        Mon, 25 Sep 2023 15:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695656244;
        bh=enZEAaGLEahP6OHXjfdfUir9CvGPuEI68n7SCxRHptY=;
        h=Date:To:From:Subject:From;
        b=skMWw/I414pNZuC/IA6NZF933dwoKxEyvzqQJGvlbHRug6fRDS4eCWaWfMgerYBbA
         Xql3yeCYHx9QC+zf+4iGnWScoCUPiZ0pBrIyP9UZN2Lc/vBEglrD2OT74Rik4ybQ0O
         J1spwfV69dhwFVBUlNvXw/3TEeglUQI/GMzdKrIg=
Date:   Mon, 25 Sep 2023 08:37:24 -0700
To:     mm-commits@vger.kernel.org, zhangpeng362@huawei.com,
        willy@infradead.org, viro@zeniv.linux.org.uk, surenb@google.com,
        shuah@kernel.org, rppt@kernel.org, peterx@redhat.com,
        ngeoffray@google.com, mhocko@suse.com, lokeshgidra@google.com,
        Liam.Howlett@oracle.com, kaleshsingh@google.com, jannh@google.com,
        hughd@google.com, david@redhat.com, brauner@kernel.org,
        bgeffon@google.com, axelrasmussen@google.com, aarcange@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-uffdio_remap-rmap-preparation.patch added to mm-unstable branch
Message-Id: <20230925153724.B2D80C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: UFFDIO_REMAP: rmap preparation
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-uffdio_remap-rmap-preparation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-uffdio_remap-rmap-preparation.patch

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
Subject: userfaultfd: UFFDIO_REMAP: rmap preparation
Date: Fri, 22 Sep 2023 18:31:44 -0700

Patch series "userfaultfd remap option", v2.

This patch series introduces UFFDIO_REMAP feature to userfaultfd, which
has long been implemented and maintained by Andrea in his local tree [1],
but was not upstreamed due to lack of use cases where this approach would
be better than allocating a new page and copying the contents.

UFFDIO_COPY performs ~20% better than UFFDIO_REMAP when the application
needs pages to be allocated [2]. However, with UFFDIO_REMAP, if pages are
available (in userspace) for recycling, as is usually the case in heap
compaction algorithms, then we can avoid the page allocation and memcpy
(done by UFFDIO_COPY). Also, since the pages are recycled in the
userspace, we avoid the need to release (via madvise) the pages back to
the kernel [3].

We see over 40% reduction (on a Google pixel 6 device) in the compacting
thread's completion time by using UFFDIO_REMAP vs.  UFFDIO_COPY.  This was
measured using a benchmark that emulates a heap compaction implementation
using userfaultfd (to allow concurrent accesses by application threads). 
More details of the usecase are explained in [3].

Furthermore, UFFDIO_REMAP enables remapping swapped-out pages without
touching them within the same vma. Today, it can only be done by mremap,
however it forces splitting the vma.


This patch (of 3):

As far as the rmap code is concerned, UFFDIO_REMAP only alters the
page->mapping and page->index.  It does it while holding the page lock. 
However folio_referenced() is doing rmap walks without taking the folio
lock first, so folio_lock_anon_vma_read() must be updated to re-check that
the folio->mapping didn't change after we obtained the anon_vma read lock.

UFFDIO_REMAP takes the anon_vma lock for writing before altering the
folio->mapping, so if the folio->mapping is still the same after obtaining
the anon_vma read lock (without the folio lock), the rmap walks can go
ahead safely (and UFFDIO_REMAP will wait the rmap walk to complete before
proceeding).

UFFDIO_REMAP serializes against itself with the folio lock.

All other places taking the anon_vma lock while holding the mmap_lock for
writing, don't need to check if the folio->mapping has changed after
taking the anon_vma lock, regardless of the folio lock, because
UFFDIO_REMAP holds the mmap_lock for reading.

There's one constraint enforced to allow this simplification: the source
pages passed to UFFDIO_REMAP must be mapped only in one vma, but this
constraint is an acceptable tradeoff for UFFDIO_REMAP users.

The source addresses passed to UFFDIO_REMAP can be set as VM_DONTCOPY with
MADV_DONTFORK to avoid any risk of the mapcount of the pages increasing if
some thread of the process forks() before UFFDIO_REMAP run.

Link: https://lkml.kernel.org/r/20230923013148.1390521-1-surenb@google.com
Link: https://lkml.kernel.org/r/20230923013148.1390521-2-surenb@google.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Nicolas Geoffray <ngeoffray@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: ZhangPeng <zhangpeng362@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/mm/rmap.c~userfaultfd-uffdio_remap-rmap-preparation
+++ a/mm/rmap.c
@@ -542,6 +542,7 @@ struct anon_vma *folio_lock_anon_vma_rea
 	struct anon_vma *root_anon_vma;
 	unsigned long anon_mapping;
 
+repeat:
 	rcu_read_lock();
 	anon_mapping = (unsigned long)READ_ONCE(folio->mapping);
 	if ((anon_mapping & PAGE_MAPPING_FLAGS) != PAGE_MAPPING_ANON)
@@ -586,6 +587,18 @@ struct anon_vma *folio_lock_anon_vma_rea
 	rcu_read_unlock();
 	anon_vma_lock_read(anon_vma);
 
+	/*
+	 * Check if UFFDIO_REMAP changed the anon_vma. This is needed
+	 * because we don't assume the folio was locked.
+	 */
+	if (unlikely((unsigned long) READ_ONCE(folio->mapping) !=
+		     anon_mapping)) {
+		anon_vma_unlock_read(anon_vma);
+		put_anon_vma(anon_vma);
+		anon_vma = NULL;
+		goto repeat;
+	}
+
 	if (atomic_dec_and_test(&anon_vma->refcount)) {
 		/*
 		 * Oops, we held the last refcount, release the lock
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-uffdio_remap-rmap-preparation.patch
userfaultfd-uffdio_remap-uabi.patch

