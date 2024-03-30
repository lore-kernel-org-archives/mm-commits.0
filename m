Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BE74685
	for <mm-commits@vger.kernel.org>; Sat, 30 Mar 2024 03:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711769658; cv=none; b=SnrBTjR67BmmSdVac9KzlzmhLNd+AlIZDzd7b5ZsZjJU8/1V5Ra3FUWr5Ys5wxBXDWuZgnXsZDlwEQKU2LlJkUDhW91J8DRdW+QgioZDPuSZYkagR5gHIoVutKk738S5ULtKaL0HFuhb+Pi/oJTCMG2BzQZTzxMDnNYxmM7utvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711769658; c=relaxed/simple;
	bh=ctkKpRTqt6NIUzouxMRlXOGhHS+JWe0PMglMXTMSGww=;
	h=Date:To:From:Subject:Message-Id; b=j3jdYuDeHaaGpzwOzoP5oRqRiCRYP8UAhdfKYq+13yyWjpRdi+qWb9xHrTSOg0PvmJDlxk4kDRdvdXGfnVlqbyS4Xz9DQ2XyKFDQLSYzd3FcnlEbqo41RolU3ABMdUk9QWXoGU/FFb2d8fnkxK6sZ0CS+8fVDL3A3ucSlenQUf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wfkA/8aZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wfkA/8aZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB7AC433F1;
	Sat, 30 Mar 2024 03:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711769658;
	bh=ctkKpRTqt6NIUzouxMRlXOGhHS+JWe0PMglMXTMSGww=;
	h=Date:To:From:Subject:From;
	b=wfkA/8aZaHP5XFojSH+BF5uAkBnt/JC+F39DVYepza7CPMBPYPRDKOU/oUcq75ou6
	 TAybCu8t4pb8mGLuGDLXdHVnBI+BZCXdisTcFPfWKt/tVNW1N1cXMeE2qm+o0Yx26Z
	 HwIejHDRozcYisR7Thg6sZLSzoBHmcmAyBg+a7g0=
Date: Fri, 29 Mar 2024 20:34:17 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-add-the-missing-folio_test_pmd_mappable-for-thp-split-statistics.patch added to mm-unstable branch
Message-Id: <20240330033418.3AB7AC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: huge_memory: add the missing folio_test_pmd_mappable() for THP split statistics
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-add-the-missing-folio_test_pmd_mappable-for-thp-split-statistics.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-add-the-missing-folio_test_pmd_mappable-for-thp-split-statistics.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: huge_memory: add the missing folio_test_pmd_mappable() for THP split statistics
Date: Fri, 29 Mar 2024 14:59:33 +0800

Now the mTHP can also be split or added into the deferred list, so add
folio_test_pmd_mappable() validation for PMD mapped THP, to avoid
confusion with PMD mapped THP related statistics.

Link: https://lkml.kernel.org/r/a5341defeef27c9ac7b85c97f030f93e4368bbc1.1711694852.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-add-the-missing-folio_test_pmd_mappable-for-thp-split-statistics
+++ a/mm/huge_memory.c
@@ -3109,7 +3109,8 @@ out_unlock:
 		i_mmap_unlock_read(mapping);
 out:
 	xas_destroy(&xas);
-	count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
+	if (folio_test_pmd_mappable(folio))
+		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
 	return ret;
 }
 
@@ -3171,7 +3172,8 @@ void deferred_split_folio(struct folio *
 
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
 	if (list_empty(&folio->_deferred_list)) {
-		count_vm_event(THP_DEFERRED_SPLIT_PAGE);
+		if (folio_test_pmd_mappable(folio))
+			count_vm_event(THP_DEFERRED_SPLIT_PAGE);
 		list_add_tail(&folio->_deferred_list, &ds_queue->split_queue);
 		ds_queue->split_queue_len++;
 #ifdef CONFIG_MEMCG
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-record-the-migration-reason-for-struct-migration_target_control.patch
mm-hugetlb-make-the-hugetlb-migration-strategy-consistent.patch
docs-hugetlbpagerst-add-hugetlb-migration-description.patch
mm-factor-out-the-numa-mapping-rebuilding-into-a-new-helper.patch
mm-support-multi-size-thp-numa-balancing.patch
mm-huge_memory-add-the-missing-folio_test_pmd_mappable-for-thp-split-statistics.patch

