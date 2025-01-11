Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE40942A8F
	for <mm-commits@vger.kernel.org>; Sat, 11 Jan 2025 01:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736559945; cv=none; b=d6q9RS1bKX+3fZECzlIUhgCA45jrVEJf60tcut4MVOZyUZ6uqWtdT1H+PRBEtFDovwZL+4AQTqZrqBIVScbFfRf54WWLcs8JHnoZ0rU8wQkk30IRVY6uNCCw/yxfWwKlVQWpmUrUREfvizdIGd3YAvOhYDGz4+ylDItPv5yTKmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736559945; c=relaxed/simple;
	bh=94wkZcMXJa0TcO17lFFo0JwTGNDTQPMcfIUB0Ma8Bq4=;
	h=Date:To:From:Subject:Message-Id; b=RVptTWWga71r6KZhzlvMp/LI9qhNzMZjiXi3P/aoIVO2s0ccIwI2R9fHFsnTcj2kA3cJQbP4RvqEwmfL0FvHMNjch4Eb4YtGSMn8aJv1lfMEL7G63RmcwB0DFHBkbhg3I3BzIHzGjT2GZoqm/Aho4vru+V7Z0o2AAyFEVord8pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=amHo4LZn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="amHo4LZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDE5C4CED6;
	Sat, 11 Jan 2025 01:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736559945;
	bh=94wkZcMXJa0TcO17lFFo0JwTGNDTQPMcfIUB0Ma8Bq4=;
	h=Date:To:From:Subject:From;
	b=amHo4LZnOFRuqGV3PCSlnPuNlrtfycAiV6cA23tSvBfBlz1WRWjdE/RReVsSIZk43
	 1JHYG4ULGAL7//b7DPulTaKQlbeGfg6BLrpBgq8bHQ5cQHmZT39ygFv0ylnFycvVBt
	 iB2XX+r85EJiStd0H6f9wTIxMZi/0OsBaOJuMLa4=
Date: Fri, 10 Jan 2025 17:45:44 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,muchun.song@linux.dev,david@redhat.com,baolin.wang@linux.alibaba.com,yangge1116@126.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + replace-free-hugepage-folios-after-migration-fix-3.patch added to mm-unstable branch
Message-Id: <20250111014545.2EDE5C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: prevent reuse of isolated free hugepages
has been added to the -mm mm-unstable branch.  Its filename is
     replace-free-hugepage-folios-after-migration-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/replace-free-hugepage-folios-after-migration-fix-3.patch

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

replace-free-hugepage-folios-after-migration.patch
replace-free-hugepage-folios-after-migration-fix-3.patch
mm-compaction-skip-memory-compaction-when-there-are-not-enough-migratable-pages.patch

