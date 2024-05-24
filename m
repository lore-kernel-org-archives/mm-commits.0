Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207DE4084E;
	Fri, 24 May 2024 18:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716576958; cv=none; b=qCocf7xus6JP4PtVV1iHTFDUT8F6b6xVSnKIEqlUhtB1bN7VP8cDJLa6OYGBzxGX1QbgNSW2CTxgaK4ijjlo40YStK3wWQIAjiLQxsklKxR8OLr5bEPVv/3TlBS/ziXRjCr/+R2ErIBU/bhIUwYh9GN/Ve/O0jyIPQH7+IQ8bR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716576958; c=relaxed/simple;
	bh=Cm94E5G/wfKQ5FPV7DKbiuWHRiQNdZYNcfhurXD1zZ8=;
	h=Date:To:From:Subject:Message-Id; b=UvcpnVuQRQM0zOYc5K08Fp6Zf1ZxJ2iU09qCqy8HCgVZDr20YuxzqIFEgQ9YKw1e476zj8kVTBL0R2A9W1w66OKdpFFUFZnAbI6jxPl3sc1k+qTWRTgtDh0CtD3OVk92p1WZonjcguoLpu62Wp1aLl/+GUh/y2pD0bTUO4UfaC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iSCCFP/8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iSCCFP/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862E3C2BD11;
	Fri, 24 May 2024 18:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716576957;
	bh=Cm94E5G/wfKQ5FPV7DKbiuWHRiQNdZYNcfhurXD1zZ8=;
	h=Date:To:From:Subject:From;
	b=iSCCFP/8jYwx8usfvzQ/+suzGYXDc2wkpQdTf5AsI+XGgUEkoxdxUmWCAI1s0C472
	 O0a+zIrgmKXGnSgLxwIng2ef+Pkl40uln08+CExGlqBf03ZaixHONjDjefQlIp7nuX
	 xe+DC9MQBQ1tZTrAeEvv20PmlFyvpLhaHFQlhgYI=
Date: Fri, 24 May 2024 11:55:57 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,mkhalfella@purestorage.com,david@redhat.com,yzhong@purestorage.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-proc-pid-smaps_rollup-avoid-skipping-vma-after-getting-mmap_lock-again.patch removed from -mm tree
Message-Id: <20240524185557.862E3C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: /proc/pid/smaps_rollup: avoid skipping vma after getting mmap_lock again
has been removed from the -mm tree.  Its filename was
     mm-proc-pid-smaps_rollup-avoid-skipping-vma-after-getting-mmap_lock-again.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yuanyuan Zhong <yzhong@purestorage.com>
Subject: mm: /proc/pid/smaps_rollup: avoid skipping vma after getting mmap_lock again
Date: Thu, 23 May 2024 12:35:31 -0600

After switching smaps_rollup to use VMA iterator, searching for next entry
is part of the condition expression of the do-while loop.  So the current
VMA needs to be addressed before the continue statement.

Otherwise, with some VMAs skipped, userspace observed memory
consumption from /proc/pid/smaps_rollup will be smaller than the sum of
the corresponding fields from /proc/pid/smaps.

Link: https://lkml.kernel.org/r/20240523183531.2535436-1-yzhong@purestorage.com
Fixes: c4c84f06285e ("fs/proc/task_mmu: stop using linked list and highest_vm_end")
Signed-off-by: Yuanyuan Zhong <yzhong@purestorage.com>
Reviewed-by: Mohamed Khalfella <mkhalfella@purestorage.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
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


