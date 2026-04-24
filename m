Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E05203710
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 09:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777023202; cv=none; b=cZwmbKM3588Fw3tIC8XukUvk6iMPeKyaLsO2/+L+kQs25PJo2xg3fKyrAEiJOuRyPtdJ9PEIM0+Kyi5My4kJignblh21EUAR50iEG7yss3hy2EDgu2TXQaKFNjsakBbAfZn1SRBIMNWItVuOejN+KXL4BrgDe80CkNyBHzeuxLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777023202; c=relaxed/simple;
	bh=7jeb2lOEmMRogDLIl3xVFgZuAIv4+p1hliYq01oEHnk=;
	h=Date:To:From:Subject:Message-Id; b=hqa5DqvV9+U6klUi6GpQ10uDr9vXxQQC6zBETjS5ygMUKMm8Cqk9wFTs1x3bY1eWeFtfczgesTQb2WB904DyknY+VWVK8+IcerOQ1EKbitC3vzxXS8EudpbnBNFqClyWks1cq6ExwoS2aGr0iv7sCqmdHe+++iAzdID7bFlXNKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aisYsyoU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aisYsyoU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA7BC19425;
	Fri, 24 Apr 2026 09:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777023202;
	bh=7jeb2lOEmMRogDLIl3xVFgZuAIv4+p1hliYq01oEHnk=;
	h=Date:To:From:Subject:From;
	b=aisYsyoUic+Dq6F/aWR80BRCjEGNv/Vw7GiYt1n7sI6PcafEE1eWGNf48ArKj962Y
	 K6wYF9Zq5BYPpgh+7l5bDXAHuwQ3XKnYbwrr1EZJaqDLPFWNAkIwOpbyxRim23DJPS
	 k25TYYxnAv/1D2FqcJJ3FizEQ6fmpJWSGFqLRvBQ=
Date: Fri, 24 Apr 2026 02:33:21 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,adi.sharma@zohomail.in,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-update-stale-locking-comments-for-fault-handlers.patch added to mm-new branch
Message-Id: <20260424093321.EBA7BC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: update stale locking comments for fault handlers
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-update-stale-locking-comments-for-fault-handlers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-update-stale-locking-comments-for-fault-handlers.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Aditya Sharma <adi.sharma@zohomail.in>
Subject: mm/memory: update stale locking comments for fault handlers
Date: Fri, 24 Apr 2026 14:52:17 +0530

Update the comments for wp_page_copy(), do_wp_page(), do_swap_page(),
do_anonymous_page(), __do_fault(), do_fault(), handle_pte_fault(),
__handle_mm_fault(), and handle_mm_fault() to concisely clarify that they
can be entered holding either the mmap_lock or the VMA lock, and that the
lock may be released upon returning VM_FAULT_RETRY.

Additionally, make the following corrections:
- In do_anonymous_page(), correct the outdated claim that the function
  is entered with the PTE "mapped but not yet locked". Since
  handle_pte_fault() unmaps the empty PTE before routing to
  do_pte_missing(), the comment now correctly states it is entered
  with the PTE unmapped and unlocked.
- In __do_fault(), update the stale reference from __lock_page_retry()
  to __folio_lock_or_retry().

Link: https://lore.kernel.org/20260424092217.263648-1-adi.sharma@zohomail.in
Signed-off-by: Aditya Sharma <adi.sharma@zohomail.in>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   55 ++++++++++++++++++++++++++------------------------
 1 file changed, 29 insertions(+), 26 deletions(-)

