Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E294B1DB13A
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 22:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545893; cv=none; b=lomRI5zofgBHH8Mj0J0tuO1NvFE8Aw/0mbqN0SYuame0MyBV/OuYPScaKVIdBnl6WZAkKshrWDSzrQYip9wLVrTJoi/cyNUml7icnCHYV07/LxFXvFBl2+E3kRX81y21Bl1KmwUQssCAb2hmu5jjbm+dFTqjQStzhGU6c2rG8RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545893; c=relaxed/simple;
	bh=iSZKaDRI2kahxA7V0L9+uOVqddQfGV34MSkxgcsRzqY=;
	h=Date:To:From:Subject:Message-Id; b=SjJkw+jmJCNcA++gvnbJB2YGUblz3Q95bGJV9lZXm691r4/76c+laEz69se4vgZoqwFM1aT/13Z34UALNRXDNYC57WNfUDT6uqQSORy5UAya6b+rsMWtNTGURQ68XCe6EMdZBOGOn62tsT/4VXdCX00rpaRkFPvpzjrnScRKWzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ylEnnKya; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ylEnnKya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0F4C4CEE4;
	Tue,  1 Apr 2025 22:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743545892;
	bh=iSZKaDRI2kahxA7V0L9+uOVqddQfGV34MSkxgcsRzqY=;
	h=Date:To:From:Subject:From;
	b=ylEnnKyaOI6LbLh7Okp4FL9VHnyVX/2JznJXP7dw8jrCOSCHeF05OyGBFTgW173WV
	 B0OOhFV4AYk5RP/WQlWc1YBG8hm1wp4giaciBDpk8UEbWJOh3xtMQUoOu657lzTglO
	 oLmILbpnsNQYa12MkI0XtIRjl9rqnv613/RVW1R4=
Date: Tue, 01 Apr 2025 15:18:11 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,wangkefeng.wang@huawei.com,sunnanyong@huawei.com,osalvador@suse.de,nao.horiguchi@gmail.com,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-fix-call-folio_test_large-with-tail-page-in-do_migrate_range.patch removed from -mm tree
Message-Id: <20250401221812.4F0F4C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory_hotplug: fix call folio_test_large with tail page in do_migrate_range
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-fix-call-folio_test_large-with-tail-page-in-do_migrate_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm/memory_hotplug: fix call folio_test_large with tail page in do_migrate_range
Date: Mon, 24 Mar 2025 21:17:50 +0800

We triggered the below BUG:

 page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x2 pfn:0x240402
 head: order:9 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
 flags: 0x1ffffe0000000040(head|node=1|zone=3|lastcpupid=0x1ffff)
 page_type: f4(hugetlb)
 page dumped because: VM_BUG_ON_PAGE(page->compound_head & 1)
 ------------[ cut here ]------------
 kernel BUG at ./include/linux/page-flags.h:310!
 Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
 Modules linked in:
 CPU: 7 UID: 0 PID: 166 Comm: sh Not tainted 6.14.0-rc7-dirty #374
 Hardware name: QEMU QEMU Virtual Machine, BIOS 0.0.0 02/06/2015
 pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
 pc : const_folio_flags+0x3c/0x58
 lr : const_folio_flags+0x3c/0x58
 Call trace:
  const_folio_flags+0x3c/0x58 (P)
  do_migrate_range+0x164/0x720
  offline_pages+0x63c/0x6fc
  memory_subsys_offline+0x190/0x1f4
  device_offline+0xc0/0x13c
  state_store+0x90/0xd8
  dev_attr_store+0x18/0x2c
  sysfs_kf_write+0x44/0x54
  kernfs_fop_write_iter+0x120/0x1cc
  vfs_write+0x240/0x378
  ksys_write+0x70/0x108
  __arm64_sys_write+0x1c/0x28
  invoke_syscall+0x48/0x10c
  el0_svc_common.constprop.0+0x40/0xe0

When allocating a hugetlb folio, between the folio is taken from buddy and
prep_compound_page() is called, start_isolate_page_range() and
do_migrate_range() is called.  When do_migrate_range() scans the head page
of the hugetlb folio, the compound_head field isn't set, so scans the tail
page next.  And at this time, the compound_head field of tail page is set,
folio_test_large() is called by tail page, thus triggers VM_BUG_ON().

To fix it, get folio refcount before calling folio_test_large().

Link: https://lkml.kernel.org/r/20250324131750.1551884-1-tujinjiang@huawei.com
Fixes: 8135d8926c08 ("mm: memory_hotplug: memory hotremove supports thp migration")
Fixes: b62b51d2d159 ("mm: memory_hotplug: remove head variable in do_migrate_range()")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-fix-call-folio_test_large-with-tail-page-in-do_migrate_range
+++ a/mm/memory_hotplug.c
@@ -1813,21 +1813,15 @@ static void do_migrate_range(unsigned lo
 		page = pfn_to_page(pfn);
 		folio = page_folio(page);
 
-		/*
-		 * No reference or lock is held on the folio, so it might
-		 * be modified concurrently (e.g. split).  As such,
-		 * folio_nr_pages() may read garbage.  This is fine as the outer
-		 * loop will revisit the split folio later.
-		 */
-		if (folio_test_large(folio))
-			pfn = folio_pfn(folio) + folio_nr_pages(folio) - 1;
-
 		if (!folio_try_get(folio))
 			continue;
 
 		if (unlikely(page_folio(page) != folio))
 			goto put_folio;
 
+		if (folio_test_large(folio))
+			pfn = folio_pfn(folio) + folio_nr_pages(folio) - 1;
+
 		if (folio_contain_hwpoisoned_page(folio)) {
 			if (WARN_ON(folio_test_lru(folio)))
 				folio_isolate_lru(folio);
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-contig_alloc-fix-alloc_contig_range-when-__gfp_comp-and-order-max_order.patch

