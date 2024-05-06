Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58AEDF9CF
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714956998; cv=none; b=uxCA4fenoB6iE8egoT9OzCPE6J0V0WNQXmeGMUiJ2l3n8qakhDAoPmACaeiHvOMR7xngS5zb/SlYTo3sI/D6IQb4+5B9Fw+6Q+PerBL4mYEYHIzWAxz8qzZwIyGQc1mDCYDB0JeicUqEmtwYExg9YPtge7KukKFBsb3MAZIeuyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714956998; c=relaxed/simple;
	bh=3kFgsNeCbm0wiCAppepYYenCxnrE2E3wF2TQ3+Ig4Ys=;
	h=Date:To:From:Subject:Message-Id; b=XBXSPxNAnSwd4yTvVvCZ2SlLcD8ZhsgAXBOuJKEsRBqxVimuxFL3HT7vezVNWnhZQ8ydptiWoPKalRjpHt3gieUQ2QPmHol+ZTL0TtQ3rlGhHnYXuH4qqrpHCYttkUDyVFHyq+nsWbXgJ9gQNwXftDvkPi5Fa9ocOnx7bB3umAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HPLgUxP1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HPLgUxP1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB01C113CC;
	Mon,  6 May 2024 00:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714956998;
	bh=3kFgsNeCbm0wiCAppepYYenCxnrE2E3wF2TQ3+Ig4Ys=;
	h=Date:To:From:Subject:From;
	b=HPLgUxP1BHidlTWyUgwEV2up3eC1AIPR+sOROwUyxkRa+J8aFLBAtKHbfDI0nWGaY
	 79NWieLh+seLUEEqfDDazbm4MUjb3Cmg9aAiCXjHzt+7i6X7d57a6255cjV8ZhpdC7
	 xHLBBzJURHIlPKzs+aU0zcUULga4pWJVAbB6P32k=
Date: Sun, 05 May 2024 17:56:37 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ysato@users.sourceforge.jp,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,richardycc@google.com,peterx@redhat.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jcmvbkbc@gmail.com,hughd@google.com,glaubitz@physik.fu-berlin.de,fengwei.yin@intel.com,dalias@libc.org,corbet@lwn.net,chris@zankel.net,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-add-fast-path-for-small-folios-when-adding-removing-duplicating.patch removed from -mm tree
Message-Id: <20240506005638.2CB01C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: add fast-path for small folios when adding/removing/duplicating
has been removed from the -mm tree.  Its filename was
     mm-rmap-add-fast-path-for-small-folios-when-adding-removing-duplicating.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: add fast-path for small folios when adding/removing/duplicating
Date: Tue, 9 Apr 2024 21:22:46 +0200

Let's add a fast-path for small folios to all relevant rmap functions. 
Note that only RMAP_LEVEL_PTE applies.

This is a preparation for tracking the mapcount of large folios in a
single value.

Link: https://lkml.kernel.org/r/20240409192301.907377-4-david@redhat.com
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

 include/linux/rmap.h |   13 +++++++++++++
 mm/rmap.c            |   26 ++++++++++++++++----------
 2 files changed, 29 insertions(+), 10 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-add-fast-path-for-small-folios-when-adding-removing-duplicating
+++ a/include/linux/rmap.h
@@ -322,6 +322,11 @@ static __always_inline void __folio_dup_
 
 	switch (level) {
 	case RMAP_LEVEL_PTE:
+		if (!folio_test_large(folio)) {
+			atomic_inc(&page->_mapcount);
+			break;
+		}
+
 		do {
 			atomic_inc(&page->_mapcount);
 		} while (page++, --nr_pages > 0);
@@ -405,6 +410,14 @@ static __always_inline int __folio_try_d
 				if (PageAnonExclusive(page + i))
 					return -EBUSY;
 		}
+
+		if (!folio_test_large(folio)) {
+			if (PageAnonExclusive(page))
+				ClearPageAnonExclusive(page);
+			atomic_inc(&page->_mapcount);
+			break;
+		}
+
 		do {
 			if (PageAnonExclusive(page))
 				ClearPageAnonExclusive(page);
--- a/mm/rmap.c~mm-rmap-add-fast-path-for-small-folios-when-adding-removing-duplicating
+++ a/mm/rmap.c
@@ -1172,15 +1172,18 @@ static __always_inline unsigned int __fo
 
 	switch (level) {
 	case RMAP_LEVEL_PTE:
+		if (!folio_test_large(folio)) {
+			nr = atomic_inc_and_test(&page->_mapcount);
+			break;
+		}
+
 		do {
 			first = atomic_inc_and_test(&page->_mapcount);
-			if (first && folio_test_large(folio)) {
+			if (first) {
 				first = atomic_inc_return_relaxed(mapped);
-				first = (first < ENTIRELY_MAPPED);
+				if (first < ENTIRELY_MAPPED)
+					nr++;
 			}
-
-			if (first)
-				nr++;
 		} while (page++, --nr_pages > 0);
 		break;
 	case RMAP_LEVEL_PMD:
@@ -1514,15 +1517,18 @@ static __always_inline void __folio_remo
 
 	switch (level) {
 	case RMAP_LEVEL_PTE:
+		if (!folio_test_large(folio)) {
+			nr = atomic_add_negative(-1, &page->_mapcount);
+			break;
+		}
+
 		do {
 			last = atomic_add_negative(-1, &page->_mapcount);
-			if (last && folio_test_large(folio)) {
+			if (last) {
 				last = atomic_dec_return_relaxed(mapped);
-				last = (last < ENTIRELY_MAPPED);
+				if (last < ENTIRELY_MAPPED)
+					nr++;
 			}
-
-			if (last)
-				nr++;
 		} while (page++, --nr_pages > 0);
 		break;
 	case RMAP_LEVEL_PMD:
_

Patches currently in -mm which might be from david@redhat.com are


