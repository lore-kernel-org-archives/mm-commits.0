Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AFB7083C
	for <mm-commits@vger.kernel.org>; Sat, 18 Jul 2026 01:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784337817; cv=none; b=gM2DtbU3MhHHCS8bP8HDQfi0269TOzz7zrbTiiUe7LaGEc3A7JCDWOSDGdZ4lxEwS4a86Clg+zOWbdaYWMevH/xdA+XW7qwie+jipFBD68hzbXXNMj7fDw8fRwZyfcoseeUwagDpROFzaSYqG4mOAxc/7eHWYqM9O5VL1n9EsO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784337817; c=relaxed/simple;
	bh=WzJqok56mfkPoh9jn8qorDoIW69OXi5SEKri/fS4o7U=;
	h=Date:To:From:Subject:Message-Id; b=ZO1XvqsFJChr89NZOI8XH0ge00omMINqPKGRv68G3nAYbTjSVRxA4w2EmsPA1FDQPdvPawQCVXk2TyxJ4J54n/MDRSnTxLSM+7VeMPPLUeWYucunhKge87WGZakMsuXpxcHpdVJTzhRzO3FAX1cDiIm4IC/kiOFrzoZBYlhpxpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xxxzMIsc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xxxzMIsc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDF11F00A3A;
	Sat, 18 Jul 2026 01:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784337816;
	bh=Pw8Lz7aPVzKgYsKFeYOcUNe0S3UZQ2fskYI4hQMKWVA=;
	h=Date:To:From:Subject;
	b=xxxzMIscoQYAOH2aqQ7ZBdZrT0NY+S/S79iDi7AfRFMvOuYmg4B889JgcYopB15Nl
	 r1G/C1p+YrLWIv9jMTa3LM5eVJMqdglFSQBILjGR6Hin5NZUltajGnEaOSTJQFYhKk
	 GmtBAoafm+uLxWI+iZihO9I6+6lYC2t2sOiEPwfk=
Date: Fri, 17 Jul 2026 18:23:35 -0700
To: mm-commits@vger.kernel.org,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-migrate-exclude-hugetlb-folios-from-mthp_stat_nr_anon-accounting.patch removed from -mm tree
Message-Id: <20260718012335.EDDF11F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: exclude hugetlb folios from MTHP_STAT_NR_ANON accounting
has been removed from the -mm tree.  Its filename was
     mm-migrate-exclude-hugetlb-folios-from-mthp_stat_nr_anon-accounting.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: mm/migrate: exclude hugetlb folios from MTHP_STAT_NR_ANON accounting
Date: Thu, 2 Jul 2026 11:25:47 -0600

__folio_migrate_mapping() increments MTHP_STAT_NR_ANON for the destination
folio when `folio_test_anon(folio) && folio_test_large(folio)` is true. 
However, hugetlb folios satisfy both conditions despite having a
completely separate accounting system; they use hugetlb_add_anon_rmap()
which does not touch mTHP stats, and their free path also bypasses the
mTHP decrement in __free_pages_prepare().

This causes MTHP_STAT_NR_ANON to be incremented on each hugetlb migration
without a corresponding decrement, permanently inflating the nr_anon
counter.

Add a !folio_test_hugetlb() check to both places in
__folio_migrate_mapping() so that only actual mTHP folios are counted.

Link: https://lore.kernel.org/20260702172548.37075-3-npache@redhat.com
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

 mm/migrate.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

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
@@ -623,7 +624,8 @@ static int __folio_migrate_mapping(struc
 	 */
 	newfolio->index = folio->index;
 	newfolio->mapping = folio->mapping;
-	if (folio_test_anon(folio) && folio_test_large(folio))
+	if (folio_test_anon(folio) && folio_test_large(folio) &&
+	    !folio_test_hugetlb(folio))
 		mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON, 1);
 	folio_ref_add(newfolio, nr); /* add cache reference */
 	if (folio_test_swapbacked(folio))
_

Patches currently in -mm which might be from npache@redhat.com are