--- a/mm/memory.c~mm-memory-update-stale-locking-comments-for-fault-handlers
+++ a/mm/memory.c
@@ -3821,8 +3821,8 @@ vm_fault_t __vmf_anon_prepare(struct vm_
  * Handle the case of a page which we actually need to copy to a new page,
  * either due to COW or unsharing.
  *
- * Called with mmap_lock locked and the old page referenced, but
- * without the ptl held.
+ * Called with either the VMA lock or the mmap_lock held (see FAULT_FLAG_VMA_LOCK)
+ * and the old page referenced, but without the ptl held.
  *
  * High level logic flow:
  *
@@ -4221,9 +4221,9 @@ static bool wp_can_reuse_anon_folio(stru
  * though the page will change only once the write actually happens. This
  * avoids a few races, and potentially makes it more efficient.
  *
- * We enter with non-exclusive mmap_lock (to exclude vma changes,
- * but allow concurrent faults), with pte both mapped and locked.
- * We return with mmap_lock still held, but pte unmapped and unlocked.
+ * We enter with either the VMA lock or the mmap_lock held (see
+ * FAULT_FLAG_VMA_LOCK) and pte both mapped and locked. We return with
+ * the same lock still held, but pte unmapped and unlocked.
  */
 static vm_fault_t do_wp_page(struct vm_fault *vmf)
 	__releases(vmf->ptl)
@@ -4769,12 +4769,12 @@ static void check_swap_exclusive(struct
 }
 
 /*
- * We enter with non-exclusive mmap_lock (to exclude vma changes,
- * but allow concurrent faults), and pte mapped but not yet locked.
+ * We enter with either the VMA lock or the mmap_lock held (see
+ * FAULT_FLAG_VMA_LOCK), and pte mapped but not yet locked.
  * We return with pte unmapped and unlocked.
  *
- * We return with the mmap_lock locked or unlocked in the same cases
- * as does filemap_fault().
+ * When returning, the lock may have been released in the same cases
+ * as done by filemap_fault().
  */
 vm_fault_t do_swap_page(struct vm_fault *vmf)
 {
@@ -5314,9 +5314,10 @@ static void map_anon_folio_pte_pf(struct
 }
 
 /*
- * We enter with non-exclusive mmap_lock (to exclude vma changes,
- * but allow concurrent faults), and pte mapped but not yet locked.
- * We return with mmap_lock still held, but pte unmapped and unlocked.
+ * We enter with either the VMA lock or the mmap_lock held (see
+ * FAULT_FLAG_VMA_LOCK), and pte unmapped and unlocked.
+ * We return with the lock still held, but pte unmapped and unlocked.
+ * If VM_FAULT_RETRY is returned, the lock may have been released.
  */
 static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 {
@@ -5424,9 +5425,10 @@ oom:
 }
 
 /*
- * The mmap_lock must have been held on entry, and may have been
- * released depending on flags and vma->vm_ops->fault() return value.
- * See filemap_fault() and __lock_page_retry().
+ * Either the VMA lock or the mmap_lock must have been held on entry
+ * (see FAULT_FLAG_VMA_LOCK) and may have been released depending on
+ * flags and vma->vm_ops->fault() return value.
+ * See filemap_fault() and __folio_lock_or_retry().
  */
 static vm_fault_t __do_fault(struct vm_fault *vmf)
 {
@@ -5987,11 +5989,11 @@ static vm_fault_t do_shared_fault(struct
 }
 
 /*
- * We enter with non-exclusive mmap_lock (to exclude vma changes,
- * but allow concurrent faults).
- * The mmap_lock may have been released depending on flags and our
+ * We enter with either the VMA lock or the mmap_lock held (see
+ * FAULT_FLAG_VMA_LOCK).
+ * The lock may have been released depending on flags and our
  * return value.  See filemap_fault() and __folio_lock_or_retry().
- * If mmap_lock is released, vma may become invalid (for example
+ * If the lock is released, vma may become invalid (for example
  * by other thread calling munmap()).
  */
 static vm_fault_t do_fault(struct vm_fault *vmf)
@@ -6358,10 +6360,11 @@ static void fix_spurious_fault(struct vm
  * with external mmu caches can use to update those (ie the Sparc or
  * PowerPC hashed page tables that act as extended TLBs).
  *
- * We enter with non-exclusive mmap_lock (to exclude vma changes, but allow
- * concurrent faults).
+ * On entry, we hold either the VMA lock or the mmap_lock
+ * (see FAULT_FLAG_VMA_LOCK).
  *
- * The mmap_lock may have been released depending on flags and our return value.
+ * The mmap_lock or VMA lock may have been released depending on flags
+ * and our return value.
  * See filemap_fault() and __folio_lock_or_retry().
  */
 static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
@@ -6442,8 +6445,8 @@ unlock:
 
 /*
  * On entry, we hold either the VMA lock or the mmap_lock
- * (FAULT_FLAG_VMA_LOCK tells you which).  If VM_FAULT_RETRY is set in
- * the result, the mmap_lock is not held on exit.  See filemap_fault()
+ * (see FAULT_FLAG_VMA_LOCK).  If VM_FAULT_RETRY is set in
+ * the result, the lock is not held on exit.  See filemap_fault()
  * and __folio_lock_or_retry().
  */
 static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
@@ -6675,9 +6678,9 @@ static vm_fault_t sanitize_fault_flags(s
 
 /*
  * By the time we get here, we already hold either the VMA lock or the
- * mmap_lock (FAULT_FLAG_VMA_LOCK tells you which).
+ * mmap_lock (see FAULT_FLAG_VMA_LOCK).
  *
- * The mmap_lock may have been released depending on flags and our
+ * The lock may have been released depending on flags and our
  * return value.  See filemap_fault() and __folio_lock_or_retry().
  */
 vm_fault_t handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
_

Patches currently in -mm which might be from adi.sharma@zohomail.in are

mm-memory-update-stale-locking-comments-for-fault-handlers.patch

