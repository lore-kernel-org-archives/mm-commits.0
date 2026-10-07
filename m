Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C6E296BB5
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334131; cv=none; b=QzRcOvJJclGPIKVk9WpqvU4t5s/POlDnSL/b+DldYvwmj7KuM8/7cuhb5+zwCZbA8vxKWXA1jNM90f5wEbWvlMPj0BQ9aH+WTVXNY7oC8kr9sToDXFDy1bsnToVHFsvXkev359Yq6z4RZHfXjE8TouHDPDpW++gk9T/Qz9zQHz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334131; c=relaxed/simple;
	bh=wA9Rct5HqD+TL4jQEqrkf+8xWDrZTouQwYsyv5muf5I=;
	h=Date:To:From:Subject:Message-Id; b=b9hsYmvCvYWS3IX7JJFjMmyB7MhY+UgblpsCeltOwO+OzEwUFonApJmOLTzyQ08QU4DkWIg8ZH45p49RKRRlSmLcdTufxy6GGRgLMdym6NI+tI8JCGaG2ieOYGrQbUVwmlQHHswcyPkyQW667TGNeqhA/gkNTnoxNzjinbrqhH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MGQ/OS7o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MGQ/OS7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70ED61F0089C;
	Wed,  7 Oct 2026 00:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334130;
	bh=MWmYVy+GpAs55MbDSILrbKeBeY4IzWvnnPA3wG7g0OI=;
	h=Date:To:From:Subject;
	b=MGQ/OS7o5k2U92i9jI5p2rpoTg6TukzNqUAMNHrVSA8puzs/rsDEPvJZiIUx3aakz
	 eWgg8bDlLdH8T1CaeK8adKXyiT8lAtEJhGh4fWnnq9h9RajgC9jbmy/TsRSn1jJ9d9
	 yxo3KrX5nBO/hqU4IgD2IavWXmXUP2hXirnJDDyA=
Date: Tue, 06 Oct 2026 17:48:50 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,joshua.hahnjy@gmail.com,david@kernel.org,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-use-hugetlb_vmemmap_optimizable-in-boolean-contexts.patch removed from -mm tree
Message-Id: <20261007004850.70ED61F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: use hugetlb_vmemmap_optimizable() in boolean contexts
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-use-hugetlb_vmemmap_optimizable-in-boolean-contexts.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-hugetlb_vmemmap_optimizable-in-boolean-contexts
+++ a/mm/hugetlb.c
@@ -3427,7 +3427,7 @@ static void __init hugetlb_hstate_alloc_
 			folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
 					&node_states[N_MEMORY], NULL);
 			if (!folio && !list_empty(&folio_list) &&
-			    hugetlb_vmemmap_optimizable_size(h)) {
+			    hugetlb_vmemmap_optimizable(h)) {
 				prep_and_add_allocated_folios(h, &folio_list);
 				INIT_LIST_HEAD(&folio_list);
 				folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
@@ -3496,7 +3496,7 @@ static void __init hugetlb_pages_alloc_b
 	for (i = 0; i < num; ++i) {
 		struct folio *folio;
 
-		if (hugetlb_vmemmap_optimizable_size(h) &&
+		if (hugetlb_vmemmap_optimizable(h) &&
 		    (si_mem_available() == 0) && !list_empty(&folio_list)) {
 			prep_and_add_allocated_folios(h, &folio_list);
 			INIT_LIST_HEAD(&folio_list);
_

Patches currently in -mm which might be from chengkaitao@kylinos.cn are

mm-page-flags-define-hwpoison-test-and-change-helpers-unconditionally.patch

