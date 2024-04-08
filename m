Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F5D145321
	for <mm-commits@vger.kernel.org>; Mon,  8 Apr 2024 19:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712604885; cv=none; b=YkTBIXqPcBc3SWaGh/KzrxvkBpfQwJp9G4J1FS+cpkln6Dqn5sbZRdVdTbYO/A2egItvwb+Hkb+54S63hWIxNUm1tOJUVLZkPoIbSpYGvktJJ/FBFJPKgh0HWmPbdIN4dnKxSMtV2Z6o1EjG8zBn1CzMNtVInN57EY/w99BH7t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712604885; c=relaxed/simple;
	bh=l0dzoHS+K/QWREPExLyIETMfSWNhM5DFa+7yjeH+3m8=;
	h=Date:To:From:Subject:Message-Id; b=taZqe9tZSZCyNvcA7QSFA+lGIxOvUeq2sV9GK0NrCFIudfRekEqLoJEfHHLFbp9s2h8hfqFLBqxwdXKkxWfwQ+6d/IkCuLYiIyp2CnykpQDfasIQOGx/UZMbezGoX4ccDDWKjZgVZc52eE1I9ye8GmRXimIJmzKYKdU/NLMmLd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xoaxqtSr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xoaxqtSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305D3C433F1;
	Mon,  8 Apr 2024 19:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712604885;
	bh=l0dzoHS+K/QWREPExLyIETMfSWNhM5DFa+7yjeH+3m8=;
	h=Date:To:From:Subject:From;
	b=xoaxqtSr2hX/r0HrzAB8nAZEPEa0LM+Hoypa1yRCmAv9bytqIoFemE9/2XxMf87Ca
	 gFaIjiOkUVgUrt4ZKjnuUW6eufzoDYmZubRXUNIaGyMGU0Jvpzs6pM5XWxeVpbvR+M
	 hWt+ZiwLK+duh7IArhP0E1szgkbbR3tMwMukRRdw=
Date: Mon, 08 Apr 2024 12:34:44 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,osalvador@suse.de,muchun.song@linux.dev,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-convert-hugetlb_no_page-to-use-struct-vm_fault-fix.patch added to mm-unstable branch
Message-Id: <20240408193445.305D3C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: simplify hugetlb_no_page() arguments
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-convert-hugetlb_no_page-to-use-struct-vm_fault-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-convert-hugetlb_no_page-to-use-struct-vm_fault-fix.patch

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
@@ -6185,11 +6185,11 @@ static bool hugetlb_pte_stable(struct hs
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
@@ -6483,7 +6483,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
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
hugetlb-convert-hugetlb_no_page-to-use-struct-vm_fault-fix.patch
hugetlb-convert-hugetlb_wp-to-use-struct-vm_fault.patch

