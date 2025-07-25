Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE3B12BF24
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409664; cv=none; b=hfyUbEUJKvJwJEd0IeoZVSQdQl3KkjuK0ADfmsrXa1LuLqcrC9e4n+oQGXn+nxUMb0TTUeZLtGsxvVa45sC1sv0NBDiwG3yV+qbDKl87cgNFgJZNG+OiBpRhLJ1KTTujr+i4Okoe1aeVeikH26Z/xDBEtfgQB+fMzo61K2DdOJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409664; c=relaxed/simple;
	bh=C5EcMtUcUDZ0ochWytKOMV2A/vkiyDWWlEcwNP/eGfE=;
	h=Date:To:From:Subject:Message-Id; b=UYKYzPRJdgTRA6V4bl09yutQTPihEvgIqZOljmgLuO9uLBMxfrv1wdyEJfTAIfQe1azIx660lOqV9Nxud/L+SUMCt7WAYM0/I0OtiQ+c9lRhqdUosxTNCrJ+oB13xLrDuOrYmutsW/h9U1beSRFuYagKT0LVuZ4JhlqdACS8/Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V+vha5Um; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V+vha5Um"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D34C4CEED;
	Fri, 25 Jul 2025 02:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409663;
	bh=C5EcMtUcUDZ0ochWytKOMV2A/vkiyDWWlEcwNP/eGfE=;
	h=Date:To:From:Subject:From;
	b=V+vha5UmUQxKE9gqLgPeMW1ix/Ynz+7SVi7X+alVM2HlMmKWu01ebXazXAaorDQYW
	 gXAZCC8SXaZSbdC6jCu4CvZiKWm4sbKLye8F3yJTr+jQ0zojKxK05I7y6DdTRuChhq
	 87icTEnPNu1F/HpZ4MsLXDQwSOgIPiIqfaZVrgfA=
Date: Thu, 24 Jul 2025 19:14:23 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,riel@surriel.com,peterx@redhat.com,liam.howlett@oracle.com,jannh@google.com,jack@suse.cz,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mremap-cleanup-post-processing-stage-of-mremap.patch removed from -mm tree
Message-Id: <20250725021423.D1D34C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mremap: cleanup post-processing stage of mremap
has been removed from the -mm tree.  Its filename was
     mm-mremap-cleanup-post-processing-stage-of-mremap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/mremap: cleanup post-processing stage of mremap
Date: Thu, 17 Jul 2025 17:55:54 +0100

Separate out the uffd bits so it clear's what's happening.

Don't bother setting vrm->mmap_locked after unlocking, because after this
we are done anyway.

The only time we drop the mmap lock is on VMA shrink, at which point
vrm->new_len will be < vrm->old_len and the operation will not be
performed anyway, so move this code out of the if (vrm->mmap_locked)
block.

All addresses returned by mremap() are page-aligned, so the
offset_in_page() check on ret seems only to be incorrectly trying to
detect whether an error occurred - explicitly check for this.

No functional change intended.

Link: https://lkml.kernel.org/r/ebb8f29650b8e343fe98fefc67b3a61a24d1e0f1.1752770784.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/mm/mremap.c~mm-mremap-cleanup-post-processing-stage-of-mremap
+++ a/mm/mremap.c
@@ -1729,6 +1729,15 @@ static int check_prep_vma(struct vma_rem
 	return 0;
 }
 
+static void notify_uffd(struct vma_remap_struct *vrm, unsigned long to)
+{
+	struct mm_struct *mm = current->mm;
+
+	userfaultfd_unmap_complete(mm, vrm->uf_unmap_early);
+	mremap_userfaultfd_complete(vrm->uf, vrm->addr, to, vrm->old_len);
+	userfaultfd_unmap_complete(mm, vrm->uf_unmap);
+}
+
 static unsigned long do_mremap(struct vma_remap_struct *vrm)
 {
 	struct mm_struct *mm = current->mm;
@@ -1754,18 +1763,13 @@ static unsigned long do_mremap(struct vm
 	res = vrm_implies_new_addr(vrm) ? mremap_to(vrm) : mremap_at(vrm);
 
 out:
-	if (vrm->mmap_locked) {
+	if (vrm->mmap_locked)
 		mmap_write_unlock(mm);
-		vrm->mmap_locked = false;
-
-		if (!offset_in_page(res) && vrm->mlocked && vrm->new_len > vrm->old_len)
-			mm_populate(vrm->new_addr + vrm->old_len, vrm->delta);
-	}
 
-	userfaultfd_unmap_complete(mm, vrm->uf_unmap_early);
-	mremap_userfaultfd_complete(vrm->uf, vrm->addr, res, vrm->old_len);
-	userfaultfd_unmap_complete(mm, vrm->uf_unmap);
+	if (!IS_ERR_VALUE(res) && vrm->mlocked && vrm->new_len > vrm->old_len)
+		mm_populate(vrm->new_addr + vrm->old_len, vrm->delta);
 
+	notify_uffd(vrm, res);
 	return res;
 }
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-rework-mseal-apply-logic.patch
maintainers-add-missing-percpu-internalh-file-to-per-cpu-section.patch
maintainers-add-missing-interval_treec-to-memory-mapping-section.patch
maintainers-add-missing-mm_sloth-file-thp-section.patch
maintainers-add-missing-mm_sloth-file-thp-section-fix.patch
maintainers-move-memremap-to-hotplug-section.patch
maintainers-add-missing-shrinker-files.patch
maintainers-add-missing-files-to-page-alloc-section.patch
maintainers-add-missing-zsmalloc-file.patch
maintainers-add-mm-misc-section-add-missing-files-to-misc-and-core.patch
maintainers-add-missing-file-to-cgroup-section.patch

