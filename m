Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C1742AAF
	for <mm-commits@vger.kernel.org>; Sun, 22 Jun 2025 21:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750628930; cv=none; b=TezYotcIY6vrCfJrA7VgWWqm7sBrUP0isUgYra6lN8a0zi1GoWedhCgsjhQZrEf70xWMYl4jSe/4FxUVMzYt/U8OXsBncaGWEwah72JcSfB+DfqiGOHQQpu/DrH/oFWrTD3+lesCso3VEL65M5apqzO0cj7lNS0B82aRcMSDKJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750628930; c=relaxed/simple;
	bh=UNvK0BduQNajmmJWFSxaCjSSR5Nk0Byy476c8rW8quo=;
	h=Date:To:From:Subject:Message-Id; b=RLYenHkkx04ZDQEJpaOGeGSc/xD76+r9yaM824ZVB4mxotG75BCAEiv8SuJHPgipCKsAL/ur+cO5K4efQNa+mlLcdmPr7M2jjRWWn6IdimH+HJzspiWoBgOsb8U8nFZXBZL4/d8+h1Qsxlz3vgaHkHKWERCNzvdXkoMP6auTr6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KKuU/nnn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KKuU/nnn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F1CC4CEEA;
	Sun, 22 Jun 2025 21:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750628930;
	bh=UNvK0BduQNajmmJWFSxaCjSSR5Nk0Byy476c8rW8quo=;
	h=Date:To:From:Subject:From;
	b=KKuU/nnnPsMS0uM211C1W513IwcYI2yWW2qgQiomAVHaz2ar31VkfTo9H4VcBbZnO
	 z2xVVCAbPVoQEn1D2nh7CbftoNXAyZR9N03X8paXNzGrKsUH00ZPvqzYQuDirgQ4iy
	 MvZi25U7O1vT3SnGLx61Gogj2GUF1p3+mJLyuLE4=
Date: Sun, 22 Jun 2025 14:48:49 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,muchun.song@linux.dev,gavinguo@igalia.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmhugetlb-rename-anon_rmap-to-new_anon_folio-and-make-it-boolean-fix.patch added to mm-new branch
Message-Id: <20250622214850.57F1CC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mmhugetlb-rename-anon_rmap-to-new_anon_folio-and-make-it-boolean-fix
has been added to the -mm mm-new branch.  Its filename is
     mmhugetlb-rename-anon_rmap-to-new_anon_folio-and-make-it-boolean-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmhugetlb-rename-anon_rmap-to-new_anon_folio-and-make-it-boolean-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Oscar Salvador <osalvador@suse.de>
Subject: mmhugetlb-rename-anon_rmap-to-new_anon_folio-and-make-it-boolean-fix
Date: Fri, 20 Jun 2025 16:28:42 +0200

make `new_anon_folio' assignment more explicit

Link: https://lkml.kernel.org/r/aFVwGttkfeRmK9Rr@localhost.localdomain
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gavin Guo <gavinguo@igalia.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mmhugetlb-rename-anon_rmap-to-new_anon_folio-and-make-it-boolean-fix
+++ a/mm/hugetlb.c
@@ -6495,7 +6495,6 @@ static vm_fault_t hugetlb_no_page(struct
 		folio_zero_user(folio, vmf->real_address);
 		__folio_mark_uptodate(folio);
 		new_folio = true;
-		new_anon_folio = !(vma->vm_flags & VM_MAYSHARE);
 
 		if (vma->vm_flags & VM_MAYSHARE) {
 			int err = hugetlb_add_to_page_cache(folio, mapping,
@@ -6515,6 +6514,7 @@ static vm_fault_t hugetlb_no_page(struct
 				goto out;
 			}
 		} else {
+			new_anon_folio = true;
 			folio_lock(folio);
 		}
 	} else {
_

Patches currently in -mm which might be from osalvador@suse.de are

mmslub-do-not-special-case-n_normal-nodes-for-slab_nodes.patch
mmmemory_hotplug-remove-status_change_nid_normal-and-update-documentation.patch
mmmemory_hotplug-implement-numa-node-notifier.patch
mmslub-use-node-notifier-instead-of-memory-notifier.patch
mmmemory-tiers-use-node-notifier-instead-of-memory-notifier.patch
driverscxl-use-node-notifier-instead-of-memory-notifier.patch
drivershmat-use-node-notifier-instead-of-memory-notifier.patch
kernelcpuset-use-node-notifier-instead-of-memory-notifier.patch
mmmempolicy-use-node-notifier-instead-of-memory-notifier.patch
mmpage_ext-derive-the-node-from-the-pfn.patch
mmmemory_hotplug-drop-status_change_nid-parameter-from-memory_notify.patch
mmhugetlb-change-mechanism-to-detect-a-cow-on-private-mapping.patch
mmhugetlb-sort-out-folio-locking-in-the-faulting-path.patch
mmhugetlb-rename-anon_rmap-to-new_anon_folio-and-make-it-boolean.patch
mmhugetlb-rename-anon_rmap-to-new_anon_folio-and-make-it-boolean-fix.patch
mmhugetlb-drop-obsolete-comment-about-non-present-pte-and-second-faults.patch
mmhugetlb-drop-unlikelys-from-hugetlb_fault.patch

