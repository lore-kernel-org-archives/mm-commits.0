Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60255CB0
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957012; cv=none; b=TKozydcRD/Rj8qCxVVWaxM1k3NvXJ5XLmMoRdJHZL+6077s4MsqU5TfCVAbHW0wOtY2TbARM1qYTDSJy+4UMRsuytmHAPYlqHsCogZJyFUq0M9YWI0qwMotrG2jhYL7V6ygY+FAN5ZxeePP7VGnCoQh1LVp39E06GsX7ni0K17s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957012; c=relaxed/simple;
	bh=y0ZNROo90zfjMAAVbemir2h8pmSApECpj5FEg5WeZY8=;
	h=Date:To:From:Subject:Message-Id; b=CAIrsENKgVbRUPMmjxrV1Rf4N7zczUpt2+hZgCpg/TQ0k8gjVP6hb4z4Q/2hIftbkTOvaAXa2TuaRFM6LDUdQtTEZDEtgJBr5G6Ozmfr5BeD0Bs9YSNNLyrCWEl2EorvaOcZks6tr7OquCmzGSAsfGDsDD10rA4yBj1r4mgQhJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fk+JjVkX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fk+JjVkX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62767C113CC;
	Mon,  6 May 2024 00:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957012;
	bh=y0ZNROo90zfjMAAVbemir2h8pmSApECpj5FEg5WeZY8=;
	h=Date:To:From:Subject:From;
	b=Fk+JjVkXanq5q9wJFkjxkMiHuGJU2JR3rJPoFFuMbFjJbOH7bSkNlnitKlyvOU00E
	 HrC+7qexvCN9yyrNL49FRcBoEPQb3SI6U5rxXHQUre92dOIilkRR+mP7CATNMWmij/
	 BqIfkstdIDX7+Qa8yJlCUhv1eAyYX2z2ECvx08nU=
Date: Sun, 05 May 2024 17:56:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ysato@users.sourceforge.jp,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,richardycc@google.com,peterx@redhat.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jcmvbkbc@gmail.com,hughd@google.com,glaubitz@physik.fu-berlin.de,fengwei.yin@intel.com,dalias@libc.org,corbet@lwn.net,chris@zankel.net,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate_device-use-folio_mapcount-in-migrate_vma_check_page.patch removed from -mm tree
Message-Id: <20240506005652.62767C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate_device: use folio_mapcount() in migrate_vma_check_page()
has been removed from the -mm tree.  Its filename was
     mm-migrate_device-use-folio_mapcount-in-migrate_vma_check_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/migrate_device: use folio_mapcount() in migrate_vma_check_page()
Date: Tue, 9 Apr 2024 21:22:57 +0200

We want to limit the use of page_mapcount() to the places where it is
absolutely necessary.  Let's convert migrate_vma_check_page() to work on a
folio internally so we can remove the page_mapcount() usage.

Note that we reject any large folios.

There is a lot more folio conversion to be had, but that has to wait for
another day.  No functional change intended.

Link: https://lkml.kernel.org/r/20240409192301.907377-15-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Richard Chang <richardycc@google.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/migrate_device.c~mm-migrate_device-use-folio_mapcount-in-migrate_vma_check_page
+++ a/mm/migrate_device.c
@@ -324,6 +324,8 @@ static void migrate_vma_collect(struct m
  */
 static bool migrate_vma_check_page(struct page *page, struct page *fault_page)
 {
+	struct folio *folio = page_folio(page);
+
 	/*
 	 * One extra ref because caller holds an extra reference, either from
 	 * isolate_lru_page() for a regular page, or migrate_vma_collect() for
@@ -336,18 +338,18 @@ static bool migrate_vma_check_page(struc
 	 * check them than regular pages, because they can be mapped with a pmd
 	 * or with a pte (split pte mapping).
 	 */
-	if (PageCompound(page))
+	if (folio_test_large(folio))
 		return false;
 
 	/* Page from ZONE_DEVICE have one extra reference */
-	if (is_zone_device_page(page))
+	if (folio_is_zone_device(folio))
 		extra++;
 
 	/* For file back page */
-	if (page_mapping(page))
-		extra += 1 + page_has_private(page);
+	if (folio_mapping(folio))
+		extra += 1 + folio_has_private(folio);
 
-	if ((page_count(page) - extra) > page_mapcount(page))
+	if ((folio_ref_count(folio) - extra) > folio_mapcount(folio))
 		return false;
 
 	return true;
_

Patches currently in -mm which might be from david@redhat.com are


