Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E5D38C2AA;
	Thu,  2 Jul 2026 21:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783028107; cv=none; b=d27G/uAw0+XRhY+cFxWaZNDblcQetzSigMAxzoqPnR5aooxSWRk6xk9g49xgOEyTiF7e3/cdErbT7P3PLdVWyuAvnTY6u6s5WcTQC2jUXIe+Ou6WuDwYI8i85N8vZhrOmza+Pf/kB+dkCyHMYXIYxqbL9hSp59w1aFs7V9RuYU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783028107; c=relaxed/simple;
	bh=3bOUGYvyxSb+VbTe5yG+v/6uMTDuQVwjKxnDCAeWlLM=;
	h=Date:To:From:Subject:Message-Id; b=kShkNviTXXKmyyJI/uP9RlLW02z6pmJAn8178v70I/gbXNJ0PWEQfvtoOXxbZ2jsD3vEZ+YWdxjywpS/vGhs+17nHjqfpDuZkHcJGfWyz6Wl0sjgJTCzfDGMVCpwDDh1xYq9ddCy88D6snnP4fGCYMaeCb0RehTus96XOYKg6So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Te5dRGJ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Te5dRGJ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB381F000E9;
	Thu,  2 Jul 2026 21:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783028106;
	bh=LQeciwc9CKUEDLecvWUrR2XSbiW5G7ZO/tuvK40MfGI=;
	h=Date:To:From:Subject;
	b=Te5dRGJ7GRKxRTSfrgAsItuz9d5DVbpKYvhnt4l32UCsC/nrOF64LkJKoNXHjEQdr
	 ccg+M/bIP7ukDbNvNK5cnCtMW15M/mcdIG/BjpcVyuXpOffi+ZabKxFXyjggSyNfOe
	 lWmL8eI3A/tW/AOFVM5N0rlaaBp/ZamH2BJCBhUc=
Date: Thu, 02 Jul 2026 14:35:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,willy@infradead.org,stable@vger.kernel.org,rakie.kim@sk.com,osalvador@suse.de,matthew.brost@intel.com,ljs@kernel.org,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,baohua@kernel.org,apopple@nvidia.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-decrement-mthp_stat_nr_anon-in-free_zone_device_folio.patch added to mm-hotfixes-unstable branch
Message-Id: <20260702213505.DCB381F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: decrement MTHP_STAT_NR_ANON in free_zone_device_folio()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-decrement-mthp_stat_nr_anon-in-free_zone_device_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-decrement-mthp_stat_nr_anon-in-free_zone_device_folio.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Nico Pache <npache@redhat.com>
Subject: mm: decrement MTHP_STAT_NR_ANON in free_zone_device_folio()
Date: Thu, 2 Jul 2026 11:25:46 -0600

Patch series "mm: fix PMD level mTHP accounting bugs".

While running selftests I noticed the PMD level per-mTHP stats (nr_anon)
remained elevated after each run.  After further investigation I noticed
this accounting error occurs for both the migration.private_anon_htlb_test
and the HMM tests.

In the HMM case this is due to folio_add_new_anon_rmap() incrementing the
mTHP stats, but never containing a corresponding decrement in
free_zone_device_folio().  We solve this by making sure to decrement the
counter when freeing device memory.

In the migration case, we are incrementing this counter without first
checking whether this folio is a hugetlb folio, which relies on a separate
accounting system.  We solve this by adding the proper hugetlb check
before incrementing this counter.

With these changes in place, the two tests no longer cause elevated PMD
level accounting issues.


This patch (of 2):

When a zone device folio is mapped as anonymous, folio_add_new_anon_rmap()
increments MTHP_STAT_NR_ANON.  The corresponding decrement lives in
__free_pages_prepare() in page_alloc.c, but zone device folios are freed
via free_zone_device_folio() which never calls __free_pages_prepare(). 
This causes nr_anon to remain permanently elevated after zone device
folios are freed.

Add the missing mod_mthp_stat() decrement to free_zone_device_folio() so
that the counter is properly balanced.

Link: https://lore.kernel.org/20260702172548.37075-1-npache@redhat.com
Link: https://lore.kernel.org/20260702172548.37075-2-npache@redhat.com
Fixes: 5d65c8d758f2 ("mm: count the number of anonymous THPs per size")
Co-developed-by: David Hildenbrand <david@kernel.org>
Signed-off-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Nico Pache <npache@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memremap.c~mm-decrement-mthp_stat_nr_anon-in-free_zone_device_folio
+++ a/mm/memremap.c
@@ -425,6 +425,7 @@ void free_zone_device_folio(struct folio
 	mem_cgroup_uncharge(folio);
 
 	if (folio_test_anon(folio)) {
+		mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON, -1);
 		for (i = 0; i < nr; i++)
 			__ClearPageAnonExclusive(folio_page(folio, i));
 	}
_

Patches currently in -mm which might be from npache@redhat.com are

mm-decrement-mthp_stat_nr_anon-in-free_zone_device_folio.patch
mm-migrate-exclude-hugetlb-folios-from-mthp_stat_nr_anon-accounting.patch

