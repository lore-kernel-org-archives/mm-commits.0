Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A69A12B75
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957001; cv=none; b=bi2DemFYf+mjhkn+Z41XCrsrq5p5pdOvv36lJJ7Z9NMgozzNq60MZhqDi3aLeWJPRlflmfb+Cfoa4UOT+LdzDFyK33Smu59MjFtVZ9b2BgB4OFO1AIDE59MdK6e6QEwu0DacWHmT0TPwLR2oj99FHuuXnL7rP6CPY//SjYzWeek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957001; c=relaxed/simple;
	bh=yBYPnDHK6gPBvZnPDS/8l1z6Bey/MaPcrDbqVtFSPVo=;
	h=Date:To:From:Subject:Message-Id; b=IFfCEccvCn/6U8av5MlIedH1dEfjoxtuK+UuIyMpktxplqWt+sRUZkLCGcSkUl1dbMADS+HixcJb53G7j5Q1YaOLrrhIGtCLonWTriYjBSptkZuBUnTypgXW2olwmIMh+Nq9clQ8yUxk6SleUJGrD7pVJEmXqHTv00CUBdxaqK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nd13K4DQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nd13K4DQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23E7C116B1;
	Mon,  6 May 2024 00:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957000;
	bh=yBYPnDHK6gPBvZnPDS/8l1z6Bey/MaPcrDbqVtFSPVo=;
	h=Date:To:From:Subject:From;
	b=Nd13K4DQlYHDBb+crutu1wXihMI6z3z9Z28+1pFpPMo6g+1iS5ocuey3KhZ9L6O6C
	 ezxC9MQUkD/iETGwQFlDCxgxG/FHtlw/e6ZMUIxZty7bVQK+jX9of7UNyjMTQ8cJky
	 D3yfIQxQJbrCreKSv341j9u7+4YzTtctCAKxjnXo=
Date: Sun, 05 May 2024 17:56:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ysato@users.sourceforge.jp,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,richardycc@google.com,peterx@redhat.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jcmvbkbc@gmail.com,hughd@google.com,glaubitz@physik.fu-berlin.de,fengwei.yin@intel.com,dalias@libc.org,corbet@lwn.net,chris@zankel.net,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-improve-folio_likely_mapped_shared-using-the-mapcount-of-large-folios.patch removed from -mm tree
Message-Id: <20240506005640.A23E7C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: improve folio_likely_mapped_shared() using the mapcount of large folios
has been removed from the -mm tree.  Its filename was
     mm-improve-folio_likely_mapped_shared-using-the-mapcount-of-large-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: improve folio_likely_mapped_shared() using the mapcount of large folios
Date: Tue, 9 Apr 2024 21:22:48 +0200

We can now read the mapcount of large folios very efficiently.  Use it to
improve our handling of partially-mappable folios, falling back to making
a guess only in case the folio is not "obviously mapped shared".

We can now better detect partially-mappable folios where the first page is
not mapped as "mapped shared", reducing "false negatives"; but false
negatives are still possible.

While at it, fixup a wrong comment (false positive vs.  false negative)
for KSM folios.

Link: https://lkml.kernel.org/r/20240409192301.907377-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
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
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-improve-folio_likely_mapped_shared-using-the-mapcount-of-large-folios
+++ a/include/linux/mm.h
@@ -2184,7 +2184,7 @@ static inline size_t folio_size(struct f
  *       indicate "mapped shared" (false positive) when two VMAs in the same MM
  *       cover the same file range.
  *    #. For (small) KSM folios, the return value can wrongly indicate "mapped
- *       shared" (false negative), when the folio is mapped multiple times into
+ *       shared" (false positive), when the folio is mapped multiple times into
  *       the same MM.
  *
  * Further, this function only considers current page table mappings that
@@ -2201,7 +2201,22 @@ static inline size_t folio_size(struct f
  */
 static inline bool folio_likely_mapped_shared(struct folio *folio)
 {
-	return page_mapcount(folio_page(folio, 0)) > 1;
+	int mapcount = folio_mapcount(folio);
+
+	/* Only partially-mappable folios require more care. */
+	if (!folio_test_large(folio) || unlikely(folio_test_hugetlb(folio)))
+		return mapcount > 1;
+
+	/* A single mapping implies "mapped exclusively". */
+	if (mapcount <= 1)
+		return false;
+
+	/* If any page is mapped more than once we treat it "mapped shared". */
+	if (folio_entire_mapcount(folio) || mapcount > folio_nr_pages(folio))
+		return true;
+
+	/* Let's guess based on the first subpage. */
+	return atomic_read(&folio->_mapcount) > 0;
 }
 
 #ifndef HAVE_ARCH_MAKE_PAGE_ACCESSIBLE
_

Patches currently in -mm which might be from david@redhat.com are


