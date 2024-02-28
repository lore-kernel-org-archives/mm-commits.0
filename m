Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107FE71EDD
	for <mm-commits@vger.kernel.org>; Wed, 28 Feb 2024 18:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709146757; cv=none; b=FqyPcDPU+4THRku8EHMdTJwJkCqIYw9Ek96sUWskjpl2UQApVD6gahxzj4B3dyHNVOBTqsV0KNuKIfZoEIvE5CbkJ/RGRRNMen39yjHTIgwpt1kHfyiArdtLKb+vrMQVJ3Y6DOs5lhebBAQuui2X0QyUXUEPoxLFGRXSNVy9CfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709146757; c=relaxed/simple;
	bh=rBwC7xd5uvvNEt/p+EQa7MAlknKxpODlPzGvVPNWahg=;
	h=Date:To:From:Subject:Message-Id; b=rYTt8OpnmscN7PTe/0PiZQ92yIeH+hdB9dYwJPEWGL7VjcgN4eHnK6K0mJiW6Bk1lfmJtbDeZZ6pTdm6w89amt/K9+fdD5d/M/EdftiGcIezcgpgIEjpHMHevJglhx3LtMImMhORxjhU3AfwGtXxn9WIQqmGcJ1PNiQey5UXkmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ss366Rp0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ss366Rp0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D104AC43390;
	Wed, 28 Feb 2024 18:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709146756;
	bh=rBwC7xd5uvvNEt/p+EQa7MAlknKxpODlPzGvVPNWahg=;
	h=Date:To:From:Subject:From;
	b=ss366Rp03/AfuDiLASkwQFqmV+8H5vD1Rcg8wk+ukxkNJxG7tTkzfdYVzRk4ZIvoU
	 M1U6J29C4AncGth5BoDviqJa9zRNmfiilPeTN/Uzxx4TyTo+vR5bRmhdmSZB0iheyk
	 PuwP7ZdEBm1wm/Fa1W6p7S+F6TmMcjeyAr/8r92c=
Date: Wed, 28 Feb 2024 10:59:16 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-cast-from-page_to_nid.patch added to mm-unstable branch
Message-Id: <20240228185916.D104AC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove cast from page_to_nid()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-cast-from-page_to_nid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-cast-from-page_to_nid.patch

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
Subject: mm: remove cast from page_to_nid()
Date: Tue, 27 Feb 2024 19:23:35 +0000

Now that PF_POISONED_CHECK() can take a const argument, we can drop
the cast.

Link: https://lkml.kernel.org/r/20240227192337.757313-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/include/linux/mm.h~mm-remove-cast-from-page_to_nid
+++ a/include/linux/mm.h
@@ -1641,13 +1641,11 @@ static inline int page_zone_id(struct pa
 }
 
 #ifdef NODE_NOT_IN_PAGE_FLAGS
-extern int page_to_nid(const struct page *page);
+int page_to_nid(const struct page *page);
 #else
 static inline int page_to_nid(const struct page *page)
 {
-	struct page *p = (struct page *)page;
-
-	return (PF_POISONED_CHECK(p)->flags >> NODES_PGSHIFT) & NODES_MASK;
+	return (PF_POISONED_CHECK(page)->flags >> NODES_PGSHIFT) & NODES_MASK;
 }
 #endif
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-support-order-1-folios-in-the-page-cache.patch
mm-make-folios_put-the-basis-of-release_pages.patch
mm-convert-free_unref_page_list-to-use-folios.patch
mm-add-free_unref_folios.patch
mm-use-folios_put-in-__folio_batch_release.patch
memcg-add-mem_cgroup_uncharge_folios.patch
mm-remove-use-of-folio-list-from-folios_put.patch
mm-use-free_unref_folios-in-put_pages_list.patch
mm-use-__page_cache_release-in-folios_put.patch
mm-handle-large-folios-in-free_unref_folios.patch
mm-allow-non-hugetlb-large-folios-to-be-batch-processed.patch
mm-free-folios-in-a-batch-in-shrink_folio_list.patch
mm-free-folios-directly-in-move_folios_to_lru.patch
memcg-remove-mem_cgroup_uncharge_list.patch
mm-remove-free_unref_page_list.patch
mm-remove-lru_to_page.patch
mm-convert-free_pages_and_swap_cache-to-use-folios_put.patch
mm-use-a-folio-in-__collapse_huge_page_copy_succeeded.patch
mm-convert-free_swap_cache-to-take-a-folio.patch
mm-use-folio-more-widely-in-__split_huge_page.patch
mm-separate-out-folio_flags-from-pageflags.patch
mm-remove-pagewaiters-pagesetwaiters-and-pageclearwaiters.patch
mm-remove-pageyoung-and-pageidle-definitions.patch
mm-add-__dump_folio.patch
mm-make-dump_page-take-a-const-argument.patch
mm-constify-testing-page-folio-flags.patch
mm-constify-more-page-folio-tests.patch
mm-remove-cast-from-page_to_nid.patch

