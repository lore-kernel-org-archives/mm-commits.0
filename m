Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F05F28467B
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126226; cv=none; b=FqOw1s2CvaxvmZMbf1ZTfrblGn+IZXsHxabuFO5ZfoRlZxsTBWT9q2E6NbYJQ1+ZOOBoemahphZA16k/OfYxUMyNL8no+TN1Wmkma3J3i1zvvQoSRnqJI6txkGNOC0Y1zxZ8XADBiOM+y0EmNUEgJJgQfiJBOjgmn6+J8OuVzfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126226; c=relaxed/simple;
	bh=xgHWFG+cSph3nkKsL0Bxscb+W4dpamSeLbgA65j0I38=;
	h=Date:To:From:Subject:Message-Id; b=nyfUqMzmnp5pnKXhu8f9jehAHyToRu+RoLrhnKSP4qRtS66489r7fsm5nV3CE9ubfrd7GEFR02XTeMtugKqOm3eYvdoq90px0luJ64IsFP8qXkEqXV3HExo5k0cwfOQy5iO7Hng8Q7e7qsW/+jQuE+s7bnGWhHapPSGskRUD0JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JoJ/OI1m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JoJ/OI1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19CEFC4CEE3;
	Thu, 10 Jul 2025 05:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126226;
	bh=xgHWFG+cSph3nkKsL0Bxscb+W4dpamSeLbgA65j0I38=;
	h=Date:To:From:Subject:From;
	b=JoJ/OI1mvGXRMec4fmZkl6xVCQZ3ZF6+iUP4CbXjx4qhTT5kwaRvYO436fjQr2m9I
	 fY5U/8O7/zwMWbVIHMLLNScsfVONA1PL07V8DL0vbdsoYjyYeNocCnWw6Vb2+vNgOu
	 AZ9PLkWW8107qMIT+Yk8EgWo+Xnl2QOYqE0Rl/iE=
Date: Wed, 09 Jul 2025 22:43:45 -0700
To: mm-commits@vger.kernel.org,zhengtangquan@oppo.com,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,osalvador@suse.de,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,dev.jain@arm.com,david@redhat.com,anshuman.khandual@arm.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-use-walk_page_range_vma-instead-of-walk_page_range.patch removed from -mm tree
Message-Id: <20250710054346.19CEFC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: madvise: use walk_page_range_vma() instead of walk_page_range()
has been removed from the -mm tree.  Its filename was
     mm-madvise-use-walk_page_range_vma-instead-of-walk_page_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: madvise: use walk_page_range_vma() instead of walk_page_range()
Date: Thu, 5 Jun 2025 20:31:44 +1200

We've already found the VMA within madvise_walk_vmas() before calling
specific madvise behavior functions like madvise_free_single_vma().  So
calling walk_page_range() and doing find_vma() again seems unnecessary. 
It also prevents potential optimizations in those madvise callbacks,
particularly the use of dedicated per-VMA locking.

[v-songbaohua@oppo.com: revert the walk_page_range_vma change for MADV_GUARD_INSTALL]
  Link: https://lkml.kernel.org/r/20250609105513.10901-1-21cnbao@gmail.com
Link: https://lkml.kernel.org/r/20250605083144.43046-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Tangquan Zheng <zhengtangquan@oppo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/madvise.c~mm-madvise-use-walk_page_range_vma-instead-of-walk_page_range
+++ a/mm/madvise.c
@@ -282,7 +282,7 @@ static long madvise_willneed(struct vm_a
 	*prev = vma;
 #ifdef CONFIG_SWAP
 	if (!file) {
-		walk_page_range(vma->vm_mm, start, end, &swapin_walk_ops, vma);
+		walk_page_range_vma(vma, start, end, &swapin_walk_ops, vma);
 		lru_add_drain(); /* Push any new pages onto the LRU now */
 		return 0;
 	}
@@ -582,7 +582,7 @@ static void madvise_cold_page_range(stru
 	};
 
 	tlb_start_vma(tlb, vma);
-	walk_page_range(vma->vm_mm, addr, end, &cold_walk_ops, &walk_private);
+	walk_page_range_vma(vma, addr, end, &cold_walk_ops, &walk_private);
 	tlb_end_vma(tlb, vma);
 }
 
@@ -620,7 +620,7 @@ static void madvise_pageout_page_range(s
 	};
 
 	tlb_start_vma(tlb, vma);
-	walk_page_range(vma->vm_mm, addr, end, &cold_walk_ops, &walk_private);
+	walk_page_range_vma(vma, addr, end, &cold_walk_ops, &walk_private);
 	tlb_end_vma(tlb, vma);
 }
 
@@ -827,7 +827,7 @@ static int madvise_free_single_vma(struc
 
 	mmu_notifier_invalidate_range_start(&range);
 	tlb_start_vma(tlb, vma);
-	walk_page_range(vma->vm_mm, range.start, range.end,
+	walk_page_range_vma(vma, range.start, range.end,
 			&madvise_free_walk_ops, tlb);
 	tlb_end_vma(tlb, vma);
 	mmu_notifier_invalidate_range_end(&range);
@@ -1246,7 +1246,7 @@ static long madvise_guard_remove(struct
 	if (!is_valid_guard_vma(vma, /* allow_locked = */true))
 		return -EINVAL;
 
-	return walk_page_range(vma->vm_mm, start, end,
+	return walk_page_range_vma(vma, start, end,
 			       &guard_remove_walk_ops, NULL);
 }
 
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are


