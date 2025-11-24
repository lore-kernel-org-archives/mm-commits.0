Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E85138D;
	Mon, 24 Nov 2025 22:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764023162; cv=none; b=McjKKQ3lQI6s9rvLChIq40ylbfhmx+Pu7tkiuQzH84HQvbWYlOZsv9Q0tn53fMtwdGuqT27v5X8As79UE1gUeMaukTTVD1N7vJxhSF7ipFC4HX487B8lqPaR0XeAGQ9o26jlVrsqgjlQ2NUnGWGsI9Gl/L4XNYenwbtJhi6xT0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764023162; c=relaxed/simple;
	bh=J0wQVM5lahOTehgc2QNxq+Hs9yS6Pubq22HXtX0inkE=;
	h=Date:To:From:Subject:Message-Id; b=p+jrS/q2HZNz6HEvFZNPtSBEgd1FdkYaYD7yUE6gBI3l2SZK1xteNq1GaPTgJMsSMcN7N9hJcxRTKi3NaRK01X6S2X6vdIwCiO6fbCUCJ2OrXuwKSPsRpnjHmb4EmcqVyuNuf/2DyftaEgL98cVxZ3Urei+Tnkdw6COcgqmdlHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NbBNYaBl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NbBNYaBl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF5BC4CEF1;
	Mon, 24 Nov 2025 22:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764023161;
	bh=J0wQVM5lahOTehgc2QNxq+Hs9yS6Pubq22HXtX0inkE=;
	h=Date:To:From:Subject:From;
	b=NbBNYaBl6a0Bco+XOc7XgHqUJWii1sA6/ytELv4v84F9IYbSMa3zUaPAj3XS91yw9
	 V0yjrZLRK2E691/b34xxsHiIyVOLCdOVBmURai5VkDQ8i6+B0zsXgcaOPSD+RHSqBP
	 6p3bfWc9YFkzdsnBhT4vTjg70yLYlUdRH4AUR2P0=
Date: Mon, 24 Nov 2025 14:26:00 -0800
To: mm-commits@vger.kernel.org,vivek.kasireddy@intel.com,stable@vger.kernel.org,osalvador@suse.de,kraxel@redhat.com,jgg@nvidia.com,hughd@google.com,hch@lst.de,david@redhat.com,david@kernel.org,airlied@redhat.com,kartikey406@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memfd-fix-information-leak-in-hugetlb-folios.patch removed from -mm tree
Message-Id: <20251124222601.8EF5BC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memfd: fix information leak in hugetlb folios
has been removed from the -mm tree.  Its filename was
     mm-memfd-fix-information-leak-in-hugetlb-folios.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Deepanshu Kartikey <kartikey406@gmail.com>
Subject: mm/memfd: fix information leak in hugetlb folios
Date: Wed, 12 Nov 2025 20:20:34 +0530

When allocating hugetlb folios for memfd, three initialization steps are
missing:

1. Folios are not zeroed, leading to kernel memory disclosure to userspace
2. Folios are not marked uptodate before adding to page cache
3. hugetlb_fault_mutex is not taken before hugetlb_add_to_page_cache()

The memfd allocation path bypasses the normal page fault handler
(hugetlb_no_page) which would handle all of these initialization steps. 
This is problematic especially for udmabuf use cases where folios are
pinned and directly accessed by userspace via DMA.

Fix by matching the initialization pattern used in hugetlb_no_page():
- Zero the folio using folio_zero_user() which is optimized for huge pages
- Mark it uptodate with folio_mark_uptodate()
- Take hugetlb_fault_mutex before adding to page cache to prevent races

The folio_zero_user() change also fixes a potential security issue where
uninitialized kernel memory could be disclosed to userspace through read()
or mmap() operations on the memfd.

Link: https://lkml.kernel.org/r/20251112145034.2320452-1-kartikey406@gmail.com
Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reported-by: syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/20251112031631.2315651-1-kartikey406@gmail.com/ [v1]
Closes: https://syzkaller.appspot.com/bug?extid=f64019ba229e3a5c411b
Suggested-by: Oscar Salvador <osalvador@suse.de>
Suggested-by: David Hildenbrand <david@redhat.com>
Tested-by: syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com> (v2)
Cc: Christoph Hellwig <hch@lst.de> (v6)
Cc: Dave Airlie <airlied@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/mm/memfd.c~mm-memfd-fix-information-leak-in-hugetlb-folios
+++ a/mm/memfd.c
@@ -96,9 +96,36 @@ struct folio *memfd_alloc_folio(struct f
 						    NULL,
 						    gfp_mask);
 		if (folio) {
+			u32 hash;
+
+			/*
+			 * Zero the folio to prevent information leaks to userspace.
+			 * Use folio_zero_user() which is optimized for huge/gigantic
+			 * pages. Pass 0 as addr_hint since this is not a faulting path
+			 *  and we don't have a user virtual address yet.
+			 */
+			folio_zero_user(folio, 0);
+
+			/*
+			 * Mark the folio uptodate before adding to page cache,
+			 * as required by filemap.c and other hugetlb paths.
+			 */
+			__folio_mark_uptodate(folio);
+
+			/*
+			 * Serialize hugepage allocation and instantiation to prevent
+			 * races with concurrent allocations, as required by all other
+			 * callers of hugetlb_add_to_page_cache().
+			 */
+			hash = hugetlb_fault_mutex_hash(memfd->f_mapping, idx);
+			mutex_lock(&hugetlb_fault_mutex_table[hash]);
+
 			err = hugetlb_add_to_page_cache(folio,
 							memfd->f_mapping,
 							idx);
+
+			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+
 			if (err) {
 				folio_put(folio);
 				goto err_unresv;
_

Patches currently in -mm which might be from kartikey406@gmail.com are


