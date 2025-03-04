Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AB886359
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 01:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741053499; cv=none; b=XiblcCAuH02AK91LS1vZjfj+DzPdxk0/yHO7zRvbD+M2UQlGgb2iFTFtdOluaK4u1iuNdV+Nwf9vtptSDbdBtfwkAgjN9v7Kv0TmIguqi2KUpFfL8YG1Xe4R14EegcY38+XFhqhc/KHeOePmNlpMk8Dzh5CDtB8Vq20Mx3W9s2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741053499; c=relaxed/simple;
	bh=vF5nv0ZO4iJuNgBWmAoqS3gazmvw9Gy5XKXxZFkvxF4=;
	h=Date:To:From:Subject:Message-Id; b=aOVIvZodz7xAUxQTPDGpHeKeHwb6JMT+0F+Gut9QfKZ3YZjIk8z+cgvPjQ22SKYkMNUjwB7zIBz4V3Jvfs3K/ie0G6TBkYUXa2OZtSIkYWnqqGuRs1zAJ2ltwx+sB83QZPn0ZEocW9qirIrTDa0OA3uGZQqgLwMG82cXJf4Oivw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=liu7PI/L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="liu7PI/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844F2C4CEE4;
	Tue,  4 Mar 2025 01:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741053498;
	bh=vF5nv0ZO4iJuNgBWmAoqS3gazmvw9Gy5XKXxZFkvxF4=;
	h=Date:To:From:Subject:From;
	b=liu7PI/LLi0XVSArbBZbLwsn6iZTzK9C9cRQxt73PBHuLHOK/gKolNykKy5nFgYhl
	 9aylHOvqGWvnQCb5vxmCrzeUgrbspUR9XH/KurslFYy8GRkAERv7blxpfaimHTPIJI
	 bV8enNcjDFTcotMU1W8a7t8FSzTdDcAg6r4EdoWU=
Date: Mon, 03 Mar 2025 17:58:17 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yang@os.amperecomputing.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,linmiaohe@huawei.com,kirill.shutemov@linux.intel.com,kasong@tencent.com,jhubbard@nvidia.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-truncate-use-buddy-allocator-like-folio-split-for-truncate-operation-fix.patch added to mm-unstable branch
Message-Id: <20250304015818.844F2C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/truncate: make sure folio2 is large and has the same mapping after lock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-truncate-use-buddy-allocator-like-folio-split-for-truncate-operation-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-truncate-use-buddy-allocator-like-folio-split-for-truncate-operation-fix.patch

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
Subject: mm/truncate: make sure folio2 is large and has the same mapping after lock
Date: Sat, 1 Mar 2025 22:34:24 -0500

It is possible that folio2 no longer belongs to the original mapping.

Link: https://lkml.kernel.org/r/56EBE3B6-99EA-470E-B2B3-92C9C13032DF@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/truncate.c~mm-truncate-use-buddy-allocator-like-folio-split-for-truncate-operation-fix
+++ a/mm/truncate.c
@@ -244,8 +244,14 @@ bool truncate_inode_partial_folio(struct
 		if (!folio_trylock(folio2))
 			goto out;
 
-		/* split result does not matter here */
-		try_folio_split(folio2, split_at2, NULL);
+		/*
+		 * make sure folio2 is large and does not change its mapping.
+		 * Its split result does not matter here.
+		 */
+		if (folio_test_large(folio2) &&
+		    folio2->mapping == folio->mapping)
+			try_folio_split(folio2, split_at2, NULL);
+
 		folio_unlock(folio2);
 out:
 		folio_put(folio2);
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-make-file-backed-thp-split-work-by-writing-pmd-size-data.patch
mm-huge_memory-allow-split-shmem-large-folio-to-any-lower-order.patch
selftests-mm-test-splitting-file-backed-thp-to-any-lower-order.patch
xarray-add-xas_try_split-to-split-a-multi-index-entry.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split.patch
mm-huge_memory-move-folio-split-common-code-to-__folio_split.patch
mm-huge_memory-add-buddy-allocator-like-non-uniform-folio_split.patch
mm-huge_memory-remove-the-old-unused-__split_huge_page.patch
mm-huge_memory-add-folio_split-to-debugfs-testing-interface.patch
mm-truncate-use-buddy-allocator-like-folio-split-for-truncate-operation.patch
mm-truncate-use-buddy-allocator-like-folio-split-for-truncate-operation-fix.patch
selftests-mm-add-tests-for-folio_split-buddy-allocator-like-split.patch
mm-filemap-use-xas_try_split-in-__filemap_add_folio.patch
mm-shmem-use-xas_try_split-in-shmem_split_large_entry.patch

