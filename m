Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF77524A06A
	for <mm-commits@vger.kernel.org>; Mon, 26 Jan 2026 18:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769452674; cv=none; b=g7LJHOenHjGZptfttJQCvSSzcGWCDkvKm0sbr09ppFJEv8mQ8EQcKPy+MKRsoUaYpvu4IIzj1JMUPzEnUDz9ueWPkH7REEhodhUBCJnbRwJZgWzrUZmaAsWmyu2HzawkthkQ0FMwzTGeSHnAMzdD0DxLt+njCPVek2x+foBEHt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769452674; c=relaxed/simple;
	bh=8vMl/z0pQVoMda6M0ESjn6iV2uALG3bL9L9HkLOq0GA=;
	h=Date:To:From:Subject:Message-Id; b=Upj2SvAOqHlBK6zkRo+9MTQQUwFf8H3uYiHnKukObDE/wfOjsneMuvbAkRO5ISQmgtQ2J8rmXfX0Wx867QTjdHrbUIlMHfTtfj0j5o5Php0pVzDtn1MRNk+je0Zk8og4anhYHf/ejIIi1MxP9rYxPe2VKQvzu1ZaC/3zSJupFD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UumUYjsI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UumUYjsI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577B8C116C6;
	Mon, 26 Jan 2026 18:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769452674;
	bh=8vMl/z0pQVoMda6M0ESjn6iV2uALG3bL9L9HkLOq0GA=;
	h=Date:To:From:Subject:From;
	b=UumUYjsIizS1aRT1IZujTXU4ulQbBycPiGqXRIekrK5GX6vtRt8KLX7W0IzTsk7gB
	 N0Fv7T8ZFdR/b5aaF2g9o5X1AF2RjBBeTqDjtWW9cqHr+m9awJ/aZRZ9aYRWLPl3fo
	 ZbU6SSQrz2Bx7+37nQptjo4RcBxpk9Ua35lao5jU=
Date: Mon, 26 Jan 2026 10:37:53 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,longman@redhat.com,liam.howlett@oracle.com,boqun.feng@gmail.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-improve-and-document-__is_vma_write_locked-fix.patch added to mm-unstable branch
Message-Id: <20260126183754.577B8C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-vma-improve-and-document-__is_vma_write_locked-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vma-improve-and-document-__is_vma_write_locked-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-improve-and-document-__is_vma_write_locked-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm-vma-improve-and-document-__is_vma_write_locked-fix
Date: Mon, 26 Jan 2026 16:23:16 +0000

minor tweaks, per Vlastimil

Link: https://lkml.kernel.org/r/3fa89c13-232d-4eee-86cc-96caa75c2c67@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmap_lock.h |    9 +++------
 mm/mmap_lock.c            |    6 +++---
 2 files changed, 6 insertions(+), 9 deletions(-)

--- a/include/linux/mmap_lock.h~mm-vma-improve-and-document-__is_vma_write_locked-fix
+++ a/include/linux/mmap_lock.h
@@ -272,8 +272,6 @@ static inline unsigned int __vma_raw_mm_
  * write lock is held.
  *
  * Returns true if write-locked, otherwise false.
- *
- * Note that mm_lock_seq is updated only if the VMA is NOT write-locked.
  */
 static inline bool __is_vma_write_locked(struct vm_area_struct *vma)
 {
@@ -284,8 +282,7 @@ static inline bool __is_vma_write_locked
 	return vma->vm_lock_seq == __vma_raw_mm_seqnum(vma);
 }
 
-int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
-		int state);
+int __vma_start_write(struct vm_area_struct *vma, int state);
 
 /*
  * Begin writing to a VMA.
@@ -297,7 +294,7 @@ static inline void vma_start_write(struc
 	if (__is_vma_write_locked(vma))
 		return;
 
-	__vma_start_write(vma, __vma_raw_mm_seqnum(vma), TASK_UNINTERRUPTIBLE);
+	__vma_start_write(vma, TASK_UNINTERRUPTIBLE);
 }
 
 /**
@@ -319,7 +316,7 @@ int vma_start_write_killable(struct vm_a
 	if (__is_vma_write_locked(vma))
 		return 0;
 
-	return __vma_start_write(vma, __vma_raw_mm_seqnum(vma), TASK_KILLABLE);
+	return __vma_start_write(vma, TASK_KILLABLE);
 }
 
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
--- a/mm/mmap_lock.c~mm-vma-improve-and-document-__is_vma_write_locked-fix
+++ a/mm/mmap_lock.c
@@ -136,14 +136,14 @@ static int __vma_start_exclude_readers(s
 	return 0;
 }
 
-int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
-		int state)
+int __vma_start_write(struct vm_area_struct *vma, int state)
 {
-	int err;
+	const unsigned int mm_lock_seq = __vma_raw_mm_seqnum(vma);
 	struct vma_exclude_readers_state ves = {
 		.vma = vma,
 		.state = state,
 	};
+	int err;
 
 	err = __vma_start_exclude_readers(&ves);
 	if (err) {
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts.patch
mm-rmap-eliminate-partial-anon_vma-tear-down-in-anon_vma_fork.patch
mm-rmap-skip-unfaulted-vmas-on-anon_vma-clone-unlink.patch
mm-rmap-remove-unnecessary-root-lock-dance-in-anon_vma-clone-unmap.patch
mm-rmap-remove-anon_vma_merge-function.patch
mm-rmap-make-anon_vma-functions-internal.patch
mm-mmap_lock-add-vma_is_attached-helper.patch
mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible.patch
mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone.patch
selftests-mm-remove-virtual_address_range-test.patch
mm-vma-rename-vma_lock_offset-to-vm_refcnt_exclude_readers_flag.patch
mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment.patch
mm-vma-rename-is_vma_write_only-separate-out-shared-refcount-put.patch
mm-vma-adduse-vma-lockdep-acquire-release-defines.patch
mm-vma-de-duplicate-__vma_enter_locked-error-path.patch
mm-vma-clean-up-__vma_enter-exit_locked.patch
mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns.patch
mm-vma-improve-and-document-__is_vma_write_locked.patch
mm-vma-improve-and-document-__is_vma_write_locked-fix.patch
mm-vma-update-vma_assert_locked-to-use-lockdep.patch
mm-vma-update-vma_assert_locked-to-use-lockdep-fix.patch
mm-vma-add-and-use-vma_assert_stabilised.patch
mm-vma-remove-__private-sparse-decoration-from-vma_flags_t.patch
mm-rename-vma_flag_test-set_atomic-to-vma_test-set_atomic_flag.patch
mm-add-mk_vma_flags-bitmap-flag-macro-helper.patch
tools-bitmap-add-missing-bitmap_.patch
mm-add-basic-vma-flag-operation-helper-functions.patch
mm-update-hugetlbfs-to-use-vma-flags-on-mmap_prepare.patch
mm-update-secretmem-to-use-vma-flags-on-mmap_prepare.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t.patch
mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t.patch
mm-make-vm_area_desc-utilise-vma_flags_t-only.patch
tools-testing-vma-separate-vma-userland-tests-into-separate-files.patch
tools-testing-vma-separate-out-vma_internalh-into-logical-headers.patch
tools-testing-vma-add-vma-userland-tests-for-vma-flag-functions.patch

