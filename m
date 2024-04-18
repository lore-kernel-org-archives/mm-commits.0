Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B011EA74;
	Thu, 18 Apr 2024 19:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713468206; cv=none; b=tv/Z8QztzJI9hPt072L07h25wJp2bKtXEjidrVlCzyY08yBGLP4Vw4I4TH2qpdVHGb0Y5QOuca7d7mdmkta4rol18HKcQ7tGynTJevl9lzMdAedCpR3BtqBaZ/rEBCS+CHUU8Y/EpUUouHGlSJszs+4maSPzRiJUW0OdOLvUiwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713468206; c=relaxed/simple;
	bh=wpT9D0IRysZEHfspZRcwm4J7+2jq2J19HJMJRlf8/8M=;
	h=Date:To:From:Subject:Message-Id; b=UAosFQTL5BsHE9Txrzr89S/8mHh63dDzWtUMewikudTNMHv4RzzHJRqcPhkCAgH2/2udLbemswteP3ICaEKHI77Uq69g7jMXMuCgZQlj6jW/0INpPMPKbMTPvV6WouaxV/Y9vvI/qkGjAxJsygLNEvYYRChKTDSy7zU0MtkP5/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DPyGLkQI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DPyGLkQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E4FC32781;
	Thu, 18 Apr 2024 19:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713468205;
	bh=wpT9D0IRysZEHfspZRcwm4J7+2jq2J19HJMJRlf8/8M=;
	h=Date:To:From:Subject:From;
	b=DPyGLkQIe5/pUElJaKR1y7DpX7CxRodDKL/InuPHOpUx8JthgYYmGWimC6OiS1LQ5
	 oPdf2+zqqsFzYvQQnOEplIHlqRWVW8H2bH1MIIzLcgD30xFyXEbiVIAOj81fbUS2ZR
	 0TWDov4ZFe3xzEa6As42ksSIbzdlk68+qSsLDfCk=
Date: Thu, 18 Apr 2024 12:23:24 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,muchun.song@linux.dev,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-check-for-anon_vma-prior-to-folio-allocation.patch added to mm-hotfixes-unstable branch
Message-Id: <20240418192325.67E4FC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: check for anon_vma prior to folio allocation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     hugetlb-check-for-anon_vma-prior-to-folio-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-check-for-anon_vma-prior-to-folio-allocation.patch

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

hugetlb-check-for-anon_vma-prior-to-folio-allocation.patch
hugetlb-convert-hugetlb_fault-to-use-struct-vm_fault.patch
hugetlb-convert-hugetlb_no_page-to-use-struct-vm_fault.patch
hugetlb-convert-hugetlb_no_page-to-use-struct-vm_fault-fix.patch
hugetlb-convert-hugetlb_wp-to-use-struct-vm_fault.patch
hugetlb-convert-hugetlb_wp-to-use-struct-vm_fault-fix.patch

