Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD4622A4EE
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 22:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752359949; cv=none; b=G+OfKhSwCbl3/FYaze/qQ3g419G2KwgR9iqCGwpj0lgRH7K+WuSSLgrCWMvpxteKOHg4nQ66trV2+p95OgRWmehe1uoqTqOfaVwnjX8afcCVLTOwyNorCrvoVpwIOE3xnAaE4NyC602uBV5ZcU6LZzTDjs9RJtwOCLNJCCQq6b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752359949; c=relaxed/simple;
	bh=mL/56iaw2iQXYC1IDFyWLlitZf+eUVGOgoHs3C/9d9E=;
	h=Date:To:From:Subject:Message-Id; b=KSX0PWdXdqFZ374Ub7fZAMS97KdeihFSF5N3D+fR5THbJoe7ick45GUU1yFhu9/4UZu7pJ6pnN2IrdHVEmslqDtE/UuCgu0b0JEB8Zbg/8us+qXmoAfOy4qyphPPZQj1HUer/KJDQ3ZZYJa5z0UW5ROZJmxOT4/s0GdGTmzmcQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MqwgqACU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MqwgqACU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B66C4CEEF;
	Sat, 12 Jul 2025 22:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752359949;
	bh=mL/56iaw2iQXYC1IDFyWLlitZf+eUVGOgoHs3C/9d9E=;
	h=Date:To:From:Subject:From;
	b=MqwgqACUMwq6SegG+4ow0tzk1J4hRicDPQJQlhOtpQCB0IqCWVoHJqA9w2fkmR21v
	 1zYhVcmyxv0BsXFaT19tAJ6LBiZ5l4IsaWKrvK2ucKYwCEo2b/lK1VH+RG8LM19ucm
	 I0NZaAIUkM/1MpCM8NWYRAYlJhafb8wiWq49oUmg=
Date: Sat, 12 Jul 2025 15:39:07 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vishal.moola@gmail.com,vbabka@suse.cz,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-convert-set_page_owner_migrate_reason-to-folios.patch added to mm-new branch
Message-Id: <20250712223909.07B66C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: convert set_page_owner_migrate_reason() to folios
has been added to the -mm mm-new branch.  Its filename is
     mm-page_owner-convert-set_page_owner_migrate_reason-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-convert-set_page_owner_migrate_reason-to-folios.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/page_owner: convert set_page_owner_migrate_reason() to folios
Date: Fri, 11 Jul 2025 10:59:10 -0400

Both callers of set_page_owner_migrate_reason() use folios.  Convert the
function to take a folio directly and move the &folio->page conversion
inside __set_page_owner_migrate_reason().

Link: https://lkml.kernel.org/r/20250711145910.90135-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_owner.h |    8 ++++----
 mm/hugetlb.c               |    2 +-
 mm/migrate.c               |    2 +-
 mm/page_owner.c            |    4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

--- a/include/linux/page_owner.h~mm-page_owner-convert-set_page_owner_migrate_reason-to-folios
+++ a/include/linux/page_owner.h
@@ -14,7 +14,7 @@ extern void __set_page_owner(struct page
 extern void __split_page_owner(struct page *page, int old_order,
 			int new_order);
 extern void __folio_copy_owner(struct folio *newfolio, struct folio *old);
-extern void __set_page_owner_migrate_reason(struct page *page, int reason);
+extern void __folio_set_owner_migrate_reason(struct folio *folio, int reason);
 extern void __dump_page_owner(const struct page *page);
 extern void pagetypeinfo_showmixedcount_print(struct seq_file *m,
 					pg_data_t *pgdat, struct zone *zone);
@@ -43,10 +43,10 @@ static inline void folio_copy_owner(stru
 	if (static_branch_unlikely(&page_owner_inited))
 		__folio_copy_owner(newfolio, old);
 }
-static inline void set_page_owner_migrate_reason(struct page *page, int reason)
+static inline void folio_set_owner_migrate_reason(struct folio *folio, int reason)
 {
 	if (static_branch_unlikely(&page_owner_inited))
-		__set_page_owner_migrate_reason(page, reason);
+		__folio_set_owner_migrate_reason(folio, reason);
 }
 static inline void dump_page_owner(const struct page *page)
 {
@@ -68,7 +68,7 @@ static inline void split_page_owner(stru
 static inline void folio_copy_owner(struct folio *newfolio, struct folio *folio)
 {
 }
-static inline void set_page_owner_migrate_reason(struct page *page, int reason)
+static inline void folio_set_owner_migrate_reason(struct folio *folio, int reason)
 {
 }
 static inline void dump_page_owner(const struct page *page)
--- a/mm/hugetlb.c~mm-page_owner-convert-set_page_owner_migrate_reason-to-folios
+++ a/mm/hugetlb.c
@@ -7835,7 +7835,7 @@ void move_hugetlb_state(struct folio *ol
 	struct hstate *h = folio_hstate(old_folio);
 
 	hugetlb_cgroup_migrate(old_folio, new_folio);
-	set_page_owner_migrate_reason(&new_folio->page, reason);
+	folio_set_owner_migrate_reason(new_folio, reason);
 
 	/*
 	 * transfer temporary state of the new hugetlb folio. This is
--- a/mm/migrate.c~mm-page_owner-convert-set_page_owner_migrate_reason-to-folios
+++ a/mm/migrate.c
@@ -1367,7 +1367,7 @@ static int migrate_folio_move(free_folio
 
 out_unlock_both:
 	folio_unlock(dst);
-	set_page_owner_migrate_reason(&dst->page, reason);
+	folio_set_owner_migrate_reason(dst, reason);
 	/*
 	 * If migration is successful, decrease refcount of dst,
 	 * which will not free the page because new page owner increased
--- a/mm/page_owner.c~mm-page_owner-convert-set_page_owner_migrate_reason-to-folios
+++ a/mm/page_owner.c
@@ -333,9 +333,9 @@ noinline void __set_page_owner(struct pa
 	inc_stack_record_count(handle, gfp_mask, 1 << order);
 }
 
-void __set_page_owner_migrate_reason(struct page *page, int reason)
+void __folio_set_owner_migrate_reason(struct folio *folio, int reason)
 {
-	struct page_ext *page_ext = page_ext_get(page);
+	struct page_ext *page_ext = page_ext_get(&folio->page);
 	struct page_owner *page_owner;
 
 	if (unlikely(!page_ext))
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-page_owner-convert-set_page_owner_migrate_reason-to-folios.patch

