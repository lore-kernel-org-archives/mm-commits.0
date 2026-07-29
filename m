Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B021F2380
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 00:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785285483; cv=none; b=jcCBB/C84UKdmRvKVQs76yEm2OG4g+RGCftaM3ID11Tmdb/gsxvGDUkQfRYPmweRuhDJsr1QnEvdhKpu1CLCO+sdgP8ir/hMDziwVESxE23H4AM9jy5OYUElNcm7iY98LROMHBCaPJKZLWOq+K/fAqwcqjnKA4u77ZcPxUMUOTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785285483; c=relaxed/simple;
	bh=X0jeJOIluikfdUcdXv9P/PYX2telQ/UiShYBrhX25W4=;
	h=Date:To:From:Subject:Message-Id; b=LEzbtuEhutHZ2PlBeFmilrHHnLwFtaNwRksSSoCNYslFtFtDvdBl/+0OSO6HnCIr+v5RD0YFMBn1e+/T5Fn/aUMyyUZg3TTSyuOizQB02kNd0/r6qoxENczFYjbnwTlLxFWXDbhWqk5Ae16SLUMJKoSZPcaALTUSAgSA/nerl4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zIBphTq3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zIBphTq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9BB41F00A3A;
	Wed, 29 Jul 2026 00:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785285481;
	bh=Nml+ixUA7LLFRrgRaN24MNZlp1Yr5mRmjvNasgSLEnk=;
	h=Date:To:From:Subject;
	b=zIBphTq313w8kObhGQCXgVucVcC32n4Kie+F3yCxoTq5p0JGPk/OGI/QXPPT4lxCU
	 ORIqDFi4vIdyCo7A49PyjgSgAa+Ay8Ex/jL8XteQxcjBIUwLJxe0qICg8jx1xPGhFZ
	 uU1hTCsJc8GEiuh0TblXJe7iiI5ZimR5Whdh2gcI=
Date: Tue, 28 Jul 2026 17:38:01 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,willy@infradead.org,rakie.kim@sk.com,osalvador@suse.de,matthew.brost@intel.com,ljs@kernel.org,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-decrement-mthp_stat_nr_anon-in-free_zone_device_folio.patch removed from -mm tree
Message-Id: <20260729003801.B9BB41F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: decrement MTHP_STAT_NR_ANON in free_zone_device_folio()
has been removed from the -mm tree.  Its filename was
     mm-decrement-mthp_stat_nr_anon-in-free_zone_device_folio.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: mm: decrement MTHP_STAT_NR_ANON in free_zone_device_folio()
Date: Fri, 17 Jul 2026 00:44:59 -0600

Patch series "mm: fix PMD level mTHP accounting bugs", v2.

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

Link: https://lore.kernel.org/20260717064502.1980173-1-npache@redhat.com
Link: https://lore.kernel.org/20260717064502.1980173-2-npache@redhat.com
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
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
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


