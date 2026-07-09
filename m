Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C694DC52D
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 18:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783621443; cv=none; b=l5MhmeHW3TX/6Sn/27winf0nhv/DlGAiFW9vTBgljwb24YfnZDXgaHb2eMYVJvRZ9eoCsFlhJONU/qz7wSPgJbkEOf/Y8cIRYzgFt+bYnhWfk4XkKMWIqCZSw82m1PPQ1J/o+E/lrfBNGmRxbi2XgZ0Fz1oWT7Em+E+QHSVvHIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783621443; c=relaxed/simple;
	bh=jqIWIHslGyrxV1HZnryk94NZgfh/UIG/orEbAwDoDKY=;
	h=Date:To:From:Subject:Message-Id; b=MuHvAjbp5w9yYlKKozVoEQvST3Nh+l62+R44JN7oOzsPXt0H/keFrFOHqcZZYfXDyVJpwwlyFISNVxV6lz7WsIcg+EZXCxgpN5xQ9KUUnuRa/rg+YIuU8Z6DkH2+oa3X/n7EiwtQ3BQX5chnhJEHCnnfI4oK4KpQZQIcSIyxPFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DHMj8660; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DHMj8660"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF39F1F00A3E;
	Thu,  9 Jul 2026 18:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783621441;
	bh=Kl8B02CUGoFHN0W2858uj3MWFLRyKZmMmeG7GQHkjJ4=;
	h=Date:To:From:Subject;
	b=DHMj8660mNRcFj+9bjS6+yvrdslbeoRzD7rUuW/UAznf5QvKp5W/LkFoTC2VAbtmy
	 uonq0aBhhqQFaqTwTzNnKbdENbWAJLliAtdaanTXOdUVXUZfVV8/2WxM/ivORohz4g
	 iyhl/q4ySWbUSUmB6/EFlWkIe1q/+O+U6dUiOABk=
Date: Thu, 09 Jul 2026 11:24:01 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time.patch removed from -mm tree
Message-Id: <20260709182401.CF39F1F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: make sure tail_page->private is zero at page free time
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/page_alloc: make sure tail_page->private is zero at page free time
Date: Fri, 03 Jul 2026 09:47:49 -0400

Any code using tail_page->private of a folio, a compound page or a
high-order page is supposed to reset it after use, otherwise ->private
data can leak to new page user and cause unexpected issues.  Add a
bad_page() check at page free path for it.

Link: https://lore.kernel.org/20260703-keep-subpage-private-zero-at-free-v2-4-2970fe777dd6@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time
+++ a/mm/page_alloc.c
@@ -1377,15 +1377,22 @@ static __always_inline bool __free_pages
 #endif
 		}
 		for (i = 1; i < (1 << order); i++) {
+			struct page *tail_page = page + i;
+
 			if (compound)
-				bad += free_tail_page_prepare(page, page + i);
+				bad += free_tail_page_prepare(page, tail_page);
 			if (is_check_pages_enabled()) {
-				if (free_page_is_bad(page + i)) {
+				if (free_page_is_bad(tail_page)) {
 					bad++;
 					continue;
 				}
 			}
-			(page + i)->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
+			tail_page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
+			if (is_check_pages_enabled() && tail_page->private) {
+				bad_page(tail_page, "nonzero private");
+				bad++;
+				continue;
+			}
 		}
 	}
 	if (folio_test_anon(folio)) {
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-page_owner-add-numa-node-filter-fix.patch
mm-page_alloc-remove-set_page_private-in-prep_compound_tail.patch

