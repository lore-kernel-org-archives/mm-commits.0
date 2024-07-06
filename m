Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7411E4C3D0
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 18:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720292031; cv=none; b=UkFkMyIZ0z1Om7dElHlHcODRR3Obi5EwFXcRednGwae5KTxac19HyVySwzgFcZ8j++HI++G3l1H5qUPZuPoEsCkweb9/vCCan1YJE9qoJE4fk0tdX1U75F3+rLwQMATL9F4cUy+aHvETpwVjhy9sJWUXcLYOxcR3fo/QibXbW3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720292031; c=relaxed/simple;
	bh=Ba9hv+gPTjA6SkInyc65H+7M8hYOnJCg8wAmZmlq4O4=;
	h=Date:To:From:Subject:Message-Id; b=Mk1JltZPiFKw3Xrt6dch+xoNzs8gIT9e3XXmUoCkE/qc5X7XcjShWP/P5gH3cNQVb0ro7ARf1S+p0ffBvIQSCcHMq9yomFpG2N++CU5spGl68n7MfthkhW6FS4U4TKvct2Ou7dt118vKboqe4fcZVw9B+e+7fLN0axm5pY0lAcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P/zsL255; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P/zsL255"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40EB6C2BD10;
	Sat,  6 Jul 2024 18:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720292031;
	bh=Ba9hv+gPTjA6SkInyc65H+7M8hYOnJCg8wAmZmlq4O4=;
	h=Date:To:From:Subject:From;
	b=P/zsL255rO82fu+uaQGVBo7MclPXMBrEAWvkIUxS9LjYJWRsIfIh112z7PiWqqQZT
	 hgeIz44KTm/XgD7VOeG0FBqT0nu/h6LxprJpL0n87Afz8a5GWiV52IDjAcmdenOqXF
	 RD6M18DSWuihAztmhBpJog1ZoVC0BzeDqVxm6c6Y=
Date: Sat, 06 Jul 2024 11:53:50 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,tony.luck@intel.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jiaqiyan@google.com,jglisse@redhat.com,jane.chu@oracle.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,bcrl@kvack.org,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-support-poisoned-recover-from-migrate-folio.patch removed from -mm tree
Message-Id: <20240706185351.40EB6C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: migrate: support poisoned recover from migrate folio
has been removed from the -mm tree.  Its filename was
     mm-migrate-support-poisoned-recover-from-migrate-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -681,16 +681,24 @@ static int __migrate_folio(struct addres
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


