Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFCB82D91
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274608; cv=none; b=LKpfYm8KlJr4RYVe3598Kv+sbc2IXMGrE9Yexm9LaW4ptu7uvEQ/yO9gfmKQSM/7Udbyhf8Hn3AvbuebaAxDC934I5OQ2Oa+Gd7CbL6qIuKX8KLVMNRgjui8mrszyoxvHKd1mD2rsS3l3/N7d3kmYcGvrcbqfRahCiG7/DJ75SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274608; c=relaxed/simple;
	bh=/QHcCaf7RrSYR25BOw2drRDJ3u+sGzmq2kJs04zCDoI=;
	h=Date:To:From:Subject:Message-Id; b=dEJeQjNspI52SeFO6flhQkzDNUqWBJ1CBjWlZ7UjFVc6661nxaEU4HegEtz7sNbxbpXHBqdOwqItyRa4awaXPr73v1oQUcWAz7OKq0AZTzDtli3C7BYnzRm02ew4mIsjSojKvDiC/DvHfxxbBSr4ghwSvO0s7Eylsm3XfXBkFe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fn0IimIF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fn0IimIF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B7EC4CEDD;
	Tue, 18 Mar 2025 05:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274608;
	bh=/QHcCaf7RrSYR25BOw2drRDJ3u+sGzmq2kJs04zCDoI=;
	h=Date:To:From:Subject:From;
	b=fn0IimIFKCGCrfoxbVFfNiEy2nWjby0sOaAAXjsiFXUSemfCNAO+5CL0lB3hn9USp
	 4NodO5LsDyLcQ17TdT/HNqPUFgJ7ajYDnG7Pf9uein7tRaK4PVcSfnNng9hknbebMf
	 YwEy2lSXo+RDB06das0XmFD/bI6eg52UjVY1jdy4=
Date: Mon, 17 Mar 2025 22:10:07 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ryan.roberts@arm.com,david@redhat.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-redundant-return-in-set_huge_zero_folio.patch removed from -mm tree
Message-Id: <20250318051007.E6B7EC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove redundant return in set_huge_zero_folio()
has been removed from the -mm tree.  Its filename was
     mm-remove-redundant-return-in-set_huge_zero_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm: remove redundant return in set_huge_zero_folio()
Date: Thu, 6 Mar 2025 20:13:15 +0530

It is the responsibility of the caller to check pmd_none(); in any case,
we are not achieving anything by returning since there is no return value
to tell the caller that we succeeded or not.  So remove this check.

Link: https://lkml.kernel.org/r/20250306144315.21907-1-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/huge_memory.c~mm-remove-redundant-return-in-set_huge_zero_folio
+++ a/mm/huge_memory.c
@@ -1309,8 +1309,6 @@ static void set_huge_zero_folio(pgtable_
 		struct folio *zero_folio)
 {
 	pmd_t entry;
-	if (!pmd_none(*pmd))
-		return;
 	entry = mk_pmd(&zero_folio->page, vma->vm_page_prot);
 	entry = pmd_mkhuge(entry);
 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
_

Patches currently in -mm which might be from dev.jain@arm.com are


