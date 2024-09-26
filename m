Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB88613CABC
	for <mm-commits@vger.kernel.org>; Thu, 26 Sep 2024 20:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727382763; cv=none; b=FPnEP3l9SbEfy3FuvLirUbbajPXSQ7No62lRLetRh0bYvwNzwYzXfsqgRIpbTCkgUm+C5csHu8wck0C1lo5Pja9rZqlq389HyiCK1aUKm/lZYW1v+ivEEsr/Ue0NeROULWPvu4R4JK0y1FTJPcqTH0BBpO76YtnNzrQLvLzYSUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727382763; c=relaxed/simple;
	bh=lJOuqc9HzmNqUh7kZo3uTelbg09+ypdBNm+WgrQAvvM=;
	h=Date:To:From:Subject:Message-Id; b=jq9Wuc20OrxpL1iXrA6mm6PfiaUu3Cq/bdGFVECc5vYkxmkRgcuwF9Pp8eNnbbEjJMpt0H+N6jt/a0R0GFu86Np04Urt6a76Jl2Qw85H+EgxFBKz5zi9IB6GqDFzipWiZnjt3MMH2XfDg5ru/M8UAmlEszyMhIMqHnPPXyEZHTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xyqBufXD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xyqBufXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF339C4CEC5;
	Thu, 26 Sep 2024 20:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727382762;
	bh=lJOuqc9HzmNqUh7kZo3uTelbg09+ypdBNm+WgrQAvvM=;
	h=Date:To:From:Subject:From;
	b=xyqBufXDkm4YySVqrLRmwJ6BzQ+D3AFVmqdafrW8uRmt5uKlc4cXfINYWLaZMG3S+
	 4E3E/NpHTZcQy00IgY1Mjw7ktJoHDTW4PUUPFkmlbAkVeJQcar3fiPsbyLHA+nnect
	 kvmKWmBQBBCvOsGegwAWOYjalckguxXwf6LvUcPY=
Date: Thu, 26 Sep 2024 13:32:42 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,david@redhat.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-move_ptes-use-pte_offset_map_rw_nolock.patch added to mm-unstable branch
Message-Id: <20240926203242.BF339C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mremap: move_ptes() use pte_offset_map_rw_nolock()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mremap-move_ptes-use-pte_offset_map_rw_nolock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-move_ptes-use-pte_offset_map_rw_nolock.patch

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: mremap: move_ptes() use pte_offset_map_rw_nolock()
Date: Thu, 26 Sep 2024 14:46:22 +0800

In move_ptes(), we may modify the new_pte after acquiring the new_ptl, so
convert it to using pte_offset_map_rw_nolock().  Now new_pte is none, so
hpage_collapse_scan_file() path can not find this by traversing
file->f_mapping, so there is no concurrency with retract_page_tables(). 
In addition, we already hold the exclusive mmap_lock, so this new_pte page
is stable, so there is no need to get pmdval and do pmd_same() check.

Link: https://lkml.kernel.org/r/9d582a09dbcf12e562ac5fe0ba05e9248a58f5e0.1727332572.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/mm/mremap.c~mm-mremap-move_ptes-use-pte_offset_map_rw_nolock
+++ a/mm/mremap.c
@@ -143,6 +143,7 @@ static int move_ptes(struct vm_area_stru
 	spinlock_t *old_ptl, *new_ptl;
 	bool force_flush = false;
 	unsigned long len = old_end - old_addr;
+	pmd_t dummy_pmdval;
 	int err = 0;
 
 	/*
@@ -175,7 +176,15 @@ static int move_ptes(struct vm_area_stru
 		err = -EAGAIN;
 		goto out;
 	}
-	new_pte = pte_offset_map_nolock(mm, new_pmd, new_addr, &new_ptl);
+	/*
+	 * Now new_pte is none, so hpage_collapse_scan_file() path can not find
+	 * this by traversing file->f_mapping, so there is no concurrency with
+	 * retract_page_tables(). In addition, we already hold the exclusive
+	 * mmap_lock, so this new_pte page is stable, so there is no need to get
+	 * pmdval and do pmd_same() check.
+	 */
+	new_pte = pte_offset_map_rw_nolock(mm, new_pmd, new_addr, &dummy_pmdval,
+					   &new_ptl);
 	if (!new_pte) {
 		pte_unmap_unlock(old_pte, old_ptl);
 		err = -EAGAIN;
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-pgtable-introduce-pte_offset_map_rorw_nolock.patch
powerpc-assert_pte_locked-use-pte_offset_map_ro_nolock.patch
mm-filemap-filemap_fault_recheck_pte_none-use-pte_offset_map_ro_nolock.patch
mm-khugepaged-__collapse_huge_page_swapin-use-pte_offset_map_ro_nolock.patch
arm-adjust_pte-use-pte_offset_map_rw_nolock.patch
mm-handle_pte_fault-use-pte_offset_map_rw_nolock.patch
mm-khugepaged-collapse_pte_mapped_thp-use-pte_offset_map_rw_nolock.patch
mm-copy_pte_range-use-pte_offset_map_rw_nolock.patch
mm-mremap-move_ptes-use-pte_offset_map_rw_nolock.patch
mm-page_vma_mapped_walk-map_pte-use-pte_offset_map_rw_nolock.patch
mm-userfaultfd-move_pages_pte-use-pte_offset_map_rw_nolock.patch
mm-multi-gen-lru-walk_pte_range-use-pte_offset_map_rw_nolock.patch
mm-pgtable-remove-pte_offset_map_nolock.patch

