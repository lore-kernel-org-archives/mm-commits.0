Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE5112E61;
	Thu, 25 Apr 2024 02:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714012523; cv=none; b=eMZb7ypqFkwHCwFNTfcvXGKzfLELoHH3KGBJL1cAqTHpUA21A+HUiiBsGfidl/tWLFNbx5yK/qC7PIpuTnnMgXy0VZWRiw0oGqgCRmH81dleDHKIHJGuHw49SjjZR1lz0YraMKD1aJfTVfxVavCQgTsNDe1QEQ/qehsT7QJgD9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714012523; c=relaxed/simple;
	bh=6BKc1YH7V5WfqZM6sCjv5Cy+joKKKXpOyLaewTOov/k=;
	h=Date:To:From:Subject:Message-Id; b=JoYMl/t5ztMIEcWa/uKQpx2pruHZI87p0Ug3lwPvd3bxBpS5OagfnJmFeYlQB2Up+B4PMjVBn2d1xMZ6CnO5svt7KoWuiiNAnKX84uqmROwRJmtmp8nnqpf4aEfhr1WclUFdknHVEvDHmehhFNsHQXYId5o36dbhihLHWY8rapc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eGaNxLyN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eGaNxLyN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DE0C113CD;
	Thu, 25 Apr 2024 02:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714012523;
	bh=6BKc1YH7V5WfqZM6sCjv5Cy+joKKKXpOyLaewTOov/k=;
	h=Date:To:From:Subject:From;
	b=eGaNxLyNoRNNvdzbB3m0Fb9S/xJ99uydXvkTlnaSst7LRmxnTTjhVDQ9ZUzdsAQRt
	 oURhWFp3RzQH3Th867KmbyGml1aHnk0YI0rE24AkgCrbuUoYClcVqZsKJ0k7yHPn1R
	 n/l1PdaIynypyNl7OqGNqyrnprZWL+PAQtWwOwuU=
Date: Wed, 24 Apr 2024 19:35:22 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,muchun.song@linux.dev,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] hugetlb-check-for-anon_vma-prior-to-folio-allocation.patch removed from -mm tree
Message-Id: <20240425023523.30DE0C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb: check for anon_vma prior to folio allocation
has been removed from the -mm tree.  Its filename was
     hugetlb-check-for-anon_vma-prior-to-folio-allocation.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: hugetlb: check for anon_vma prior to folio allocation
Date: Mon, 15 Apr 2024 14:17:47 -0700

Commit 9acad7ba3e25 ("hugetlb: use vmf_anon_prepare() instead of
anon_vma_prepare()") may bailout after allocating a folio if we do not
hold the mmap lock.  When this occurs, vmf_anon_prepare() will release the
vma lock.  Hugetlb then attempts to call restore_reserve_on_error(), which
depends on the vma lock being held.

We can move vmf_anon_prepare() prior to the folio allocation in order to
avoid calling restore_reserve_on_error() without the vma lock.

Link: https://lkml.kernel.org/r/ZiFqSrSRLhIV91og@fedora
Fixes: 9acad7ba3e25 ("hugetlb: use vmf_anon_prepare() instead of anon_vma_prepare()")
Reported-by: syzbot+ad1b592fc4483655438b@syzkaller.appspotmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~hugetlb-check-for-anon_vma-prior-to-folio-allocation
+++ a/mm/hugetlb.c
@@ -6261,6 +6261,12 @@ static vm_fault_t hugetlb_no_page(struct
 							VM_UFFD_MISSING);
 		}
 
+		if (!(vma->vm_flags & VM_MAYSHARE)) {
+			ret = vmf_anon_prepare(vmf);
+			if (unlikely(ret))
+				goto out;
+		}
+
 		folio = alloc_hugetlb_folio(vma, haddr, 0);
 		if (IS_ERR(folio)) {
 			/*
@@ -6297,15 +6303,12 @@ static vm_fault_t hugetlb_no_page(struct
 				 */
 				restore_reserve_on_error(h, vma, haddr, folio);
 				folio_put(folio);
+				ret = VM_FAULT_SIGBUS;
 				goto out;
 			}
 			new_pagecache_folio = true;
 		} else {
 			folio_lock(folio);
-
-			ret = vmf_anon_prepare(vmf);
-			if (unlikely(ret))
-				goto backout_unlocked;
 			anon_rmap = 1;
 		}
 	} else {
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

hugetlb-convert-hugetlb_fault-to-use-struct-vm_fault.patch
hugetlb-convert-hugetlb_no_page-to-use-struct-vm_fault.patch
hugetlb-convert-hugetlb_no_page-to-use-struct-vm_fault-fix.patch
hugetlb-convert-hugetlb_wp-to-use-struct-vm_fault.patch
hugetlb-convert-hugetlb_wp-to-use-struct-vm_fault-fix.patch

