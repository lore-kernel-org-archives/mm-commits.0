Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1387E3264FF
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334374; cv=none; b=TbS+ZhcFC84CCLjuyOLju1jmVF0izXL1Cgowl/9CaGEUsTh8qrmqDZk1yakqW+U5FZZdbBi4wTksheDUPZkPX3vV3SLbc4WCgSaDZm+j6O5BlvkXF2hEWANRuI7oO5DQ+GbOcJqW9cWfz9hqvyVEw+9XNlI505TnpV2eHXYCl7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334374; c=relaxed/simple;
	bh=Sk297RSb9P3nUIsbUh4qxn/zEe/DA6OS/Gbkcj06TPU=;
	h=Date:To:From:Subject:Message-Id; b=TAzuzEFNI3RaKWAdWCRvzfJxaV939vQ3ted+HkgdGXq3Hv+DLrH/CXb7JZjp5K5gG9S8ChD4aH9B5aiVXCdznlMrx0AtJrM7bhHbf67trN/VbOfsyF8TL5EkYC9iYqYhYdthNJ45GbNIyQCijxk4IoC8hLhj5CyG3LK9lCE2aw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jqu75cYh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jqu75cYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F471F0089B;
	Wed,  7 Oct 2026 00:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334373;
	bh=3T3aDBQKT5QDAMrOVUhylIyKmPgamr5O2TYMIOoDSZw=;
	h=Date:To:From:Subject;
	b=Jqu75cYh07iCMJvLm1LKQi2kgty8fr44mOoeZZqmbCgAF7uuHjgbeqClvPqRYytI8
	 6zfmWwbu/43qAzAQdvOUwtRFan6BsXsygMS4Mxfv64aFrYzMm1onJY+TSXd2VlFyfv
	 LhiDT3yJ4L9clgSLgI0RBW2Gdu55ZvzoSJEg6URg=
Date: Tue, 06 Oct 2026 17:52:52 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,xueyuan.chen21@gmail.com,weixugc@google.com,stevensd@chromium.org,shakeel.butt@linux.dev,ridong.chen@linux.dev,mhocko@kernel.org,ljs@kernel.org,lianux.mm@gmail.com,kunwu.chan@gmail.com,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-make-lru-folio-prefetch-helper-an-inline-function.patch removed from -mm tree
Message-Id: <20261007005252.E4F471F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: make LRU folio prefetch helper an inline function
has been removed from the -mm tree.  Its filename was
     mm-mglru-make-lru-folio-prefetch-helper-an-inline-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm/mglru: make LRU folio prefetch helper an inline function
Date: Wed, 2 Sep 2026 07:24:19 +0800

`prefetchw_prev_lru_folio()` is currently implemented as a macro with a
potentially unused argument.  This makes the helper harder to read and can
also trigger checkpatch warnings about unused macro arguments.

Make it a `static inline` function and remove the unnecessary `_field`
argument.  The helper always prefetches the previous folio's `flags`, so
there is no need to make the field configurable.

Link: https://lore.kernel.org/20260901232421.40157-6-baohua@kernel.org
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Stevens <stevensd@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Ridong Chen <ridong.chen@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
---

 mm/vmscan.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

--- a/mm/vmscan.c~mm-mglru-make-lru-folio-prefetch-helper-an-inline-function
+++ a/mm/vmscan.c
@@ -182,17 +182,21 @@ struct scan_control {
 };
 
 #ifdef ARCH_HAS_PREFETCHW
-#define prefetchw_prev_lru_folio(_folio, _base, _field)			\
-	do {								\
-		if ((_folio)->lru.prev != _base) {			\
-			struct folio *prev;				\
-									\
-			prev = lru_to_folio(&(_folio->lru));		\
-			prefetchw(&prev->_field);			\
-		}							\
-	} while (0)
+static inline void prefetchw_prev_lru_folio(struct folio *folio,
+		struct list_head *base)
+{
+	if (folio->lru.prev != base) {
+		struct folio *prev;
+
+		prev = lru_to_folio(&folio->lru);
+		prefetchw(&prev->flags);
+	}
+}
 #else
-#define prefetchw_prev_lru_folio(_folio, _base, _field) do { } while (0)
+static inline void prefetchw_prev_lru_folio(struct folio *folio,
+		struct list_head *base)
+{
+}
 #endif
 
 /*
@@ -1700,7 +1704,7 @@ static unsigned long isolate_lru_folios(
 		struct folio *folio;
 
 		folio = lru_to_folio(src);
-		prefetchw_prev_lru_folio(folio, src, flags);
+		prefetchw_prev_lru_folio(folio, src);
 
 		nr_pages = folio_nr_pages(folio);
 		total_scan += nr_pages;
_

Patches currently in -mm which might be from baohua@kernel.org are

mm-mglru-restore-accidentally-removed-seq-max_seq-check.patch

