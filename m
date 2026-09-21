Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A765B47728F
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 21:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790025540; cv=none; b=fUGxC6En7pOoYnbg3nABGd7Sk6/eauU4/AmaawW4fzysT5uANVCSbP7U+PSMDmAuBlzvzPJLtdLxmieKQi8Ahf3/uq0vReYP4N1Z8D4lt4V7mzxVB13TT4vwj3Xf68JfvBf2rQwWaE7VCRPDtsc3OoE0+83WP4jadEYClkHO1JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790025540; c=relaxed/simple;
	bh=AdvVPrWPzVqkx3sq+6nSLyIxFpdfYdJ/2aWUzwSe8m8=;
	h=Date:To:From:Subject:Message-Id; b=ezZHqSMMt5zBAZx6sMxaHIZPt9JG5V1ZkpWsoukCt2zpYchsP2o9lKPj4X7TiOC/SPStLoYrRXCC0lWDfYULQXsKi0qwnQMxliRrGoIj7jsiPLswIxX8X2A2ASJDKLVJISwTQUXRRKhAhr/X6uzlpLaqvkyrEeDX3fqVURbrueM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WjdSeqeo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WjdSeqeo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29BE31F00893;
	Mon, 21 Sep 2026 21:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790025538;
	bh=kZhmNuaPEiLW0AArvRHUDUogxvsM4UQDNj5lgerJNaM=;
	h=Date:To:From:Subject;
	b=WjdSeqeosnsFF33kL2vEaeUAu8ZBkr0AyIiV2kyiFJeDCfjeGAY3G0/GHsDe8OEhQ
	 olObOhkjBOYLGeaUPZUEhbLalXCPfGMcbRc5vRJ0WufalKNOhcIZIGidatsSi7wy/l
	 4FkPeoCRS/iBfFtDiAISzfUm1MVkbMZGXwjmrLFg=
Date: Mon, 21 Sep 2026 14:18:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,yeoreum.yun@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kselftest-mm-fix-intermittent-failure-khugepaged-test.patch added to mm-new branch
Message-Id: <20260921211858.29BE31F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kselftest: mm: fix intermittent failure khugepaged test
has been added to the -mm mm-new branch.  Its filename is
     kselftest-mm-fix-intermittent-failure-khugepaged-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kselftest-mm-fix-intermittent-failure-khugepaged-test.patch

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
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
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
kselftest-mm-return-fail-when-child-test-result-is-fail-in-khugepaged.patch
kselftest-mm-fix-intermittent-failure-khugepaged-test.patch

