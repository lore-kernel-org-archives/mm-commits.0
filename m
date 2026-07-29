Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534763019D9
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 00:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785285486; cv=none; b=lKg/DEU3ppwBmHshIaSGovFbCFe8KI7WRCVVloJguwrvY4y/z6ELuUOHh7Q+D09f5wQpHT/ob5qn7Qj8UGMXgQMGhMyzfyrYjWkzWZE0Kz5at7d5ExPctv7tBTO0z0A5TclRXrQJ7TbfAGnIXfnXMp7nVW4gKhRvOQzmiQt8A4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785285486; c=relaxed/simple;
	bh=K0TU+s/YjIvSTdNfhKP6FAPkkr4dcVj9m+C9SGZMmfk=;
	h=Date:To:From:Subject:Message-Id; b=VxfjjBiWVPvJ7Lp6bZExjXuNwD4vEWTGXZruqkSiqpe2DC6pHjwv+3pNaoXmTAn4w4x2kiAWymskHQ3+Oq+ttpxZsMaNLCxm23z46sdd/LLDAxoqePkqhmxhknWq1eTKFqsCODYodlo19z4I01Jw8IL/K/twC8tqbGxkTKk3Jr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G5CluWpT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G5CluWpT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBB21F00A3D;
	Wed, 29 Jul 2026 00:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785285483;
	bh=Plk3roBqRj/+f0UHzhXAc4c0ykTzqVvBc+x1uZt2h70=;
	h=Date:To:From:Subject;
	b=G5CluWpToyvNcOypl3S0oM61kMTHE3sRc3KOKs3SqlTfanf4CZip1CGtGcI5m4PVB
	 r57iXJrdUaauXF1Ok0bw3LUNSN3I8bIciSlzIcIYl33MI5+mmjcbDmMQgYF7wkGgD3
	 bIbzIh93gpYZJhAEHrtxGhtqjFrMBVPgFacQXorw=
Date: Tue, 28 Jul 2026 17:38:03 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,willy@infradead.org,rakie.kim@sk.com,osalvador@suse.de,matthew.brost@intel.com,ljs@kernel.org,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-migrate-exclude-hugetlb-folios-from-mthp_stat_nr_anon-accounting.patch removed from -mm tree
Message-Id: <20260729003803.7CBB21F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: exclude hugetlb folios from MTHP_STAT_NR_ANON accounting
has been removed from the -mm tree.  Its filename was
     mm-migrate-exclude-hugetlb-folios-from-mthp_stat_nr_anon-accounting.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: mm/migrate: exclude hugetlb folios from MTHP_STAT_NR_ANON accounting
Date: Fri, 17 Jul 2026 00:45:00 -0600

__folio_migrate_mapping() increments MTHP_STAT_NR_ANON for the destination
folio when `folio_test_anon(folio) && folio_test_large(folio)` is true. 
However, hugetlb folios satisfy both conditions despite having a
completely separate accounting system — they use hugetlb_add_anon_rmap()
which does not touch mTHP stats, and their free path also bypasses the
mTHP decrement in __free_pages_prepare().

This causes MTHP_STAT_NR_ANON to be incremented on each hugetlb migration
without a corresponding decrement, permanently inflating the nr_anon
counter.

Add a !folio_test_hugetlb() check to __folio_migrate_mapping() so that
only actual mTHP folios are counted.

Link: https://lore.kernel.org/20260717064502.1980173-3-npache@redhat.com
Fixes: 5d65c8d758f2 ("mm: count the number of anonymous THPs per size")
Co-developed-by: David Hildenbrand <david@kernel.org>
Signed-off-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Nico Pache <npache@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-exclude-hugetlb-folios-from-mthp_stat_nr_anon-accounting
+++ a/mm/migrate.c
@@ -590,7 +590,8 @@ static int __folio_migrate_mapping(struc
 		/* No turning back from here */
 		newfolio->index = folio->index;
 		newfolio->mapping = folio->mapping;
-		if (folio_test_anon(folio) && folio_test_large(folio))
+		if (folio_test_anon(folio) && folio_test_large(folio) &&
+		    !folio_test_hugetlb(folio))
 			mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON, 1);
 		if (folio_test_swapbacked(folio))
 			__folio_set_swapbacked(newfolio);
_

Patches currently in -mm which might be from npache@redhat.com are


