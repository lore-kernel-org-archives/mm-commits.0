Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96ED81EF38E
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450042; cv=none; b=fugGITqpEJXA6CmWNk66lJT4hcm1evdMl1rkpcA2WObua86awlRkR+F6f9uO/248O9Zy8F3Z61WvFZhDMJhipCqJ4mdzXt7l5Uc1JEpzVq6wvlXBuIRSTXkLJJCOB4R3PglkHf+DtxUgbXRamz66CRUUIpSLBgU8BMs6fSgAT58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450042; c=relaxed/simple;
	bh=hVfXYbXtaGRyCuj84P9ovQ0t0xLC3MQN9mw2QR8IYsI=;
	h=Date:To:From:Subject:Message-Id; b=rQKwWSYSyHnqafYr2d1JLdzfSMhTI3m0XCror23wEBn/uQyX+vB0pDr+7leKqE+6lt+zqZbeQ52aTtpVVE5AAzjsc4c+DfhkvXsZOqF/9e7YoEP7xo1yPJjw6T6H0l5FtrCVy1Gx5ivm5RN0LDL1pcPQHrb7LSpXMHF5dJugBo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oKfoY6ZS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oKfoY6ZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA85C4CEE3;
	Sun, 13 Jul 2025 23:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450042;
	bh=hVfXYbXtaGRyCuj84P9ovQ0t0xLC3MQN9mw2QR8IYsI=;
	h=Date:To:From:Subject:From;
	b=oKfoY6ZSIe7X1Pz+ehxJlSfMCh/QNuPiaXYIqGst8gPuGLnkF/VbiGtrQkMbqtxc0
	 wNO7zOif2ta7yeBMQHwRxyu1/EE1QN32znQBWmzfDDgLLPwdiPmwUUzgKWzmYK7M4Z
	 gKwfyRcKFPvXNZY+U0BNZdK/du07Jkd+fzrGcqJs=
Date: Sun, 13 Jul 2025 16:40:41 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,muchun.song@linux.dev,gavinguo@igalia.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmhugetlb-drop-unlikelys-from-hugetlb_fault.patch removed from -mm tree
Message-Id: <20250713234042.6AA85C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm,hugetlb: drop unlikelys from hugetlb_fault
has been removed from the -mm tree.  Its filename was
     mmhugetlb-drop-unlikelys-from-hugetlb_fault.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Gavin Guo <gavinguo@igalia.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mmhugetlb-drop-unlikelys-from-hugetlb_fault
+++ a/mm/hugetlb.c
@@ -6729,7 +6729,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 
 	/* Not present, either a migration or a hwpoisoned entry */
 	if (!pte_present(vmf.orig_pte)) {
-		if (unlikely(is_hugetlb_entry_migration(vmf.orig_pte))) {
+		if (is_hugetlb_entry_migration(vmf.orig_pte)) {
 			/*
 			 * Release the hugetlb fault lock now, but retain
 			 * the vma lock, because it is needed to guard the
@@ -6740,7 +6740,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
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


