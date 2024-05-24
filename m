Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF0C12C81A
	for <mm-commits@vger.kernel.org>; Fri, 24 May 2024 20:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716581918; cv=none; b=dbIL4vT++izeV0PhIhHcRpP0Uay6rso21wjjVzlDx0GmCpaF4HDZFOVG2Wac2wfSdBYUgsHG3hpYVhP2vuF1B3ibwK+cS4HkYktJzQ7ialW3eV9TKHLFYuX9f/ydvuUj0rJxAIvAFWqAKzBnggG9W4halm0rnLe4SBFbl7v1KIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716581918; c=relaxed/simple;
	bh=3RwoB6uF3dO2xImdMiQ1mORJYH1zS0fN0cioTnwFSYA=;
	h=Date:To:From:Subject:Message-Id; b=s2BpqL0wZo1SrcBPHdZ3xpGOKu6ibqoR8mFhiZpyVsuppO6u8Dn9XvoFb9BR6y3czgswJNpSGj2IIeuOgHOwzzS7YnSUt0xj+eEYagH4UlAFMDIJsyxyp6Uzze4cYq6EcSHaS7Mo5mVvlxIpx6YHutKp43hWovVkCSUJExbWubs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lgSKjaBn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lgSKjaBn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495D0C2BBFC;
	Fri, 24 May 2024 20:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716581917;
	bh=3RwoB6uF3dO2xImdMiQ1mORJYH1zS0fN0cioTnwFSYA=;
	h=Date:To:From:Subject:From;
	b=lgSKjaBnZYDjbfeqpXerhywXzaFuvBcpKD9oA22R2W4Sh/A0YOvewnmm+wcb4IdwN
	 62IxJXbbZGN6PvPnRCss/mdqBlmpqrprx6VvPvDh9tjTQGOEvnt6iV2QjWGhj86Jy7
	 OxqyM4gNgSbXek3kA1NTk/H9/iKUP2aWonwmFW2k=
Date: Fri, 24 May 2024 13:18:36 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vishal.moola@gmail.com,tony.luck@intel.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jiaqiyan@google.com,jglisse@redhat.com,hughd@google.com,david@redhat.com,bcrl@kvack.org,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-simplify-__buffer_migrate_folio.patch added to mm-unstable branch
Message-Id: <20240524201837.495D0C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: migrate: simplify __buffer_migrate_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-simplify-__buffer_migrate_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-simplify-__buffer_migrate_folio.patch

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
Subject: mm: migrate: simplify __buffer_migrate_folio()
Date: Fri, 24 May 2024 13:28:39 +0800

Patch series "mm: cleanup MIGRATE_SYNC_NO_COPY mode".

Commit 2916ecc0f9d4 ("mm/migrate: new migrate mode MIGRATE_SYNC_NO_COPY")
introduce a new MIGRATE_SYNC_NO_COPY mode to allow to offload the copy to
a device DMA engine, which is only used __migrate_device_pages() to decide
whether or not copy the old page, and the MIGRATE_SYNC_NO_COPY mode only
used in hmm, a easy way is just to call the folio_migrate_mapping() and
folio_migrate_flags(), which help to remove the MIGRATE_SYNC_NO_COPY mode.


This patch (of 5):

Use filemap_migrate_folio() helper to simplify __buffer_migrate_folio().

Link: https://lkml.kernel.org/r/20240524052843.182275-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20240524052843.182275-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/mm/migrate.c~mm-migrate-simplify-__buffer_migrate_folio
+++ a/mm/migrate.c
@@ -777,24 +777,16 @@ recheck_buffers:
 		}
 	}
 
-	rc = folio_migrate_mapping(mapping, dst, src, 0);
+	rc = filemap_migrate_folio(mapping, dst, src, mode);
 	if (rc != MIGRATEPAGE_SUCCESS)
 		goto unlock_buffers;
 
-	folio_attach_private(dst, folio_detach_private(src));
-
 	bh = head;
 	do {
 		folio_set_bh(bh, dst, bh_offset(bh));
 		bh = bh->b_this_page;
 	} while (bh != head);
 
-	if (mode != MIGRATE_SYNC_NO_COPY)
-		folio_migrate_copy(dst, src);
-	else
-		folio_migrate_flags(dst, src);
-
-	rc = MIGRATEPAGE_SUCCESS;
 unlock_buffers:
 	if (check_refs)
 		spin_unlock(&mapping->i_private_lock);
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

