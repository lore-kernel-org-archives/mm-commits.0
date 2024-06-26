Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A539D190686
	for <mm-commits@vger.kernel.org>; Wed, 26 Jun 2024 20:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719432536; cv=none; b=MErhO2wsTDCO0LiL3iOsHgP8hu5S8ABUb+4zrP4ko7qA5SWFqwA8yeTuJSuFcyTtgLb+VShdXxgAeDSA0LYh4dVLjOd5aukoAGFLjsMu4lsziMT/9LonX1zQuXUGo58SwBk8arDr9+KPdbGY8U9Ii7dSc7rjP+DW1De0mo/nieo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719432536; c=relaxed/simple;
	bh=65MoGF0nWlfWTd4yP7uah4nBvajbRNzo61l7v/q8Rtg=;
	h=Date:To:From:Subject:Message-Id; b=fxBDzuZY+iXz3H54Y019nG9N3Dzqhq8KT1N0dwGRJN6XK+TM7YxOwWsZgUWzeifWGl9zOqEaGRwD6JIMtvY8m7rQ/wKGPJeO6AT9d2NP2S/nyJwRB2NAOn/q62cam3QZ5ybc6QdowiSZyrEQnhFJzOTgt22r7zl0XeGX68X5WC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PTdHKLJ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PTdHKLJ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F11EC116B1;
	Wed, 26 Jun 2024 20:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719432536;
	bh=65MoGF0nWlfWTd4yP7uah4nBvajbRNzo61l7v/q8Rtg=;
	h=Date:To:From:Subject:From;
	b=PTdHKLJ7sE0Wq0m7OTbea4zqQDJUqce1SyibxV3AIcJvLJL5b7+TwxPcmEB4mZ3nx
	 MaNgnHlww8XayKbWmaDPzS/ODezyedGeVbNXu0txQMPBjxg7I9fp8UVmOw82BJOtGZ
	 yk4MB7jzA6ZAuCWP+00hmOlQ50vMTNljCGV4sYWM=
Date: Wed, 26 Jun 2024 13:08:55 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,tony.luck@intel.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jiaqiyan@google.com,jglisse@redhat.com,jane.chu@oracle.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,bcrl@kvack.org,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-hugetlbfs-support-poisoned-recover-from-hugetlbfs_migrate_folio.patch added to mm-unstable branch
Message-Id: <20240626200856.6F11EC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs: hugetlbfs: support poisoned recover from hugetlbfs_migrate_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     fs-hugetlbfs-support-poisoned-recover-from-hugetlbfs_migrate_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-hugetlbfs-support-poisoned-recover-from-hugetlbfs_migrate_folio.patch

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
Subject: fs: hugetlbfs: support poisoned recover from hugetlbfs_migrate_folio()
Date: Wed, 26 Jun 2024 16:53:27 +0800

This is similar to __migrate_folio(), use folio_mc_copy() in HugeTLB folio
migration to avoid panic when copy from poisoned folio.

Link: https://lkml.kernel.org/r/20240626085328.608006-6-wangkefeng.wang@huawei.com
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
 mm/migrate.c         |   10 ++++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/fs/hugetlbfs/inode.c~fs-hugetlbfs-support-poisoned-recover-from-hugetlbfs_migrate_folio
+++ a/fs/hugetlbfs/inode.c
@@ -1128,7 +1128,7 @@ static int hugetlbfs_migrate_folio(struc
 		hugetlb_set_folio_subpool(src, NULL);
 	}
 
-	folio_migrate_copy(dst, src);
+	folio_migrate_flags(dst, src);
 
 	return MIGRATEPAGE_SUCCESS;
 }
--- a/mm/migrate.c~fs-hugetlbfs-support-poisoned-recover-from-hugetlbfs_migrate_folio
+++ a/mm/migrate.c
@@ -537,10 +537,16 @@ int migrate_huge_page_move_mapping(struc
 				   struct folio *dst, struct folio *src)
 {
 	XA_STATE(xas, &mapping->i_pages, folio_index(src));
-	int expected_count;
+	int rc, expected_count = folio_expected_refs(mapping, src);
+
+	if (folio_ref_count(src) != expected_count)
+		return -EAGAIN;
+
+	rc = folio_mc_copy(dst, src);
+	if (unlikely(rc))
+		return rc;
 
 	xas_lock_irq(&xas);
-	expected_count = folio_expected_refs(mapping, src);
 	if (!folio_ref_freeze(src, expected_count)) {
 		xas_unlock_irq(&xas);
 		return -EAGAIN;
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

