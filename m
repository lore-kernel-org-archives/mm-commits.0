Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A39B208CA;
	Sat, 23 Aug 2025 01:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755913249; cv=none; b=RAoV2XXaRCHwWhH9rt1UaXXdf4i8wvt+IXTRItcPt1937zijXNilSiAmOeumiLqxKL0yxw+u6GWszGfDOzhJ4ZIBYjMz8rCWH/NrKOdbrUiohd66AcmPcPV/nv6vb2B3WlocN11ncvoZJOMg6AM/IwqsPzustWR63kBcFudhA0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755913249; c=relaxed/simple;
	bh=O8gVHSNzhHRPA2iUp0A0aSMxPzPvr5WgrBklmdUNwJ4=;
	h=Date:To:From:Subject:Message-Id; b=MVkbhIP21csSFbaMa8zTP56BKKq/OjvVGlf5VDgUh94UBgiXbvAT1Cvr3WMdaNWjj2hGUqN48wHmmgJ/5b7Dtn6aIe9mp5Th8KqMXL4ZhiDcxfIYFefqgbLiM0XD/Il6ZyL8Dn6zMk7b3ULZNIH29fIiyJSLe8EQDMdkTVGy4wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rGs39JuK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rGs39JuK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED954C4CEED;
	Sat, 23 Aug 2025 01:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755913249;
	bh=O8gVHSNzhHRPA2iUp0A0aSMxPzPvr5WgrBklmdUNwJ4=;
	h=Date:To:From:Subject:From;
	b=rGs39JuKEGcyNBeptuJ/ghJTFpEJ0Tqj/8jxCIKM7U66JwwFgwx7e6CPweM1TNPwO
	 XtxBDFUh76UY6LCvCX3yy+cUTPy0AV2pMMo7oIinwmWHwcK2IP41Bpp4826ir7UW59
	 BgSzb5o15irjYSY8r69bWpazLrcgRsH/z4oveoqY=
Date: Fri, 22 Aug 2025 18:40:48 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,stable@vger.kernel.org,osalvador@suse.de,mhocko@kernel.org,linmiaohe@huawei.com,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] mm-memory_hotplug-fix-hwpoisoned-large-folio-handling-in-do_migrate_range.patch removed from -mm tree
Message-Id: <20250823014048.ED954C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory_hotplug: fix hwpoisoned large folio handling in do_migrate_range
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-fix-hwpoisoned-large-folio-handling-in-do_migrate_range.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm/memory_hotplug: fix hwpoisoned large folio handling in do_migrate_range
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

In this case, just make offline_pages() fail.

Also, do_migrate_range() may be called between memory_failure() setting
the hwposion flag and isolation of the folio from the lru, so remove
WARN_ON().

Also, in other places unmap_poisoned_folio() is called when the folio is
isolated, so obey that in do_migrate_range().

Link: https://lkml.kernel.org/r/20250627125747.3094074-3-tujinjiang@huawei.com
Fixes: b15c87263a69 ("hwpoison, memory_hotplug: allow hwpoisoned pages to be offlined")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-fix-hwpoisoned-large-folio-handling-in-do_migrate_range
+++ a/mm/memory_hotplug.c
@@ -1791,7 +1791,7 @@ found:
 	return 0;
 }
 
-static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
+static int do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 {
 	struct folio *folio;
 	unsigned long pfn;
@@ -1815,8 +1815,10 @@ static void do_migrate_range(unsigned lo
 			pfn = folio_pfn(folio) + folio_nr_pages(folio) - 1;
 
 		if (folio_contain_hwpoisoned_page(folio)) {
-			if (WARN_ON(folio_test_lru(folio)))
-				folio_isolate_lru(folio);
+			if (folio_test_large(folio) && !folio_test_hugetlb(folio))
+				goto err_out;
+			if (folio_test_lru(folio) && !folio_isolate_lru(folio))
+				goto err_out;
 			if (folio_mapped(folio)) {
 				folio_lock(folio);
 				unmap_poisoned_folio(folio, pfn, false);
@@ -1873,6 +1875,11 @@ put_folio:
 			putback_movable_pages(&source);
 		}
 	}
+	return 0;
+err_out:
+	folio_put(folio);
+	putback_movable_pages(&source);
+	return -EBUSY;
 }
 
 static int __init cmdline_parse_movable_node(char *p)
@@ -2006,11 +2013,9 @@ int offline_pages(unsigned long start_pf
 
 			ret = scan_movable_pages(pfn, end_pfn, &pfn);
 			if (!ret) {
-				/*
-				 * TODO: fatal migration failures should bail
-				 * out
-				 */
-				do_migrate_range(pfn, end_pfn);
+				ret = do_migrate_range(pfn, end_pfn);
+				if (ret)
+					break;
 			}
 		} while (!ret);
 
_

Patches currently in -mm which might be from tujinjiang@huawei.com are


