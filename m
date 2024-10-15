Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBB020EB;
	Tue, 15 Oct 2024 03:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728961487; cv=none; b=DvCmlbsFLT+W4fapr9EYRaWJ4Bo7YRfeVomL0fNIsEy9yTjGObf1xsS4Xc/Lpm6yGIss09HvkTMS7VRn2ze/8Y4DtWmsTZwKM2ZEhF/XB6izpwY8OdZtV/7JmpzZc80nSBHd2RMgmSax6EHwfaxE/wE66mw9lOusYzkgjvCNPJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728961487; c=relaxed/simple;
	bh=gffqmSkv6/kGn0dAuGk8nzX1sXzyLGvCIr+FvpQfy0I=;
	h=Date:To:From:Subject:Message-Id; b=RI+LONEcWrRuBGp4x17N0RfmIbMnjQl028hbie9k3kw5NaVjtO2jx22higM8xfWrETRZRpo9mDDDlgWxPnnVyUFNLsYHR1I4TJ8DUDjQaLm9UQ2YrWFj+XNn7Fz61wvDHIYVFs4SyfjRWZ3YeObY24nxd6kuIIaFvUrG1EIP1rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qIByKXsN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qIByKXsN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDDDC4CEC3;
	Tue, 15 Oct 2024 03:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728961487;
	bh=gffqmSkv6/kGn0dAuGk8nzX1sXzyLGvCIr+FvpQfy0I=;
	h=Date:To:From:Subject:From;
	b=qIByKXsNV3VXLzeXCV9W/OQgy73yFtfHM36B6tF+V2PF8RzIhDA5FXipmzhFtRAQN
	 Y4iYbMcqGAkytOYXQQSQDp8z75gsTX7U26v3Re54P7IQKtIw5y4+eyV2Q3FKWPIQQL
	 GRmmTQC3DuDBr/vQSVqgCh7xiP0OyjqzujlA8oYA=
Date: Mon, 14 Oct 2024 20:04:46 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,nao.horiguchi@gmail.com,muchun.song@linux.dev,liushixin2@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfile-skip-hugetlb-pages-for-unuse_vma.patch added to mm-hotfixes-unstable branch
Message-Id: <20241015030447.0BDDDC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swapfile: skip HugeTLB pages for unuse_vma
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-swapfile-skip-hugetlb-pages-for-unuse_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapfile-skip-hugetlb-pages-for-unuse_vma.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-swapfile-skip-hugetlb-pages-for-unuse_vma.patch

