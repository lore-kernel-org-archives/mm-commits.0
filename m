Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E6E1FB1
	for <mm-commits@vger.kernel.org>; Thu, 27 Aug 2026 03:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787802361; cv=none; b=oaR8oJ4KJEK/jTe6IM7eARhnSqToW7dB6XAZgPZ4lKYQnjXe2pwf1HkowwlnVGBMuNQR4SQsOuebzx0PtF1zp0ZLiiPntOePo+0q2E85YLvp8kwuDzPyyJAORnhLNgFMSAm2aY2n3FKXAaG8Plvbp/enoi81MRTOdWS8OASwX+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787802361; c=relaxed/simple;
	bh=CD8qa3zB5dkDZx7Mj7AHZjkV28e8WYr4BwyVYKS+bE0=;
	h=Date:To:From:Subject:Message-Id; b=THi+garlm5QznmMg9Y6Ne13/NTODPjeB+whnz0SqbczaGPHmdGEcnXNGA+cl4vXXwVQ1oZPQ5k+pbLzVIy3dpYmhgD5dwrDkG+e/7Xvs5e4Lr37E46b/fgzcg9Ll3UwqLQZt2HuiPZ26y//xBkhe0yNBSmYCWWQt63+YJD8SH9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q5P8qMy8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q5P8qMy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B231F000E9;
	Thu, 27 Aug 2026 03:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787802360;
	bh=HNqgXQOc5nrH4+8Vqq4ggGeJyWb1zO8X0D7bsj5Y6WY=;
	h=Date:To:From:Subject;
	b=Q5P8qMy87QSSYf9YgClekQsTZxebaRbIVSD8Ay3nj9nC/FKGxlxP9OuCAIegyrAOw
	 dZwdQnh7aqoO2z1O1HYhGOTzIcVtqizgPoN6b51JX68IKJqBACu9bFGEpmnoCiH7uT
	 lZOeoD4rcHwCQULzrabYHDI8igvJKuYS+IWyKids=
Date: Wed, 26 Aug 2026 20:45:59 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,joshua.hahnjy@gmail.com,david@kernel.org,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-use-hugetlb_vmemmap_optimizable-in-boolean-contexts.patch added to mm-new branch
Message-Id: <20260827034600.05B231F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: use hugetlb_vmemmap_optimizable() in boolean contexts
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-use-hugetlb_vmemmap_optimizable-in-boolean-contexts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-use-hugetlb_vmemmap_optimizable-in-boolean-contexts.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: mm/hugetlb: use hugetlb_vmemmap_optimizable() in boolean contexts
Date: Mon, 24 Aug 2026 23:16:55 +0800

The two boot-time sites in hugetlb_hstate_alloc_pages_onenode() and
hugetlb_pages_alloc_boot_node() only need to know whether HVO is
applicable, not the exact optimizable size.  Switch them from
hugetlb_vmemmap_optimizable_size() to hugetlb_vmemmap_optimizable() to
make intent explicit.

No functional change intended.

Link: https://lore.kernel.org/20260824151655.30840-1-kaitao.cheng@linux.dev
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
Reviewed-by: Joshua hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-hugetlb_vmemmap_optimizable-in-boolean-contexts
+++ a/mm/hugetlb.c
@@ -3425,7 +3425,7 @@ static void __init hugetlb_hstate_alloc_
 			folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
 					&node_states[N_MEMORY], NULL);
 			if (!folio && !list_empty(&folio_list) &&
-			    hugetlb_vmemmap_optimizable_size(h)) {
+			    hugetlb_vmemmap_optimizable(h)) {
 				prep_and_add_allocated_folios(h, &folio_list);
 				INIT_LIST_HEAD(&folio_list);
 				folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
@@ -3494,7 +3494,7 @@ static void __init hugetlb_pages_alloc_b
 	for (i = 0; i < num; ++i) {
 		struct folio *folio;
 
-		if (hugetlb_vmemmap_optimizable_size(h) &&
+		if (hugetlb_vmemmap_optimizable(h) &&
 		    (si_mem_available() == 0) && !list_empty(&folio_list)) {
 			prep_and_add_allocated_folios(h, &folio_list);
 			INIT_LIST_HEAD(&folio_list);
_

Patches currently in -mm which might be from chengkaitao@kylinos.cn are

mm-hugetlb-use-hugetlb_vmemmap_optimizable-in-boolean-contexts.patch

