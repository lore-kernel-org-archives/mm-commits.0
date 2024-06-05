Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6716A33D
	for <mm-commits@vger.kernel.org>; Wed,  5 Jun 2024 03:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717558305; cv=none; b=fe0cyje+BCMvC1MFjFsx2MlbKD+fDvFh85Kc8HbOenJ+5yOKB1RzUMvy7X4XwzpltFhPHRyk81ENgakr/bhCu9TG+UTmSo2oN7sro297XVTm/+tYZkXkOLBljfJvvt4ZmpNnPRedZtrY4T+LKW/8CKt62nzHPY/grRrINCHwjuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717558305; c=relaxed/simple;
	bh=/Nx9CvX5kyi2qC4Qfet53Urt84WDPqmTr6duN0XwF1M=;
	h=Date:To:From:Subject:Message-Id; b=hlzAl1gVkJyBYlOadKKSzNwcND4j+HgdBwIcmP2orRZ555qALdqpArzFQbIA6LZeDQHEIspakxHrR9IExySYr9xMGpSxgFKhs46iRp8Q0BQQDOlN1mckxA5a+oBGdG5/TNzY9JMaoawskTySodEwjNfspef7OYnM7iJ+iPn3MQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oLDpjJYI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oLDpjJYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E527DC32781;
	Wed,  5 Jun 2024 03:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717558305;
	bh=/Nx9CvX5kyi2qC4Qfet53Urt84WDPqmTr6duN0XwF1M=;
	h=Date:To:From:Subject:From;
	b=oLDpjJYI2IVn74BgTZVPemkpq5f+JdmT+SHE2nLiZ2TM+79q+Q4kktXp80V4F2qjz
	 eOWvRmDV7tFW1I68R2rmSW8C09+VkxoRvw/CjayS03lRd2/jt9aS4UqY9xwRbYnxte
	 KBJ4N2lEKWq3REh0lYZiuwXGhpad53OwH9g7n+FM=
Date: Tue, 04 Jun 2024 20:31:44 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,tony.luck@intel.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jiaqiyan@google.com,jglisse@redhat.com,jane.chu@oracle.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,bcrl@kvack.org,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-hugetlbfs-support-poison-recover-from-hugetlbfs_migrate_folio.patch added to mm-unstable branch
Message-Id: <20240605033144.E527DC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs: hugetlbfs: support poison recover from hugetlbfs_migrate_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     fs-hugetlbfs-support-poison-recover-from-hugetlbfs_migrate_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-hugetlbfs-support-poison-recover-from-hugetlbfs_migrate_folio.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: fs: hugetlbfs: support poison recover from hugetlbfs_migrate_folio()
Date: Mon, 3 Jun 2024 17:24:38 +0800

This is similar to __migrate_folio(), use folio_mc_copy() in HugeTLB folio
migration to avoid panic when copy from poisoned folio.

Link: https://lkml.kernel.org/r/20240603092439.3360652-6-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 +-
 mm/migrate.c         |   14 +++++++++-----
 2 files changed, 10 insertions(+), 6 deletions(-)

--- a/fs/hugetlbfs/inode.c~fs-hugetlbfs-support-poison-recover-from-hugetlbfs_migrate_folio
+++ a/fs/hugetlbfs/inode.c
@@ -1128,7 +1128,7 @@ static int hugetlbfs_migrate_folio(struc
 		hugetlb_set_folio_subpool(src, NULL);
 	}
 
-	folio_migrate_copy(dst, src);
+	folio_migrate_flags(dst, src);
 
 	return MIGRATEPAGE_SUCCESS;
 }
--- a/mm/migrate.c~fs-hugetlbfs-support-poison-recover-from-hugetlbfs_migrate_folio
+++ a/mm/migrate.c
@@ -532,15 +532,19 @@ int migrate_huge_page_move_mapping(struc
 				   struct folio *dst, struct folio *src)
 {
 	XA_STATE(xas, &mapping->i_pages, folio_index(src));
-	int expected_count;
+	int ret, expected_count = folio_expected_refs(mapping, src);
 
-	xas_lock_irq(&xas);
-	expected_count = folio_expected_refs(mapping, src);
-	if (!folio_ref_freeze(src, expected_count)) {
-		xas_unlock_irq(&xas);
+	if (!folio_ref_freeze(src, expected_count))
 		return -EAGAIN;
+
+	ret = folio_mc_copy(dst, src);
+	if (unlikely(ret)) {
+		folio_ref_unfreeze(src, expected_count);
+		return ret;
 	}
 
+	xas_lock_irq(&xas);
+
 	dst->index = src->index;
 	dst->mapping = src->mapping;
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-add-folio_alloc_mpol.patch
mm-mempolicy-use-folio_alloc_mpol_noprof-in-vma_alloc_folio_noprof.patch
mm-mempolicy-use-folio_alloc_mpol-in-alloc_migration_target_by_mpol.patch
mm-shmem-use-folio_alloc_mpol-in-shmem_alloc_folio.patch
mm-refactor-folio_undo_large_rmappable.patch
mm-memcontrol-remove-page_memcg.patch
rmap-remove-define_page_vma_walk.patch
mm-migrate-simplify-__buffer_migrate_folio.patch
mm-migrate_device-use-a-newfolio-in-__migrate_device_pages.patch
mm-migrate_device-unify-migrate-folio-for-migrate_sync_no_copy.patch
mm-migrate-remove-migrate_folio_extra.patch
mm-remove-migrate_sync_no_copy-mode.patch
fs-proc-task_mmu-use-folio-api-in-pte_is_pinned.patch
mm-remove-page_maybe_dma_pinned.patch
fb_defio-use-a-folio-in-fb_deferred_io_work.patch
mm-remove-page_mkclean.patch
mm-move-memory_failure_queue-into-copy_mc__highpage.patch
mm-add-folio_mc_copy.patch
mm-migrate-split-folio_migrate_mapping.patch
mm-migrate-support-poisoned-recover-from-migrate-folio.patch
fs-hugetlbfs-support-poison-recover-from-hugetlbfs_migrate_folio.patch
mm-migrate-remove-folio_migrate_copy.patch

