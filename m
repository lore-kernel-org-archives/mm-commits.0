Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364F81CBE9E;
	Thu, 17 Oct 2024 07:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729150145; cv=none; b=SrJvMwmYY/lYV6ppxvXlI6bluHsjuM/Yy0fmd/K85jXdJz/f7950CgXo/Ker8PyZck0ZECG1IynzjbtwRx2VUF3AFftw/HG58IhQAeZPicPjKCe3hlYCz5KFpRHTLXpCCnucNmr7IK9neYQ28eN4GPUou0g03ou8GGp43G3ktgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729150145; c=relaxed/simple;
	bh=sOXILtF7E1xsWYLmT1amA6XU2CK/o/Xg8iavkM+an5g=;
	h=Date:To:From:Subject:Message-Id; b=g/RScCVI1dcjVbviguNtBbwWdZfOHrBErHB3ZkSy+qjGDWmTzfg0QwT2wzyQGeoL8VOg+Otk+RP7OtNA6dTv+vXO50/auB2Oh2h7m00aue27RhGrzO2WNsHpZh0RSjUynZdb2Jl1VTForR1kLZHgwtYXFR66NXMa8eH4KYD6OQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qGlVEztw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qGlVEztw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A884C4CEC3;
	Thu, 17 Oct 2024 07:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729150145;
	bh=sOXILtF7E1xsWYLmT1amA6XU2CK/o/Xg8iavkM+an5g=;
	h=Date:To:From:Subject:From;
	b=qGlVEztw3Fyv+Sp7+7r1I7yXb96SMkonEHYwYwP0go2V9thOAmNraxj8m7McRau3L
	 cua0GBexJIKarK4pJt8VoZZ9AlCLUWvyZq98L5vvvyruFMBMmOfh6aRdQtKtMIESIU
	 Gx/w5XvKtG/lQVPHszgM3zX7JldDcJejhBttU1sE=
Date: Thu, 17 Oct 2024 00:29:04 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,nao.horiguchi@gmail.com,muchun.song@linux.dev,liushixin2@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-swapfile-skip-hugetlb-pages-for-unuse_vma.patch removed from -mm tree
Message-Id: <20241017072905.0A884C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swapfile: skip HugeTLB pages for unuse_vma
has been removed from the -mm tree.  Its filename was
     mm-swapfile-skip-hugetlb-pages-for-unuse_vma.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/swapfile: skip HugeTLB pages for unuse_vma
Date: Tue, 15 Oct 2024 09:45:21 +0800

I got a bad pud error and lost a 1GB HugeTLB when calling swapoff.  The
problem can be reproduced by the following steps:

 1. Allocate an anonymous 1GB HugeTLB and some other anonymous memory.
 2. Swapout the above anonymous memory.
 3. run swapoff and we will get a bad pud error in kernel message:

  mm/pgtable-generic.c:42: bad pud 00000000743d215d(84000001400000e7)

We can tell that pud_clear_bad is called by pud_none_or_clear_bad in
unuse_pud_range() by ftrace.  And therefore the HugeTLB pages will never
be freed because we lost it from page table.  We can skip HugeTLB pages
for unuse_vma to fix it.

Link: https://lkml.kernel.org/r/20241015014521.570237-1-liushixin2@huawei.com
Fixes: 0fe6e20b9c4c ("hugetlb, rmap: add reverse mapping for hugepage")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swapfile-skip-hugetlb-pages-for-unuse_vma
+++ a/mm/swapfile.c
@@ -2313,7 +2313,7 @@ static int unuse_mm(struct mm_struct *mm
 
 	mmap_read_lock(mm);
 	for_each_vma(vmi, vma) {
-		if (vma->anon_vma) {
+		if (vma->anon_vma && !is_vm_hugetlb_page(vma)) {
 			ret = unuse_vma(vma, type);
 			if (ret)
 				break;
_

Patches currently in -mm which might be from liushixin2@huawei.com are


