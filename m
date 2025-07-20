Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D283595E;
	Sun, 20 Jul 2025 02:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752978411; cv=none; b=Zl/Uom743HbjeAnep8LJNaoLz/VUaJAUD4MvDul/Pku62QHg6dhGwpJ9ogYQAkiwnYhrkUSp88w31ssa2xmA/YdKHBgkdSM7A9iJQj46rCO6rNxzxQCoCP4fOVxPHhOgt561VjMhTMKJCubbXeQ20ns/lcNP1QsfaF05vQeP7eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752978411; c=relaxed/simple;
	bh=RQ5X3DQJmL485VOWxkKWSbmVwJ7L2D8Tc1YrbK2x7Ek=;
	h=Date:To:From:Subject:Message-Id; b=t98ihDXLS4Pe8Ar0eMhRDpGUIc/uAGbTyh2JT39YWWO6s4LQv0yvR552ZZ52+WLbAkzOBnZxheLMtyGXlBbvgr8c1p03Z9LVHdjQLlpIEAU135PHjTBHf+Cg88DQ92vZ7PIoQEhCGGKjSFYvJq3Y+9t1tMwJ8DTLZmNr8ROtsMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jVE2fLi4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jVE2fLi4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9214C4CEE3;
	Sun, 20 Jul 2025 02:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752978410;
	bh=RQ5X3DQJmL485VOWxkKWSbmVwJ7L2D8Tc1YrbK2x7Ek=;
	h=Date:To:From:Subject:From;
	b=jVE2fLi4MNnbY14BOlCWcPy1UFWXQbCjz2KQizvu17vAT21zfSNdjpx3N1b0X8de1
	 WlrqotONKt66GffmLazO5JlnVSUGqlcvir9PzlsK1gBsn10prZwBCJYK5ieMa9/IPI
	 P/5AUBywzrThp46MNu+VdOLCIySIrGp1jNC0Kamc=
Date: Sat, 19 Jul 2025 19:26:50 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,donettom@linux.ibm.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-fix-split_huge_page_test-for-folio_split-tests.patch removed from -mm tree
Message-Id: <20250720022650.A9214C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix split_huge_page_test for folio_split() tests
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-split_huge_page_test-for-folio_split-tests.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: selftests/mm: fix split_huge_page_test for folio_split() tests
Date: Tue, 8 Jul 2025 21:27:59 -0400

PID_FMT does not have an offset field, so folio_split() tests are not
performed.  Add PID_FMT_OFFSET with an offset field and use it to perform
folio_split() tests.

Link: https://lkml.kernel.org/r/20250709012800.3225727-1-ziy@nvidia.com
Fixes: 80a5c494c89f ("selftests/mm: add tests for folio_split(), buddy allocator like split")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Tested-by : Donet Tom <donettom@linux.ibm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
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

mm-huge_memory-move-unrelated-code-out-of-__split_unmapped_folio.patch
mm-huge_memory-remove-after_split-label-in-__split_unmapped_folio.patch
mm-huge_memory-deduplicate-code-in-__folio_split.patch
mm-huge_memory-convert-vm_bug-to-vm_warn-in-__folio_split.patch
mm-huge_memory-get-frozen-folio-refcount-with-folio_expected_ref_count.patch
mm-huge_memory-refactor-after-split-page-cache-code.patch

