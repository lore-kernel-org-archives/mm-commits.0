Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54141F37C5
	for <mm-commits@vger.kernel.org>; Thu, 13 Mar 2025 20:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741898801; cv=none; b=T5FFcFnIps1EXCITnw91myz0kpZ6p0eq44CDhFHOGkl7fO1tEvVQeGUFm3S4lBtXD97ugjWq7U+mAa6tY8xkR9ib/zl1PvRiAdC7TzctHxKsE/A8jcuPpQ4m+qE+lHAEKpvGXfbXrnZ6pZiAwKl6uQt5+AuSd1BKBcuBkXIadOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741898801; c=relaxed/simple;
	bh=sc36hblwNwe8KIzM5T6w70AaLwdtS3biMqSmvbgkTGw=;
	h=Date:To:From:Subject:Message-Id; b=cNRzJaCHsxSgCbHRfyNOPMUM4ZdClwoG0WlF744wMh0cIPMexPj91Q7InVWdV44jmS8aWOZZ1d2O3XmJr57r5v+PhY+HRLHrnQpTiC8PRXxVaEWwECrqoCGD1acGQnvEA1vdv5W04PBSDlGyMSgQf91B56hWk4Rqw1Khy4j2JvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rf8alX0S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rf8alX0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258F1C4CEDD;
	Thu, 13 Mar 2025 20:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741898801;
	bh=sc36hblwNwe8KIzM5T6w70AaLwdtS3biMqSmvbgkTGw=;
	h=Date:To:From:Subject:From;
	b=rf8alX0SRZko+w2+E/oOlmthbHMuqNTgPJgKxlgJmOY8Q3KpfvjRPTbGbJCfz+Mgn
	 AnzW1TF+CReJfgqrTWiMYH222PI0rvxIy08LSxS8SECkmJwjCc+Vxs6ayIidmAok3m
	 pvNqv1ElO3bFc2s2byC9eeqgO1UMh8QZdNEZFNV4=
Date: Thu, 13 Mar 2025 13:46:40 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix-2.patch added to mm-unstable branch
Message-Id: <20250313204641.258F1C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: use NULL instead of 0 for folio->private assignment.
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix-2.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: use NULL instead of 0 for folio->private assignment.
Date: Thu, 13 Mar 2025 10:04:20 -0400

It makes sparse happy.

Link: https://lkml.kernel.org/r/1E11B9DD-3A87-4C9C-8FB4-E1324FB6A21A@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202503131109.s7iuWfGq-lkp@intel.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix-2
+++ a/mm/huge_memory.c
@@ -3584,7 +3584,7 @@ static void __split_folio_to_order(struc
 		 */
 		if (unlikely(new_folio->private)) {
 			VM_WARN_ON_ONCE_PAGE(true, new_head);
-			new_folio->private = 0;
+			new_folio->private = NULL;
 		}
 
 		if (folio_test_swapcache(folio))
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-migrate-fix-shmem-xarray-update-during-migration.patch
mm-huge_memory-drop-beyond-eof-folios-with-the-right-number-of-refs.patch
selftests-mm-make-file-backed-thp-split-work-by-writing-pmd-size-data.patch
mm-huge_memory-allow-split-shmem-large-folio-to-any-lower-order.patch
selftests-mm-test-splitting-file-backed-thp-to-any-lower-order.patch
xarray-add-xas_try_split-to-split-a-multi-index-entry.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix-2.patch
mm-huge_memory-move-folio-split-common-code-to-__folio_split.patch
mm-huge_memory-add-buddy-allocator-like-non-uniform-folio_split.patch
mm-huge_memory-remove-the-old-unused-__split_huge_page.patch
mm-huge_memory-add-folio_split-to-debugfs-testing-interface.patch
mm-truncate-use-folio_split-in-truncate-operation.patch
selftests-mm-add-tests-for-folio_split-buddy-allocator-like-split.patch
mm-filemap-use-xas_try_split-in-__filemap_add_folio.patch
mm-shmem-use-xas_try_split-in-shmem_split_large_entry.patch

