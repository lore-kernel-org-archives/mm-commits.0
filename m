Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD70619E971;
	Thu,  6 Mar 2025 05:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741239473; cv=none; b=oN9VE8isvYE+RiWDgnk8V3XJL3ZKnhhxY64gBNkaP2h2aSpXcrv0msTik6/+nWY5KVLFwenxDokuyfSGnTj5YcuQJChEAi6wLOanWKGKCfY1Djl2S74HwXPglsDR8Dyv8Kiuqa5sy/UnHrFoVGRZOzXr9w0v1qe4XLgynCOjRUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741239473; c=relaxed/simple;
	bh=V93DcyGj0jCFtgGFQIpnCtMRSaijC4/CPK2U7bcgS1E=;
	h=Date:To:From:Subject:Message-Id; b=K7Sxf8k6sTqQo/EyIEYdijX7bkgvf0JLyekPwjmv2i1cObeA+2U4GKLg2RYPWkr1Kq7Xt6kG4yOGclenLZTqIpxQiPWfxyaJN7kuALnAofqjrTUJUXqLulqNSxZTD/WYMYV9qCQOiaxkmZbnKjR0MKfGa9ym9zqSpBUoKZxk2f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xJoOiHC0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xJoOiHC0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5176C4CEE4;
	Thu,  6 Mar 2025 05:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741239473;
	bh=V93DcyGj0jCFtgGFQIpnCtMRSaijC4/CPK2U7bcgS1E=;
	h=Date:To:From:Subject:From;
	b=xJoOiHC0wLeIlkb9ErgLJ1Lg05BT/W4Vua+hJ7q74Zeb3ORSjW4KYEHlnZsLq4Bo7
	 8fze1t9GolfmM+F88iBYhmI5n8bOgFPACq4T253uPjErJtTHZJE21fb0PEdk9RFIuY
	 DMUGNdbZRAHy0EU1pREbgWPYfygoQ3h7iLYmZZII=
Date: Wed, 05 Mar 2025 21:37:53 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,wangkefeng.wang@huawei.com,surenb@google.com,stable@vger.kernel.org,mmaslanka@google.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,bgeffon@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-finish_fault-handling-for-large-folios.patch removed from -mm tree
Message-Id: <20250306053753.A5176C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix finish_fault() handling for large folios
has been removed from the -mm tree.  Its filename was
     mm-fix-finish_fault-handling-for-large-folios.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brian Geffon <bgeffon@google.com>
Subject: mm: fix finish_fault() handling for large folios
Date: Wed, 26 Feb 2025 11:23:41 -0500

When handling faults for anon shmem finish_fault() will attempt to install
ptes for the entire folio.  Unfortunately if it encounters a single
non-pte_none entry in that range it will bail, even if the pte that
triggered the fault is still pte_none.  When this situation happens the
fault will be retried endlessly never making forward progress.

This patch fixes this behavior and if it detects that a pte in the range
is not pte_none it will fall back to setting a single pte.

[bgeffon@google.com: tweak whitespace]
  Link: https://lkml.kernel.org/r/20250227133236.1296853-1-bgeffon@google.com
Link: https://lkml.kernel.org/r/20250226162341.915535-1-bgeffon@google.com
Fixes: 43e027e41423 ("mm: memory: extend finish_fault() to support large folio")
Signed-off-by: Brian Geffon <bgeffon@google.com>
Suggested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reported-by: Marek Maslanka <mmaslanka@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/mm/memory.c~mm-fix-finish_fault-handling-for-large-folios
+++ a/mm/memory.c
@@ -5185,7 +5185,11 @@ vm_fault_t finish_fault(struct vm_fault
 	bool is_cow = (vmf->flags & FAULT_FLAG_WRITE) &&
 		      !(vma->vm_flags & VM_SHARED);
 	int type, nr_pages;
-	unsigned long addr = vmf->address;
+	unsigned long addr;
+	bool needs_fallback = false;
+
+fallback:
+	addr = vmf->address;
 
 	/* Did we COW the page? */
 	if (is_cow)
@@ -5224,7 +5228,8 @@ vm_fault_t finish_fault(struct vm_fault
 	 * approach also applies to non-anonymous-shmem faults to avoid
 	 * inflating the RSS of the process.
 	 */
-	if (!vma_is_anon_shmem(vma) || unlikely(userfaultfd_armed(vma))) {
+	if (!vma_is_anon_shmem(vma) || unlikely(userfaultfd_armed(vma)) ||
+	    unlikely(needs_fallback)) {
 		nr_pages = 1;
 	} else if (nr_pages > 1) {
 		pgoff_t idx = folio_page_idx(folio, page);
@@ -5260,9 +5265,9 @@ vm_fault_t finish_fault(struct vm_fault
 		ret = VM_FAULT_NOPAGE;
 		goto unlock;
 	} else if (nr_pages > 1 && !pte_range_none(vmf->pte, nr_pages)) {
-		update_mmu_tlb_range(vma, addr, vmf->pte, nr_pages);
-		ret = VM_FAULT_NOPAGE;
-		goto unlock;
+		needs_fallback = true;
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+		goto fallback;
 	}
 
 	folio_ref_add(folio, nr_pages - 1);
_

Patches currently in -mm which might be from bgeffon@google.com are


