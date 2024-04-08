Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B3F1272C4
	for <mm-commits@vger.kernel.org>; Mon,  8 Apr 2024 20:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712606602; cv=none; b=jdCTDFe93NG1bLBHwJgJzux54+2iCdfiifgRbOTiJH1LuLeun8UcJ364qZtN58t3+W3klVx5rm5eMiXgNPVFDXEqDyyj2F48OD6RxEte1OAbaEmZAm7g/CUMB4QSGCw3UEk4L1VN0fIS5z4qZAmmN/an3sqpBRAzx11GUMbY7ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712606602; c=relaxed/simple;
	bh=zVRF7St6DBN9sb2v0No1Aa8DtrXDE3cn0p3Sc+xHQpA=;
	h=Date:To:From:Subject:Message-Id; b=gsS/cNG7eLX3y3kFHHPMLwA5tL6TZC7kw58dCQqrvBhRYijuYBPenPloJb+JUEzfD2Wb8VtSnvJinMmyP3O0I1qLPcaBoqlBKC+ELX4y8zKoO0H3HTStef2D3KUk3NHrZE5PQc5+FNB/P8zvrlds55t0Z5Uch4KCy8C9JpLEyso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xirV6PMO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xirV6PMO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527B3C433C7;
	Mon,  8 Apr 2024 20:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712606602;
	bh=zVRF7St6DBN9sb2v0No1Aa8DtrXDE3cn0p3Sc+xHQpA=;
	h=Date:To:From:Subject:From;
	b=xirV6PMOHdBzwJh8kJvd6VZnNy3EQtqc/8/MdiN7gxjkaMIQUWSH76ISAlpq0Z3Qk
	 mCdD5vLNMOqzB/Rp2TqPYMZUnzJPwgeDlfEhrVoIB39sot/HBTBCEhTucsCq4VSW04
	 Spc12X26MKK6jGnp2T/plXRXavMPpV2HQ7RwzSZg=
Date: Mon, 08 Apr 2024 13:03:21 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,osalvador@suse.de,muchun.song@linux.dev,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-convert-hugetlb_wp-to-use-struct-vm_fault-fix.patch added to mm-unstable branch
Message-Id: <20240408200322.527B3C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: Simplify hugetlb_wp() arguments
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-convert-hugetlb_wp-to-use-struct-vm_fault-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-convert-hugetlb_wp-to-use-struct-vm_fault-fix.patch

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
Subject: hugetlb: Simplify hugetlb_wp() arguments
Date: Mon, 8 Apr 2024 10:21:44 -0700

simplify the function arguments, per Oscar and Muchun.

Link: https://lkml.kernel.org/r/ZhQtoFNZBNwBCeXn@fedora
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Suggested-by: Muchun Song <muchun.song@linux.dev>
Suggested-by: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~hugetlb-convert-hugetlb_wp-to-use-struct-vm_fault-fix
+++ a/mm/hugetlb.c
@@ -5915,10 +5915,11 @@ static void unmap_ref_private(struct mm_
  * cannot race with other handlers or page migration.
  * Keep the pte_same checks anyway to make transition from the mutex easier.
  */
-static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
-		       struct folio *pagecache_folio,
+static vm_fault_t hugetlb_wp(struct folio *pagecache_folio,
 		       struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
+	struct mm_struct *mm = vma->vm_mm;
 	const bool unshare = vmf->flags & FAULT_FLAG_UNSHARE;
 	pte_t pte = huge_ptep_get(vmf->pte);
 	struct hstate *h = hstate_vma(vma);
@@ -6364,7 +6365,7 @@ static vm_fault_t hugetlb_no_page(struct
 	hugetlb_count_add(pages_per_huge_page(h), mm);
 	if ((vmf->flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED)) {
 		/* Optimization, do the COW without a second fault */
-		ret = hugetlb_wp(mm, vma, folio, vmf);
+		ret = hugetlb_wp(folio, vmf);
 	}
 
 	spin_unlock(vmf->ptl);
@@ -6577,7 +6578,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 
 	if (flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)) {
 		if (!huge_pte_write(vmf.orig_pte)) {
-			ret = hugetlb_wp(mm, vma, pagecache_folio, &vmf);
+			ret = hugetlb_wp(pagecache_folio, &vmf);
 			goto out_put_page;
 		} else if (likely(flags & FAULT_FLAG_WRITE)) {
 			vmf.orig_pte = huge_pte_mkdirty(vmf.orig_pte);
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

hugetlb-convert-hugetlb_fault-to-use-struct-vm_fault.patch
hugetlb-convert-hugetlb_no_page-to-use-struct-vm_fault.patch
hugetlb-convert-hugetlb_no_page-to-use-struct-vm_fault-fix.patch
hugetlb-convert-hugetlb_wp-to-use-struct-vm_fault.patch
hugetlb-convert-hugetlb_wp-to-use-struct-vm_fault-fix.patch

