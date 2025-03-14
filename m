Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAE015886C
	for <mm-commits@vger.kernel.org>; Fri, 14 Mar 2025 19:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741981528; cv=none; b=p0w9ZZ6JsmJ+fVi/wMAOokrAVrhbEoRmFNHE+yjVtiIgIdeUeeykv0JdsSdXtbCautKzEDbbP8X+dWoKSdOjZjL/7xLTcMRJriOJRcDNG3g7XDhSL1ZZIaJg3uGT5rpi5dschhTQofBPA0snhYFIKCmdFH2IZDzhVbwvKtW6cAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741981528; c=relaxed/simple;
	bh=8AUmQbF7xiBfjzqR+T8rWzHmCTIxPnUTz8T39f7jY1A=;
	h=Date:To:From:Subject:Message-Id; b=Q+zWmAAZgoLVxa7glApbTPSXysqZEEvo0dMIrxMBURSQpgqgdUuZ235Tet0GNsPOvbbvNkbTgR2C3P+zQLasLbwUw6EZvnCkrtxu5rKBCuyJRTjcAdlHSS8KN3DF0GiJKY1FRV7UFj1ibsrQZBGhHKQbcSBY4ARKpoz5KcxXEHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pDdVyA7F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pDdVyA7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96F4C4CEE3;
	Fri, 14 Mar 2025 19:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741981527;
	bh=8AUmQbF7xiBfjzqR+T8rWzHmCTIxPnUTz8T39f7jY1A=;
	h=Date:To:From:Subject:From;
	b=pDdVyA7FYo+wRTRbLsiAvY5gDALvQ+EIoNhJ4x8mTuDSCC/DHYVsIoxF4thL++8cM
	 CyfcCAT+FqKzLn2GNw+/OYAu0/O2dqe04DQ4/pqetjH6jhhl/gJstJK1kx1SWoHIME
	 zsMYOF81BK7dG8OWnNkJ+55clmffqOWWHdgJ5meU=
Date: Fri, 14 Mar 2025 12:45:27 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-simplify-folio_memcg_charged.patch added to mm-unstable branch
Message-Id: <20250314194527.A96F4C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: simplify folio_memcg_charged()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-simplify-folio_memcg_charged.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-simplify-folio_memcg_charged.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: simplify folio_memcg_charged()
Date: Fri, 14 Mar 2025 13:36:14 +0000

There's no need to check which kind of pointer is in the memcg_data field,
all we actually care about is whether it's zero or not.  Saves 70 bytes in
workingset_activation() with the Debian config.

Link: https://lkml.kernel.org/r/20250314133617.138071-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/memcontrol.h~mm-simplify-folio_memcg_charged
+++ a/include/linux/memcontrol.h
@@ -438,9 +438,7 @@ static inline struct mem_cgroup *folio_m
  */
 static inline bool folio_memcg_charged(struct folio *folio)
 {
-	if (folio_memcg_kmem(folio))
-		return __folio_objcg(folio) != NULL;
-	return __folio_memcg(folio) != NULL;
+	return folio->memcg_data != 0;
 }
 
 /*
_

Patches currently in -mm which might be from willy@infradead.org are

mm-decline-to-manipulate-the-refcount-on-a-slab-page.patch
dax-remove-access-to-page-index.patch
dax-use-folios-more-widely-within-dax.patch
fs-convert-block_commit_write-to-take-a-folio.patch
fs-remove-page_file_mapping.patch
fs-remove-folio_file_mapping.patch
mm-assert-the-folio-is-locked-in-folio_start_writeback.patch
hugetlb-convert-hugetlb_vma_maps_page-to-hugetlb_vma_maps_pfn.patch
hugetlb-convert-adjust_range_hwpoison-to-take-a-folio.patch
mm-convert-lru_add_page_tail-to-lru_add_split_folio.patch
mm-separate-folio_split_memcg_refs-from-split_page_memcg.patch
mm-simplify-split_page_memcg.patch
mm-remove-references-to-folio-in-split_page_memcg.patch
mm-simplify-folio_memcg_charged.patch
mm-remove-references-to-folio-in-__memcg_kmem_uncharge_page.patch
ocfs2-use-memcpy_to_folio-in-ocfs2_symlink_get_block.patch
ocfs2-remove-reference-to-bh-b_page.patch

