Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1B6182;
	Wed,  9 Jul 2025 02:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752027170; cv=none; b=VJ2nxZhp+5v1wG2zyUdzzKUU1bzwmmwVwDvSU/vzP02uXhEDwnZm0NRjZVGvw6qa1cnw0wfxXYEu+FQHRPPSHYTqRiMOuqeqMQqEBPik9xef8R/2XYPD0uLw8fWY9IMuv/A7G3qr6TixxQoB7lZfeX3hS4PVmJzvZOCTVKsAZcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752027170; c=relaxed/simple;
	bh=T9A/oqHcLojXFQoPdcYCyZJegeuTqBIAbh5o3qBwP1A=;
	h=Date:To:From:Subject:Message-Id; b=bwxFl9Zi26XvSopgiItJAOjHGDMPV6FtGL/axxemmL77krpjCY08clP8kkwRQBL5dvE7ZIAPwqdOSDtG9nfIUHLf3Xa12jwFUu+ipDpr9a1R0UIic3aToIDiJEJyapZB0DdBiYcJiUYczF7pOtO/ZkYk37lJUPIcRgrBMIggysQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KWa2kpcu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KWa2kpcu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA10C4CEED;
	Wed,  9 Jul 2025 02:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752027169;
	bh=T9A/oqHcLojXFQoPdcYCyZJegeuTqBIAbh5o3qBwP1A=;
	h=Date:To:From:Subject:From;
	b=KWa2kpcutNVEq5mEBp3ncs0Li+dY4pNBhNP5h91dUaELPZKVHsXQ4w/jjuDjnYOz4
	 b0L8cY4hMxDGIRZYeQo73QrSa7zgS01lZ/WUo1B1o0T0WoD9EqWbQOWxLbXZ5Kj9gd
	 UVTAXs6yBhktsCFwJax/PsyiyrANU3hCf0XSOJKc=
Date: Tue, 08 Jul 2025 19:12:48 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-split_huge_page_test-for-folio_split-tests.patch added to mm-hotfixes-unstable branch
Message-Id: <20250709021249.5DA10C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix split_huge_page_test for folio_split() tests.
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-fix-split_huge_page_test-for-folio_split-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-split_huge_page_test-for-folio_split-tests.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: selftests/mm: fix split_huge_page_test for folio_split() tests.
Date: Tue, 8 Jul 2025 21:27:59 -0400

PID_FMT does not have an offset field, so folio_split() tests are not
performed.  Add PID_FMT_OFFSET with an offset field and use it to perform
folio_split() tests.

Link: https://lkml.kernel.org/r/20250709012800.3225727-1-ziy@nvidia.com
Fixes: 80a5c494c89f ("selftests/mm: add tests for folio_split(), buddy allocator like split")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-fix-split_huge_page_test-for-folio_split-tests
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -31,6 +31,7 @@ uint64_t pmd_pagesize;
 #define INPUT_MAX 80
 
 #define PID_FMT "%d,0x%lx,0x%lx,%d"
+#define PID_FMT_OFFSET "%d,0x%lx,0x%lx,%d,%d"
 #define PATH_FMT "%s,0x%lx,0x%lx,%d"
 
 #define PFN_MASK     ((1UL<<55)-1)
@@ -483,7 +484,7 @@ void split_thp_in_pagecache_to_order_at(
 		write_debugfs(PID_FMT, getpid(), (uint64_t)addr,
 			      (uint64_t)addr + fd_size, order);
 	else
-		write_debugfs(PID_FMT, getpid(), (uint64_t)addr,
+		write_debugfs(PID_FMT_OFFSET, getpid(), (uint64_t)addr,
 			      (uint64_t)addr + fd_size, order, offset);
 
 	for (i = 0; i < fd_size; i++)
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-fix-split_huge_page_test-for-folio_split-tests.patch
mm-rename-config_page_block_order-to-config_page_block_max_order.patch
mm-page_alloc-pageblock-flags-functions-clean-up.patch
mm-page_isolation-make-page-isolation-a-standalone-bit.patch
mm-page_alloc-add-support-for-initializing-pageblock-as-isolated.patch
mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate.patch
mm-page_isolation-remove-migratetype-from-undo_isolate_page_range.patch
mm-page_isolation-remove-migratetype-parameter-from-more-functions.patch

