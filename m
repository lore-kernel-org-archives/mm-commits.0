Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D118633D
	for <mm-commits@vger.kernel.org>; Thu, 19 Dec 2024 03:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734577524; cv=none; b=VxN4kLGJjysleOCiIdwZ7vL//YgIsJJzJF0/bIzZ09br8OKoE+RjsBWzo4D4D+fB+fhXv/Jz69FYVuJvOJT8gILlo1cg0GHkflvrmKQb9XUIBR2FKH5V5MhDMFQvbptXP+zlNy90CSw1vbDo1rUner61xqzpnV6JzVYx9uSyM2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734577524; c=relaxed/simple;
	bh=A6pTHmUZmgVKxbtY4XHcH47ZMCQupflL+mZaoI6xUI8=;
	h=Date:To:From:Subject:Message-Id; b=llgRBgWE2LyKuA83VO+eluVQVxc8Vg9SvKchkpkp2eSOggu4HN1xd7VKeqaN+t/lIfBLlvd1oiwjjTqlMf9Ty9LDJ6MEO6xDXNA68EvNtITZaotD2fA6MiGDm81dDcslykO4K4ANkLjkTyPya3ihnt5swhiAoaWwEWGW8PEB5NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MLQEMShH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MLQEMShH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D568C4CECD;
	Thu, 19 Dec 2024 03:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734577524;
	bh=A6pTHmUZmgVKxbtY4XHcH47ZMCQupflL+mZaoI6xUI8=;
	h=Date:To:From:Subject:From;
	b=MLQEMShH7WUxgRR3xN/YpJlqNtuW4ezXnnwuwvL1M4CwIZzxBimP3lbSfIBMDHq3r
	 dPvXo/fyhHoNG/o1TKuB6y/L2Qt/vwx0RQg5b7fY4OQDGeLZErNEdFj1OsUmzeGDd3
	 +XJAW33BnfJiDmdCi3muIx4qhtjABnDzpYNuGUpA=
Date: Wed, 18 Dec 2024 19:05:23 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-correctly-reference-merged-vma.patch removed from -mm tree
Message-Id: <20241219030524.5D568C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: correctly reference merged VMA
has been removed from the -mm tree.  Its filename was
     mm-correctly-reference-merged-vma.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: correctly reference merged VMA
Date: Fri, 6 Dec 2024 21:52:29 +0000

On second merge attempt on mmap() we incorrectly discard the possibly
merged VMA, resulting in a possible use-after-free (and most certainly a
reference to the wrong VMA) in this instance in the subsequent
__mmap_complete() invocation.

Correct this mistake by reassigning vma correctly if a merge succeeds in
this case.

Link: https://lkml.kernel.org/r/20241206215229.244413-1-lorenzo.stoakes@oracle.com
Fixes: 5ac87a885aec ("mm: defer second attempt at merge on mmap()")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Suggested-by: Jann Horn <jannh@google.com>
Reported-by: syzbot+91cf8da9401355f946c3@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67536a25.050a0220.a30f1.0149.GAE@google.com/
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/vma.c~mm-correctly-reference-merged-vma
+++ a/mm/vma.c
@@ -2460,10 +2460,13 @@ unsigned long __mmap_region(struct file
 
 	/* If flags changed, we might be able to merge, so try again. */
 	if (map.retry_merge) {
+		struct vm_area_struct *merged;
 		VMG_MMAP_STATE(vmg, &map, vma);
 
 		vma_iter_config(map.vmi, map.addr, map.end);
-		vma_merge_existing_range(&vmg);
+		merged = vma_merge_existing_range(&vmg);
+		if (merged)
+			vma = merged;
 	}
 
 	__mmap_complete(&map, vma);
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch
mm-vma-move-brk-internals-to-mm-vmac.patch
mm-vma-move-brk-internals-to-mm-vmac-fix.patch
mm-vma-move-unmapped_area-internals-to-mm-vmac.patch
mm-abstract-get_arg_page-stack-expansion-and-mmap-read-lock.patch
mm-vma-move-stack-expansion-logic-to-mm-vmac.patch
mm-vma-move-__vm_munmap-to-mm-vmac.patch
selftests-mm-add-fork-cow-guard-page-test.patch
mm-enforce-__must_check-on-vma-merge-and-split.patch
mm-perform-all-memfd-seal-checks-in-a-single-place.patch
mm-perform-all-memfd-seal-checks-in-a-single-place-fix.patch
maintainers-update-memory-mapping-section.patch
mm-assert-mmap-write-lock-held-on-do_mmap-mmap_region.patch
mm-add-comments-to-do_mmap-mmap_region-and-vm_mmap.patch
tools-testing-add-simple-__mmap_region-userland-test.patch

