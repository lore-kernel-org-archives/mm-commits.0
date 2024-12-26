Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDD014E2E2
	for <mm-commits@vger.kernel.org>; Thu, 26 Dec 2024 21:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735247791; cv=none; b=bd0+dBhqOrzqrMVlwE7i5VRGIusRH9t/r1upoNKyMhfUW6IH1dYYWIEk3cmgYg/ODhykYcWLkeL4vIOWpJOYO8fD7b4CsXNvR8mXJjm/AmTMQqSRZw2yyE5U37ihdh2xZ2LBP1BQaSWIiHf7rpRPRzdG7+ZywYcZRkTHqn2Xb0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735247791; c=relaxed/simple;
	bh=3kdTsl9PEePBwDZyM8rlFZ9/yxJf6HOkv8lCX6Sd8t0=;
	h=Date:To:From:Subject:Message-Id; b=JpMwz2GpQiAnXi9AbIcF7OFY5+t46v0TwMW27MQtKNPn3HHx3m7hCwspFQ0gOuNXHYJI2o9qIAO44nacdEtuFBz3nLpnaC/nV+dKK9H88vTJfUSAF6KWkhFP1OZ/NBsq9iq5h+RUihICCjavtPa4iOQZjzVObtDUXKP5QdDW7Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tOKiQDtj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tOKiQDtj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A253C4CED1;
	Thu, 26 Dec 2024 21:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735247791;
	bh=3kdTsl9PEePBwDZyM8rlFZ9/yxJf6HOkv8lCX6Sd8t0=;
	h=Date:To:From:Subject:From;
	b=tOKiQDtjnOnmnF2HQwrWYv8An0mvCwoCgaCSw+Izr4iWCfOvs0UlKSmZEIeuOevjq
	 t3HKnBDpMZm0a51R/7fJR3VGRL1r4n+eo8HohQ+/8cSGp7yFgqEsWGyyrUR/xyMzun
	 5eWe0whzJOYf6byJ1hbiUkNsqEo0+hyHzhkIumbc=
Date: Thu, 26 Dec 2024 13:16:30 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,souravpanda@google.com,shakeel.butt@linux.dev,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oliver.sang@intel.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@Oracle.com,klarasmodin@gmail.com,jannh@google.com,hughd@google.com,hdanton@sina.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-document-latest-changes-to-vm_lock.patch added to mm-unstable branch
Message-Id: <20241226211631.7A253C4CED1@smtp.kernel.org>
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
Date: Thu, 26 Dec 2024 09:07:09 -0800

Change the documentation to reflect that vm_lock is integrated into vma
and replaced with vm_refcnt.

Document newly introduced vma_start_read_locked{_nested} functions.

Link: https://lkml.kernel.org/r/20241226170710.1159679-18-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/process_addrs.rst |   46 +++++++++++++++------------
 1 file changed, 27 insertions(+), 19 deletions(-)

--- a/Documentation/mm/process_addrs.rst~docs-mm-document-latest-changes-to-vm_lock
+++ a/Documentation/mm/process_addrs.rst
@@ -716,9 +716,14 @@ calls :c:func:`!rcu_read_lock` to ensure
 critical section, then attempts to VMA lock it via :c:func:`!vma_start_read`,
 before releasing the RCU lock via :c:func:`!rcu_read_unlock`.
 
-VMA read locks hold the read lock on the :c:member:`!vma->vm_lock` semaphore for
-their duration and the caller of :c:func:`!lock_vma_under_rcu` must release it
-via :c:func:`!vma_end_read`.
+In cases when the user already holds mmap read lock, :c:func:`!vma_start_read_locked`
+and :c:func:`!vma_start_read_locked_nested` can be used. These functions do not
+fail due to lock contention but the caller should still check their return values
+in case they fail for other reasons.
+
+VMA read locks increment :c:member:`!vma.vm_refcnt` reference counter for their
+duration and the caller of :c:func:`!lock_vma_under_rcu` must drop it via
+:c:func:`!vma_end_read`.
 
 VMA **write** locks are acquired via :c:func:`!vma_start_write` in instances where a
 VMA is about to be modified, unlike :c:func:`!vma_start_read` the lock is always
@@ -726,9 +731,9 @@ acquired. An mmap write lock **must** be
 lock, releasing or downgrading the mmap write lock also releases the VMA write
 lock so there is no :c:func:`!vma_end_write` function.
 
