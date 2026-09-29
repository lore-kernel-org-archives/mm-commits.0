Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D67233721
	for <mm-commits@vger.kernel.org>; Tue, 29 Sep 2026 20:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790713862; cv=none; b=izgAkC0SnhMlWjivSJvaoASPPwrGycMVGktHMfITKBh2HnyjtH6H9KHGveEjJiu4WpVhQxe9ZNAb7NsB2IUr0Y7nWx8bLpjcEes+LRpcn1MlltGX+pnNOVNMxsz95ftehjOh2KSFXdVDfX1BYtq/p49yRW/Qo21Kzz/OhsIKAsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790713862; c=relaxed/simple;
	bh=qsN7ZrgLW5bmpUP5XVVsmNpz8iznbDQMeaoN0OdfBYE=;
	h=Date:To:From:Subject:Message-Id; b=S2jv9NSOyGj61x/+7N7QJ51R5cPq2T5qhsRozqmrWbVp3m5QJrV4PHDrjz/STbQ7vmeQnkYRdrMilkJYCLstvUtb44tgAR3PP8DFHacazE2NcdULN3+N7912XhBr6B6COUarsaEnKJZGUaMDMw0uDithMMeDkC6iveNkEDyydio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=044CAqns; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="044CAqns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792141F000FF;
	Tue, 29 Sep 2026 20:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790713860;
	bh=D2gAchbdEFLyaFKWw+SblzpmG2HFc5JlsUFwEYE3mYE=;
	h=Date:To:From:Subject;
	b=044CAqnsG9L3nejptjUhBlJFGz1sNTR5SH2wkzYOgo/aVU70dT6x6dpWr9z7NpUpR
	 b4p8vkeZzWZ/m57LITl1b8UI8O6/COdsvu54wlh0/wGUdGxpN4BsUJoE4cebPd03sm
	 aoHeGCyGd1PnZfYRt1t9yaOH3XISIn5cxYl8omxE=
Date: Tue, 29 Sep 2026 13:31:00 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,gourry@gourry.net,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,yeoreum.yun@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kselftest-mm-fix-intermittent-failure-khugepaged-test.patch added to mm-unstable branch
Message-Id: <20260929203100.792141F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kselftest: mm: fix intermittent failure khugepaged test
has been added to the -mm mm-unstable branch.  Its filename is
     kselftest-mm-fix-intermittent-failure-khugepaged-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kselftest-mm-fix-intermittent-failure-khugepaged-test.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: kselftest: mm: fix intermittent failure khugepaged test
Date: Tue, 29 Sep 2026 11:33:19 +0100

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

This happens because khugepaged may collapse the pages before
wait_for_scan() is called, causing a sanity check that expects uncollapsed
pages to fail.

For example, in collapse_max_ptes_swap(), after faulting the pages back in
and paging out up to max_ptes_swap pages, khugepaged may collapse them
again before c->collapse() is called.

To prevent this, mark the VMA with MADV_NOHUGEPAGE after it has been
collapsed by wait_for_scan() for anon.  This prevents khugepaged from
collapsing it again before c->collapse() is called.

This failure was observed on NVIDIA Spark with 16KB page.

Link: https://lore.kernel.org/20260929-fix_khugepagd_fail-v4-2-2169c18f2576@arm.com
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
---

 tools/testing/selftests/mm/khugepaged.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/tools/testing/selftests/mm/khugepaged.c~kselftest-mm-fix-intermittent-failure-khugepaged-test
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -618,6 +618,16 @@ static bool wait_for_scan(const char *ms
 		usleep(TICK);
 	}
 
+	/*
+	 * The file and shmem tests rely on refaults to install PMD mappings
+	 * after collapse. MADV_NOHUGEPAGE would prevent those mappings.
+	 *
+	 * Apply MADV_NOHUGEPAGE only to anonymous VMAs to prevent khugepaged
+	 * from unexpectedly collapsing pages during the test.
+	 */
+	if (is_anon(ops))
+		madvise(p, len, MADV_NOHUGEPAGE);
+
 	return timeout == -1;
 }
 
_

Patches currently in -mm which might be from yeoreum.yun@arm.com are

kselftest-mm-fix-potential-failure-for-merged-vma-in-guard-regions.patch
kselftest-mm-remove-exclusion-of-building-soft-dirty-test-in-arm64.patch
kselftest-mm-return-fail-when-child-test-result-is-fail-in-khugepaged.patch
kselftest-mm-fix-intermittent-failure-khugepaged-test.patch
kselftest-mm-prevent-random-failure-of-huge-page-split-for-khugepaged.patch
kselftest-mm-replace-usage-of-proc-self-smaps-for-__check_pmd_huge.patch
kselftest-mm-integrate-huge-page-checks.patch
kselftest-mm-remove-check_huge_shmem.patch

