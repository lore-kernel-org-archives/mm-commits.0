Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36EE949620;
	Mon, 17 Mar 2025 00:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742172072; cv=none; b=IWAKLN9lltO3XtYuga63ZP7InmuCO+fbkyFcWGUV9AAtznhwWDiiWKwOctNHSQZHqPsaxzQgwwcsvPGBtsC1M5WtpfmcJvfHQ/wl7l++bO8VqRu0BiB3wlIBvJ1xhaK+VdBQY4iBv0GMUq6hjZ7LuX030kpLN/hUoUFwsRk3NHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742172072; c=relaxed/simple;
	bh=qyN9wuDrjIMxWs3klzzZDrkcTasmeQThEFCHfHFe8gE=;
	h=Date:To:From:Subject:Message-Id; b=gh9e91d9S9owrmI2wZjddJJ4tC4tFmLMLKW/MrFFwV7sDU/3Ws8cc+6/UshTyqh1gx7CRUnMSpQl+gNg5CfciQzDJA9uFY0F4YqHuiPc/Fj+DZ9dQOyMmOVx+W1dmAN3r/osODQbnobsOEIe/Oo4pqOEQyQFqNKi+NS0YpoHxSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a84x+8yM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a84x+8yM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE92C4CEDD;
	Mon, 17 Mar 2025 00:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742172071;
	bh=qyN9wuDrjIMxWs3klzzZDrkcTasmeQThEFCHfHFe8gE=;
	h=Date:To:From:Subject:From;
	b=a84x+8yMX4wAknkPbYbHjkPFFIVg1uzSCEPygS/fYMsBAKr0TYaU8Z1mIO9BJ3b7T
	 hmTzugLRMSArC9tqwTo0cP5zomo3cQw3cVZb8hHbx7KMYl6U9vv5iiAwI3JNx2ld5G
	 XF6PIFKzxPaa515K6+RCb+aCtctbC8DI5yQ9yPBI=
Date: Sun, 16 Mar 2025 17:41:11 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,stable@vger.kernel.org,ryan.roberts@arm.com,quic_charante@quicinc.com,liushixin2@huawei.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-migrate-fix-shmem-xarray-update-during-migration.patch removed from -mm tree
Message-Id: <20250317004111.9CE92C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: fix shmem xarray update during migration
has been removed from the -mm tree.  Its filename was
     mm-migrate-fix-shmem-xarray-update-during-migration.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/migrate: fix shmem xarray update during migration
Date: Wed, 5 Mar 2025 15:04:03 -0500

A shmem folio can be either in page cache or in swap cache, but not at the
same time.  Namely, once it is in swap cache, folio->mapping should be
NULL, and the folio is no longer in a shmem mapping.

In __folio_migrate_mapping(), to determine the number of xarray entries to
update, folio_test_swapbacked() is used, but that conflates shmem in page
cache case and shmem in swap cache case.  It leads to xarray multi-index
entry corruption, since it turns a sibling entry to a normal entry during
xas_store() (see [1] for a userspace reproduction).  Fix it by only using
folio_test_swapcache() to determine whether xarray is storing swap cache
entries or not to choose the right number of xarray entries to update.

[1] https://lore.kernel.org/linux-mm/Z8idPCkaJW1IChjT@casper.infradead.org/

Note:
In __split_huge_page(), folio_test_anon() && folio_test_swapcache() is
used to get swap_cache address space, but that ignores the shmem folio in
swap cache case.  It could lead to NULL pointer dereferencing when a
in-swap-cache shmem folio is split at __xa_store(), since
!folio_test_anon() is true and folio->mapping is NULL.  But fortunately,
its caller split_huge_page_to_list_to_order() bails out early with EBUSY
when folio->mapping is NULL.  So no need to take care of it here.

Link: https://lkml.kernel.org/r/20250305200403.2822855-1-ziy@nvidia.com
Fixes: fc346d0a70a1 ("mm: migrate high-order folios in swap cache correctly")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: Liu Shixin <liushixin2@huawei.com>
Closes: https://lore.kernel.org/all/28546fb4-5210-bf75-16d6-43e1f8646080@huawei.com/
Suggested-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/mm/migrate.c~mm-migrate-fix-shmem-xarray-update-during-migration
+++ a/mm/migrate.c
@@ -518,15 +518,13 @@ static int __folio_migrate_mapping(struc
 	if (folio_test_anon(folio) && folio_test_large(folio))
 		mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON, 1);
 	folio_ref_add(newfolio, nr); /* add cache reference */
-	if (folio_test_swapbacked(folio)) {
+	if (folio_test_swapbacked(folio))
 		__folio_set_swapbacked(newfolio);
-		if (folio_test_swapcache(folio)) {
-			folio_set_swapcache(newfolio);
-			newfolio->private = folio_get_private(folio);
-		}
+	if (folio_test_swapcache(folio)) {
+		folio_set_swapcache(newfolio);
+		newfolio->private = folio_get_private(folio);
 		entries = nr;
 	} else {
-		VM_BUG_ON_FOLIO(folio_test_swapcache(folio), folio);
 		entries = 1;
 	}
 
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-make-file-backed-thp-split-work-by-writing-pmd-size-data.patch
mm-huge_memory-allow-split-shmem-large-folio-to-any-lower-order.patch
selftests-mm-test-splitting-file-backed-thp-to-any-lower-order.patch
xarray-add-xas_try_split-to-split-a-multi-index-entry.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix-2.patch
mm-huge_memory-move-folio-split-common-code-to-__folio_split.patch
mm-huge_memory-add-buddy-allocator-like-non-uniform-folio_split.patch
mm-huge_memory-remove-the-old-unused-__split_huge_page.patch
mm-huge_memory-add-folio_split-to-debugfs-testing-interface.patch
mm-truncate-use-folio_split-in-truncate-operation.patch
selftests-mm-add-tests-for-folio_split-buddy-allocator-like-split.patch
mm-filemap-use-xas_try_split-in-__filemap_add_folio.patch
mm-shmem-use-xas_try_split-in-shmem_split_large_entry.patch

