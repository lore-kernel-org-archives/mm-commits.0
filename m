Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBC321B199
	for <mm-commits@vger.kernel.org>; Fri, 19 Sep 2025 20:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758314386; cv=none; b=MaUu3ifX1O4ux9FZE5dQbT9Q5Xkkz/Iycu8SF1w6G3QH0YMsKdaXCub/Xb6956b5xhhkbJBDIqcZr2DrHe5O9ncjXqqAqfdEHcTqVOI4GgoDSNQTy3qAp/ckhRub17hRPa4F+XokFnyOYzXk/qsvZO5GhhvrkTaoi33rwnx5q2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758314386; c=relaxed/simple;
	bh=g1w0j1MeOJRdsZn9nz9AfJbrS2INat1F7kiAog7qSxk=;
	h=Date:To:From:Subject:Message-Id; b=lv0wdC61WLKlSooHUVqSLe9aEQuHEhlel4mhV233dnEL1Pl+yQF/ps5n23qQytaEsjQABbvk+TVww+2lA+iTEbTshySRvsNzsgEEjawf5BDt8kASa9BGUC4Mm2Feo8MMCJbGVBoTUN9ixHCZUOkJB80a5BYhPc81ir5DWiTN/MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G67ak5bZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G67ak5bZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C5DC4CEF7;
	Fri, 19 Sep 2025 20:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758314385;
	bh=g1w0j1MeOJRdsZn9nz9AfJbrS2INat1F7kiAog7qSxk=;
	h=Date:To:From:Subject:From;
	b=G67ak5bZPOM/8uM/7IAs16pM6wNI1GdzucwAQDmEumk4s65dYpa3a7IS/faAOY25+
	 qMMMiIL8vIK/Prfx/rBET8myq/pW18YafElb9FponPh6GIyCa+7Mv36qdxzmrlEfW/
	 XDYbpgLcaM/2FfgYw4absFkQc2BxwPkf/hX7XQBU=
Date: Fri, 19 Sep 2025 13:39:45 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-increase-number-of-reserving-hugepages-via-cmdline.patch added to mm-new branch
Message-Id: <20250919203945.88C5DC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: increase number of reserving hugepages via cmdline
has been added to the -mm mm-new branch.  Its filename is
     hugetlb-increase-number-of-reserving-hugepages-via-cmdline.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-increase-number-of-reserving-hugepages-via-cmdline.patch

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
From: Li Zhe <lizhe.67@bytedance.com>
Subject: hugetlb: increase number of reserving hugepages via cmdline
Date: Fri, 19 Sep 2025 17:23:53 +0800

Commit 79359d6d24df ("hugetlb: perform vmemmap optimization on a list of
pages") batches the submission of HugeTLB vmemmap optimization (HVO)
during hugepage reservation.  With HVO enabled, hugepages obtained from
the buddy allocator are not submitted for optimization and their
struct-page memory is therefore not released—until the entire
reservation request has been satisfied.  As a result, any struct-page
memory freed in the course of the allocation cannot be reused for the
ongoing reservation, artificially limiting the number of huge pages that
can ultimately be provided.

As commit b1222550fbf7 ("mm/hugetlb: do pre-HVO for bootmem allocated
pages") already applies early HVO to bootmem-allocated huge pages, this
patch extends the same benefit to non-bootmem pages by incrementally
submitting them for HVO as they are allocated, thereby returning
struct-page memory to the buddy allocator in real time.  The change raises
the maximum 2 MiB hugepage reservation from just under 376 GB to more than
381 GB on a 384 GB x86 VM.

Link: https://lkml.kernel.org/r/20250919092353.41671-1-lizhe.67@bytedance.com
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~hugetlb-increase-number-of-reserving-hugepages-via-cmdline
+++ a/mm/hugetlb.c
@@ -3558,7 +3558,14 @@ static void __init hugetlb_pages_alloc_b
 	nodes_clear(node_alloc_noretry);
 
 	for (i = 0; i < num; ++i) {
-		struct folio *folio = alloc_pool_huge_folio(h, &node_states[N_MEMORY],
+		struct folio *folio;
+
+		if (hugetlb_vmemmap_optimizable_size(h) &&
+		    (si_mem_available() == 0) && !list_empty(&folio_list)) {
+			prep_and_add_allocated_folios(h, &folio_list);
+			INIT_LIST_HEAD(&folio_list);
+		}
+		folio = alloc_pool_huge_folio(h, &node_states[N_MEMORY],
 						&node_alloc_noretry, &next_node);
 		if (!folio)
 			break;
_

Patches currently in -mm which might be from lizhe.67@bytedance.com are

hugetlb-increase-number-of-reserving-hugepages-via-cmdline.patch

