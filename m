Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E5276F17
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103335; cv=none; b=qYCoCIWxbdnJwrCrfXHHgrP/kBylu+i6sFjoQ7tjXplxhCVq6mO44oXF8SJiHl9984YXxQRIXOKnH6QKS2+LHLKzihNe0UycUF4ilSQig8YAgWhabKP/toe+YKqpWlbXAEBis8bKGap/vShiBuT3HCB3aHNSZnX7P1w032Ufm5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103335; c=relaxed/simple;
	bh=OJMqZtrHRPYCsQ4j9ioFiVztfzxheQ7r6s0naJtD18g=;
	h=Date:To:From:Subject:Message-Id; b=LEE1kOg/+OY6xjv+uVOxksgY78w/jI5NoYyTIIt3UAjjftJ4uXZd+u+HD6NjaT1QWcomHPZTBCWO1fySMoU8c4nN04mLjUqmUHNxIqvHLti8tD2vFwQ8vSmJkATf3nHdth9Er8qtcV9zd0dASURBHldHbSbEghN9bwJiRXHGS4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yq1+3keC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yq1+3keC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A828C113CD;
	Fri, 26 Apr 2024 03:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103335;
	bh=OJMqZtrHRPYCsQ4j9ioFiVztfzxheQ7r6s0naJtD18g=;
	h=Date:To:From:Subject:From;
	b=Yq1+3keCzFWT+nYBFGU27PXWqSscHOctp5fT4wID53KJGHKM5ZXvHQNCjMC1YL9YH
	 OpP6dc03/YbPq1GfV/5YOsIUTMx4DSZsRhxpuFbPdZQduTpUmqkHRseGgGlISYDa/3
	 L5cFFFe6rggzqjCkE9Oqf0Ak1gWvxY1sh+YZJte8=
Date: Thu, 25 Apr 2024 20:48:54 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,osalvador@suse.de,muchun.song@linux.dev,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] hugetlb-convert-hugetlb_no_page-to-use-struct-vm_fault-fix.patch removed from -mm tree
Message-Id: <20240426034855.0A828C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb: simplify hugetlb_no_page() arguments
has been removed from the -mm tree.  Its filename was
     hugetlb-convert-hugetlb_no_page-to-use-struct-vm_fault-fix.patch

This patch was dropped because it was folded into hugetlb-convert-hugetlb_no_page-to-use-struct-vm_fault.patch

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: hugetlb: simplify hugetlb_no_page() arguments
Date: Mon, 8 Apr 2024 10:17:54 -0700

To simplify the function arguments, as suggested by Oscar and Muchun.

Link: https://lkml.kernel.org/r/ZhQtN8y5zud8iI1u@fedora
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Suggested-by: Muchun Song <muchun.song@linux.dev>
Suggested-by: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~hugetlb-convert-hugetlb_no_page-to-use-struct-vm_fault-fix
+++ a/mm/hugetlb.c
@@ -6188,11 +6188,11 @@ static bool hugetlb_pte_stable(struct hs
 	return same;
 }
 
-static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
-			struct vm_area_struct *vma,
-			struct address_space *mapping,
+static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 			struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
+	struct mm_struct *mm = vma->vm_mm;
 	struct hstate *h = hstate_vma(vma);
 	vm_fault_t ret = VM_FAULT_SIGBUS;
 	int anon_rmap = 0;
@@ -6489,7 +6489,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 		 * hugetlb_no_page will drop vma lock and hugetlb fault
 		 * mutex internally, which make us return immediately.
 		 */
-		return hugetlb_no_page(mm, vma, mapping, &vmf);
+		return hugetlb_no_page(mapping, &vmf);
 	}
 
 	ret = 0;
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

hugetlb-convert-hugetlb_fault-to-use-struct-vm_fault.patch
hugetlb-convert-hugetlb_no_page-to-use-struct-vm_fault.patch
hugetlb-convert-hugetlb_wp-to-use-struct-vm_fault.patch
hugetlb-convert-hugetlb_wp-to-use-struct-vm_fault-fix.patch

