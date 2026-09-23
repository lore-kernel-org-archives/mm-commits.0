Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C7B53B60B
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 18:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790189102; cv=none; b=LRITU+BQlSBCEoLBui4iUQrfXRPAh17WlY8vpwhOdb2qGAQSew30VbdJF+zLbRRHWJqOqInUAYCJCF7Cd52ROexDT192iRNnzDsN4RyjZDLrl42VwXJBXFbPerHthVFnpsY7ruEThjnF8UB7u671ADrbWHlu4W49YeYvN1NMBI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790189102; c=relaxed/simple;
	bh=+DPEs1Ijlmh8iE64iIZBRW5F10R8V4bZLiA7cxdGUP0=;
	h=Date:To:From:Subject:Message-Id; b=lR+K+vhaCShn6jCT8iBFlMkV3lAmj252UaHWfEKjU2hnLR7MBskmVG7VBazDjjELU0PHBH4OInc/hQJrYWngNVMJT1gt575+svOCK/stXuYT62TaPkjou86C0Y/Y03+2QCE9R5JoeLpEUlNT4Hcbu3EjmwMl3M7KRu2a6hNdBWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=15diY+m0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="15diY+m0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9515E1F00898;
	Wed, 23 Sep 2026 18:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790189094;
	bh=Se61cEVPxuKkp3Z536kOKudQlOoXEJ7FXS9mXOrFEAE=;
	h=Date:To:From:Subject;
	b=15diY+m0Ocjo/XTBCuEVje3QMmy+dFHvBjF7mZ2rDl5qwXEftsi2qyo4ietQj0FBW
	 /LtlMPZUfpOPYndHKXfdf/1NOpU+oj3Y1HqrD3uRnk88YpCuynorAwLQ3mO/yXm4Tc
	 5eicn/Y832CnEdYjcEZj3tEYOOQrQkQHW53vQkkI=
Date: Wed, 23 Sep 2026 11:44:54 -0700
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kselftest-mm-fix-intermittent-failure-khugepaged-test.patch removed from -mm tree
Message-Id: <20260923184454.9515E1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kselftest: mm: fix intermittent failure khugepaged test
has been removed from the -mm tree.  Its filename was
     kselftest-mm-fix-intermittent-failure-khugepaged-test.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: kselftest: mm: fix intermittent failure khugepaged test
Date: Mon, 21 Sep 2026 11:35:02 +0100

There are intermittent failures in collapse_max_ptes_swap() and
collapse_max_ptes_shared() when using the khugepaged_context:

  // while running ./khugepaged -s 2

  # Run test: collapse_max_ptes_shared (khugepaged:anon)
  # Allocate huge page... OK
  # Share huge page over fork()... OK
  # Trigger CoW on page 1023 of 2048... OK
  # Maybe collapse with max_ptes_shared exceeded.... OK
  # Trigger CoW on page 1024 of 2048... Fail
  Bail out! Unexpected huge page
  # Planned tests != run tests (26 != 23)
  # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0

  # Run test: collapse_max_ptes_swap (khugepaged:anon)
  # Swapout 257 of 2048 pages... OK
  # Maybe collapse with max_ptes_swap exceeded.... OK
  # Swapout 256 of 2048 pages... OK
  Bail out! Unexpected huge page
  # Planned tests != run tests (26 != 17)
  # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:0 error:0

This happens because khugepaged may collapse the pages before wait_for_scan()
is called, causing a sanity check that expects uncollapsed pages to fail.

For example, in collapse_max_ptes_swap(), after faulting the pages back in
and paging out up to max_ptes_swap pages, khugepaged may collapse them again
before c->collapse() is called.

To prevent this, mark the VMA with MADV_NOHUGEPAGE after it has been
collapsed by wait_for_scan() for anon. This prevents khugepaged from
collapsing it again before c->collapse() is called.

This failure was observed on NVIDIA Spark with 16KB page.

Link: https://lore.kernel.org/20260921-fix_khugepagd_fail-v2-2-3c2877beef61@arm.com
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Liam Howlett <liam@infradead.org>
Cc: Nico Pache (Red Hat) <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kirill A. Shutemov <kas@kernel.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand (ARM) <david@kernel.org>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
---

 tools/testing/selftests/mm/khugepaged.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/mm/khugepaged.c~kselftest-mm-fix-intermittent-failure-khugepaged-test
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -618,6 +618,9 @@ static bool wait_for_scan(const char *ms
 		usleep(TICK);
 	}
 
+	if (!strncmp(ops->name, "anon", 4))
+		madvise(p, len, MADV_NOHUGEPAGE);
+
 	return timeout == -1;
 }
 
_

Patches currently in -mm which might be from yeoreum.yun@arm.com are

kselftest-mm-fix-potential-failure-for-merged-vma-in-guard-regions.patch
kselftest-mm-remove-exclusion-of-building-soft-dirty-test-in-arm64.patch

