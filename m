Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0884C3D0
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 18:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720292034; cv=none; b=ponROfuHxcCqqnQuPDFYA2m+QKMTSvC9Y7QY4LWsNZpSTON7UC3hrrwVZOh6beld2WXxo7tbLiBDWQX9PzfnZ3LeL6IbgtaO+Z6ARmw610faxH42GVMNrFkvLuDRqNwu0YuTK9Pgxi7r9bT76UgTQpUGFJZ3/HyLLPR6Q7cmD88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720292034; c=relaxed/simple;
	bh=KIlOdySlUDTLLRWaaI5bl7I709eydelIFdFkLQHRPGM=;
	h=Date:To:From:Subject:Message-Id; b=lZkb9W3ksbDzGJ3B3xHqf2rwTh3YU1NdAnCxYQgRu+qV/QiXd2QG2V9PR2aPTbwfoWdmitI3QTClTODANHSXQxZFE++wR6oX8HsA9CUjRGrgVtl/sxFuhTDgaZ+IB2KZSY+8Z3QPlmzpwXdpswr0OekYyCx/vIt6WFKmCXSmtVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KPczwEYP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KPczwEYP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFDECC2BD10;
	Sat,  6 Jul 2024 18:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720292034;
	bh=KIlOdySlUDTLLRWaaI5bl7I709eydelIFdFkLQHRPGM=;
	h=Date:To:From:Subject:From;
	b=KPczwEYP5/crOzYtWhrUbFk+FGm6ZhhXVD1nuR1uhKtv56zfn9vd2k2OwpXPhgc5Y
	 ag3z6rXBug6mNCowJK4gIKNpYbV0o0hyRfsRXEmGQW+0zdTiqoVmINOjB3gkYPSUUB
	 X3XYhi5auDDhBGzBMduntjo55eBQu+uLkyqWjtAk=
Date: Sat, 06 Jul 2024 11:53:53 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,tony.luck@intel.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jiaqiyan@google.com,jglisse@redhat.com,jane.chu@oracle.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,bcrl@kvack.org,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-remove-folio_migrate_copy.patch removed from -mm tree
Message-Id: <20240706185353.DFDECC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: migrate: remove folio_migrate_copy()
has been removed from the -mm tree.  Its filename was
     mm-migrate-remove-folio_migrate_copy.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: migrate: remove folio_migrate_copy()
Date: Wed, 26 Jun 2024 16:53:28 +0800

The folio_migrate_copy() is just a wrapper of folio_copy() and
folio_migrate_flags(), it is simple and only aio use it for now, unfold it
and remove folio_migrate_copy().

Link: https://lkml.kernel.org/r/20240626085328.608006-7-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
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

 fs/aio.c                |    3 ++-
 include/linux/migrate.h |    1 -
 mm/migrate.c            |    7 -------
 3 files changed, 2 insertions(+), 9 deletions(-)

--- a/fs/aio.c~mm-migrate-remove-folio_migrate_copy
+++ a/fs/aio.c
@@ -455,7 +455,8 @@ static int aio_migrate_folio(struct addr
 	 * events from being lost.
 	 */
 	spin_lock_irqsave(&ctx->completion_lock, flags);
-	folio_migrate_copy(dst, src);
+	folio_copy(dst, src);
+	folio_migrate_flags(dst, src);
 	BUG_ON(ctx->ring_folios[idx] != src);
 	ctx->ring_folios[idx] = dst;
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
--- a/include/linux/migrate.h~mm-migrate-remove-folio_migrate_copy
+++ a/include/linux/migrate.h
@@ -76,7 +76,6 @@ int migrate_huge_page_move_mapping(struc
 void migration_entry_wait_on_locked(swp_entry_t entry, spinlock_t *ptl)
 		__releases(ptl);
 void folio_migrate_flags(struct folio *newfolio, struct folio *folio);
-void folio_migrate_copy(struct folio *newfolio, struct folio *folio);
 int folio_migrate_mapping(struct address_space *mapping,
 		struct folio *newfolio, struct folio *folio, int extra_count);
 
--- a/mm/migrate.c~mm-migrate-remove-folio_migrate_copy
+++ a/mm/migrate.c
@@ -672,13 +672,6 @@ void folio_migrate_flags(struct folio *n
 }
 EXPORT_SYMBOL(folio_migrate_flags);
 
-void folio_migrate_copy(struct folio *newfolio, struct folio *folio)
-{
-	folio_copy(newfolio, folio);
-	folio_migrate_flags(newfolio, folio);
-}
-EXPORT_SYMBOL(folio_migrate_copy);
-
 /************************************************************
  *                    Migration functions
  ***********************************************************/
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


