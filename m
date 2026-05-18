Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2655393DCD
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 21:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779139796; cv=none; b=YS+gpXLBb1fjWzd3GYBlGj9jTRMfqhHrwoVGiYjYf0h0+Ls5IDFfaHUuK024pqb6T2H1/SGUYpFm17SAT8TQd9XAkx2qXCSdp6nwQsmbu33ISgd58lGt2VURb/58v0OClMZ8Z+xy2LtDxWfGjh8Z8pep7K7EFFOVoXRyb5sNNTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779139796; c=relaxed/simple;
	bh=qu2ueXzSoNgknj4Cc21oKoo9DRGywHHVkx9U6sS7Zac=;
	h=Date:To:From:Subject:Message-Id; b=TbYwrJJsavdlbptRYgUjzK+onFBr0NQ/ei1IqeJD8NRPhVSmr/NuNrONp7wDLYXPKnCTBgNv9BSHl3lTvXo2/q7pa9AEVlsgr4NUFF3k54Jx+tyQYR89nqEsed81EPp9qx9Hs1+/bkgL2zuBs6H15Lt5jSSfKJdZBJuSMT0XCpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XQuhU/YK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XQuhU/YK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A0D7C2BCB7;
	Mon, 18 May 2026 21:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779139795;
	bh=qu2ueXzSoNgknj4Cc21oKoo9DRGywHHVkx9U6sS7Zac=;
	h=Date:To:From:Subject:From;
	b=XQuhU/YKJucUHeCEQK+Z7SBp6pxFdSLgLedGWq7w0IACcCNVa0QI64Mc26STiUab6
	 ZMBYxGgCqhtauFmUsglgw5sd4ejJ9ZqwQfkZ5sBIf7tAFZcktuGKTHzZgT0BRuo61I
	 REzzVL7BNaxoLL0kyBHdIsPrdX4j7MgJj/3YVKW4=
Date: Mon, 18 May 2026 14:29:54 -0700
To: mm-commits@vger.kernel.org,leon@kernel.org,jgg@ziepe.ca,apopple@nvidia.com,liuqiang@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_hmm-check-alloc_page_vma-return-value.patch added to mm-new branch
Message-Id: <20260518212955.6A0D7C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_hmm: check alloc_page_vma() return value
has been added to the -mm mm-new branch.  Its filename is
     lib-test_hmm-check-alloc_page_vma-return-value.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_hmm-check-alloc_page_vma-return-value.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Qiang Liu <liuqiang@kylinos.cn>
Subject: lib/test_hmm: check alloc_page_vma() return value
Date: Mon, 18 May 2026 11:19:03 +0800

Return VM_FAULT_OOM if page allocation fails, which avoids a NULL pointer
dereference when calling lock_page().

Link: https://lore.kernel.org/20260518031903.63455-1-liuqiangneo@163.com
Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/lib/test_hmm.c~lib-test_hmm-check-alloc_page_vma-return-value
+++ a/lib/test_hmm.c
@@ -1063,6 +1063,17 @@ static vm_fault_t dmirror_devmem_fault_a
 			/* Try with smaller pages if large allocation fails */
 			if (!dpage && order) {
 				dpage = alloc_page_vma(GFP_HIGHUSER_MOVABLE, args->vma, addr);
+				if (!dpage) {
+					/* Unlock and free pages already allocated. */
+					while (i > 0) {
+						struct page *fpage;
+
+						fpage = migrate_pfn_to_page(dst[--i]);
+						unlock_page(fpage);
+						__free_page(fpage);
+					}
+					return VM_FAULT_OOM;
+				}
 				lock_page(dpage);
 				dst[i] = migrate_pfn(page_to_pfn(dpage));
 				dst_page = pfn_to_page(page_to_pfn(dpage));
_

Patches currently in -mm which might be from liuqiang@kylinos.cn are

lib-test_hmm-check-alloc_page_vma-return-value.patch

