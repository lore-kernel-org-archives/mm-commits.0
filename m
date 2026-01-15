Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECF22E090B
	for <mm-commits@vger.kernel.org>; Thu, 15 Jan 2026 22:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768516959; cv=none; b=XiMSalsNebdMXvjdQ35DsI8KeULFcSpeUEm9l1H7eD5ONNR2yr/bIBqVzZ0jH6E/8uagRI5ye1wmqxAynkxnEPW8CosXs13dKsHQ87qYXtgyietnFZr58QjoPM7FpPQGRSQ9ml8Za/ykAn0MOor9E/UpGrR2J/JB0i9bX52x/Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768516959; c=relaxed/simple;
	bh=du1rDA5wxRFXITnSmxVH+yLfZy9e8uLJk2km2gI3hyY=;
	h=Date:To:From:Subject:Message-Id; b=ibNi1x0Lz8Zcgv+ftPHiVMW1RAearNYrPivX4hLZ8at2WRjblgHVAe5LOc+0neBDZ6mplJH4OxcQi6bQAQ8SnKkM0+3/Nn2cOUWhernOixDpLn8BKq24/YCs3qWdqSSZZwHQb+lECxTevIdxRkoRZIlmA7mTjoWh6k1au5UHf74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TMLKt0Ji; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TMLKt0Ji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1882EC116D0;
	Thu, 15 Jan 2026 22:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768516959;
	bh=du1rDA5wxRFXITnSmxVH+yLfZy9e8uLJk2km2gI3hyY=;
	h=Date:To:From:Subject:From;
	b=TMLKt0JihuT18j/5oJWfJZPtH2Zw9plV+0nrPgq5Mp7b+vEck2VmPHhr6AuL4dRcd
	 Y/JRWCWJzJ91Q7swj8wMg1dsAdIi2l2HCYzqsuP/pZA24Zy08pkEJsjWdej4CD+XvW
	 +K07EQ/LyxXA974uiqQQ8rC9Zi9Is/fqZfG39Bjg=
Date: Thu, 15 Jan 2026 14:42:38 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,wangkefeng.wang@huawei.com,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-optimize-replace_free_hugepage_folios-v2-fix.patch added to mm-unstable branch
Message-Id: <20260115224239.1882EC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-hugetlb-optimize-replace_free_hugepage_folios-v2-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-optimize-replace_free_hugepage_folios-v2-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-optimize-replace_free_hugepage_folios-v2-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-optimize-replace_free_hugepage_folios-v2-fix
Date: Thu Jan 15 02:34:07 PM PST 2026

use single-return-point style, tweak comment

Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-optimize-replace_free_hugepage_folios-v2-fix
+++ a/mm/hugetlb.c
@@ -2834,10 +2834,15 @@ int replace_free_hugepage_folios(unsigne
 
 			nr = folio_nr_pages(folio) - folio_page_idx(folio, page);
 
-			/* Not to disrupt normal path by vainly holding hugetlb_lock */
+			/*
+			 * Don't disrupt normal path by vainly holding
+			 * hugetlb_lock
+			 */
 			if (folio_test_hugetlb(folio) && !folio_ref_count(folio)) {
-				if (order_is_gigantic(folio_order(folio)))
-					return -ENOMEM;
+				if (order_is_gigantic(folio_order(folio))) {
+					ret = -ENOMEM;
+					break;
+				}
 
 				ret = alloc_and_dissolve_hugetlb_folio(folio, &list);
 				if (ret)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-basic-tests-for-lazy_mmu-fix.patch
mm-vmscanc-shrink_folio_list-save-a-tabstop.patch
mm-block-fs-remove-laptop_mode-fix.patch
mm-fix-minor-spelling-mistakes-in-comments-fix.patch
memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch
mm-hugetlb-optimize-replace_free_hugepage_folios-v2-fix.patch
mm-memcontrol-eliminate-the-problem-of-dying-memory-cgroup-for-lru-folios-fix.patch
mm-hugetlb-enforce-brace-style-checkpatch-fixes.patch
kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup-fix.patch
list-add-primitives-for-private-list-manipulations-fix.patch
init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning-fix.patch
panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu-checkpatch-fixes.patch

