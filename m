Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA4E3211
	for <mm-commits@vger.kernel.org>; Wed,  5 Jun 2024 03:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717558303; cv=none; b=H2IQMCXFrlLl2defdyAONKVdoPh2gTVHDtpsmvCPHZExvxClqR6HvAQsZPEm4YhoUY8fDhiT+u+/G0Cg5qDFH2lEEFeHee1kiENQep4MfESPl5n5yN9Lys3rX4Ugi5pYjw5tWx7g5aQ9gkGrWlWw+QswNH0D1CX4lwUxs+UwWxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717558303; c=relaxed/simple;
	bh=kf1sCDwalUgpTx/gvMXFB8Z0RtfbBBq3pDXN4jlQFfw=;
	h=Date:To:From:Subject:Message-Id; b=K+sW5GCVjzV0QnfC11QohJher+XFp8qW8ijcKWvHzVAAv8IQJ3+u+qPgZqim/OH0F/TgN2U5cFdXznHb49XCZ7UpK9WdR6b9uSHox75Y02ilLE0qdrB2GY49QkmgFP/6madA12O2CIRw0+gxsKEsaMnHu+chXAVOFXbP5VB/cwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O3l3rNk2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O3l3rNk2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A2FC32781;
	Wed,  5 Jun 2024 03:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717558303;
	bh=kf1sCDwalUgpTx/gvMXFB8Z0RtfbBBq3pDXN4jlQFfw=;
	h=Date:To:From:Subject:From;
	b=O3l3rNk2KyVSkjNtwJ+FFvcJtnLvYwfKyUcdtRtJ7eP6MBqS6/rbdlmm8xAyUuA7j
	 rWY0wkRGXYJen5Wsg0N8M33qCrD/AOPLclEQZrNtjdpDZuEkUj7mMTr+M8XaGRCo+O
	 GYmyPkzyAtE7uGo/GuWPu6s/zEhVvNj1a6jqB+30=
Date: Tue, 04 Jun 2024 20:31:42 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,tony.luck@intel.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jiaqiyan@google.com,jglisse@redhat.com,jane.chu@oracle.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,bcrl@kvack.org,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-support-poisoned-recover-from-migrate-folio.patch added to mm-unstable branch
Message-Id: <20240605033143.02A2FC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: migrate: support poisoned recover from migrate folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-support-poisoned-recover-from-migrate-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-support-poisoned-recover-from-migrate-folio.patch

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
Subject: mm: migrate: support poisoned recover from migrate folio
Date: Mon, 3 Jun 2024 17:24:37 +0800

The folio migration is widely used in kernel, memory compaction, memory
hotplug, soft offline page, numa balance, memory demote/promotion, etc,
but once access a poisoned source folio when migrating, the kerenl will
panic.

There is a mechanism in the kernel to recover from uncorrectable memory
errors, ARCH_HAS_COPY_MC, which is already used in other core-mm paths,
eg, CoW, khugepaged, coredump, ksm copy, see copy_mc_to_{user,kernel},
copy_mc_{user_}highpage callers.

In order to support poisoned folio copy recover from migrate folio, we
chose to make folio migration tolerant of memory failures and return error
for folio migration, because folio migration is no guarantee of success,
this could avoid the similar panic shown below.

  CPU: 1 PID: 88343 Comm: test_softofflin Kdump: loaded Not tainted 6.6.0
  pc : copy_page+0x10/0xc0
  lr : copy_highpage+0x38/0x50
  ...
  Call trace:
   copy_page+0x10/0xc0
   folio_copy+0x78/0x90
   migrate_folio_extra+0x54/0xa0
   move_to_new_folio+0xd8/0x1f0
   migrate_folio_move+0xb8/0x300
   migrate_pages_batch+0x528/0x788
   migrate_pages_sync+0x8c/0x258
   migrate_pages+0x440/0x528
   soft_offline_in_use_page+0x2ec/0x3c0
   soft_offline_page+0x238/0x310
   soft_offline_page_store+0x6c/0xc0
   dev_attr_store+0x20/0x40
   sysfs_kf_write+0x4c/0x68
   kernfs_fop_write_iter+0x130/0x1c8
   new_sync_write+0xa4/0x138
   vfs_write+0x238/0x2d8
   ksys_write+0x74/0x110

Link: https://lkml.kernel.org/r/20240603092439.3360652-5-wangkefeng.wang@huawei.com
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

 mm/migrate.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/mm/migrate.c~mm-migrate-support-poisoned-recover-from-migrate-folio
+++ a/mm/migrate.c
@@ -663,16 +663,29 @@ static int __migrate_folio(struct addres
 			   struct folio *src, void *src_private,
 			   enum migrate_mode mode)
 {
-	int rc;
+	int ret, expected_cnt = folio_expected_refs(mapping, src);
 
-	rc = folio_migrate_mapping(mapping, dst, src, 0);
-	if (rc != MIGRATEPAGE_SUCCESS)
-		return rc;
+	if (!mapping) {
+		if (folio_ref_count(src) != expected_cnt)
+			return -EAGAIN;
+	} else {
+		if (!folio_ref_freeze(src, expected_cnt))
+			return -EAGAIN;
+	}
+
+	ret = folio_mc_copy(dst, src);
+	if (unlikely(ret)) {
+		if (mapping)
+			folio_ref_unfreeze(src, expected_cnt);
+		return ret;
+	}
+
+	__folio_migrate_mapping(mapping, dst, src, expected_cnt);
 
 	if (src_private)
 		folio_attach_private(dst, folio_detach_private(src));
 
-	folio_migrate_copy(dst, src);
+	folio_migrate_flags(dst, src);
 	return MIGRATEPAGE_SUCCESS;
 }
 
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

