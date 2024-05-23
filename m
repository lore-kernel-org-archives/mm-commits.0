Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0DD2C694
	for <mm-commits@vger.kernel.org>; Thu, 23 May 2024 18:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716490631; cv=none; b=PwLuXdMiFGViVNpSR+k0e7AJBT+3b8ONFptM7sZ8txoTIldPW0tdfQxoUCPp9FmWvb3mWeZhdngKstt+sehCrHG96nB9PL320OTawqk+WwvAYRD/WnlH2gYyKUQEHfTHZiSETdrxLCrYpaaKnHPVXKO76OWiyF+1FloDBDB8i9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716490631; c=relaxed/simple;
	bh=LB5Mmcy6v+tIg9Pq+FQvAhYNMNheEQLcB0dsPlLP+po=;
	h=Date:To:From:Subject:Message-Id; b=bjo5f5l2wzvxFHzo7NRdMNrW9D9MyZX++LvIQnRaP27Sv099MPcUfnv63KxondeXcMh3jZtJ2NL2NWNrP58iy2n4StTu1+8/zKEiLSs68MK5LGF6G2DmWWPQHUme8qf8LSm2OUKgY+KTg3NyNRNTYjDk/mo0YGaDtFWPnJ4F7Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0yuoyfld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0yuoyfld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF3AC2BD10;
	Thu, 23 May 2024 18:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716490630;
	bh=LB5Mmcy6v+tIg9Pq+FQvAhYNMNheEQLcB0dsPlLP+po=;
	h=Date:To:From:Subject:From;
	b=0yuoyfldV/VuriQcTK/ORUMevr1aAB5dOWxY0dDsvBqAqLz4zCX3WGbRUfVawMdRK
	 WTNEh2Crpm7Scyp5Mz1QZ2pIzfrGMYBqnuNjoumUjtOJCuLlm6AA2y1Y7NQNqrQoG9
	 4kKXrqNR43R9YTvDnyp8NVyTWJB6cRZ0FqHouF4U=
Date: Thu, 23 May 2024 11:57:09 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,mkhalfella@purestorage.com,david@redhat.com,yzhong@purestorage.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-proc-pid-smaps_rollup-avoid-skipping-vma-after-getting-mmap_lock-again.patch added to mm-hotfixes-unstable branch
Message-Id: <20240523185710.BFF3AC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: /proc/pid/smaps_rollup: avoid skipping vma after getting mmap_lock again
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-proc-pid-smaps_rollup-avoid-skipping-vma-after-getting-mmap_lock-again.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-proc-pid-smaps_rollup-avoid-skipping-vma-after-getting-mmap_lock-again.patch

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
From: Yuanyuan Zhong <yzhong@purestorage.com>
Subject: mm: /proc/pid/smaps_rollup: avoid skipping vma after getting mmap_lock again
Date: Thu, 23 May 2024 12:35:31 -0600

After switching smaps_rollup to use VMA iterator, searching for next entry
is part of the condition expression of the do-while loop.  So the current
VMA needs to be addressed before the continue statement.

Link: https://lkml.kernel.org/r/20240523183531.2535436-1-yzhong@purestorage.com
Fixes: c4c84f06285e ("fs/proc/task_mmu: stop using linked list and highest_vm_end")
Signed-off-by: Yuanyuan Zhong <yzhong@purestorage.com>
Reviewed-by: Mohamed Khalfella <mkhalfella@purestorage.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/proc/task_mmu.c~mm-proc-pid-smaps_rollup-avoid-skipping-vma-after-getting-mmap_lock-again
+++ a/fs/proc/task_mmu.c
@@ -970,12 +970,17 @@ static int show_smaps_rollup(struct seq_
 				break;
 
 			/* Case 1 and 2 above */
-			if (vma->vm_start >= last_vma_end)
+			if (vma->vm_start >= last_vma_end) {
+				smap_gather_stats(vma, &mss, 0);
+				last_vma_end = vma->vm_end;
 				continue;
+			}
 
 			/* Case 4 above */
-			if (vma->vm_end > last_vma_end)
+			if (vma->vm_end > last_vma_end) {
 				smap_gather_stats(vma, &mss, last_vma_end);
+				last_vma_end = vma->vm_end;
+			}
 		}
 	} for_each_vma(vmi, vma);
 
_

Patches currently in -mm which might be from yzhong@purestorage.com are

mm-proc-pid-smaps_rollup-avoid-skipping-vma-after-getting-mmap_lock-again.patch

