Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928A13D3B3
	for <mm-commits@vger.kernel.org>; Sat, 18 Jul 2026 01:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784338245; cv=none; b=PSb27w7dXPtEs3YKoRqm+KIn7wlwS+BDZPX/x5QvimWljNAfqssIa2+uFipnaR3oMlDtIcCE0Cuv3g3PRtnSUBH74HHFPeybDBWGI80ofzgaQCYlzFiPMewYoqmhlJ2YNozKRX6abzmNvYAtmeHT19Q9KSgxdFTgYXL8ikYm5as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784338245; c=relaxed/simple;
	bh=NZtEIC8h7lEWJMMr1fh78Olz/N+5oDDcaHhYW92QpjE=;
	h=Date:To:From:Subject:Message-Id; b=L2hxD9DqOrs+rpJxAvUDba3DPigbuc62gT+fdUMaameQHYMVBlYRevRPyLve80xxa3NNx5qo3rFS+oF85OGgXoU+D38jPbuSO3ntfN67d97y3w5ymGe6KeK/h9egMSpQreP4tSJlwnuBeXN59xISXtJZTdNw4g7O0dDUe6k7g+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gDZ+mB08; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gDZ+mB08"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6F91F000E9;
	Sat, 18 Jul 2026 01:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784338244;
	bh=wHWqlLSMO2yc0A7gq465JKc0ldTa0D2e7b1nV7sHJ9A=;
	h=Date:To:From:Subject;
	b=gDZ+mB08pmBM94JiVQ2wicnPmJCQ4YrrjlXLvEmuh28y8nJjnGBnK+IE51D1VnJLW
	 tLl03Qq/5+SIDKBmf8rWvfPO30laqtgdlgve4FCh4Z3wdQIreNWmEGaSEaBvC7qQhl
	 LexpP3C6d0nVJDTfb/sT3Pa9QP2tY6izv6o/NHgg=
Date: Fri, 17 Jul 2026 18:30:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,willy@infradead.org,rakie.kim@sk.com,osalvador@suse.de,matthew.brost@intel.com,ljs@kernel.org,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-exclude-hugetlb-folios-from-mthp_stat_nr_anon-accounting.patch added to mm-hotfixes-unstable branch
Message-Id: <20260718013044.1A6F91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate: exclude hugetlb folios from MTHP_STAT_NR_ANON accounting
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-migrate-exclude-hugetlb-folios-from-mthp_stat_nr_anon-accounting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-exclude-hugetlb-folios-from-mthp_stat_nr_anon-accounting.patch

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

mm-decrement-mthp_stat_nr_anon-in-free_zone_device_folio.patch
mm-migrate-exclude-hugetlb-folios-from-mthp_stat_nr_anon-accounting.patch

