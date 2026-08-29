Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D0336B912
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 20:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788035926; cv=none; b=cX1PHfWibqscjvkq1neIipWlH00trHzGWUknSWzUd5efr7vHyh/w1rj2wBGoj/VmkcKPRkA/Mi1CRbL+emyVo1AUQUHT//412qAK6u0C9+mRPG0cSAFoRQ3i4v3MYa3peLxbvmdlvtWGHYiEQMfVzEHzgYnJ1Rg2qjvKpgKcQm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788035926; c=relaxed/simple;
	bh=ZRwMGyrULcgrbZPHU9XIQOiRfKk6pzdkwmzklPsGBJY=;
	h=Date:To:From:Subject:Message-Id; b=YlRJvzOdW0V5lKiOX3YttqPMOToQLUyKwdYHy5qD9ylXINO3JwH2ZaQE33dDEh9cHuk/AAVnxxHrJuVcOMazOUvvk2BF91rU14Kk2dLlpUdI1RUUZcl7Eri1ZjOSjfExgUsIrOp4mlW2p53Tt/UzM1JA2k9T5W8LA+1JU/5wU3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aHkYfT0j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aHkYfT0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83AF91F000E9;
	Sat, 29 Aug 2026 20:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788035924;
	bh=fc25lfUDm8SpSrRB/ivh0dj9ZYxJLFbcLGAzlCKzUes=;
	h=Date:To:From:Subject;
	b=aHkYfT0jYxk541Cs140o8pwHxmt6EuKS0XN+YubA5Q2Op0UV09+xZPXGfhJBtry3K
	 qRkoUk5089jKu3UdC/meHGjU3D7e5PEaCIQfNAq5T852yT3Zwp0bRB71csAoRPulAv
	 LljrQog2i2CeUJJ/UocyPL0Ft1uCcUek47AIWKzo=
Date: Sat, 29 Aug 2026 13:38:44 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ljs@kernel.org,hannes@cmpxchg.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_io-use-swap-entries-directly-in-zeromap-helpers.patch added to mm-new branch
Message-Id: <20260829203844.83AF91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_io: use swap entries directly in zeromap helpers
has been added to the -mm mm-new branch.  Its filename is
     mm-page_io-use-swap-entries-directly-in-zeromap-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_io-use-swap-entries-directly-in-zeromap-helpers.patch

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
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm/page_io: use swap entries directly in zeromap helpers
Date: Sat, 29 Aug 2026 15:09:02 -0400

Increment swp_entry_t::val directly instead of recomputing each entry with
page_swap_entry().  This removes the last struct page usage in page_io.c
and saves one call to compound_head() per page.

Link: https://lore.kernel.org/20260829-b4-page_io-folios-v2-3-649728091117@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/page_io.c~mm-page_io-use-swap-entries-directly-in-zeromap-helpers
+++ a/mm/page_io.c
@@ -160,7 +160,7 @@ static void swap_zeromap_folio_set(struc
 	struct obj_cgroup *objcg = get_obj_cgroup_from_folio(folio);
 	int nr_pages = folio_nr_pages(folio);
 	struct swap_cluster_info *ci;
-	swp_entry_t entry;
+	swp_entry_t entry = folio->swap;
 	unsigned int i;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
@@ -168,8 +168,8 @@ static void swap_zeromap_folio_set(struc
 
 	ci = swap_cluster_get_and_lock(folio);
 	for (i = 0; i < folio_nr_pages(folio); i++) {
-		entry = page_swap_entry(folio_page(folio, i));
 		__swap_table_set_zero(ci, swp_cluster_offset(entry));
+		entry.val++;
 	}
 	swap_cluster_unlock(ci);
 
@@ -183,7 +183,7 @@ static void swap_zeromap_folio_set(struc
 static void swap_zeromap_folio_clear(struct folio *folio)
 {
 	struct swap_cluster_info *ci;
-	swp_entry_t entry;
+	swp_entry_t entry = folio->swap;
 	unsigned int i;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
@@ -191,8 +191,8 @@ static void swap_zeromap_folio_clear(str
 
 	ci = swap_cluster_get_and_lock(folio);
 	for (i = 0; i < folio_nr_pages(folio); i++) {
-		entry = page_swap_entry(folio_page(folio, i));
 		__swap_table_clear_zero(ci, swp_cluster_offset(entry));
+		entry.val++;
 	}
 	swap_cluster_unlock(ci);
 }
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-page_io-convert-write-completion-handlers-to-folios.patch
mm-remove-pagereclaim.patch
mm-page_io-use-swap-entries-directly-in-zeromap-helpers.patch
mm-page_io-rename-bio_associate_blkg_from_page.patch
mm-page_io-refer-to-folios-in-swap_writeout-comments.patch
mm-swap-rename-__swap_writepage-to-__swap_writeout.patch

