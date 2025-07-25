Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CEB194124
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 01:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753406006; cv=none; b=ETQB38Ols3CjiJ/Vy2qX/RBArjC4WuyUQk4n9fDDWO2cQApsZeKttScK3WrsMxLA+Nm8PYmr3WuBWYubc5OWo1HP7Q6UGDKri6nWrTKzlWQbnFEZ8OXUN08TQ+e7rBZcU0oREwkhzoU1atHZeWje0tnlm6qgZqoVxQPieHgi5xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753406006; c=relaxed/simple;
	bh=gKZs3Y/H4f4/lvWRNaEojehafo2R9YcyZiQng9VI8+s=;
	h=Date:To:From:Subject:Message-Id; b=fu7pRQl45xAqdxMrQFHHmjoYQ4wGD6TuAu2sOXU5wGMtXGDrDLAoW4roblLlWjoAFKpF/l3UD+S7C6+N+sVw2WVVqdnAflVYvrya28SZ1GqbZ0BVxFaFNlC/OzXhdMTwZTEiTN3Dr6g3V9EWSh6i1rscjVstErGG15gad1zjGeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hivUjtm+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hivUjtm+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767CBC4CEED;
	Fri, 25 Jul 2025 01:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753406005;
	bh=gKZs3Y/H4f4/lvWRNaEojehafo2R9YcyZiQng9VI8+s=;
	h=Date:To:From:Subject:From;
	b=hivUjtm+Te5tSSvN+JhJGniwJseJJeqZDcDmfmzstvfxxsaiXGfNy0Pal26SXK9Am
	 hHmIJBi3a2jVszOmo5qolD1R6pn6vhTaOkOay6zJZMmKmjorgomGAddaoW6KRvm9Kd
	 POhGv9we/yAsexMhXpMliGaTylwpTj9DsWOMLh2c=
Date: Thu, 24 Jul 2025 18:13:24 -0700
To: mm-commits@vger.kernel.org,oliver.sang@intel.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-mremap-check-remap-conditions-earlier-fix.patch removed from -mm tree
Message-Id: <20250725011325.767CBC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mremap: allow undocumented mremap() shrink behaviour
has been removed from the -mm tree.  Its filename was
     mm-mremap-check-remap-conditions-earlier-fix.patch

This patch was dropped because it was folded into mm-mremap-check-remap-conditions-earlier.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/mremap: allow undocumented mremap() shrink behaviour
Date: Sun, 20 Jul 2025 11:41:48 +0100

It turns out that, in apparent contradiction to the man page, and at odds
with every other mremap() operation - we are allowed to specify an input
addr, old_len range that spans any number of VMAs and any number of gaps,
as long as we shrink that range to the point at which the new range spans
only one.

In order to accommodate this, adjust the remap validity check to account
for this.

Link: https://lkml.kernel.org/r/8fc92a38-c636-465e-9a2f-2c6ac9cb49b8@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202507201002.69144b74-lkp@intel.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/mremap.c~mm-mremap-check-remap-conditions-earlier-fix
+++ a/mm/mremap.c
@@ -1339,11 +1339,18 @@ static int remap_is_valid(struct vma_rem
 			(vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP)))
 		return -EINVAL;
 
+	/*
+	 * We permit crossing of boundaries for the range being unmapped due to
+	 * a shrink.
+	 */
+	if (vrm->remap_type == MREMAP_SHRINK)
+		old_len = new_len;
+
 	/* We can't remap across vm area boundaries */
 	if (old_len > vma->vm_end - addr)
 		return -EFAULT;
 
-	if (new_len <= old_len)
+	if (new_len == old_len)
 		return 0;
 
 	/* Need to be careful about a growing mapping */
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name.patch
mm-mremap-perform-some-simple-cleanups.patch
mm-mremap-refactor-initial-parameter-sanity-checks.patch
mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch
mm-mremap-cleanup-post-processing-stage-of-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch
tools-testing-selftests-add-mremap-shrink-test-for-multiple-vmas.patch
tools-testing-selftests-test-mremap_dontunmap-on-multiple-vma-move.patch
tools-testing-selftests-explicitly-test-split-multi-vma-mremap-move.patch
docs-update-thp-documentation-to-clarify-sysfs-never-setting.patch
docs-update-thp-documentation-to-clarify-sysfs-never-setting-fix.patch
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

