Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794270252;
	b=W/4Q91jmHRJuyMk4JcD5XWTvXfpFLon9kVy/H5X6HGvJc8d7hAJZfpznuclqB1wQbyYN
	 Y+WSOGMeTQuRL9QTyjnkywf2rA/TetxS7HiRFiNjqM1e/C2kisacF1f5pG62PZJgxLBC9
	 u/eNkJrVnvbcWO5I7ZfdwFROOvwO/TW18E6Wy+zjYfJ438RujCfdmuw1VTh8fGfHJCKMu
	 F9WEM8EtCxS8tkSQQRJiAFk4nPrNdMEkw/N31gbUA0rxG52fHhknqgSc06VqukSQo2+1B
	 kHWb/hfd6X+BagM8TMhN1c3jHLwC8kZrkgYAF0f1+aII/tatLA33RNR1DQBO/EKj1BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794270252;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=tEk5w1snQzn2m0CE5CWXxUZ1b1YeqEXu6k5gNjalTag=;
	b=UGXdhkgIn0LSz86NSWOKI85/RqCx9a77NAgVhZXbzCm+RoXvob8uPua8OzewSs6gW26g
	 sLoOYtnU/oTGrBh3v1t4ga3QsYuV9hOJGpL8tyDrf07RpbNm4Hhj/nuwXffl9okNuMzUf
	 AjNLk0ybnr96oSCs6vaD2965/LdscEOyoorDdGouCAU43ia7FGVT1nHeu8tSgNuf5qOil
	 r/nro/eS9Bv53jScsGO66CofmyTL3scxlMkFjW0xYgF+7NVbkNi6rIhbVp68a7swSPe1Y
	 MVH1suYCeuVcUe4+DYqebXr7Mc0WyqBDUOf5qd4kwknOb2MZWuvaVLgbrZB9z76OtwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eL97MSOo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77960606A321
	for <mm-commits@vger.kernel.org>; Tue, 10 Nov 2026 00:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eL97MSOo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289861F008A1;
	Tue, 10 Nov 2026 00:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794270252;
	bh=tEk5w1snQzn2m0CE5CWXxUZ1b1YeqEXu6k5gNjalTag=;
	h=Date:To:From:Subject;
	b=eL97MSOoBN3klQs2IObnH0UM/RU1VDLqrYc05TWvnQxck8yYHTT/Z0I74CuDDT/GV
	 6RTlF1nqxIg7E3PIev5K6KW2RbfXnXZZSgURDczKB52sH9VfEle65IsOFhc4Ef5r2V
	 lIoQwfC98LYgX9A3sPPpBAmxsbal3BqW0qAuLbt0=
Date: Mon, 09 Nov 2026 16:24:11 -0800
To: mm-commits@vger.kernel.org,chengkaitao@kylinos.cn,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-nr_hugetlb-accounting-for-unused-surplus-folios.patch added to mm-unstable branch
Message-Id: <20261110002412.289861F008A1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/hugetlb: fix NR_HUGETLB accounting for unused surplus folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-fix-nr_hugetlb-accounting-for-unused-surplus-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-nr_hugetlb-accounting-for-unused-surplus-folios.patch

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
From: Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: mm/hugetlb: fix NR_HUGETLB accounting for unused surplus folios
Date: Fri, 06 Nov 2026 18:05:20 +0800

free_huge_folio() unconditionally decrements NR_HUGETLB, but freshly
allocated surplus folios can be freed before the counter has been
incremented.

This happens when alloc_surplus_hugetlb_folio() rejects a fresh folio
after its second surplus limit check. It also happens when
gather_surplus_pages() frees folios because a reservation cannot be
satisfied, or because concurrent pool changes leave excess folios
after the reservation succeeds.

These paths leave unmatched decrements, causing HugeTLB usage to be
underreported and potentially underflowing the counter.

Increment NR_HUGETLB before calling free_huge_folio() in both paths
to balance its unconditional decrement.

Link: https://lore.kernel.org/20261106100521.30099-4-kaitao.cheng@linux.dev
Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://sashiko.dev/#/bug/linux-860a3b8f-0b07-4cd5-a122-aa2288463bee
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Mani Tofigh <mt4022@columbia.edu>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
---

 mm/hugetlb.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-nr_hugetlb-accounting-for-unused-surplus-folios
+++ a/mm/hugetlb.c
@@ -2133,6 +2133,8 @@ static struct folio *alloc_surplus_huget
 	if (h->surplus_huge_pages >= h->nr_overcommit_huge_pages) {
 		folio_set_hugetlb_temporary(folio);
 		spin_unlock_irq(&hugetlb_lock);
+		/* Balance the NR_HUGETLB decrement in free_huge_folio(). */
+		lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
 		free_huge_folio(folio);
 		return NULL;
 	}
@@ -2377,9 +2379,13 @@ free:
 	/*
 	 * Free unnecessary surplus pages to the buddy allocator.
 	 * Pages have no ref count, call free_huge_folio directly.
+	 * These pages were not accounted in NR_HUGETLB, so balance the
+	 * decrement in free_huge_folio().
 	 */
-	list_for_each_entry_safe(folio, tmp, &surplus_list, lru)
+	list_for_each_entry_safe(folio, tmp, &surplus_list, lru) {
+		lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
 		free_huge_folio(folio);
+	}
 	spin_lock_irq(&hugetlb_lock);
 
 	return ret;
_

Patches currently in -mm which might be from chengkaitao@kylinos.cn are

mm-hugetlb_cma-fix-incorrect-hugetlb_cma_size-assignment-on-malformed-input.patch
mm-hugetlb-preserve-persistent-flags-when-returning-folios-to-the-pool.patch
mm-hugetlb-fix-nr_hugetlb-accounting-for-unused-surplus-folios.patch
mm-hugetlb-account-nr_hugetlb-at-folio-state-transitions.patch

