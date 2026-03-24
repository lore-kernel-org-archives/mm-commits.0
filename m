Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62C734C141
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388576; cv=none; b=PPOVvdfhHW+0e6S7d8wLCLUqScnTiEXg3OfJwL2BRHiqJF4VlqsgsKCzEKXOMsEGp5m69mqrCU3az8eWmPI5Hb13Dau1TFKCCbXpp3kzxFFA+aoD9MkzK5WB2xnAjR3rqTZLo0S7UgrHgF5W9flHJM2fRc9x8pLOuMLAytEu89c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388576; c=relaxed/simple;
	bh=0tIBXI3g9cu7MsmXuqcL/nXPGeuidIPCURdY6hzUbMY=;
	h=Date:To:From:Subject:Message-Id; b=tsaasJRX65YyMxaUhEU6WXCAGMU8B1P3Zu5SkgniUNE0FL2xUG9KkJ1hx191TB8ozY9ieukqPWM9VhJr+9uVcoU7U/Zk6/bzPHN8CvKKGP8dW7F2Z9SszoztcmMVfEE2yOoscWquof3ZX6BfMfWA3jK9pttdbnRkzNvws47D2Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D6zbd5rg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D6zbd5rg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE9EC19424;
	Tue, 24 Mar 2026 21:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388575;
	bh=0tIBXI3g9cu7MsmXuqcL/nXPGeuidIPCURdY6hzUbMY=;
	h=Date:To:From:Subject:From;
	b=D6zbd5rg2ej6LpwFfv3hUvPpE50fn1BXOrJn9WGPcbEHuSQPUtedrbAUC/gmFilSx
	 iQcfSftAiyQNO2kcJPNg9J3QANkSLogiVnK7NZcDOb6gc38iG5C0xUaR6Or1X0w3Tg
	 onnGuFL/p3AUwtghPs5fpIH/3GXyWRo9sNPUVmlI=
Date: Tue, 24 Mar 2026 14:42:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,yanglincheng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-set-to-next-mm-direct-when-mm-has-mmf_disable_thp_completely.patch removed from -mm tree
Message-Id: <20260324214255.6DE9EC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: khugepaged: set to next mm direct when mm has MMF_DISABLE_THP_COMPLETELY
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-set-to-next-mm-direct-when-mm-has-mmf_disable_thp_completely.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vernon Yang <yanglincheng@kylinos.cn>
Subject: mm: khugepaged: set to next mm direct when mm has MMF_DISABLE_THP_COMPLETELY
Date: Sat, 7 Feb 2026 16:16:13 +0800

When an mm with the MMF_DISABLE_THP_COMPLETELY flag is detected during
scanning, directly set khugepaged_scan.mm_slot to the next mm_slot, reduce
redundant operation.

Without this patch, entering khugepaged_scan_mm_slot() next time, we will
set khugepaged_scan.mm_slot to the next mm_slot.

With this patch, we will directly set khugepaged_scan.mm_slot to the next
mm_slot.

Link: https://lkml.kernel.org/r/20260207081613.588598-6-vernon2gm@gmail.com
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-set-to-next-mm-direct-when-mm-has-mmf_disable_thp_completely
+++ a/mm/khugepaged.c
@@ -2508,9 +2508,9 @@ breakouterloop_mmap_lock:
 	VM_BUG_ON(khugepaged_scan.mm_slot != slot);
 	/*
 	 * Release the current mm_slot if this mm is about to die, or
-	 * if we scanned all vmas of this mm.
+	 * if we scanned all vmas of this mm, or THP got disabled.
 	 */
-	if (hpage_collapse_test_exit(mm) || !vma) {
+	if (hpage_collapse_test_exit_or_disable(mm) || !vma) {
 		/*
 		 * Make sure that if mm_users is reaching zero while
 		 * khugepaged runs here, khugepaged_exit will find
_

Patches currently in -mm which might be from yanglincheng@kylinos.cn are


