Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF892EEE61
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334230; cv=none; b=gO3duJZnUB8M/v+unNdj8JjM1CdYCHtoFtDx6j5z3UgraDua2BUS2f4j8HllMXa/dxI62/Qx9vM9iLX9X6ir0u7uj3zOQ4LWtLy9+fEoEM7wTO/uY1uj5E7jLEk5/UmjFlmgV0p8Yw6AK2aXJ1v73W4YqW7glJTdk0uyErk4DO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334230; c=relaxed/simple;
	bh=VQA48LMDxwn9jqxw6DD45OTpq6lB/WkXkHLRxSKXQdM=;
	h=Date:To:From:Subject:Message-Id; b=d+7zd0g6AC44BcJJqCpJiHHppbZwR9ZcVXnFWFXvkHsnzdZTFiOWdE6a1vKqcVu2Q5zQYkZ9F7l8fsoVW/pbgaEGk6dKfc4kRP0AWrFwSmK9/vvoq63H5P5fQLCI5z6uZcogx5hfG6H0DSUgwgo8iTKZBSucfAhuNJqvOpOOkYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mMjNg2r6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mMjNg2r6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07C91F0089B;
	Wed,  7 Oct 2026 00:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334228;
	bh=t+YQoBYFPSJ+qhLHvrE030HkM+zMQ6WzJZiVsiUU9N4=;
	h=Date:To:From:Subject;
	b=mMjNg2r6BzbS/9FIq8C0Zi3YabYfiXBiOiQCj5W3nhOrXkduB8kkcsjlAsAwVAC+q
	 Lw2tVR7ME/5VRFLZTym0ESUW9bqChramkQMa7ns8LBHYmh+YvfMozeWcWjQTv6C7xa
	 ujMyYE5FKFlBeJcSgO4KzDP6siA1WfQnW1YfT+28=
Date: Tue, 06 Oct 2026 17:50:28 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ljs@kernel.org,hannes@cmpxchg.org,david@kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-pagereclaim.patch removed from -mm tree
Message-Id: <20261007005028.D07C91F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove PageReclaim
has been removed from the -mm tree.  Its filename was
     mm-remove-pagereclaim.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm: remove PageReclaim
Date: Sat, 29 Aug 2026 15:09:01 -0400

This flag is now only used on folios, so we can remove all the page
accessors.  folio_test_clear_reclaim() is not used, so don't add
FOLIO_TEST_CLEAR_FLAG() for it.

Link: https://lore.kernel.org/20260829-b4-page_io-folios-v2-2-649728091117@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---

 include/linux/page-flags.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/page-flags.h~mm-remove-pagereclaim
+++ a/include/linux/page-flags.h
@@ -593,8 +593,7 @@ TESTPAGEFLAG(Writeback, writeback, PF_NO
 FOLIO_FLAG(mappedtodisk, FOLIO_HEAD_PAGE)
 
 /* PG_readahead is only used for reads; PG_reclaim is only for writes */
-PAGEFLAG(Reclaim, reclaim, PF_NO_TAIL)
-	TESTCLEARFLAG(Reclaim, reclaim, PF_NO_TAIL)
+FOLIO_FLAG(reclaim, FOLIO_HEAD_PAGE)
 FOLIO_FLAG(readahead, FOLIO_HEAD_PAGE)
 	FOLIO_TEST_CLEAR_FLAG(readahead, FOLIO_HEAD_PAGE)
 
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-remove-pagewriteback.patch
mm-swap-add-folio_swap_entry-and-folio_page_swap_entry.patch
mm-swap-add-folio_swap_entry-and-folio_page_swap_entry-fix.patch
mm-huge_memory-add-a-comment-to-the-open-coded-swap-entry.patch
mm-rmap-use-folio_page_swap_entry-in-ttu_anon_swapbacked_folio.patch
mm-zswap-use-folio_swap_entry-in-zswap_store_page.patch
mm-swapfile-use-folio_page_swap_entry.patch
arm64-mte-make-mte_save_tags-and-mte_restore_tags-static.patch
arm64-mte-pass-the-swap-entry-to-mte_save_tags.patch
mm-swap-remove-page_swap_entry.patch
mm-memcontrol-take-a-const-folio-in-folio_memcg-and-friends.patch
mm-memcontrol-constify-obj_cgroup_memcg-and-friends.patch
mm-memcontrol-constify-the-lruvec-helpers.patch
mm-page_io-take-a-const-folio-in-bio_associate_blkg_from_folio.patch
mm-memcontrol-constify-the-mem_cgroup-accessors.patch
mm-page_counter-constify-page_counter_read-and-page_counter_margin.patch
mm-memcontrol-constify-the-reclaim-protection-helpers.patch
mm-memcontrol-constify-the-memcg-and-lruvec-stat-readers.patch
mm-memcontrol-constify-the-swap-accounting-helpers.patch
mm-memcontrol-constify-mem_cgroup_swappiness-and-mem_cgroup_get_max.patch
mm-memcontrol-constify-the-zswap-and-socket-pressure-helpers.patch
vmcore-convert-mmap_vmcore_fault-to-use-folios.patch