-Note that a semaphore write lock is not held across a VMA lock. Rather, a
-sequence number is used for serialisation, and the write semaphore is only
-acquired at the point of write lock to update this.
+Note that when write-locking a VMA lock, the :c:member:`!vma.vm_refcnt` is temporarily
+modified so that readers can detect the presense of a writer. The reference counter is
+restored once the vma sequence number used for serialisation is updated.
 
 This ensures the semantics we require - VMA write locks provide exclusive write
 access to the VMA.
@@ -738,7 +743,7 @@ Implementation details
 
 The VMA lock mechanism is designed to be a lightweight means of avoiding the use
 of the heavily contended mmap lock. It is implemented using a combination of a
-read/write semaphore and sequence numbers belonging to the containing
+reference counter and sequence numbers belonging to the containing
 :c:struct:`!struct mm_struct` and the VMA.
 
 Read locks are acquired via :c:func:`!vma_start_read`, which is an optimistic
@@ -779,28 +784,31 @@ release of any VMA locks on its release
 keep VMAs locked across entirely separate write operations. It also maintains
 correct lock ordering.
 
-Each time a VMA read lock is acquired, we acquire a read lock on the
-:c:member:`!vma->vm_lock` read/write semaphore and hold it, while checking that
-the sequence count of the VMA does not match that of the mm.
-
-If it does, the read lock fails. If it does not, we hold the lock, excluding
-writers, but permitting other readers, who will also obtain this lock under RCU.
+Each time a VMA read lock is acquired, we increment :c:member:`!vma.vm_refcnt`
+reference counter and check that the sequence count of the VMA does not match
+that of the mm.
+
+If it does, the read lock fails and :c:member:`!vma.vm_refcnt` is dropped.
+If it does not, we keep the reference counter raised, excluding writers, but
+permitting other readers, who can also obtain this lock under RCU.
 
 Importantly, maple tree operations performed in :c:func:`!lock_vma_under_rcu`
 are also RCU safe, so the whole read lock operation is guaranteed to function
 correctly.
 
-On the write side, we acquire a write lock on the :c:member:`!vma->vm_lock`
-read/write semaphore, before setting the VMA's sequence number under this lock,
-also simultaneously holding the mmap write lock.
+On the write side, we set a bit in :c:member:`!vma.vm_refcnt` which can't be
+modified by readers and wait for all readers to drop their reference count.
+Once there are no readers, VMA's sequence number is set to match that of the
+mm. During this entire operation mmap write lock is held.
 
 This way, if any read locks are in effect, :c:func:`!vma_start_write` will sleep
 until these are finished and mutual exclusion is achieved.
 
-After setting the VMA's sequence number, the lock is released, avoiding
-complexity with a long-term held write lock.
+After setting the VMA's sequence number, the bit in :c:member:`!vma.vm_refcnt`
+indicating a writer is cleared. From this point on, VMA's sequence number will
+indicate VMA's write-locked state until mmap write lock is dropped or downgraded.
 
-This clever combination of a read/write semaphore and sequence count allows for
+This clever combination of a reference counter and sequence count allows for
 fast RCU-based per-VMA lock acquisition (especially on page fault, though
 utilised elsewhere) with minimal complexity around lock ordering.
 
_

Patches currently in -mm which might be from surenb@google.com are

seqlock-add-raw_seqcount_try_begin.patch
mm-convert-mm_lock_seq-to-a-proper-seqcount.patch
mm-introduce-mmap_lock_speculate_try_beginretry.patch
mm-introduce-vma_start_read_locked_nested-helpers.patch
mm-move-per-vma-lock-into-vm_area_struct.patch
mm-mark-vma-as-detached-until-its-added-into-vma-tree.patch
mm-modify-vma_iter_store_gfp-to-indicate-if-its-storing-a-new-vma.patch
mm-mark-vmas-detached-upon-exit.patch
mm-nommu-fix-the-last-places-where-vma-is-not-locked-before-being-attached.patch
types-move-struct-rcuwait-into-typesh.patch
mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail.patch
mm-move-mmap_init_lock-out-of-the-header-file.patch
mm-uninline-the-main-body-of-vma_start_write.patch
refcount-introduce-__refcount_addinc_not_zero_limited.patch
mm-replace-vm_lock-and-detached-flag-with-a-reference-count.patch
mm-debug-print-vm_refcnt-state-when-dumping-the-vma.patch
mm-debug-print-vm_refcnt-state-when-dumping-the-vma-fix.patch
mm-remove-extra-vma_numab_state_init-call.patch
mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility.patch
mm-make-vma-cache-slab_typesafe_by_rcu.patch
docs-mm-document-latest-changes-to-vm_lock.patch

