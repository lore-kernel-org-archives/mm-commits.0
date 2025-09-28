Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744E421FF3B
	for <mm-commits@vger.kernel.org>; Sun, 28 Sep 2025 18:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759085522; cv=none; b=NCFT80UX2CQ1jVD+QndQSfsZMWjC/cInFJML77DeZ4IhtSNgoxRpLDJH8W3/Z8xA1UbTMLdBJN7Q39ZZsoDnSzEfHvm3tgiHQuIfKT/O3V6leDO8+fiGewfWgyybCTrgK3BlaE+E/LrblNbtEZTjJHWoZMz+U3cY8OHRM6XYQF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759085522; c=relaxed/simple;
	bh=/kpxyBdIlmcX6WQlYmMeQ+TD2eOp2vAWzPVlLLSm3l4=;
	h=Date:To:From:Subject:Message-Id; b=A5OkaUgQIc52rgs3vlKKzMB1PaS57dHuv0ITjjqnUkdUJl80lU2m7LLtvyop/pPeW6a36H1EqS+JKjqxkcRyZagznGt0KIpUS2faYbfkam/84/VU//mmjpHEHwC6db39hkriJeNL/qy0znYlfBkrmE4nYCseYUnrMUJqe7tJNcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CnSXTgXM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CnSXTgXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03ACBC4CEF0;
	Sun, 28 Sep 2025 18:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759085522;
	bh=/kpxyBdIlmcX6WQlYmMeQ+TD2eOp2vAWzPVlLLSm3l4=;
	h=Date:To:From:Subject:From;
	b=CnSXTgXM/PRsHRQoZIJDlYkiwtjY7Rswodvhw+/vQRjPPD2Ym7lfAEMEuhgRrtnbJ
	 D3cMBQAPqWYw5gX6xYxhgBVJvkk+Rcst6QrXIjLVo5E2SP0MQTL3EdKwOuvsrvQHbG
	 1oo8wQKYkeZmBgJf+e0f5elO9wScPtfbY4kVGhlI=
Date: Sun, 28 Sep 2025 11:52:01 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,vbabka@suse.cz,surenb@google.com,osalvador@suse.de,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-fix-low_pfn-advance-on-isolating-hugetlb.patch removed from -mm tree
Message-Id: <20250928185202.03ACBC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/compaction: fix low_pfn advance on isolating hugetlb
has been removed from the -mm tree.  Its filename was
     mm-compaction-fix-low_pfn-advance-on-isolating-hugetlb.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/compaction: fix low_pfn advance on isolating hugetlb
Date: Wed, 10 Sep 2025 09:22:40 +0000

Commit 56ae0bb349b4 ("mm: compaction: convert to use a folio in
isolate_migratepages_block()") converts api from page to folio.  But the
low_pfn advance for hugetlb page seems wrong when low_pfn doesn't point to
head page.

Originally, if page is a hugetlb tail page, compound_nr() return 1, which
means low_pfn only advance one in next iteration.  After the change,
low_pfn would advance more than the hugetlb range, since folio_nr_pages()
always return total number of the large page.  This results in skipping
some range to isolate and then to migrate.

The worst case for alloc_contig is it does all the isolation and
migration, but finally find some range is still not isolated.  And then
undo all the work and try a new range.

Advance low_pfn to the end of hugetlb.

Link: https://lkml.kernel.org/r/20250910092240.3981-1-richard.weiyang@gmail.com
Fixes: 56ae0bb349b4 ("mm: compaction: convert to use a folio in isolate_migratepages_block()")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-fix-low_pfn-advance-on-isolating-hugetlb
+++ a/mm/compaction.c
@@ -989,7 +989,7 @@ isolate_migratepages_block(struct compac
 				 * Hugepage was successfully isolated and placed
 				 * on the cc->migratepages list.
 				 */
-				low_pfn += folio_nr_pages(folio) - 1;
+				low_pfn += folio_nr_pages(folio) - folio_page_idx(folio, page) - 1;
 				goto isolate_success_no_list;
 			}
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


