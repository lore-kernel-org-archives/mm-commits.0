Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6A932ED55
	for <mm-commits@vger.kernel.org>; Fri,  8 May 2026 20:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778272966; cv=none; b=tIj1Gf8srcJ0WwwVE5FyGNnbMy/iOGytSxpX4vuEQG+mVD2nudb1CZ8IOJX+cY9Fdt98gE8hUFGwBfYm29eONRETrHs0ZNTQU+nsRu/h4IKNbZJC1JgUn3x6wszvPYblmBkvvR5+GyZo7sDhNJqmTXw4L34G3gj/YcdW0SUHPlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778272966; c=relaxed/simple;
	bh=qW9+blvVuw2MjzOVar6rkU5a2+DNh0P1B775/FgprNg=;
	h=Date:To:From:Subject:Message-Id; b=P9mQQHB9aKpwO5KAFchrAZ1VJzWW7NJWcQ68LugQieqgaJdrL0TjOAbpeKDuvQKjlRWgrHpR87OTybJLLnG1dNKVX7GJwEDzXaKMNqxrNCb7AFHn4v15K+BDOsJM/AkBgc6ClMA72pq5dCVVUmAJkFmiOvNOdE934qPvoU6w4rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IC+Sat0E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IC+Sat0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0EEC2BCB0;
	Fri,  8 May 2026 20:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778272965;
	bh=qW9+blvVuw2MjzOVar6rkU5a2+DNh0P1B775/FgprNg=;
	h=Date:To:From:Subject:From;
	b=IC+Sat0ETsoq4gcbYffnhqWkZpmzWR26yTosaayxAOxojSRvxOfQn280O17J5foA6
	 2FfNTEJE3gYFv/MZxO4BWTviGSyNR2I8cXMM1hwDb7rTyq/cjUySlzqw8CDMIsP9bU
	 OXCbNdrLo43Hte3s4KTGgOaQbR9Mz0/Y0+JkkN/I=
Date: Fri, 08 May 2026 13:42:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-remove-read_only_thp_for_fs-in-khugepaged-fix-2.patch added to mm-new branch
Message-Id: <20260508204245.BD0EEC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fix run_vmtests.sh to only print SKIP when khugepaged is selected
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-remove-read_only_thp_for_fs-in-khugepaged-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-remove-read_only_thp_for_fs-in-khugepaged-fix-2.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Zi Yan <ziy@nvidia.com>
Subject: fix run_vmtests.sh to only print SKIP when khugepaged is selected
Date: Thu, 7 May 2026 03:17:51 -0400

Link: https://lore.kernel.org/E44ED51F-D250-442D-A89F-B90A671D53ED@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-remove-read_only_thp_for_fs-in-khugepaged-fix-2
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -508,7 +508,7 @@ fi
 
 if [ -n "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
 CATEGORY="thp" run_test ./khugepaged all:file ${SPLIT_HUGE_PAGE_TEST_XFS_PATH}
-else
+elif test_selected thp; then
 	count_total=$(( count_total + 1 ))
 	count_skip=$(( count_skip + 1 ))
 	echo "[SKIP] ./khugepaged all:file" | tap_prefix
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-khugepaged-remove-read_only_thp_for_fs-check.patch
mm-khugepaged-add-folio-dirty-check-after-try_to_unmap.patch
mm-huge_memory-remove-read_only_thp_for_fs-from-file_thp_enabled.patch
mm-khugepaged-remove-read_only_thp_for_fs-check-in-hugepage_enabled.patch
mm-remove-read_only_thp_for_fs-kconfig-option.patch
mm-fs-remove-filemap_nr_thps-functions-and-their-users.patch
fs-remove-nr_thps-from-struct-address_space.patch
mm-huge_memory-remove-folio-split-check-for-read_only_thp_for_fs.patch
mm-truncate-use-folio_split-in-truncate_inode_partial_folio.patch
fs-btrfs-remove-a-comment-referring-to-read_only_thp_for_fs.patch
selftests-mm-remove-read_only_thp_for_fs-in-khugepaged.patch
selftests-mm-remove-read_only_thp_for_fs-in-khugepaged-fix.patch
selftests-mm-remove-read_only_thp_for_fs-in-khugepaged-fix-2.patch
selftests-mm-remove-read_only_thp_for_fs-code-from-guard-regions.patch
mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files.patch
selftests-mm-add-writable-file-collapse-tests-for-khugepaged.patch

