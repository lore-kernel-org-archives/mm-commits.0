Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68FB5207DFD
	for <mm-commits@vger.kernel.org>; Fri, 10 Jan 2025 23:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736550288; cv=none; b=dJhx0dnF1rwyIXfraaN31YYosbOfgSpI/l2SFffpAI+AjKYrptVJsp9t+9pB/+T5zDFhFpcF5QnH8PO6Q/5uwr45QEL+bccntMcKUk3ZudqnOB9d33MMNCvZcTthmsANxdNxsWRZnKBrhiP8p4DM8FB4kww2WseM8opKqOGChro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736550288; c=relaxed/simple;
	bh=18HFaTpttt8EnSvd+RBiaDPNi2k8LECXYFZw9b9uDqw=;
	h=Date:To:From:Subject:Message-Id; b=jNw9DsFXHALEnR88mqTqP1tHsQrkchqSGwYFI5AEHRwk89yYcLfOCR5QMEh9SkTGqKbooTuyYWHD/G0eBmfsUvWJK5PP6cfzxLWV4LHhYl2GsHo1l4W4iMbapGejG/PAxPGWZid26YvP9YzGFnUFbuKk12OsvKWOnTjpyn/TcKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vipne4v7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vipne4v7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE453C4CED6;
	Fri, 10 Jan 2025 23:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736550288;
	bh=18HFaTpttt8EnSvd+RBiaDPNi2k8LECXYFZw9b9uDqw=;
	h=Date:To:From:Subject:From;
	b=vipne4v7Nwg0yZhJrAoi9rvNDewq+7B6wZ2Qs3+wSpTZFhD16gRoigGKxS1U7M+2i
	 MeqwfUPu2igf9X0Jm98WBAd1sj96hat9uAtdLgaNV3PZUtLRdGGxTFsp+Djfw6zcEY
	 xy4MTrIWuFCwodtRfZ/f61brWZB2oQFjmCk0Lv1E=
Date: Fri, 10 Jan 2025 15:04:47 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,muchun.song@linux.dev,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-use-folio-lru-int-demote_free_hugetlb_folios.patch added to mm-unstable branch
Message-Id: <20250110230447.DE453C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: use folio->lru int demote_free_hugetlb_folios()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-use-folio-lru-int-demote_free_hugetlb_folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-use-folio-lru-int-demote_free_hugetlb_folios.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/hugetlb: use folio->lru int demote_free_hugetlb_folios()
Date: Fri, 10 Jan 2025 19:21:49 +0100

We are demoting hugetlb folios to smaller hugetlb folios; let's avoid
messing with pages where avoidable.

Link: https://lkml.kernel.org/r/20250110182149.746551-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-folio-lru-int-demote_free_hugetlb_folios
+++ a/mm/hugetlb.c
@@ -3822,13 +3822,15 @@ static long demote_free_hugetlb_folios(s
 
 		for (i = 0; i < pages_per_huge_page(src); i += pages_per_huge_page(dst)) {
 			struct page *page = folio_page(folio, i);
+			struct folio *new_folio;
 
 			page->mapping = NULL;
 			clear_compound_head(page);
 			prep_compound_page(page, dst->order);
+			new_folio = page_folio(page);
 
-			init_new_hugetlb_folio(dst, page_folio(page));
-			list_add(&page->lru, &dst_list);
+			init_new_hugetlb_folio(dst, new_folio);
+			list_add(&new_folio->lru, &dst_list);
 		}
 	}
 
_

Patches currently in -mm which might be from david@redhat.com are

docs-tmpfs-update-the-large-folios-policy-for-tmpfs-and-shmem.patch
mm-memory_hotplug-move-debug_pagealloc_map_pages-into-online_pages_range.patch
mm-page_isolation-dont-pass-gfp-flags-to-isolate_single_pageblock.patch
mm-page_isolation-dont-pass-gfp-flags-to-start_isolate_page_range.patch
mm-page_alloc-make-__alloc_contig_migrate_range-static.patch
mm-page_alloc-sort-out-the-alloc_contig_range-gfp-flags-mess.patch
mm-page_alloc-forward-the-gfp-flags-from-alloc_contig_range-to-post_alloc_hook.patch
powernv-memtrace-use-__gfp_zero-with-alloc_contig_pages.patch
mm-hugetlb-dont-map-folios-writable-without-vm_write-when-copying-during-fork.patch
mm-page_alloc-dont-use-__gfp_hardwall-when-migrating-pages-via-alloc_contig.patch
mm-memory_hotplug-dont-use-__gfp_hardwall-when-migrating-pages-via-memory-offlining.patch
mm-huge_memory-convert-has_hwpoisoned-into-a-pure-folio-flag.patch
mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb.patch
mm-migrate-dont-call-folio_putback_active_hugetlb-on-dst-hugetlb-folio.patch
mm-hugetlb-rename-folio_putback_active_hugetlb-to-folio_putback_hugetlb.patch
mm-hugetlb-cgroup-convert-hugetlb_cgroup_css_offline-to-work-on-folios.patch
mm-hugetlb-use-folio-lru-int-demote_free_hugetlb_folios.patch

