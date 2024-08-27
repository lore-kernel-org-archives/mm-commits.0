Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1201442E8
	for <mm-commits@vger.kernel.org>; Tue, 27 Aug 2024 22:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724799516; cv=none; b=SFy3Afd/A7ptT6mAKUPwtRJtgaCvt7mmIsh/FRUIqhhfHHlS7mz1bgx01GtqWy4jD1TxDNOrGkFbMN67kohVV+OeXQ9WjMt0RGZ63is0UrGPZcYA59KHGLoOa5WTSPaQL+j7RL52MaXKT/e47creLOo9BuOdTzV6tT2gSDTS3QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724799516; c=relaxed/simple;
	bh=+gbi6zBnXiLyiyNjWx43ezwkWqJpl5QYbH5F+13iR6c=;
	h=Date:To:From:Subject:Message-Id; b=fOHQqfil6w9/p5KQwuuy1pUIB29akjreNCslAIE5wiPHaYlczL/9wKFDTBxXhbxNYd0EnVkK+XxwNUZuFZ0Y5Uc+wJ/e6oABkbiNCvW+jk09BFaqUpG1wYAzPpK4avv1FYdERI3Vb5tqsECkBznQJZe4Ri+wDadQl0hj4T27FFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nAfoclHN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nAfoclHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857A6C4E674;
	Tue, 27 Aug 2024 22:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724799515;
	bh=+gbi6zBnXiLyiyNjWx43ezwkWqJpl5QYbH5F+13iR6c=;
	h=Date:To:From:Subject:From;
	b=nAfoclHN+WBlYMWdfJGi2OGsxy7O/w77hwWF2d3T3loqKpyZ911FxC6YjahjDhCtp
	 dp7MQ73lsycW8bEseubkQqof27SfFnjneF2XGCX6SUVcPmCIMBeyqkW12sEAhc+Fy/
	 skcQNZXvUU4PrgWoxHzhgjSyhKcTTSCtq5KYx2qY=
Date: Tue, 27 Aug 2024 15:58:34 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paulmck@kernel.org,olsajiri@gmail.com,lorenzo.stoakes@oracle.com,kees@kernel.org,dan.carpenter@linaro.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-change-failure-of-map_fixed-to-restoring-the-gap-on-failure-fix.patch added to mm-unstable branch
Message-Id: <20240827225835.857A6C4E674@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: fix null pointer dereference in vms_abort_munmap_vmas()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-change-failure-of-map_fixed-to-restoring-the-gap-on-failure-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-change-failure-of-map_fixed-to-restoring-the-gap-on-failure-fix.patch

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
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/vma: fix null pointer dereference in vms_abort_munmap_vmas()
Date: Tue, 27 Aug 2024 13:15:49 -0400

Don't pass a NULL vma to the vma_iter_store(), instead set up the maple
state for the store and do it manually.  vma_iter_clear() cannot be used
as it needs preallocations.

Link: https://lkml.kernel.org/r/20240827171549.273063-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Bert Karwatzki <spasswolf@web.de>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/vma.h~mm-change-failure-of-map_fixed-to-restoring-the-gap-on-failure-fix
+++ a/mm/vma.h
@@ -173,6 +173,7 @@ static inline void reattach_vmas(struct
 static inline void vms_abort_munmap_vmas(struct vma_munmap_struct *vms,
 		struct ma_state *mas_detach)
 {
+	struct ma_state *mas = &vms->vmi->mas;
 	if (!vms->nr_pages)
 		return;
 
@@ -184,13 +185,14 @@ static inline void vms_abort_munmap_vmas
 	 * not symmetrical and state data has been lost.  Resort to the old
 	 * failure method of leaving a gap where the MAP_FIXED mapping failed.
 	 */
-	if (unlikely(vma_iter_store_gfp(vms->vmi, NULL, GFP_KERNEL))) {
+	mas_set_range(mas, vms->start, vms->end);
+	if (unlikely(mas_store_gfp(mas, NULL, GFP_KERNEL))) {
 		pr_warn_once("%s: (%d) Unable to abort munmap() operation\n",
 			     current->comm, current->pid);
 		/* Leaving vmas detached and in-tree may hamper recovery */
 		reattach_vmas(mas_detach);
 	} else {
-		/* Clean up the insertion of unfortunate the gap */
+		/* Clean up the insertion of the unfortunate gap */
 		vms_complete_munmap_vmas(vms, mas_detach);
 	}
 }
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

maple_tree-remove-rcu_read_lock-from-mt_validate.patch
mm-vma-correctly-position-vma_iterator-in-__split_vma.patch
mm-vma-introduce-abort_munmap_vmas.patch
mm-vma-introduce-vmi_complete_munmap_vmas.patch
mm-vma-extract-the-gathering-of-vmas-from-do_vmi_align_munmap.patch
mm-vma-introduce-vma_munmap_struct-for-use-in-munmap-operations.patch
mm-vma-change-munmap-to-use-vma_munmap_struct-for-accounting-and-surrounding-vmas.patch
mm-vma-change-munmap-to-use-vma_munmap_struct-for-accounting-and-surrounding-vmas-fix.patch
mm-vma-extract-validate_mm-from-vma_complete.patch
mm-vma-inline-munmap-operation-in-mmap_region.patch
mm-vma-expand-mmap_region-munmap-call.patch
mm-vma-support-vma-==-null-in-init_vma_munmap.patch
mm-mmap-reposition-vma-iterator-in-mmap_region.patch
mm-vma-track-start-and-end-for-munmap-in-vma_munmap_struct.patch
mm-clean-up-unmap_region-argument-list.patch
mm-mmap-avoid-zeroing-vma-tree-in-mmap_region.patch
mm-change-failure-of-map_fixed-to-restoring-the-gap-on-failure.patch
mm-change-failure-of-map_fixed-to-restoring-the-gap-on-failure-fix.patch
mm-mmap-use-phys_pfn-in-mmap_region.patch
mm-mmap-use-vms-accounted-pages-in-mmap_region.patch
ipc-shm-mm-drop-do_vma_munmap.patch
mm-move-may_expand_vm-check-in-mmap_region.patch
mm-vma-drop-incorrect-comment-from-vms_gather_munmap_vmas.patch
mm-vmah-optimise-vma_munmap_struct.patch

