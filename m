Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398702E337D;
	Tue,  4 Mar 2025 21:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741122347; cv=none; b=XV91Ilt/wWzG45lOKTrmhdBqLfJRCEOt/P6MdXI3kn5+OL5HRDth75YnXIHbtppAABZE+rcHay6yK5P3v/HnwhKjwCUJIY17iktK/FkZ+jSqKqHNdoE6l1KSwN29Tat27aDzp0lioAVNMk8kr4UEt1NU1TbaPtOwvGqQyw8ozDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741122347; c=relaxed/simple;
	bh=p/YmkFWD96a273eY0RGKJJXae0CjD04Bl0XKgZ3cT/g=;
	h=Date:To:From:Subject:Message-Id; b=Th1UMTH7TFLvkx8UFWzlzqcc1bUNNQ6piTn0M1NnT8EVONyLHpFl+3jp5t9pNlaKijDR4SGo+ytUU+o8/4gCGnIPMJ4NROxx5ZBx8FcpHlfkgepxJZGLGO8HfuNITnUJVHJJjMZgaFACEHJFix9Nq7FSwCLURKKwBW9pyXSdsDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jsumTwG9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jsumTwG9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE79C4CEE5;
	Tue,  4 Mar 2025 21:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741122346;
	bh=p/YmkFWD96a273eY0RGKJJXae0CjD04Bl0XKgZ3cT/g=;
	h=Date:To:From:Subject:From;
	b=jsumTwG9xMKOOCES68HAnwCnqR54qjB00gIgLOQl69M9hISFLyCCbOuwugIyedFBY
	 00VP1mDdvnuS8GDaK3LRPQzMzs1O8bZL2OZpsD3x6k9nYLxx7I/PkPVyCkSC2PaKIh
	 N4kJJyKyx0APjaMVMxULZaL89Tq9zwAlCotUYtws=
Date: Tue, 04 Mar 2025 13:05:45 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,stable@vger.kernel.org,shivankg@amd.com,ryan.roberts@arm.com,quic_charante@quicinc.com,liushixin2@huawei.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-migrate-fix-shmem-xarray-update-during-migration.patch removed from -mm tree
Message-Id: <20250304210546.8BE79C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: fix shmem xarray update during migration
has been removed from the -mm tree.  Its filename was
     mm-migrate-fix-shmem-xarray-update-during-migration.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/migrate: fix shmem xarray update during migration
Date: Fri, 28 Feb 2025 12:49:53 -0500

Pagecache uses multi-index entries for large folio, so does shmem.  Only
swap cache still stores multiple entries for a single large folio.  Commit
fc346d0a70a1 ("mm: migrate high-order folios in swap cache correctly")
fixed swap cache but got shmem wrong by storing multiple entries for a
large shmem folio.

This results in a soft lockup as reported by Liu Shixin.

Fix it by storing a single entry for a shmem folio.

Link: https://lkml.kernel.org/r/20250228174953.2222831-1-ziy@nvidia.com
Fixes: fc346d0a70a1 ("mm: migrate high-order folios in swap cache correctly")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: Liu Shixin <liushixin2@huawei.com>
Closes: https://lore.kernel.org/all/28546fb4-5210-bf75-16d6-43e1f8646080@huawei.com/
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-fix-shmem-xarray-update-during-migration
+++ a/mm/migrate.c
@@ -524,7 +524,11 @@ static int __folio_migrate_mapping(struc
 			folio_set_swapcache(newfolio);
 			newfolio->private = folio_get_private(folio);
 		}
-		entries = nr;
+		/* shmem uses high-order entry */
+		if (!folio_test_anon(folio))
+			entries = 1;
+		else
+			entries = nr;
 	} else {
 		VM_BUG_ON_FOLIO(folio_test_swapcache(folio), folio);
 		entries = 1;
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-make-file-backed-thp-split-work-by-writing-pmd-size-data.patch
mm-huge_memory-allow-split-shmem-large-folio-to-any-lower-order.patch
selftests-mm-test-splitting-file-backed-thp-to-any-lower-order.patch
mm-filemap-use-xas_try_split-in-__filemap_add_folio.patch
mm-shmem-use-xas_try_split-in-shmem_split_large_entry.patch

