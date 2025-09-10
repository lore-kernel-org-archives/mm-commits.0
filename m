Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0FA4268C73
	for <mm-commits@vger.kernel.org>; Wed, 10 Sep 2025 23:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757548244; cv=none; b=ARYu2qg/yMzkRKVgGFwV8V1wpqvFflSeU/R8c2mTOqZRnP+krsVbAxI+hhhGA1SFQPAjAthvOxbhCLQVwFwT9W8eUUJ+ROaDSCuZdgZ3XBQU/FO3TxtqcWLlRf6nbI7uYUx7DOc5BqMEh3wKyoHSdFV+ZighJQwpwLNwN5uF8i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757548244; c=relaxed/simple;
	bh=prUNzHlOufUqrkMyuIW8L/M1ogiPnZi0uoy/uTJ8Dvw=;
	h=Date:To:From:Subject:Message-Id; b=iwLtypLVTO7LdE5o8RHbfw2/Z7jl77/CSL3CxwqPTHhH3S+S+qXRE+OA4Uj6Vql/fOBJuak33RgrJtOUD+3CahVrxHz13YPQo81AkCeBIv5S41byS9jdtTzJsKDLd7toum2Yg5bj4ZG+TETx7aZvGUwS0XQ7lVPgqb5MiZVbF40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NDOCmG4h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NDOCmG4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6C2C4CEEB;
	Wed, 10 Sep 2025 23:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757548243;
	bh=prUNzHlOufUqrkMyuIW8L/M1ogiPnZi0uoy/uTJ8Dvw=;
	h=Date:To:From:Subject:From;
	b=NDOCmG4he6vdLiUnJEnLIEt27RZltApN1PwwwgRmLiuTxli16a6/m6wCSyq6nptHU
	 ILmqN0Zmn9Gm959cOUBv5fGmesOQBySDissJkK+Py3qJ00hdKtq+EeENpNL8bI5AE8
	 Wws06YuRgOdHdOFC7XAaUnFzG6NaN1j93yPdxEis=
Date: Wed, 10 Sep 2025 16:50:42 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,wangkefeng.wang@huawei.com,vbabka@suse.cz,surenb@google.com,osalvador@suse.de,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-fix-low_pfn-advance-on-isolating-hugetlb.patch added to mm-new branch
Message-Id: <20250910235043.6B6C2C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/compaction: fix low_pfn advance on isolating hugetlb
has been added to the -mm mm-new branch.  Its filename is
     mm-compaction-fix-low_pfn-advance-on-isolating-hugetlb.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-fix-low_pfn-advance-on-isolating-hugetlb.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
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

mm-rmap-do-__folio_mod_stat-in-__folio_add_rmap.patch
selftests-mm-do-check_huge_anon-with-a-number-been-passed-in.patch
mm-rmap-not-necessary-to-mask-off-folio_pages_mapped.patch
mm-rmap-use-folio_large_nr_pages-when-we-are-sure-it-is-a-large-folio.patch
selftests-mm-put-general-ksm-operation-into-vm_util.patch
selftests-mm-test-that-rmap-behave-as-expected.patch
mm-khugepaged-use-list_xxx-helper-to-improve-readability.patch
mm-page_alloc-use-xxx_pageblock_isolate-for-better-reading.patch
mm-pageblock-flags-remove-pb_migratetype_bits-pb_migrate_end.patch
mm-page_alloc-find_large_buddy-from-start_pfn-aligned-order.patch
mm-page_alloc-find_large_buddy-from-start_pfn-aligned-order-v2.patch
mm-page_alloc-check-the-correct-buddy-if-it-is-a-starting-block.patch
mm-compaction-fix-low_pfn-advance-on-isolating-hugetlb.patch

