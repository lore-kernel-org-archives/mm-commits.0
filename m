Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93EF142E76
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291596; cv=none; b=dSlHZPlqzTpev9xWrbS5AMvYYJU2T/CnUawd8D4zA9Xz1XWAbUnuhZ35YcqMDX6/zXzuU4KDVwdqua8CztUWosZSq3gajBNhlfzbnPsXnfJjTSULkpEiL/F/2azQDXgvsweWT4DPoykMDtWGlKHBoKaKneS1C/2RGpmGgQ9vP6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291596; c=relaxed/simple;
	bh=rL/+RUn7dlbPjdUkkFTavXgklm44hiFVR0zXa+8u01o=;
	h=Date:To:From:Subject:Message-Id; b=Jyl1b34VzLGUZsdxspuCJMMzRt/fETN/8KPNeOSAiUXgEjQKG3JNg9EyIIiDw+tSVew9fLbLYnuoLQ7ICoPBi7EC33S4k6qe3S1QSQZtBFW4fJCtI9xqm6lRpAON70HndM6tUysMg2BdySz3gNcog2hCM7FcPBvlzTCHLy8T0TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U9gMiBkl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U9gMiBkl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D099C32782;
	Tue, 25 Jun 2024 04:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291596;
	bh=rL/+RUn7dlbPjdUkkFTavXgklm44hiFVR0zXa+8u01o=;
	h=Date:To:From:Subject:From;
	b=U9gMiBklW13nOxQwg1X/WkuXuy+YkDea+F5Z8b5f3twImyfUaTnxDVLscHbXu/AB6
	 z+OLwWYOoHY32hARUZM1A/3aRBXJKoXgGxXUPsaNpPkhSGJOekJl0EP/ldUfxZK8JE
	 j3mrbIb6F8mt8M6Fg2BhqBkFmBdBA8VnEo1gDxrI=
Date: Mon, 24 Jun 2024 21:59:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vishal.moola@gmail.com,tony.luck@intel.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jiaqiyan@google.com,jglisse@redhat.com,hughd@google.com,david@redhat.com,bcrl@kvack.org,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-simplify-__buffer_migrate_folio.patch removed from -mm tree
Message-Id: <20240625045956.9D099C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: migrate: simplify __buffer_migrate_folio()
has been removed from the -mm tree.  Its filename was
     mm-migrate-simplify-__buffer_migrate_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

fs-proc-task_mmu-use-folio-api-in-pte_is_pinned.patch
mm-remove-page_maybe_dma_pinned.patch
mm-remove-page_maybe_dma_pinned-fix.patch
fb_defio-use-a-folio-in-fb_deferred_io_work.patch
mm-remove-page_mkclean.patch
mm-move-memory_failure_queue-into-copy_mc__highpage.patch
mm-add-folio_mc_copy.patch
mm-migrate-split-folio_migrate_mapping.patch
mm-migrate-support-poisoned-recover-from-migrate-folio.patch
fs-hugetlbfs-support-poison-recover-from-hugetlbfs_migrate_folio.patch
mm-migrate-remove-folio_migrate_copy.patch
mm-memory-convert-clear_huge_page-to-folio_zero_user.patch
mm-memory-use-folio-in-struct-copy_subpage_arg.patch
mm-memory-improve-copy_user_large_folio.patch
mm-memory-rename-pages_per_huge_page-to-nr_pages.patch

