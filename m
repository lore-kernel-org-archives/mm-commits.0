Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163FD8C07
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600528; cv=none; b=Gol1JNAjQM9eaV3Z3pqIYF27YOvQuo2pyWatHB2TIu1qzvZNTJUDoJzGsnovFi+ODf2c71d5qw+h8oAMrs0BZvHJfoRy3YFDYbaEaVPiXLKzZOojpgu4goUalZyMUdctjgey9x7YO2DOW5WEN34BhszB3+7mKgSapcUmfP0mV9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600528; c=relaxed/simple;
	bh=eTuKePRa3KCRCYlRA6iUxXtG0FWWW0Z+lgKs4j5LevY=;
	h=Date:To:From:Subject:Message-Id; b=Uz8scE8QNLsBQxXY55J6OoGxipnfws2O2TLxHMrLCPSyVbiSghtkGJyfwcpyuJ6j9ZrKrubPZFVgCNoTWq2En0uLHszVI768oyFlcEdnsFJpJiLyib1aytBIEw2f8XN0U9YpfTQDbL4DetIDr0cN3BZDBqAyGoCQl/WIcbvV/Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TIH0P8Pc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TIH0P8Pc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD47EC433F1;
	Tue,  5 Mar 2024 01:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600528;
	bh=eTuKePRa3KCRCYlRA6iUxXtG0FWWW0Z+lgKs4j5LevY=;
	h=Date:To:From:Subject:From;
	b=TIH0P8Pc5EDqtnutnk43+SRwLp5jK7sqQfbY8h2w9dY4uC1RTYfkhr/zMj6hfy53f
	 4y6F2AS/Sp70ueVeNwX8yUFjN35LA7xKverjiCf8NHQoEZCUE7jnaar7ek1OW8qBRa
	 VhFdkl7Mce1t11OFQ79Un+l3nCRchV3kLn61htXs=
Date: Mon, 04 Mar 2024 17:02:07 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,muchun.song@linux.dev,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-use-vmf_anon_prepare-instead-of-anon_vma_prepare.patch removed from -mm tree
Message-Id: <20240305010207.DD47EC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb: use vmf_anon_prepare() instead of anon_vma_prepare()
has been removed from the -mm tree.  Its filename was
     hugetlb-use-vmf_anon_prepare-instead-of-anon_vma_prepare.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: hugetlb: use vmf_anon_prepare() instead of anon_vma_prepare()
Date: Wed, 21 Feb 2024 15:47:31 -0800

hugetlb_no_page() and hugetlb_wp() call anon_vma_prepare().  In
preparation for hugetlb to safely handle faults under the VMA lock, use
vmf_anon_prepare() here instead.

Additionally, passing hugetlb_wp() the vm_fault struct from
hugetlb_fault() works toward cleaning up the hugetlb code and function
stack.

Link: https://lkml.kernel.org/r/20240221234732.187629-5-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/hugetlb.c~hugetlb-use-vmf_anon_prepare-instead-of-anon_vma_prepare
+++ a/mm/hugetlb.c
@@ -5851,7 +5851,8 @@ static void unmap_ref_private(struct mm_
  */
 static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
 		       unsigned long address, pte_t *ptep, unsigned int flags,
-		       struct folio *pagecache_folio, spinlock_t *ptl)
+		       struct folio *pagecache_folio, spinlock_t *ptl,
+		       struct vm_fault *vmf)
 {
 	const bool unshare = flags & FAULT_FLAG_UNSHARE;
 	pte_t pte = huge_ptep_get(ptep);
@@ -5985,10 +5986,9 @@ retry_avoidcopy:
 	 * When the original hugepage is shared one, it does not have
 	 * anon_vma prepared.
 	 */
-	if (unlikely(anon_vma_prepare(vma))) {
-		ret = VM_FAULT_OOM;
+	ret = vmf_anon_prepare(vmf);
+	if (unlikely(ret))
 		goto out_release_all;
-	}
 
 	if (copy_user_large_folio(new_folio, old_folio, address, vma)) {
 		ret = VM_FAULT_HWPOISON_LARGE;
@@ -6228,10 +6228,10 @@ static vm_fault_t hugetlb_no_page(struct
 			new_pagecache_folio = true;
 		} else {
 			folio_lock(folio);
-			if (unlikely(anon_vma_prepare(vma))) {
-				ret = VM_FAULT_OOM;
+
+			ret = vmf_anon_prepare(vmf);
+			if (unlikely(ret))
 				goto backout_unlocked;
-			}
 			anon_rmap = 1;
 		}
 	} else {
@@ -6298,7 +6298,7 @@ static vm_fault_t hugetlb_no_page(struct
 	hugetlb_count_add(pages_per_huge_page(h), mm);
 	if ((flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED)) {
 		/* Optimization, do the COW without a second fault */
-		ret = hugetlb_wp(mm, vma, address, ptep, flags, folio, ptl);
+		ret = hugetlb_wp(mm, vma, address, ptep, flags, folio, ptl, vmf);
 	}
 
 	spin_unlock(ptl);
@@ -6521,7 +6521,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	if (flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)) {
 		if (!huge_pte_write(entry)) {
 			ret = hugetlb_wp(mm, vma, address, ptep, flags,
-					 pagecache_folio, ptl);
+					 pagecache_folio, ptl, &vmf);
 			goto out_put_page;
 		} else if (likely(flags & FAULT_FLAG_WRITE)) {
 			entry = huge_pte_mkdirty(entry);
_

Patches currently in -mm which might be from vishal.moola@gmail.com are


