Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04A7189B84
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 23:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771629064; cv=none; b=si0AtIIzsaqa/M0TN8z3ZmKD4aZ+mkIf2f3pY0PcQHkNrhlbeTMUuA2JMtm3x+7XUwFV0SSRbkr/ywepNwWtMHEGP617tC7OXn9qrRCk/lEb7ZdKcowFBdlFtxn3nJNP2pDZkiWr0wzWkVgeIZrayG6aQIAM7ndZII7q9VmZt8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771629064; c=relaxed/simple;
	bh=z0kKujpF2TPS47Oogiv7J189wUHuEiP7EEhRk7ZQoAE=;
	h=Date:To:From:Subject:Message-Id; b=W7RkFLE6yS96NEF3irRbsvn8IAKeZjr4mTPmvm49IQlcOeQN8IDPKALaTZlbXat8FYDOQ4UXCUej7eU0Q7hN/0LtAKtsqIvvx/kNgyyYw+9jw0ijT5a9bdcdTo3Qq4wuzUu1yEnz59+lukktzJNdfjckW3OgrauFoSI5erzebAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TVltZncm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TVltZncm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EEA4C116C6;
	Fri, 20 Feb 2026 23:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771629064;
	bh=z0kKujpF2TPS47Oogiv7J189wUHuEiP7EEhRk7ZQoAE=;
	h=Date:To:From:Subject:From;
	b=TVltZncmo4KfLXUO2pCfIUERnl7gB+EFaosKq2VrVREC7iT277KDO94bhqoVGdhic
	 /GmBvUcBi/n1WOJJGkQfQjU8CW3WFU7vXuMuKyXgzMUNiBARtjZbWWtYofIbRStPcv
	 LoZkLg752BHRSEEztEwzW435qwtXoGTNhuUaAGUQ=
Date: Fri, 20 Feb 2026 15:11:03 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,yanglincheng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-set-to-next-mm-direct-when-mm-has-mmf_disable_thp_completely.patch added to mm-new branch
Message-Id: <20260220231104.0EEA4C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: khugepaged: set to next mm direct when mm has MMF_DISABLE_THP_COMPLETELY
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-set-to-next-mm-direct-when-mm-has-mmf_disable_thp_completely.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-set-to-next-mm-direct-when-mm-has-mmf_disable_thp_completely.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-khugepaged-set-to-next-mm-direct-when-mm-has-mmf_disable_thp_completely.patch

