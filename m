Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA3421C16E
	for <mm-commits@vger.kernel.org>; Wed, 24 Sep 2025 22:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758752028; cv=none; b=AGsDQsEgq/vxdUJPAIho1LbxCvVEGO7aNEVTT7rS9Q/v5927bbpabUfeHr9XK8ClK762FuS4KFeHw6ls8X2h5eHd0hM0DMpoDeWt8nVa4u1ofo0SdjQOyoof268unlAnqBsEIB5nK+XFQGtB84JS6ykI2gJujAUKTM7Z2UIcJkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758752028; c=relaxed/simple;
	bh=x79yDRbxn9DnggMcWewyX/BrS0LXiJ6FCnhi4WfAV4M=;
	h=Date:To:From:Subject:Message-Id; b=HMF7+jCYli4bTER35Jko1V1j1aghiBjWIOVJPoUFqoXFauPfF6+NGn5AK1sAISRzhNhGZMQRWfFtIuwAfZUqBS/ofBb+2F9T3rJ0tsy9kIedNkLFS7jc7+5MeIq00pYobVYJoG94pCCNMVTY0mSabOH8ChlXtLaUeBTAY/XqJWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=quRdSEjW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="quRdSEjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207BBC4CEE7;
	Wed, 24 Sep 2025 22:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758752028;
	bh=x79yDRbxn9DnggMcWewyX/BrS0LXiJ6FCnhi4WfAV4M=;
	h=Date:To:From:Subject:From;
	b=quRdSEjWfyBYzJgFxO0f4vBVaLGG5aTuSxh+RZ76rfStm2NJ1eHRItniRz3zMi3T9
	 tOq/5fdaMSRsn5GMAcWcat/ubWepTOscjIbEWSTNZ/m1nkDkBZGAnXOgMTVMC/iHIT
	 kMX3sUxAIrvC5yAw6QxgBAFOJSuDWbtIaVujUTkY=
Date: Wed, 24 Sep 2025 15:13:47 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,mpenttil@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kirill@shutemov.name,kasong@tencent.com,hughd@google.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-clean-up-is_guard_pte_marker.patch added to mm-new branch
Message-Id: <20250924221348.207BBC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: clean up is_guard_pte_marker()
has been added to the -mm mm-new branch.  Its filename is
     mm-clean-up-is_guard_pte_marker.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-clean-up-is_guard_pte_marker.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Lance Yang <lance.yang@linux.dev>
Subject: mm: clean up is_guard_pte_marker()
Date: Wed, 24 Sep 2025 12:58:30 +0800

Let's simplify the implementation. The current code is redundant as it
effectively expands to:

  is_swap_pte(pte) &&
  is_pte_marker_entry(...) && // from is_pte_marker()
  is_pte_marker_entry(...)    // from is_guard_swp_entry()

While a modern compiler could likely optimize this away, let's have clean
code and not rely on it.

Link: https://lkml.kernel.org/r/20250924045830.3817-1-lance.yang@linux.dev
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/madvise.c~mm-clean-up-is_guard_pte_marker
+++ a/mm/madvise.c
@@ -1071,8 +1071,8 @@ static bool is_valid_guard_vma(struct vm
 
 static bool is_guard_pte_marker(pte_t ptent)
 {
-	return is_pte_marker(ptent) &&
-		is_guard_swp_entry(pte_to_swp_entry(ptent));
+	return is_swap_pte(ptent) &&
+	       is_guard_swp_entry(pte_to_swp_entry(ptent));
 }
 
 static int guard_install_pud_entry(pud_t *pud, unsigned long addr,
_

Patches currently in -mm which might be from lance.yang@linux.dev are

hung_task-fix-warnings-caused-by-unaligned-lock-pointers.patch
mm-thp-fix-mte-tag-mismatch-when-replacing-zero-filled-subpages.patch
mm-clean-up-is_guard_pte_marker.patch

