Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A34E156898
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 17:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721840441; cv=none; b=hP+P+kOe/ZqjbCTN03/6JBAShoP5TfXB0eebGeTy+ZQj2NkacnFBfYt04MzieiX5bJwz8fYkEKHx9lXx0QKFoTqRZiBFpSx9y/9+3HoRDuBfOOALvsJ1FdKRE983IJ2hSXjiJ40CsaRdV/o2aqmGrSYk77QxTMMYvdL1tN9hK1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721840441; c=relaxed/simple;
	bh=EGDjCKS8TTdOS6u49eZnJylffVX5QQYdVFkyWpn+h0c=;
	h=Date:To:From:Subject:Message-Id; b=fUNVn4vehALzkopONWf8+ITK6uC4gJyQLhV3iqvg++Yr4lKGaI4ejQXip+EJnJVKmxUpf/mUCFuqSP6cLrPq1O2Y59lN61twWZSwsDRat2pZ43yC6bVKGHdlD+Tsg3W46Ww7mc1eU+H9wzShBiGMBeZfwVK6xbh1ENk2+lIFBaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bS/GlHwo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bS/GlHwo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15595C32781;
	Wed, 24 Jul 2024 17:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721840441;
	bh=EGDjCKS8TTdOS6u49eZnJylffVX5QQYdVFkyWpn+h0c=;
	h=Date:To:From:Subject:From;
	b=bS/GlHwoz5nSpHLo/q34pNq2FOK3Ibk8G/K41j8GMdajkAbHkSzu5Fp9Y3X3Jhuiv
	 Xr/Fp7hwbXvsXTROz/DRJUhrwgzY9G1Kuh55SsdpjrkvW9pQAFiVyYGSHyqKjs9KqV
	 gGNFRgO1sP/U0+AIF+ICrXSijml9sV8voLzAhzpM=
Date: Wed, 24 Jul 2024 10:00:40 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,wangkefeng.wang@huawei.com,lorenzo.stoakes@oracle.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memory-tiering-count-pgpromote_success-when-mem-tiering-is-enabled.patch added to mm-unstable branch
Message-Id: <20240724170041.15595C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memory tiering: count PGPROMOTE_SUCCESS when mem tiering is enabled.
has been added to the -mm mm-unstable branch.  Its filename is
     memory-tiering-count-pgpromote_success-when-mem-tiering-is-enabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memory-tiering-count-pgpromote_success-when-mem-tiering-is-enabled.patch

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
Subject: memory tiering: count PGPROMOTE_SUCCESS when mem tiering is enabled.
Date: Wed, 24 Jul 2024 09:01:15 -0400

memory tiering can be enabled/disabled at runtime and
sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING is used to
check it.  In migrate_misplaced_folio(), the check is missing when
PGPROMOTE_SUCCESS is incremented.  Add the missing check.

Link: https://lkml.kernel.org/r/20240724130115.793641-4-ziy@nvidia.com
Fixes: 33024536bafd ("memory tiering: hot page selection with hint page fault latency")
Reported-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Closes: https://lore.kernel.org/linux-mm/f4ae2c9c-fe40-4807-bdb2-64cf2d716c1a@huawei.com/
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~memory-tiering-count-pgpromote_success-when-mem-tiering-is-enabled
+++ a/mm/migrate.c
@@ -2630,7 +2630,9 @@ int migrate_misplaced_folio(struct folio
 		putback_movable_pages(&migratepages);
 	if (nr_succeeded) {
 		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
-		if (!node_is_toptier(folio_nid(folio)) && node_is_toptier(node))
+		if ((sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
+		    && !node_is_toptier(folio_nid(folio))
+		    && node_is_toptier(node))
 			mod_node_page_state(pgdat, PGPROMOTE_SUCCESS,
 					    nr_succeeded);
 	}
_

Patches currently in -mm which might be from ziy@nvidia.com are

memory-tiering-read-last_cpupid-correctly-in-do_huge_pmd_numa_page.patch
memory-tiering-introduce-folio_use_access_time-check.patch
memory-tiering-count-pgpromote_success-when-mem-tiering-is-enabled.patch

