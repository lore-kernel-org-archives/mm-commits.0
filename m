Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93ADC50097C;
	Sun, 11 Jan 2026 02:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768099424; cv=none; b=XPI3JjRu15AFu+9YTPyQcMl56I4j9Z33D/xHwp53XLhK/cZrQBPIKEhbqgPX12uXuPUjLQYxO/Pcmx4KUpQxxG5tPt6xgVNKrUsA5C4W/7Z7eBpsbZTqn/buhxgxC/j/Jcz37AMtw9zVCXC2qlND+Jv+utWZNRueuWwen6i0q1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768099424; c=relaxed/simple;
	bh=cCZIJh4/iY01wNU8TcIoLu7sBmglGvcxzE1Veb0zHJg=;
	h=Date:To:From:Subject:Message-Id; b=JxQncXfAwDxfbdFFPsbvhQHfod8GvaUzxYoTqObPZJhX+z46AUXGV5uExbacp36nTANP0FjGpaETcZVCuAUskUgMhjlOWv73kJZbuyN/2Rurc2wJ+fby/r5l2C4Z4duoowd2HwDsMEfedAbRZfBlm0aN3Uq/frPCdh0k+CQGvBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gzonoEk/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gzonoEk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0552DC4CEF1;
	Sun, 11 Jan 2026 02:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768099424;
	bh=cCZIJh4/iY01wNU8TcIoLu7sBmglGvcxzE1Veb0zHJg=;
	h=Date:To:From:Subject:From;
	b=gzonoEk/e9vNlYmIwmLBLsImcKYsWm7RFLJyW1CBVOxpbzaV4tFbfLgvufn/0q2Ow
	 0K81XaiCsegz728+76qyA8Cc34Mqc/x7TPgdd+wdDKahXWFuqH8MBixdzl7eufDLbl
	 ekgL61RsXPxrtW7Dfk8+Bo1rezoinEhxHadOdBhM=
Date: Sat, 10 Jan 2026 18:43:43 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@suse.cz,stable@vger.kernel.org,riel@surriel.com,rakie.kim@sk.com,matthew.brost@intel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,joshua.hahnjy@gmail.com,jannh@google.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + migrate-correct-lock-ordering-for-hugetlb-file-folios.patch added to mm-hotfixes-unstable branch
Message-Id: <20260111024344.0552DC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: migrate: correct lock ordering for hugetlb file folios
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     migrate-correct-lock-ordering-for-hugetlb-file-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/migrate-correct-lock-ordering-for-hugetlb-file-folios.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: migrate: correct lock ordering for hugetlb file folios
Date: Fri, 9 Jan 2026 04:13:42 +0000

Syzbot has found a deadlock (analyzed by Lance Yang):

1) Task (5749): Holds folio_lock, then tries to acquire i_mmap_rwsem(read lock).
2) Task (5754): Holds i_mmap_rwsem(write lock), then tries to acquire
folio_lock.

migrate_pages()
  -> migrate_hugetlbs()
    -> unmap_and_move_huge_page()     <- Takes folio_lock!
      -> remove_migration_ptes()
        -> __rmap_walk_file()
          -> i_mmap_lock_read()       <- Waits for i_mmap_rwsem(read lock)!

hugetlbfs_fallocate()
  -> hugetlbfs_punch_hole()           <- Takes i_mmap_rwsem(write lock)!
    -> hugetlbfs_zero_partial_page()
     -> filemap_lock_hugetlb_folio()
      -> filemap_lock_folio()
        -> __filemap_get_folio        <- Waits for folio_lock!

The migration path is the one taking locks in the wrong order according to
the documentation at the top of mm/rmap.c.  So expand the scope of the
existing i_mmap_lock to cover the calls to remove_migration_ptes() too.

This is (mostly) how it used to be after commit c0d0381ade79.  That was
removed by 336bf30eb765 for both file & anon hugetlb pages when it should
only have been removed for anon hugetlb pages.

Link: https://lkml.kernel.org/r/20260109041345.3863089-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Fixes: 336bf30eb765 ("hugetlbfs: fix anon huge page migration race")
Reported-by: syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/68e9715a.050a0220.1186a4.000d.GAE@google.com
Debugged-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Jann Horn <jannh@google.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/migrate.c~migrate-correct-lock-ordering-for-hugetlb-file-folios
+++ a/mm/migrate.c
@@ -1458,6 +1458,7 @@ static int unmap_and_move_huge_page(new_
 	int page_was_mapped = 0;
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
+	enum ttu_flags ttu = 0;
 
 	if (folio_ref_count(src) == 1) {
 		/* page was freed from under us. So we are done. */
@@ -1498,8 +1499,6 @@ static int unmap_and_move_huge_page(new_
 		goto put_anon;
 
 	if (folio_mapped(src)) {
-		enum ttu_flags ttu = 0;
-
 		if (!folio_test_anon(src)) {
 			/*
 			 * In shared mappings, try_to_unmap could potentially
@@ -1516,16 +1515,17 @@ static int unmap_and_move_huge_page(new_
 
 		try_to_migrate(src, ttu);
 		page_was_mapped = 1;
-
-		if (ttu & TTU_RMAP_LOCKED)
-			i_mmap_unlock_write(mapping);
 	}
 
 	if (!folio_mapped(src))
 		rc = move_to_new_folio(dst, src, mode);
 
 	if (page_was_mapped)
-		remove_migration_ptes(src, !rc ? dst : src, 0);
+		remove_migration_ptes(src, !rc ? dst : src,
+				ttu ? RMP_LOCKED : 0);
+
+	if (ttu & TTU_RMAP_LOCKED)
+		i_mmap_unlock_write(mapping);
 
 unlock_put_anon:
 	folio_unlock(dst);
_

Patches currently in -mm which might be from willy@infradead.org are

migrate-correct-lock-ordering-for-hugetlb-file-folios.patch
migrate-replace-rmp_-flags-with-ttu_-flags.patch

