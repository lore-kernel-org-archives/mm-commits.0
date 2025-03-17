Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE2417583
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 00:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742172070; cv=none; b=c8Q3AOic+H+qyt5R0NFCefMuluQ/spMH4sRlhk3hy7b4OD3Oi9J91/tr3em8yPyB0NdyTI/w6AzrzrfJ9tMrvV3T+lL+PuRpV+iC1WIcD4Vl9ae2tvNxShjxqjCzqeV+hDwrAzLBwCf/ZNRS9ZBP771KrS6dYZcMJRraUusmx4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742172070; c=relaxed/simple;
	bh=C3WKaEnCMBC/DUDcmXh6jcB6y0PKznj4OztKlpD6bzU=;
	h=Date:To:From:Subject:Message-Id; b=Nw1UW005WHwW3HUxi59ly4ee9UEzlnlgHeiRfFAzxnkAO5/5qg3rQgCj3nOv7iXVTDWqIP+jbrnRnKk3aMaWWF/gkCCc1ZInx/8NR5uRrKpubt0rT1dr3kKArxc0wsg84Urmkh4m9Sl8YMWKRSVXa4rVn40Wpbd6kZd/4fptLDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N0Id8Yqd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N0Id8Yqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D101C4CEDD;
	Mon, 17 Mar 2025 00:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742172070;
	bh=C3WKaEnCMBC/DUDcmXh6jcB6y0PKznj4OztKlpD6bzU=;
	h=Date:To:From:Subject:From;
	b=N0Id8Yqdhc3TOlqxjrkarZXv6hsSyZJDKlKbhwp9QHkwG6IAsIhJsk2ps1AlJqA2X
	 3io4MEa0f7y40jOmVgGMz4oJraIapGo8j1+p9FwSsXxBHl76vxk2bNJGpeJEHnVMiQ
	 BiX8wyQdVnPI97z2qVc3Lt7cRRKdf6PlmX0NvrqQ=
Date: Sun, 16 Mar 2025 17:41:09 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,sunnanyong@huawei.com,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-fix-surplus-pages-in-dissolve_free_huge_page.patch removed from -mm tree
Message-Id: <20250317004110.4D101C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: fix surplus pages in dissolve_free_huge_page()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-surplus-pages-in-dissolve_free_huge_page.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nanyong Sun <sunnanyong@huawei.com>
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

mm-contig_alloc-fix-alloc_contig_range-when-__gfp_comp-and-order-max_order.patch
mm-hugetlb-fix-set_max_huge_pages-when-there-are-surplus-pages.patch

