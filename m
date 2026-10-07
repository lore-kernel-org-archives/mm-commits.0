Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA57E2C3245
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334178; cv=none; b=D5S362/eim/bkubSlP2GVl75oxSXlJr1frqbQM6Uldvyi7b40lzjqQ4AbNmaesLmLWswj4uOctNikwLyP8/3VYuMTwpYzWZ/euP2JcEtxE1O0hB4pBHfIMctLtY6/r/+DL2RDEUq1qHU/3dlOuHzAjhwyKKdLOo0vm5fsi0P/wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334178; c=relaxed/simple;
	bh=l/hQ5x+oca+tjGUgri+odbLwsAB2wk+RLuqs1wQu+Uk=;
	h=Date:To:From:Subject:Message-Id; b=LX8Zu0/4skHWS2eKY2vH2hGgWc/RVraeuA9Ol+H8E6UhWR8uGe3QaiUDgVgQ0b04WU7IMHe9u4UYbLdLXpETDzBb04HDi30Tmcv1IolHfReUl0+57mqKQpdEYJws/EtHDXfnKn8Oor++nrg368gvDPk6fG1ELkycprSDyScGH6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NlrwwO2G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NlrwwO2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5E21F0089B;
	Wed,  7 Oct 2026 00:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334176;
	bh=J9ueVlKK4yPZG8wFMHo/g6R9aer9pXzye3sJz3OW+2g=;
	h=Date:To:From:Subject;
	b=NlrwwO2GfS6A9hFDCoqjytBnl5rs5hKEbCPPFfWr8+3I/HQ3vUDPoo4KVG6bQ1DGC
	 RNMgR/MnI6IOqfL+BCjreTqNbjlj2T4n/+FTXRcSzlzG7DtIiezy6jQECm4+qTKwx/
	 MGo2DBHgzvkMgtM/qQviXryQU/Cnvosw9SB76lTc=
Date: Tue, 06 Oct 2026 17:49:36 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david.laight.linux@gmail.com,david@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-localize-huge_bootmem_zones_valid.patch removed from -mm tree
Message-Id: <20261007004936.7D5E21F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: localize HUGE_BOOTMEM_ZONES_VALID
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-localize-huge_bootmem_zones_valid.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/hugetlb: localize HUGE_BOOTMEM_ZONES_VALID
Date: Thu, 10 Sep 2026 14:32:56 +0800

HUGE_BOOTMEM_ZONES_VALID is only used by the huge_bootmem_page flag
handling in mm/hugetlb.c.  Keep the definition next to that private data
structure instead of exposing it through the public hugetlb header.

No functional change is intended.

Link: https://lore.kernel.org/20260910063256.64386-18-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 include/linux/hugetlb.h |    2 --
 mm/hugetlb.c            |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-localize-huge_bootmem_zones_valid
+++ a/include/linux/hugetlb.h
@@ -675,8 +675,6 @@ struct hstate {
 	char name[HSTATE_NAME_LEN];
 };
 
-#define HUGE_BOOTMEM_ZONES_VALID	BIT(0)
-
 int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
 void wait_for_freed_hugetlb_folios(void);
--- a/mm/hugetlb.c~mm-hugetlb-localize-huge_bootmem_zones_valid
+++ a/mm/hugetlb.c
@@ -55,6 +55,8 @@
 #include "sparse.h"
 #include <linux/page-isolation.h>
 
+#define HUGE_BOOTMEM_ZONES_VALID	BIT(0)
+
 struct huge_bootmem_page {
 	struct list_head list;
 	struct hstate *hstate;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


