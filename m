Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBC321E08B
	for <mm-commits@vger.kernel.org>; Thu,  7 Aug 2025 21:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754602891; cv=none; b=VdUWf6T5A1EXHMordnQXEr6vACGb6xOWfcrSt7dslFP3XsOob8Hp0PUmigH2tl0no22GTvNphwHoKQaWvy+xpJtetWMjhK57hJrp+tc1Euw2rX+D61hJTczhqmMN8OvYlHztBSf5DHv5oA61R+jkkxtTsbJiTaMu/hiMt3F5pXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754602891; c=relaxed/simple;
	bh=9lN8+AgRyOJ90qVacZvCFQMoAKtKwz+cbyxbmO9lMrc=;
	h=Date:To:From:Subject:Message-Id; b=BImCdMkrQur8ffaG/yzpdGdUMNJiXpWA/NZdTj54G7FX6voqey3GK3VVl5omZZnPQXr1bpBI1WVwtG2WLF8bK/v+/w5iN6J4QbsHjXOsku6ZMLoiyCkA+BY278lkEWZUbDxthHj8mFMsGyKeAMpL+4ClJa29n4zl6kUnUx9oCSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wn4TxuQd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wn4TxuQd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F10C4CEEB;
	Thu,  7 Aug 2025 21:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754602891;
	bh=9lN8+AgRyOJ90qVacZvCFQMoAKtKwz+cbyxbmO9lMrc=;
	h=Date:To:From:Subject:From;
	b=wn4TxuQd1FRtC4mrztXIIgDgOdvK3rn09XqRa6LtW4fhhnW5dRoAYpSZtfY00GGzM
	 943vDqqDv4oBwmtBorFx5d2xlW8vhrffDVAWtbGQnZG2YA2Q46F9EIuRRMpctOVrMu
	 4aEBZl3hFZhSOfeLrkomTh5b7gay4Z2vmGatQZss=
Date: Thu, 07 Aug 2025 14:41:30 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,lorenzo.stoakes@oracle.com,donettom@linux.ibm.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-do-check_huge_anon-with-a-number-been-passed-in.patch added to mm-new branch
Message-Id: <20250807214131.03F10C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: do check_huge_anon() with a number been passed in
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-do-check_huge_anon-with-a-number-been-passed-in.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-do-check_huge_anon-with-a-number-been-passed-in.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: selftests/mm: do check_huge_anon() with a number been passed in
Date: Thu, 7 Aug 2025 08:27:07 +0000

Currently it hard codes the number of hugepage to check for
check_huge_anon(), but we already have the number passed in.

Do the check based on the number of hugepage passed in is more reasonable.

Link: https://lkml.kernel.org/r/20250807082707.30647-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-do-check_huge_anon-with-a-number-been-passed-in
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -112,7 +112,7 @@ static void verify_rss_anon_split_huge_p
 	unsigned long rss_anon_before, rss_anon_after;
 	size_t i;
 
-	if (!check_huge_anon(one_page, 4, pmd_pagesize))
+	if (!check_huge_anon(one_page, nr_hpages, pmd_pagesize))
 		ksft_exit_fail_msg("No THP is allocated\n");
 
 	rss_anon_before = rss_anon();
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-rmap-do-__folio_mod_stat-in-__folio_add_rmap.patch
selftests-mm-do-check_huge_anon-with-a-number-been-passed-in.patch

