Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD947FBA2
	for <mm-commits@vger.kernel.org>; Sat, 29 Nov 2025 18:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764441717; cv=none; b=NHMjJ9nUhu5va36Td50OfnW8XF5rDAsmICzMOtPhXYqA1HHK5T0F/dThMGB4ZBOfqua9nw0Xrbgc1F4J9MJZO8prpQIuhN3a2QvUSEqf75ksbCOipmpXWZgXwq2JEpXLP/46OMwfM0CuY+3zQFEQICEFFz4KuNgBLUA1xqganig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764441717; c=relaxed/simple;
	bh=FuC7C5ymxFpsVYu5YqIHKeu/yMbWf6aEU9tisa+o3EY=;
	h=Date:To:From:Subject:Message-Id; b=LJxQM0GitSq7JXEgNa6t/Q270nA0qOvlepC4ZZAzp1EzIoqv0gZzNR4JncYX9C+BVGS4cWLzNYVdFSPSq9bvKBGXTlW0Bz2k7xem5/AyhTCetiKchIxES2e5Tt9mAZYBk3r/5/duNgbLLCEar/SRfFfjmgt0bixE7beF8V9nPUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2YjMeJiv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2YjMeJiv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D41C4CEF7;
	Sat, 29 Nov 2025 18:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764441717;
	bh=FuC7C5ymxFpsVYu5YqIHKeu/yMbWf6aEU9tisa+o3EY=;
	h=Date:To:From:Subject:From;
	b=2YjMeJivAA4wVpztFojJGD0jWJtYwpixGJW0z4Ts8o+yWpMtRerEteUfCmeDePgNu
	 3xXgxrqoK3YxW9+HgLJvkQBjd1aSAGGdLjtTkTfgk0LYvgnTgZzHyNSAs0TZNOm2F1
	 caNEZ0nS0XbZ20X6ecsSk/oDYP1tiDvwmEQ2hB9Q=
Date: Sat, 29 Nov 2025 10:41:57 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-proc-task_mmuc-fix-make_uffd_wp_huge_pte-huge-pte-handling.patch removed from -mm tree
Message-Id: <20251129184157.91D41C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/task_mmu.c: fix make_uffd_wp_huge_pte() huge pte handling
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmuc-fix-make_uffd_wp_huge_pte-huge-pte-handling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: fs/proc/task_mmu.c: fix make_uffd_wp_huge_pte() huge pte handling
Date: Thu, 27 Nov 2025 17:45:17 +0000

make_uffd_wp_huge_pte() should return after handling a huge_pte_none()
pte.

Link: https://lkml.kernel.org/r/66178124-ebdf-4e23-b8ca-ed3eb8030c81@lucifer.local
Fixes: 03bfbc3ad6e4 ("mm: remove is_hugetlb_entry_[migration, hwpoisoned]()")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Closes: https://lkml.kernel.org/r/dc483db3-be4d-45f7-8b40-a28f5d8f5738@suse.cz
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmuc-fix-make_uffd_wp_huge_pte-huge-pte-handling
+++ a/fs/proc/task_mmu.c
@@ -2500,9 +2500,11 @@ static void make_uffd_wp_huge_pte(struct
 	const unsigned long psize = huge_page_size(hstate_vma(vma));
 	softleaf_t entry;
 
-	if (huge_pte_none(ptent))
+	if (huge_pte_none(ptent)) {
 		set_huge_pte_at(vma->vm_mm, addr, ptep,
 				make_pte_marker(PTE_MARKER_UFFD_WP), psize);
+		return;
+	}
 
 	entry = softleaf_from_pte(ptent);
 	if (softleaf_is_hwpoison(entry) || softleaf_is_marker(entry))
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are


