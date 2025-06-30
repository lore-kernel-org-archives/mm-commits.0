Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B94428DF29
	for <mm-commits@vger.kernel.org>; Mon, 30 Jun 2025 22:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751324139; cv=none; b=oKToxlQitiXAs1TkHkA62BGt2Gt1Pozgqdzl+dc/4X9/KAxmC+imwl9uCCZAuxrNNmuPdi4nY737Sxos7oLVTsniCYSWYsmcrb594WpmbZeL8kWBIxXqPy27AYWoTnWMC0Mq21jKSAzN+g26KHSY30A99G57H/wdZ/3yZk8Bh7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751324139; c=relaxed/simple;
	bh=e0qCPS7C5y4/KIX0FdY5bI4VySH/NVDmLj7oAjh9GXw=;
	h=Date:To:From:Subject:Message-Id; b=ebeXNHqOJPbw40MGj34UwE7eTswuZUfDonhhspHkLrEZ5DVG9ltKRno62e+VaxgKiYBnXinMw/MuR0VrtETiiQjhMlLAihb4izJSoneDxFrsgQKau1tYx+n+5aDT6/734+9zev13SBY4z+XOSI6VNgiUACQGnFQpuHFfbwRK1hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jDbG4yjz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jDbG4yjz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C946AC4CEF0;
	Mon, 30 Jun 2025 22:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751324138;
	bh=e0qCPS7C5y4/KIX0FdY5bI4VySH/NVDmLj7oAjh9GXw=;
	h=Date:To:From:Subject:From;
	b=jDbG4yjzwDLD6IxNWeqSnORFcYcXj+9Dd100WGj0y5sgbBLXZeouCOQjaIHjvW2xP
	 EY8W1/Q5E5tg1ZjCQicWlYbfmTaX8+Xwow5fGB7E/Vhb4+L8lWcJrKturs3PJCT5y1
	 SQ7Fg9advbrrBBey0FawjiRVPbf6QAbmBZv4Dl0s=
Date: Mon, 30 Jun 2025 15:55:38 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,muchun.song@linux.dev,gavinguo@igalia.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmhugetlb-drop-unlikelys-from-hugetlb_fault.patch added to mm-new branch
Message-Id: <20250630225538.C946AC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,hugetlb: drop unlikelys from hugetlb_fault
has been added to the -mm mm-new branch.  Its filename is
     mmhugetlb-drop-unlikelys-from-hugetlb_fault.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmhugetlb-drop-unlikelys-from-hugetlb_fault.patch

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
Subject: mm,hugetlb: drop unlikelys from hugetlb_fault
Date: Mon, 30 Jun 2025 16:42:12 +0200

The unlikely predates an era where we were checking for
hwpoisoned/migration entries prior to checking whether the pte was
present.

Currently, we check for the pte to be a migration/hwpoison entry after we
have checked that is not present, so it must be either one or the other.

Link: https://lkml.kernel.org/r/20250627102904.107202-6-osalvador@suse.de
Link: https://lkml.kernel.org/r/20250630144212.156938-6-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gavin Guo <gavinguo@igalia.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mmhugetlb-drop-unlikelys-from-hugetlb_fault
+++ a/mm/hugetlb.c
@@ -6748,7 +6748,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 
 	/* Not present, either a migration or a hwpoisoned entry */
 	if (!pte_present(vmf.orig_pte)) {
-		if (unlikely(is_hugetlb_entry_migration(vmf.orig_pte))) {
+		if (is_hugetlb_entry_migration(vmf.orig_pte)) {
 			/*
 			 * Release the hugetlb fault lock now, but retain
 			 * the vma lock, because it is needed to guard the
@@ -6759,7 +6759,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			migration_entry_wait_huge(vma, vmf.address, vmf.pte);
 			return 0;
-		} else if (unlikely(is_hugetlb_entry_hwpoisoned(vmf.orig_pte)))
+		} else if (is_hugetlb_entry_hwpoisoned(vmf.orig_pte))
 			ret = VM_FAULT_HWPOISON_LARGE |
 			    VM_FAULT_SET_HINDEX(hstate_index(h));
 		goto out_mutex;
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
mmhugetlb-drop-obsolete-comment-about-non-present-pte-and-second-faults.patch
mmhugetlb-drop-unlikelys-from-hugetlb_fault.patch

