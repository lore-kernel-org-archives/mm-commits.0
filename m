Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022081C69D
	for <mm-commits@vger.kernel.org>; Thu,  4 Sep 2025 00:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756944693; cv=none; b=uhJmyemSJ7eYGnt9+OtDu5ImAZOp+0Vq/G10xUSmgCYWceYMwIrgM1lCOO66yWi0EoeCCAJ+Jqfq4YA4Aw90ft5BjFX8R0Uv0eVq0VzJoaxZnsjy7mvqQZazOkbZ9F6ug9/YdyflRbWXa40OThu0p/stRsGRLduD/z3LDD592lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756944693; c=relaxed/simple;
	bh=YXPChBL3Yc3IWEtzSIZV3xuir8srJGspHPBdg4bupW0=;
	h=Date:To:From:Subject:Message-Id; b=D6tYtI7aqdRWjMtOdZWAl28VAxpwytYPn2sXBoeCn66NlNsLgeWtvQBDneDmjzwmoIZVtfhXjufC1GIp5FPpq2ZCh7vVO6IpO7o+VgFG3DoIR2IJJtpmrQo4IL0cUZLbiHmg3JwDCXQStITAv234Uamkjl6uNifnr0Gmp8IVCD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VpzkQjNb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VpzkQjNb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B61CC4CEE7;
	Thu,  4 Sep 2025 00:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756944692;
	bh=YXPChBL3Yc3IWEtzSIZV3xuir8srJGspHPBdg4bupW0=;
	h=Date:To:From:Subject:From;
	b=VpzkQjNbZA1D6+/LsLfHX41px6rQ2kvrxi24XA9XIRR0Z576l5/L2FbbBEh7FEOvE
	 qc7dU2V/pEW/mjJvNFNfNadsZgbzyo8WkxxzS7T9lWPnEuGJxQk8SsdcsgvMvlUM6q
	 kQuXg/37nhqD+O+S57NxBI32Zjki0Fof2JSasBRM=
Date: Wed, 03 Sep 2025 17:11:31 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,wangkefeng.wang@huawei.com,osalvador@suse.de,mhocko@kernel.org,mcgrof@kernel.org,linmiaohe@huawei.com,kernel@pankajraghav.com,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memory_hotplug-fix-hwpoisoned-large-folio-handling-in-do_migrate_range.patch removed from -mm tree
Message-Id: <20250904001132.7B61CC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory_hotplug: fix hwpoisoned large folio handling in do_migrate_range()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-fix-hwpoisoned-large-folio-handling-in-do_migrate_range.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm/memory_hotplug: fix hwpoisoned large folio handling in do_migrate_range()
Date: Fri, 27 Jun 2025 20:57:47 +0800

In do_migrate_range(), the hwpoisoned folio may be large folio, which
can't be handled by unmap_poisoned_folio().

I can reproduce this issue in qemu after adding delay in memory_failure()

BUG: kernel NULL pointer dereference, address: 0000000000000000
Workqueue: kacpi_hotplug acpi_hotplug_work_fn
RIP: 0010:try_to_unmap_one+0x16a/0xfc0
  <TASK>
  rmap_walk_anon+0xda/0x1f0
  try_to_unmap+0x78/0x80
  ? __pfx_try_to_unmap_one+0x10/0x10
  ? __pfx_folio_not_mapped+0x10/0x10
  ? __pfx_folio_lock_anon_vma_read+0x10/0x10
  unmap_poisoned_folio+0x60/0x140
  do_migrate_range+0x4d1/0x600
  ? slab_memory_callback+0x6a/0x190
  ? notifier_call_chain+0x56/0xb0
  offline_pages+0x3e6/0x460
  memory_subsys_offline+0x130/0x1f0
  device_offline+0xba/0x110
  acpi_bus_offline+0xb7/0x130
  acpi_scan_hot_remove+0x77/0x290
  acpi_device_hotplug+0x1e0/0x240
  acpi_hotplug_work_fn+0x1a/0x30
  process_one_work+0x186/0x340

Besides, do_migrate_range() may be called between memory_failure set
hwpoison flag and isolate the folio from lru, so remove WARN_ON(). In other
places, unmap_poisoned_folio() is called when the folio is isolated, obey
it in do_migrate_range() too.

[david@redhat.com: don't abort offlining, fixed typo, add comment]
Link: https://lkml.kernel.org/r/3c214dff-9649-4015-840f-10de0e03ebe4@redhat.com
Fixes: b15c87263a69 ("hwpoison, memory_hotplug: allow hwpoisoned pages to be offlined")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pankaj Raghav <kernel@pankajraghav.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-fix-hwpoisoned-large-folio-handling-in-do_migrate_range
+++ a/mm/memory_hotplug.c
@@ -1815,8 +1815,14 @@ static void do_migrate_range(unsigned lo
 			pfn = folio_pfn(folio) + folio_nr_pages(folio) - 1;
 
 		if (folio_contain_hwpoisoned_page(folio)) {
-			if (WARN_ON(folio_test_lru(folio)))
-				folio_isolate_lru(folio);
+			/*
+			 * unmap_poisoned_folio() cannot handle large folios
+			 * in all cases yet.
+			 */
+			if (folio_test_large(folio) && !folio_test_hugetlb(folio))
+				goto put_folio;
+			if (folio_test_lru(folio) && !folio_isolate_lru(folio))
+				goto put_folio;
 			if (folio_mapped(folio)) {
 				folio_lock(folio);
 				unmap_poisoned_folio(folio, pfn, false);
_

Patches currently in -mm which might be from tujinjiang@huawei.com are


