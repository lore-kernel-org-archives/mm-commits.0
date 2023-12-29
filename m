Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7E612E46
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KwXbnnyG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DE6C433C8;
	Fri, 29 Dec 2023 19:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703879985;
	bh=1VXYYSNSDAoZq3NXqcxtYE3TITW1/amjE0Z//4r6R2I=;
	h=Date:To:From:Subject:From;
	b=KwXbnnyGEuLjGoTKGBOYozrEH0yvQnoCRcoRVmmCt6x2pgGu0pz1XKd2dM+qPtw23
	 A5gvNdsv3vn590LZYZYfmJ8o8+ARzlvV+PH1+ld09yJSKmz/+0MEbVTSlpNl1NHpyd
	 IlSm05Io/nFep/+VUNx84INiQ2K3hAjhgtOMe6+k=
Date: Fri, 29 Dec 2023 11:59:45 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-references-to-page_add_new_anon_rmap-in-comments.patch removed from -mm tree
Message-Id: <20231229195945.85DE6C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove references to page_add_new_anon_rmap in comments
has been removed from the -mm tree.  Its filename was
     mm-remove-references-to-page_add_new_anon_rmap-in-comments.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove references to page_add_new_anon_rmap in comments
Date: Mon, 11 Dec 2023 16:22:11 +0000

Refer to folio_add_new_anon_rmap() instead.

Link: https://lkml.kernel.org/r/20231211162214.2146080-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/rmap.c~mm-remove-references-to-page_add_new_anon_rmap-in-comments
+++ a/mm/rmap.c
@@ -1231,9 +1231,9 @@ static void __page_check_anon_rmap(struc
 	 * We have exclusion against page_add_anon_rmap because the caller
 	 * always holds the page locked.
 	 *
-	 * We have exclusion against page_add_new_anon_rmap because those pages
+	 * We have exclusion against folio_add_new_anon_rmap because those pages
 	 * are initially only visible via the pagetables, and the pte is locked
-	 * over the call to page_add_new_anon_rmap.
+	 * over the call to folio_add_new_anon_rmap.
 	 */
 	VM_BUG_ON_FOLIO(folio_anon_vma(folio)->root != vma->anon_vma->root,
 			folio);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

