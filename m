Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304551FA178
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 20:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741119881; cv=none; b=amjMp4p5zTATKnkA6XnKoRd9ZBLls4cUolljm7RD0xXBEOlw8z3v5v3Kvs3wrBHSW1rF0QOx/T7eAw4pCmzCgD6gJKxNHUnP49XMOPml+XHLIg2P3owomKhN7xcdfhYACYua4i/Sskm9FWA1X4Z02+NPPoIE9nnjHF3YW583N0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741119881; c=relaxed/simple;
	bh=xHfk613d6gV69hQ1SqpwdFOK8ge1M+WyjRYu9/19mtU=;
	h=Date:To:From:Subject:Message-Id; b=RmA845P4IPBwH0aNcQlANGJfnukHLVDDS8DGKLV+R2xajBbWq/TJHFxwBIWzBPHLUqqiXQrZDcp7hmDIytp1G4uvrzkSvBf4zWCNGkHpwTLlI0RYiiRUoH5sowiHo4wwPRiy6TkCbZ6TEUz8I+onYFRNKZOhMd9KMh824u5FqkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C3gQ/N3M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C3gQ/N3M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6D5C4CEE5;
	Tue,  4 Mar 2025 20:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741119879;
	bh=xHfk613d6gV69hQ1SqpwdFOK8ge1M+WyjRYu9/19mtU=;
	h=Date:To:From:Subject:From;
	b=C3gQ/N3MJEYlflhk+rUJ2GKVeLirwALkZtxngA2bzWaPVHUcn9Sh3NqItgajOrbHC
	 pBxAYLipHFY1uZi1SnYOEbNFR9lV+dqfFJ3hNb1JGvMl4ZrT6ERm79bZ3l1O7fBXev
	 NbdcvNRfOHAlfEVjIkjQdvERXYqkVd2y7MLm6zoU=
Date: Tue, 04 Mar 2025 12:24:38 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,sunnanyong@huawei.com,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-surplus-pages-in-dissolve_free_huge_page.patch added to mm-hotfixes-unstable branch
Message-Id: <20250304202439.8A6D5C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix surplus pages in dissolve_free_huge_page()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-fix-surplus-pages-in-dissolve_free_huge_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-surplus-pages-in-dissolve_free_huge_page.patch

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
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm/hugetlb: fix surplus pages in dissolve_free_huge_page()
Date: Tue, 4 Mar 2025 21:21:06 +0800

In dissolve_free_huge_page(), free huge pages are dissolved without
adjusting surplus count. However, free huge pages may be accounted as
surplus pages, and will lead to wrong surplus count.

I reproduce this issue on qemu. The steps are:
1) Node1 is memory-less at first. Hot-add memory to node1 by executing
the two commands in qemu monitor:
  object_add memory-backend-ram,id=mem1,size=1G
  device_add pc-dimm,id=dimm1,memdev=mem1,node=1
2) online one memory block of Node1 with：
  echo online_movable > /sys/devices/system/node/node1/memoryX/state
3) create 64 huge pages for node1
4) run a program to reserve (don't consume) all the huge pages
5) echo 0 > nr_huge_pages for node1. After this step, free huge pages in
Node1 are surplus.
6) create 80 huge pages for node0
7) offline memory of node1, The memory range to offline contains the free
surplus huge pages created in step3) ~ step5)
  echo offline > /sys/devices/system/node/node1/memoryX/state
8) kill the program in step 4)

The result:
           Node0     Node1
total       80        0
free        80        0
surplus     0         61

To fix it, adjust surplus when destroying huge pages if the node has
surplus pages in dissolve_free_hugetlb_folio().

The result with this patch:
           Node0     Node1
total       80        0
free        80        0
surplus     0         0

Link: https://lkml.kernel.org/r/20250304132106.2872754-1-tujinjiang@huawei.com
Fixes: c8721bbbdd36 ("mm: memory-hotplug: enable memory hotplug to handle hugepage")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-surplus-pages-in-dissolve_free_huge_page
+++ a/mm/hugetlb.c
@@ -2135,6 +2135,8 @@ retry:
 
 	if (!folio_ref_count(folio)) {
 		struct hstate *h = folio_hstate(folio);
+		bool adjust_surplus = false;
+
 		if (!available_huge_pages(h))
 			goto out;
 
@@ -2157,7 +2159,9 @@ retry:
 			goto retry;
 		}
 
-		remove_hugetlb_folio(h, folio, false);
+		if (h->surplus_huge_pages_node[folio_nid(folio)])
+			adjust_surplus = true;
+		remove_hugetlb_folio(h, folio, adjust_surplus);
 		h->max_huge_pages--;
 		spin_unlock_irq(&hugetlb_lock);
 
@@ -2177,7 +2181,7 @@ retry:
 			rc = hugetlb_vmemmap_restore_folio(h, folio);
 			if (rc) {
 				spin_lock_irq(&hugetlb_lock);
-				add_hugetlb_folio(h, folio, false);
+				add_hugetlb_folio(h, folio, adjust_surplus);
 				h->max_huge_pages++;
 				goto out;
 			}
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-hugetlb-fix-surplus-pages-in-dissolve_free_huge_page.patch
mm-hugetlb-fix-set_max_huge_pages-when-there-are-surplus-pages.patch

