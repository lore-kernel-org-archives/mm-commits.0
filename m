Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2A4142E86
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854731; cv=none; b=Tb6IMpk7xcqDOozh5mjeEdHoJ9diWEAF/z30u/x8S2ke7mGIeGZFUbSh9NtMHmsGNkSi6chy7KR5i1jC6e1tSuMEwa8Ptdz9nU1NWto/QEKPYwvzlRU86zkyTevd73R9t3UMNIOVw3YBuDm3R7yKm9Fn1CohWI5UBUmbxvxSsxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854731; c=relaxed/simple;
	bh=Duwx6FaS3zowCguOiIQnCMIULEMxNVQilR7n/SVfr9M=;
	h=Date:To:From:Subject:Message-Id; b=pMBFWZSB6wrot7DPGPF2Gy+EZ1lolKN7OhaO1VKPgyXO4890vK8DThjeoO940d7uUguPLEdSoAsB0ozCZDurJAr1oSy+tqLPq+8usMBY7l1QrtgHWapi53wNDi5PccYv3iYeMfbkwRIZq4U9/Jmu5zTIbV0YzOGkh1hiCRX1npk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0/o95x6B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0/o95x6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A1EC4CECF;
	Wed,  6 Nov 2024 00:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854731;
	bh=Duwx6FaS3zowCguOiIQnCMIULEMxNVQilR7n/SVfr9M=;
	h=Date:To:From:Subject:From;
	b=0/o95x6Bx1MRlQLnzsweG6bbwJkcqhZfoAcbGglQ04i12KHQAZ0wGJXkzJuMSkfj0
	 YkO9Jdp7yP77j7H35gNDN/cyfjIb2seJPCX75lxUJVy1bBMSU7zjjmVML/KubMNIDd
	 GniYrtaJ9LVVv06d5Rkh0mezeSxsoZoJsP0EwHaM=
Date: Tue, 05 Nov 2024 16:58:50 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,david@redhat.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-handle_pte_fault-use-pte_offset_map_rw_nolock.patch removed from -mm tree
Message-Id: <20241106005850.E5A1EC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: handle_pte_fault() use pte_offset_map_rw_nolock()
has been removed from the -mm tree.  Its filename was
     mm-handle_pte_fault-use-pte_offset_map_rw_nolock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: handle_pte_fault() use pte_offset_map_rw_nolock()
Date: Thu, 26 Sep 2024 14:46:19 +0800

In handle_pte_fault(), we may modify the vmf->pte after acquiring the
vmf->ptl, so convert it to using pte_offset_map_rw_nolock().  But since we
will do the pte_same() check, so there is no need to get pmdval to do
pmd_same() check, just pass a dummy variable to it.

Link: https://lkml.kernel.org/r/af8d694853b44c5a6018403ae435440e275854c7.1727332572.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-handle_pte_fault-use-pte_offset_map_rw_nolock
+++ a/mm/memory.c
@@ -5742,14 +5742,24 @@ static vm_fault_t handle_pte_fault(struc
 		vmf->pte = NULL;
 		vmf->flags &= ~FAULT_FLAG_ORIG_PTE_VALID;
 	} else {
+		pmd_t dummy_pmdval;
+
 		/*
 		 * A regular pmd is established and it can't morph into a huge
 		 * pmd by anon khugepaged, since that takes mmap_lock in write
 		 * mode; but shmem or file collapse to THP could still morph
 		 * it into a huge pmd: just retry later if so.
+		 *
+		 * Use the maywrite version to indicate that vmf->pte may be
+		 * modified, but since we will use pte_same() to detect the
+		 * change of the !pte_none() entry, there is no need to recheck
+		 * the pmdval. Here we chooes to pass a dummy variable instead
+		 * of NULL, which helps new user think about why this place is
+		 * special.
 		 */
-		vmf->pte = pte_offset_map_nolock(vmf->vma->vm_mm, vmf->pmd,
-						 vmf->address, &vmf->ptl);
+		vmf->pte = pte_offset_map_rw_nolock(vmf->vma->vm_mm, vmf->pmd,
+						    vmf->address, &dummy_pmdval,
+						    &vmf->ptl);
 		if (unlikely(!vmf->pte))
 			return 0;
 		vmf->orig_pte = ptep_get_lockless(vmf->pte);
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


