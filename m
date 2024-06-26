Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6261922C5
	for <mm-commits@vger.kernel.org>; Wed, 26 Jun 2024 20:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719432535; cv=none; b=t8kLR5TUw65s+W+CiVeO/UFRkwmR9ICHbXQKmhbSs+/d7l/sMModZKVkK4lVDMeuXDiC4p0/IPijG+PQp1JuWiFvfgGeODbSZNuRl6wB//cg09AM5Hl9ILbCbZOmptVQ+BwiVIxBQW0w2RE7yODOr+LnS/+eEQ2zngjzrSsvxZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719432535; c=relaxed/simple;
	bh=NF+xL51HHjUfRst/WAEgo5m3gzCG0myv/DAjdSBrGfM=;
	h=Date:To:From:Subject:Message-Id; b=P20A3Ytix6O2Phg3MZ8fDgobJGLgGi0Ah2+9aAl1RsBfZc2MaFpAq20sP1RzKkGNvD4VHnWYO2I63wZL7NrfD//3cvORWXIHKaPNCoQuxwgrS2iizIKH+311NAqftedF1KdWzlxazG0F2vJsXDUh4n1BMXBh2LKib0PUkwngTuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LE5Aia+I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LE5Aia+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14EBCC116B1;
	Wed, 26 Jun 2024 20:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719432535;
	bh=NF+xL51HHjUfRst/WAEgo5m3gzCG0myv/DAjdSBrGfM=;
	h=Date:To:From:Subject:From;
	b=LE5Aia+IwmxiEyjmz2efvKwCcLjrLwUUdMypeeUWct+QLF0hUSxbUeucQ35SfarBT
	 bbazdI/4hGSQY1DBYXjhhFXGrYKZu6lhYQUpxdYOaWszzCp0K3IbhcOUm0YDHk6sOZ
	 YPVhsn5sIJGBJseKFqvT60ogXDTXGJEdYQNX9+u8=
Date: Wed, 26 Jun 2024 13:08:54 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,tony.luck@intel.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jiaqiyan@google.com,jglisse@redhat.com,jane.chu@oracle.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,bcrl@kvack.org,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-support-poisoned-recover-from-migrate-folio.patch added to mm-unstable branch
Message-Id: <20240626200855.14EBCC116B1@smtp.kernel.org>
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
Date: Wed, 26 Jun 2024 16:53:26 +0800

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

Note, folio copy is moved in the begin of the __migrate_folio(), which
could simplify the error handling since there is no turning back if
folio_migrate_mapping() return success, the downside is the folio copied
even though folio_migrate_mapping() return fail, an optimization is to
check whether source folio does not have extra refs before we do folio
copy.

Link: https://lkml.kernel.org/r/20240626085328.608006-5-wangkefeng.wang@huawei.com
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

 mm/migrate.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/mm/migrate.c~mm-migrate-support-poisoned-recover-from-migrate-folio
+++ a/mm/migrate.c
@@ -668,16 +668,24 @@ static int __migrate_folio(struct addres
 			   struct folio *src, void *src_private,
 			   enum migrate_mode mode)
 {
-	int rc;
+	int rc, expected_count = folio_expected_refs(mapping, src);
 
-	rc = folio_migrate_mapping(mapping, dst, src, 0);
+	/* Check whether src does not have extra refs before we do more work */
+	if (folio_ref_count(src) != expected_count)
+		return -EAGAIN;
+
+	rc = folio_mc_copy(dst, src);
+	if (unlikely(rc))
+		return rc;
+
+	rc = __folio_migrate_mapping(mapping, dst, src, expected_count);
 	if (rc != MIGRATEPAGE_SUCCESS)
 		return rc;
 
 	if (src_private)
 		folio_attach_private(dst, folio_detach_private(src));
 
-	folio_migrate_copy(dst, src);
+	folio_migrate_flags(dst, src);
 	return MIGRATEPAGE_SUCCESS;
 }
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

fs-proc-task_mmu-use-folio-api-in-pte_is_pinned.patch
mm-remove-page_maybe_dma_pinned.patch
mm-remove-page_maybe_dma_pinned-fix.patch
fb_defio-use-a-folio-in-fb_deferred_io_work.patch
mm-remove-page_mkclean.patch
mm-memory-convert-clear_huge_page-to-folio_zero_user.patch
mm-memory-use-folio-in-struct-copy_subpage_arg.patch
mm-memory-improve-copy_user_large_folio.patch
mm-memory-rename-pages_per_huge_page-to-nr_pages.patch
mm-move-memory_failure_queue-into-copy_mc__highpage.patch
mm-add-folio_mc_copy.patch
mm-migrate-split-folio_migrate_mapping.patch
mm-migrate-support-poisoned-recover-from-migrate-folio.patch
fs-hugetlbfs-support-poisoned-recover-from-hugetlbfs_migrate_folio.patch
mm-migrate-remove-folio_migrate_copy.patch

