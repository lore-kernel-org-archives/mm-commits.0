Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FFE632
	for <mm-commits@vger.kernel.org>; Sun, 12 Jan 2025 05:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736659786; cv=none; b=UYAEHnaIa4mfGT3trSQyYNEsM+KAsq6UIQ0MYunak+mTqGmJ20HD55ysJx9e1n8Fp2KZFI/59cjPEhQZRUCXIxRVUAU65/Y0Q5IWPoelxUsomVc88i4But9ONjJdFhtnLbGKl7EaDU6WPhLz01CUDOuwKbQge1CEPiA3Aaa++YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736659786; c=relaxed/simple;
	bh=8YwGEUWdDll5wda3glxo/WbAvoL7LBXZwddOm/65uU4=;
	h=Date:To:From:Subject:Message-Id; b=KSc8H/T24vYVpZJhZ6TAweaz4XOU9TG/Ls7YIEsZQ3NW5gSFXQXnLFVG8qJeXpWzMdcz0un9WUUPvsWCua7b7ebnYbRCYTAX0TNmajymbR1xB7+1wV11xWb2Jjuxdb8CiS3+SQ3utd1Qt0fgqEXROjuBNDYJq7XJtkUWCIpNUPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aJlLH/CS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aJlLH/CS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1D3C4CEE0;
	Sun, 12 Jan 2025 05:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736659786;
	bh=8YwGEUWdDll5wda3glxo/WbAvoL7LBXZwddOm/65uU4=;
	h=Date:To:From:Subject:From;
	b=aJlLH/CShjkvtOWdGgPMpAQ34RFnaNqIPgSqT3P6tcGH1c86TaoPJRj7ajjD34ZLf
	 B+O1qW9g5dhbETW6MqtEooxxMxy3tnGu1fPeswlg9S0EIa6TuJd6pU3UrOb8o9Iebh
	 Bc9j9mK3+0czAPN1BHnOZEkhO30OY93sNu+PkBlA=
Date: Sat, 11 Jan 2025 21:29:45 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,muchun.song@linux.dev,david@redhat.com,baolin.wang@linux.alibaba.com,yangge1116@126.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] replace-free-hugepage-folios-after-migration-fix-3.patch removed from -mm tree
Message-Id: <20250112052946.1B1D3C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: prevent reuse of isolated free hugepages
has been removed from the -mm tree.  Its filename was
     replace-free-hugepage-folios-after-migration-fix-3.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: yangge <yangge1116@126.com>
Subject: mm/hugetlb: prevent reuse of isolated free hugepages
Date: Fri, 10 Jan 2025 10:56:06 +0800

When there are free hugetlb folios in the hugetlb pool, during the
migration of in-use hugetlb folios, new folios is allocated from the free
hugetlb pool.  After the migration is completed, the old folios are
released back to the free hugetlb pool.  However, after the old folios are
released to the free hugetlb pool, they may be reallocated.  When
replace_free_hugepage_folios() is executed later, it cannot release these
old folios back to the buddy system.

As discussed with David in [1], when alloc_contig_range() is used to
migrate multiple in-use hugetlb pages, it can lead to the issue described
above.  For example:

[huge 0] [huge 1]

To migrate huge 0, we obtain huge x from the pool.  After the migration is
completed, we return the now-freed huge 0 back to the pool.  When it's
time to migrate huge 1, we can simply reuse the now-freed huge 0 from the
pool.  As a result, when replace_free_hugepage_folios() is executed, it
cannot release huge 0 back to the buddy system.

To solve the problem above, we should prevent reuse of isolated free
hugepages.

Link: https://lore.kernel.org/lkml/1734503588-16254-1-git-send-email-yangge1116@126.com/
Link: https://lkml.kernel.org/r/1736477766-23525-1-git-send-email-yangge1116@126.com
Fixes: 08d312ee4c0a ("mm: replace free hugepage folios after migration")
Signed-off-by: yangge <yangge1116@126.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/hugetlb.c~replace-free-hugepage-folios-after-migration-fix-3
+++ a/mm/hugetlb.c
@@ -48,6 +48,7 @@
 #include <linux/page_owner.h>
 #include "internal.h"
 #include "hugetlb_vmemmap.h"
+#include <linux/page-isolation.h>
 
 int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
@@ -1336,6 +1337,9 @@ static struct folio *dequeue_hugetlb_fol
 		if (folio_test_hwpoison(folio))
 			continue;
 
+		if (is_migrate_isolate_page(&folio->page))
+			continue;
+
 		list_move(&folio->lru, &h->hugepage_activelist);
 		folio_ref_unfreeze(folio, 1);
 		folio_clear_hugetlb_freed(folio);
_

Patches currently in -mm which might be from yangge1116@126.com are

mm-replace-free-hugepage-folios-after-migration.patch
mm-compaction-skip-memory-compaction-when-there-are-not-enough-migratable-pages.patch

