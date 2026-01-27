Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84ACC31619E
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486656; cv=none; b=YHnkjUTDCBWT+xS2rm7HHKwZuhTMULcTo8MCNnR/1F2NBq8zxgS4usWMbKZ9ggrs/5QlAu++tghVNMZQ6SN5BLuvCRFYeHvZjpeSg2CYWlwvWsKy71frWj/F+SZu85zdq3TMsshHVK8gTSfiMR7w21sv76yxHpx2KR1UkSXMuCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486656; c=relaxed/simple;
	bh=N/g7rwt8oQlRt0iOLaaQFIwW42In893d4VRigzoF1Qk=;
	h=Date:To:From:Subject:Message-Id; b=ZYLNCVXm7nhX6vTpt3Ir2xB2bvj+KsAUDgwDUYYywxPGtu48gGCELhuKDQSx1Hx+MQGBYmZzOetBpdrvHYfVbg56IDamaPogYiR+3XtlLRFvo0CxFFMNJIdVfoR93r07nJ9v94SB1nofwkUv1NlBY1WHhKUfctrKaFVjgKInOjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Esif//wl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Esif//wl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403D5C116C6;
	Tue, 27 Jan 2026 04:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486656;
	bh=N/g7rwt8oQlRt0iOLaaQFIwW42In893d4VRigzoF1Qk=;
	h=Date:To:From:Subject:From;
	b=Esif//wlLgMT7KmNcJVYF5wHPK/A6G+ACWY+LBQuHycZX8plg9pmAa3WloyExJaK6
	 Dpl8/9FNTbcvLpASnbIY3qVdt/B+VeIEPVpUBuU7IS9arPG0geO3F6LLrajvazvKjP
	 zuXUkNyShV/39a6hfwxoFyUvtla7V71I3Q9C9A7A=
Date: Mon, 26 Jan 2026 20:04:15 -0800
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,mhocko@suse.com,Liam.Howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@kernel.org,chriscli@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-eliminate-partial-anon_vma-tear-down-in-anon_vma_fork.patch removed from -mm tree
Message-Id: <20260127040416.403D5C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: eliminate partial anon_vma tear-down in anon_vma_fork()
has been removed from the -mm tree.  Its filename was
     mm-rmap-eliminate-partial-anon_vma-tear-down-in-anon_vma_fork.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/rmap: eliminate partial anon_vma tear-down in anon_vma_fork()
Date: Sun, 18 Jan 2026 14:50:38 +0000

