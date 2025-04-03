Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E927C18732B
	for <mm-commits@vger.kernel.org>; Thu,  3 Apr 2025 07:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743663937; cv=none; b=smw4edak4dnqSI5E8bXBQAXKfCfGsMhCDwowTQJVkKGlAkDeCAVoRc7Z9PJBKAhuE4VDW4A+mb3QKH+unGhAfMh1YFpiFFjemMSSXvwKPZw0kRMK1KLGSx3wmt+kaJNZDFsXZ3Exvx9iD5oafyES7e8NnXa7RxbaHYkq33v5m/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743663937; c=relaxed/simple;
	bh=zO6M1Ke+5u/SrDoxyEzXFoGpfvL/M6igy2Fob1aJvyU=;
	h=Date:To:From:Subject:Message-Id; b=S/aXcOsaZ/2AmIP+d3R1xYbFVeYFhusAQmKCAhEc1ScUcKSgJWc+5qW6KDYksPkj4UGsVlOUEK6P6Iqjf2hbqa064e3QxrbFS6ZaED1eA5pxEONNWquXkcrsXbnkRA9yZs/aes877On5q2X430sOUDn+H7gezbjXQiwqQhw6PzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ag0gQa+K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ag0gQa+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60642C4CEE3;
	Thu,  3 Apr 2025 07:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743663936;
	bh=zO6M1Ke+5u/SrDoxyEzXFoGpfvL/M6igy2Fob1aJvyU=;
	h=Date:To:From:Subject:From;
	b=Ag0gQa+K5v43prJVhzkwt5ma9ZGstKARnEMpQo1KD2pw560vtuI/9udMpismb3AQG
	 jdygS9rs4DGalCTjFwNmfOapY0SqwGwUZe6NnAGuygGpE/E772melQTb+K+AaJkq/J
	 9YYiLFx03U/HFIK6Fq0rU4hwAQ0RyWMlYfJfrPxk=
Date: Thu, 03 Apr 2025 00:05:35 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,sunnanyong@huawei.com,muchun.song@linux.dev,david@redhat.com,liushixin2@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-nid-mismatch-in-alloc_surplus_hugetlb_folio.patch added to mm-hotfixes-unstable branch
Message-Id: <20250403070536.60642C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix nid mismatch in alloc_surplus_hugetlb_folio()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-fix-nid-mismatch-in-alloc_surplus_hugetlb_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-nid-mismatch-in-alloc_surplus_hugetlb_folio.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/hugetlb: fix nid mismatch in alloc_surplus_hugetlb_folio()
Date: Thu, 3 Apr 2025 14:41:38 +0800

It's wrong to use nid directly since the nid may be changed in allocation.
Use folio_nid() to obtain the nid of folio instead.

Fix: 2273dea6b1e1 ("mm/hugetlb: update nr_huge_pages and surplus_huge_pages together")
Link: https://lkml.kernel.org/r/20250403064138.2867929-1-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-nid-mismatch-in-alloc_surplus_hugetlb_folio
+++ a/mm/hugetlb.c
@@ -2271,7 +2271,7 @@ static struct folio *alloc_surplus_huget
 	 * as surplus_pages, otherwise it might confuse
 	 * persistent_huge_pages() momentarily.
 	 */
-	__prep_account_new_huge_page(h, nid);
+	__prep_account_new_huge_page(h, folio_nid(folio));
 
 	/*
 	 * We could have raced with the pool size change.
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-hugetlb-fix-nid-mismatch-in-alloc_surplus_hugetlb_folio.patch

