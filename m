Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB193134A8
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kkPRHuPU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 881F2C433C7;
	Fri, 29 Dec 2023 19:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703879984;
	bh=aE0KWgVipxNsyDkvHvt4/4SN6H0+qauT0n2WGNsRTaQ=;
	h=Date:To:From:Subject:From;
	b=kkPRHuPUwtWFnsQ29eFkZttqPsM7HEuyOfUnkPpVmImuqYLsLbqgYnZ9H8KNQgM9P
	 5lUL5KlWX0z4G7rQcUNSI+36Ux9NMx5XrIO1tFgy5K9JAMOFSwXjWEtGdI0s0CWhpj
	 cl9+YZ/IeQyicEXR5dEKDzC4ARTCR8/cz7ThWJFs=
Date: Fri, 29 Dec 2023 11:59:44 -0800
To: mm-commits@vger.kernel.org,rcampbell@nvidia.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-stale-example-from-comment.patch removed from -mm tree
Message-Id: <20231229195944.881F2C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove stale example from comment
has been removed from the -mm tree.  Its filename was
     mm-remove-stale-example-from-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove stale example from comment
Date: Mon, 11 Dec 2023 16:22:10 +0000

folio_add_new_anon_rmap() no longer works this way, so just remove the
entire example.

Link: https://lkml.kernel.org/r/20231211162214.2146080-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

--- a/mm/memremap.c~mm-remove-stale-example-from-comment
+++ a/mm/memremap.c
@@ -473,21 +473,11 @@ void free_zone_device_page(struct page *
 		__ClearPageAnonExclusive(page);
 
 	/*
-	 * When a device managed page is freed, the page->mapping field
+	 * When a device managed page is freed, the folio->mapping field
 	 * may still contain a (stale) mapping value. For example, the
-	 * lower bits of page->mapping may still identify the page as an
-	 * anonymous page. Ultimately, this entire field is just stale
-	 * and wrong, and it will cause errors if not cleared.  One
-	 * example is:
-	 *
-	 *  migrate_vma_pages()
-	 *    migrate_vma_insert_page()
-	 *      page_add_new_anon_rmap()
-	 *        __page_set_anon_rmap()
-	 *          ...checks page->mapping, via PageAnon(page) call,
-	 *            and incorrectly concludes that the page is an
-	 *            anonymous page. Therefore, it incorrectly,
-	 *            silently fails to set up the new anon rmap.
+	 * lower bits of folio->mapping may still identify the folio as an
+	 * anonymous folio. Ultimately, this entire field is just stale
+	 * and wrong, and it will cause errors if not cleared.
 	 *
 	 * For other types of ZONE_DEVICE pages, migration is either
 	 * handled differently or not done at all, so there is no need
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