We have spun a web of unnecessary headaches for ourselves in
anon_vma_fork() with the introduction of the anon_vma reuse logic, as
introduced by commit 7a3ef208e662 ("mm: prevent endless growth of anon_vma
hierarchy").

When we clone anon_vma's linked to a VMA via vma->anon_vma_chain, we check
each anon_vma for specific conditions, and if met we set vma->anon_vma to
this anon_vma to indicate we will reuse it rather than allocating a new
one.

It triggers upon the first ancestor anon_vma found that possesses at most
1 child, and no active VMAs.

This was implemented such that if you continually fork and free VMAs, you
would achieve anon_vma reuse rather than continually allocating
unnecessary new anon_vma's.

This however brings an unfortunate situation should a memory allocation
fail during this process.  anon_vma_fork():

1. Clones the anon_vma.
2. If no reuse (i.e. !vma->anon_vma), tries to allocate anon_vma, AVC.
3. If 2 fails, we are forced to unwind step 1 by invoking
   unlink_anon_vmas(vma).

This means that we send a partially set up (i.e.  invalid) VMA to
unlink_anon_vmas().

Doing this is dangerous and confusing - it is reasonable for kernel
developers to assume unlink_anon_vmas() is called on a correctly
established vma, and thus confusion arises if logic is implemented there
to account for invalid VMAs, and further development might introduce
subtle bugs.

It is especially problematic in the anon rmap implementation which is
essentially a broken abstraction.

The patch solves the issue by simply trying to allocate the anon_vma and
AVC ahead of time - i.e.  optimising for the usual case - and freeing them
should reuse occur or an error arise in anon_vma_clone().

This is not egregious performance-wise, as this function is called on the
fork path which already performs a great number of allocations, and thus
it is already a slow-path in this respect.

It is additionally not egregious in terms of memory usage - the
allocations are too-small-to-fail anyway unless, for instance, a fatal
signal may have arisen, and any OOM for such tiny allocations that may
arise would indicate the system is under so much memory pressure that the
associated process is not long for this world anyway.

We also update anon_vma->num_active_vmas to 1 directly rather than
incrementing the newly allocated anon_vma's active VMA count - this makes
it clear that this detached anon_vma can have only 1 num_active_vma at
this point.

Finally we eliminate the out_error and out_error_free_anon_vma labels
which makes the logic much easier to follow.  We also correct a small
comment typo.

Link: https://lkml.kernel.org/r/9923da5f8b095dd1e8d677692dcaf95859de0ef5.1768746221.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chriscli@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   46 ++++++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 22 deletions(-)

--- a/mm/rmap.c~mm-rmap-eliminate-partial-anon_vma-tear-down-in-anon_vma_fork
+++ a/mm/rmap.c
@@ -359,7 +359,7 @@ int anon_vma_fork(struct vm_area_struct
 {
 	struct anon_vma_chain *avc;
 	struct anon_vma *anon_vma;
-	int error;
+	int rc;
 
 	/* Don't bother if the parent process has no anon_vma here. */
 	if (!pvma->anon_vma)
@@ -368,27 +368,35 @@ int anon_vma_fork(struct vm_area_struct
 	/* Drop inherited anon_vma, we'll reuse existing or allocate new. */
 	vma->anon_vma = NULL;
 
+	anon_vma = anon_vma_alloc();
+	if (!anon_vma)
+		return -ENOMEM;
+	avc = anon_vma_chain_alloc(GFP_KERNEL);
+	if (!avc) {
+		put_anon_vma(anon_vma);
+		return -ENOMEM;
+	}
+
 	/*
 	 * First, attach the new VMA to the parent VMA's anon_vmas,
 	 * so rmap can find non-COWed pages in child processes.
 	 */
-	error = anon_vma_clone(vma, pvma);
-	if (error)
-		return error;
-
-	/* An existing anon_vma has been reused, all done then. */
-	if (vma->anon_vma)
-		return 0;
+	rc = anon_vma_clone(vma, pvma);
+	/* An error arose or an existing anon_vma was reused, all done then. */
+	if (rc || vma->anon_vma) {
+		put_anon_vma(anon_vma);
+		anon_vma_chain_free(avc);
+		return rc;
+	}
 
-	/* Then add our own anon_vma. */
-	anon_vma = anon_vma_alloc();
-	if (!anon_vma)
-		goto out_error;
-	anon_vma->num_active_vmas++;
-	avc = anon_vma_chain_alloc(GFP_KERNEL);
-	if (!avc)
-		goto out_error_free_anon_vma;
+	/*
+	 * OK no reuse, so add our own anon_vma.
+	 *
+	 * Since it is not linked anywhere we can safely manipulate anon_vma
+	 * fields without a lock.
+	 */
 
+	anon_vma->num_active_vmas = 1;
 	/*
 	 * The root anon_vma's rwsem is the lock actually used when we
 	 * lock any of the anon_vmas in this anon_vma tree.
@@ -409,12 +417,6 @@ int anon_vma_fork(struct vm_area_struct
 	anon_vma_unlock_write(anon_vma);
 
 	return 0;
-
- out_error_free_anon_vma:
-	put_anon_vma(anon_vma);
- out_error:
-	unlink_anon_vmas(vma);
-	return -ENOMEM;
 }
 
 /*
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

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

