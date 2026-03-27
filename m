Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC4B370D6A
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774630826; cv=none; b=BrO28NgJWheDcMeNVa4wrKILIw+qGWb8h5+qL1hoaBgLU2CpISNV5tQcvyTLH+XOydiHzIBKb6u/g/G1xav/rkr/xh0ckaRzsH3bMl2VBRqKAwrofojXSo4A3lUSuSahJzDS7rpOeR5dSqwY/MUUq46ogA23Y5YiCFH2YiANU1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774630826; c=relaxed/simple;
	bh=soZfS6VsqXZ8mnvHXrFFuHseYUPZnaX7l9LaCvZV9vM=;
	h=Date:To:From:Subject:Message-Id; b=Plw4JdSIMNFilwWJypXi8FIuEi+W60GBbxNQgaWB24oifTX5VSqa2jjfaAizfYU6P1RbfdRnrxOX3ZudlCubXLcrBzdJc6g1A6JrrCx+jE6uXO44jWh1U5giSxC12MDfocQp6waIe4jezzdrzQnU+AUKoTiP1UF37+7pqsGtIT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qt5nz5Bo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qt5nz5Bo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3406CC19423;
	Fri, 27 Mar 2026 17:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774630826;
	bh=soZfS6VsqXZ8mnvHXrFFuHseYUPZnaX7l9LaCvZV9vM=;
	h=Date:To:From:Subject:From;
	b=qt5nz5BoIKTuQ/5vYMvYGQPv0aCtOaqaow+Id+0wfck6NYgT9qqA5vJp5GBRTYZi0
	 8JTdO5XmTlHRirwy6sKjwDrtUce9FbHTusMwUPWg/7m+OasrdVjb/qPW+LQ8bAIQJJ
	 wMvihi7iZ4f0fbIMf8en80qLQYJwi5FKp6oaxPqA=
Date: Fri, 27 Mar 2026 10:00:25 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-cleanup-error-handling-path-in-vma_expand.patch added to mm-new branch
Message-Id: <20260327170026.3406CC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: cleanup error handling path in vma_expand()
has been added to the -mm mm-new branch.  Its filename is
     mm-vma-cleanup-error-handling-path-in-vma_expand.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-cleanup-error-handling-path-in-vma_expand.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm/vma: cleanup error handling path in vma_expand()
Date: Thu, 26 Mar 2026 01:08:31 -0700

Patch series "Use killable vma write locking in most places", v5.

Now that we have vma_start_write_killable() we can replace most of the
vma_start_write() calls with it, improving reaction time to the kill
signal.

There are several places which are left untouched by this patchset:

1. free_pgtables() because function should free page tables even if a
   fatal signal is pending.

2. userfaultd code, where some paths calling vma_start_write() can
   handle EINTR and some can't without a deeper code refactoring.

3. mpol_rebind_mm() which is used by cpusset controller for migrations
   and operates on a remote mm.  Incomplete operations here would result
   in an inconsistent cgroup state.

4. vm_flags_{set|mod|clear} require refactoring that involves moving
   vma_start_write() out of these functions and replacing it with
   vma_assert_write_locked(), then callers of these functions should lock
   the vma themselves using vma_start_write_killable() whenever possible.


This patch (of 6):

vma_expand() error handling is a bit confusing with "if (ret) return ret;"
mixed with "if (!ret && ...) ret = ...;".  Simplify the code to check for
errors and return immediately after an operation that might fail.  This
also makes later changes to this function more readable.  Change variable
name for storing the error code from "ret" to "err".

No functional change intended.

Link: https://lkml.kernel.org/r/20260326080836.695207-2-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Jann Horn <jannh@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/mm/vma.c~mm-vma-cleanup-error-handling-path-in-vma_expand
+++ a/mm/vma.c
@@ -1170,7 +1170,7 @@ int vma_expand(struct vma_merge_struct *
 	vma_flags_t sticky_flags =
 		vma_flags_and_mask(&vmg->vma_flags, VMA_STICKY_FLAGS);
 	vma_flags_t target_sticky;
-	int ret = 0;
+	int err = 0;
 
 	mmap_assert_write_locked(vmg->mm);
 	vma_start_write(target);
@@ -1200,12 +1200,16 @@ int vma_expand(struct vma_merge_struct *
 	 * Note that, by convention, callers ignore OOM for this case, so
 	 * we don't need to account for vmg->give_up_on_mm here.
 	 */
-	if (remove_next)
-		ret = dup_anon_vma(target, next, &anon_dup);
-	if (!ret && vmg->copied_from)
-		ret = dup_anon_vma(target, vmg->copied_from, &anon_dup);
-	if (ret)
-		return ret;
+	if (remove_next) {
+		err = dup_anon_vma(target, next, &anon_dup);
+		if (err)
+			return err;
+	}
+	if (vmg->copied_from) {
+		err = dup_anon_vma(target, vmg->copied_from, &anon_dup);
+		if (err)
+			return err;
+	}
 
 	if (remove_next) {
 		vma_flags_t next_sticky;
_

Patches currently in -mm which might be from surenb@google.com are

mm-vma-cleanup-error-handling-path-in-vma_expand.patch
mm-use-vma_start_write_killable-in-mm-syscalls.patch
mm-khugepaged-use-vma_start_write_killable-in-collapse_huge_page.patch
mm-vma-use-vma_start_write_killable-in-vma-operations.patch
mm-use-vma_start_write_killable-in-process_vma_walk_lock.patch
kvm-ppc-use-vma_start_write_killable-in-kvmppc_memslot_page_merge.patch

