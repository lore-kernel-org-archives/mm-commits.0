Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1188237CD3C
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 18:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774981783; cv=none; b=KQkkPvU7/IyKJvdntqwT3gK2g92y1/70y+W3Kpb2mbmUo0Vj8PDuhw39L905Smvkj265rVMOXjL0cnBWM1mGQCLA39XeMXdO5B28YdQ+KeSZ2JlibDRqulN/WWQKX42WI8z1FWPP9CWUVFJa8OG5SlA+za3ieiHgCHndMQ1mSzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774981783; c=relaxed/simple;
	bh=3iafkpUZF64Nj9YRDhR3jw7Ouzvih9HbgnYobjX5WSo=;
	h=Date:To:From:Subject:Message-Id; b=YoNdb3LJv8a13qO5VLT9wHeJxvPICkOZVp+XM3cTnNnXYWdbNe9O8Xd0Ehza3ff6fCkd8R608Y1wX9SaczBa6Oj2pwfBejtbWelyAsuZI3fVNA+1s0tJH2ZtJ8cYncDGqxQhapLX9c9Wfv6dHBx6ZsHfF2Cy+1VowewJXeJe/Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rjHurkRu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rjHurkRu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF89C19423;
	Tue, 31 Mar 2026 18:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774981782;
	bh=3iafkpUZF64Nj9YRDhR3jw7Ouzvih9HbgnYobjX5WSo=;
	h=Date:To:From:Subject:From;
	b=rjHurkRuPTcVNOceP5XEz2tNQ77/goCG3PrBvxhPIlIVgQltiQl3/q1IJ/qChegWv
	 M04oIzxatLoi2fdwvQuubsrvgouBIBaBOCEAsrTw7C9fUWTJBO3sxteLKilq/Cg7v2
	 GiH+wVWWrjCMmeR7/p8/Q3dgq1BadJLqS/MA9vfs=
Date: Tue, 31 Mar 2026 11:29:41 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vma-cleanup-error-handling-path-in-vma_expand.patch removed from -mm tree
Message-Id: <20260331182942.7DF89C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: cleanup error handling path in vma_expand()
has been removed from the -mm tree.  Its filename was
     mm-vma-cleanup-error-handling-path-in-vma_expand.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm/vma: cleanup error handling path in vma_expand()
Date: Fri, 27 Mar 2026 13:54:52 -0700

Patch series "Use killable vma write locking in most places", v6.

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

Link: https://lkml.kernel.org/r/20260327205457.604224-1-surenb@google.com
Link: https://lkml.kernel.org/r/20260327205457.604224-2-surenb@google.com
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

mm-use-vma_start_write_killable-in-mm-syscalls.patch
mm-khugepaged-use-vma_start_write_killable-in-collapse_huge_page.patch
mm-vma-use-vma_start_write_killable-in-vma-operations.patch
mm-use-vma_start_write_killable-in-process_vma_walk_lock.patch
kvm-ppc-use-vma_start_write_killable-in-kvmppc_memslot_page_merge.patch
mm-vmscan-prevent-mglru-reclaim-from-pinning-address-space.patch

