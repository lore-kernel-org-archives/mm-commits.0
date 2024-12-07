Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED3E51C5A
	for <mm-commits@vger.kernel.org>; Sat,  7 Dec 2024 04:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733545774; cv=none; b=TJWmjwqV8iycNMj9cyR4OKGaT5G+YRj01Iu5M9YGwhHhabpJ+8qaSCEWpyEOxrjs1mT4UM981afR3VAgxwzVtHKUvm9VBAdVdB9H66mBneowXIsePwyggj/TpzDUihj+U7P139kNIRwdQV1hOQjS3mQLOUEGdJ0ncNyQeNx4oY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733545774; c=relaxed/simple;
	bh=NzBBdqm3Zr8PRUu93FcnsbfAqSXcUKMOY+KP39Se8JI=;
	h=Date:To:From:Subject:Message-Id; b=eJRlcVUkUugTBu1pGUYFLJZfsg0i3aEcvRk5Chx6pF2Nr4mrlUvvb1OSpdTA1TQqiP+rcnq4NjvHPzixfmW8wjwBJtAzlQJ7Y3EdCR+YmMf4W8WW+hsFHnaAHtO8G1tREC6/k76XIrAyITbuUOG4Af5yvo4CNI+8sS1m4qRaPiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EKi30yZ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EKi30yZ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60915C4CECD;
	Sat,  7 Dec 2024 04:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733545774;
	bh=NzBBdqm3Zr8PRUu93FcnsbfAqSXcUKMOY+KP39Se8JI=;
	h=Date:To:From:Subject:From;
	b=EKi30yZ64kApOqA7+L5alFh237eJr8eZNHbibWPWqTJ41KCi/dAbSwODo9ViYr1bz
	 KSyPdVRUkrfC0hWXyqIKdFOejlJPQplY0DyymKLN3QM4xPqxVu4YkeJWawTpyrm3Va
	 lCd/68mU7oxe9vlvw+rLSMNa8DWi/8FOT7UacGl8=
Date: Fri, 06 Dec 2024 20:29:33 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,souravpanda@google.com,shakeel.butt@linux.dev,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jannh@google.com,hughd@google.com,hdanton@sina.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-document-latest-changes-to-vm_lock.patch added to mm-unstable branch
Message-Id: <20241207042934.60915C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs/mm: document latest changes to vm_lock
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-document-latest-changes-to-vm_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-document-latest-changes-to-vm_lock.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: docs/mm: document latest changes to vm_lock
Date: Fri, 6 Dec 2024 14:52:03 -0800

Change the documentation to reflect that vm_lock is integrated into vma. 
Document newly introduced vma_start_read_locked{_nested} functions.

Link: https://lkml.kernel.org/r/20241206225204.4008261-7-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/process_addrs.rst |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/Documentation/mm/process_addrs.rst~docs-mm-document-latest-changes-to-vm_lock
+++ a/Documentation/mm/process_addrs.rst
@@ -716,7 +716,11 @@ calls :c:func:`!rcu_read_lock` to ensure
 critical section, then attempts to VMA lock it via :c:func:`!vma_start_read`,
 before releasing the RCU lock via :c:func:`!rcu_read_unlock`.
 
-VMA read locks hold the read lock on the :c:member:`!vma->vm_lock` semaphore for
+In cases when the user already holds mmap read lock, :c:func:`!vma_start_read_locked`
+and :c:func:`!vma_start_read_locked_nested` can be used. These functions always
+succeed in acquiring VMA read lock.
+
+VMA read locks hold the read lock on the :c:member:`!vma.vm_lock` semaphore for
 their duration and the caller of :c:func:`!lock_vma_under_rcu` must release it
 via :c:func:`!vma_end_read`.
 
@@ -780,7 +784,7 @@ keep VMAs locked across entirely separat
 correct lock ordering.
 
 Each time a VMA read lock is acquired, we acquire a read lock on the
-:c:member:`!vma->vm_lock` read/write semaphore and hold it, while checking that
+:c:member:`!vma.vm_lock` read/write semaphore and hold it, while checking that
 the sequence count of the VMA does not match that of the mm.
 
 If it does, the read lock fails. If it does not, we hold the lock, excluding
@@ -790,7 +794,7 @@ Importantly, maple tree operations perfo
 are also RCU safe, so the whole read lock operation is guaranteed to function
 correctly.
 
-On the write side, we acquire a write lock on the :c:member:`!vma->vm_lock`
+On the write side, we acquire a write lock on the :c:member:`!vma.vm_lock`
 read/write semaphore, before setting the VMA's sequence number under this lock,
 also simultaneously holding the mmap write lock.
 
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-fix-module-allocation-tags-populated-area-calculation.patch
alloc_tag-fix-set_codetag_empty-when-config_mem_alloc_profiling_debug.patch
seqlock-add-raw_seqcount_try_begin.patch
mm-convert-mm_lock_seq-to-a-proper-seqcount.patch
mm-introduce-mmap_lock_speculate_try_beginretry.patch
mm-introduce-vma_start_read_locked_nested-helpers.patch
mm-move-per-vma-lock-into-vm_area_struct.patch
mm-mark-vma-as-detached-until-its-added-into-vma-tree.patch
mm-make-vma-cache-slab_typesafe_by_rcu.patch
mm-slab-allow-freeptr_offset-to-be-used-with-ctor.patch
docs-mm-document-latest-changes-to-vm_lock.patch

