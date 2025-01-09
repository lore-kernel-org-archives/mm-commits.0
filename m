Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E31C143888
	for <mm-commits@vger.kernel.org>; Thu,  9 Jan 2025 05:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736401491; cv=none; b=UUAx1TFPWvFzYrxhxphNkVBxQgZsGT7zAsG+j1Kr5dnv4bFrNK9wG2zCNq2k2HlFjQD7rHCRHZ8HgEgP79W+mANRzVfVgmDpelj/EWGGlUS64QXojWpws1I8mL/OLF608vMOBThPVtEEVPBcp+Uooghzs6RKAKwjE1lvctT17fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736401491; c=relaxed/simple;
	bh=jazjWD5DQt6MiHMr03ZPz/BYqn0GeFhl33Kcv0VrSjc=;
	h=Date:To:From:Subject:Message-Id; b=ksuHOoizsUVjCcox6uecOUN9lXw9xWO2tcVOrD51NapCkaOIetmDG53WwazcZ9lkDIF4U5Tz+fz2+oVEDzsuQti8FECR/kkwdh/ibVU5j4lq+9GGbNm/9RQXgLTTzlHL6UGjUxLPFZIavO9zATo3A9F944MFQ5hXJD6v+AdyaEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WvdS/fgA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WvdS/fgA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BFDDC4CED2;
	Thu,  9 Jan 2025 05:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736401491;
	bh=jazjWD5DQt6MiHMr03ZPz/BYqn0GeFhl33Kcv0VrSjc=;
	h=Date:To:From:Subject:From;
	b=WvdS/fgAWSjVeQyTk1Jo5gEW1dF2E2aKW6PSyif5b9mIPNkA0cqnaSxZS5Cp5/+/i
	 g+emp7BJ90SUnSkR479y2RU9w6T2dN/nJJELeqoXlPRLNV8QJGGdXD400AzyEhaKff
	 d3plIU1A4/57DA672YT1qCBWCJ9+gxJvrqep8ngc=
Date: Wed, 08 Jan 2025 21:44:50 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,souravpanda@google.com,shakeel.butt@linux.dev,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@Oracle.com,klarasmodin@gmail.com,jannh@google.com,hughd@google.com,hdanton@sina.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility.patch added to mm-unstable branch
Message-Id: <20250109054451.0BFDDC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: prepare lock_vma_under_rcu() for vma reuse possibility
has been added to the -mm mm-unstable branch.  Its filename is
     mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility.patch

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
Subject: mm: prepare lock_vma_under_rcu() for vma reuse possibility
Date: Wed, 8 Jan 2025 18:30:23 -0800

Once we make vma cache SLAB_TYPESAFE_BY_RCU, it will be possible for a vma
to be reused and attached to another mm after lock_vma_under_rcu() locks
the vma.  lock_vma_under_rcu() should ensure that vma_start_read() is
using the original mm and after locking the vma it should ensure that
vma->vm_mm has not changed from under us.

Link: https://lkml.kernel.org/r/20250109023025.2242447-15-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
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
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   10 ++++++----
 mm/memory.c        |    7 ++++---
 2 files changed, 10 insertions(+), 7 deletions(-)

--- a/include/linux/mm.h~mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility
+++ a/include/linux/mm.h
@@ -737,8 +737,10 @@ static inline void vma_refcount_put(stru
  * Try to read-lock a vma. The function is allowed to occasionally yield false
  * locked result to avoid performance overhead, in which case we fall back to
  * using mmap_lock. The function should never yield false unlocked result.
+ * False locked result is possible if mm_lock_seq overflows or if vma gets
+ * reused and attached to a different mm before we lock it.
  */
-static inline bool vma_start_read(struct vm_area_struct *vma)
+static inline bool vma_start_read(struct mm_struct *mm, struct vm_area_struct *vma)
 {
 	int oldcnt;
 
@@ -749,7 +751,7 @@ static inline bool vma_start_read(struct
 	 * we don't rely on for anything - the mm_lock_seq read against which we
 	 * need ordering is below.
 	 */
-	if (READ_ONCE(vma->vm_lock_seq) == READ_ONCE(vma->vm_mm->mm_lock_seq.sequence))
+	if (READ_ONCE(vma->vm_lock_seq) == READ_ONCE(mm->mm_lock_seq.sequence))
 		return false;
 
 	/*
@@ -772,7 +774,7 @@ static inline bool vma_start_read(struct
 	 * after it has been unlocked.
 	 * This pairs with RELEASE semantics in vma_end_write_all().
 	 */
-	if (unlikely(vma->vm_lock_seq == raw_read_seqcount(&vma->vm_mm->mm_lock_seq))) {
+	if (unlikely(vma->vm_lock_seq == raw_read_seqcount(&mm->mm_lock_seq))) {
 		vma_refcount_put(vma);
 		return false;
 	}
@@ -906,7 +908,7 @@ struct vm_area_struct *lock_vma_under_rc
 #else /* CONFIG_PER_VMA_LOCK */
 
 static inline void vma_lock_init(struct vm_area_struct *vma, bool reset_refcnt) {}
-static inline bool vma_start_read(struct vm_area_struct *vma)
+static inline bool vma_start_read(struct mm_struct *mm, struct vm_area_struct *vma)
 		{ return false; }
 static inline void vma_end_read(struct vm_area_struct *vma) {}
 static inline void vma_start_write(struct vm_area_struct *vma) {}
--- a/mm/memory.c~mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility
+++ a/mm/memory.c
@@ -6423,7 +6423,7 @@ struct vm_area_struct *lock_vma_under_rc
 	if (!vma)
 		goto inval;
 
-	if (!vma_start_read(vma))
+	if (!vma_start_read(mm, vma))
 		goto inval;
 
 	/*
@@ -6433,8 +6433,9 @@ struct vm_area_struct *lock_vma_under_rc
 	 * fields are accessible for RCU readers.
 	 */
 
-	/* Check since vm_start/vm_end might change before we lock the VMA */
-	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
+	/* Check if the vma we locked is the right one. */
+	if (unlikely(vma->vm_mm != mm ||
+		     address < vma->vm_start || address >= vma->vm_end))
 		goto inval_end_read;
 
 	rcu_read_unlock();
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-skip-pgalloc_tag_swap-if-profiling-is-disabled.patch
tools-fix-atomic_set-definition-to-set-the-value-correctly.patch
seqlock-add-raw_seqcount_try_begin.patch
mm-convert-mm_lock_seq-to-a-proper-seqcount.patch
mm-introduce-mmap_lock_speculate_try_beginretry.patch
mm-introduce-vma_start_read_locked_nested-helpers.patch
mm-move-per-vma-lock-into-vm_area_struct.patch
mm-mark-vma-as-detached-until-its-added-into-vma-tree.patch
mm-introduce-vma_iter_store_attached-to-use-with-attached-vmas.patch
mm-mark-vmas-detached-upon-exit.patch
types-move-struct-rcuwait-into-typesh.patch
mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail.patch
mm-move-mmap_init_lock-out-of-the-header-file.patch
mm-uninline-the-main-body-of-vma_start_write.patch
refcount-introduce-__refcount_addinc_not_zero_limited.patch
mm-replace-vm_lock-and-detached-flag-with-a-reference-count.patch
mm-debug-print-vm_refcnt-state-when-dumping-the-vma.patch
mm-remove-extra-vma_numab_state_init-call.patch
mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility.patch
mm-make-vma-cache-slab_typesafe_by_rcu.patch
docs-mm-document-latest-changes-to-vm_lock.patch
alloc_tag-avoid-current-alloc_tag-manipulations-when-profiling-is-disabled.patch

