Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F2A28A414
	for <mm-commits@vger.kernel.org>; Fri, 27 Jun 2025 21:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751061262; cv=none; b=S7qZwjSFt3jf5jT3QWZcK4pJTpRPgdat8RA89DR3mOOHKv8KVQ80ZPETLzKV4J9UjyP609MGT4IBikqF3ZsQ28qbxzNzLZ4atLcd8pXfX70tW5yAT3eQ+c6N7z4lXBkwrUyOLNGJK27lrDOygONXx/Q3uD1FI0+4jf4ye9QIDwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751061262; c=relaxed/simple;
	bh=I+pyrYPWXX3mKcjqsSTyhUb251VCijXJjeHkSIuy5kc=;
	h=Date:To:From:Subject:Message-Id; b=OVwQ4fEm/LGqH1746U1guZf9KB4lC8C+yOx5eugPy33h96OOeKOw7oL3rNdLUAUcKy5Qt2naQ4J4VWW5ESqjzDaHf0knaZfu2GLXcoG6ciTivR3AbUoVLM/Zyqj3DfmnY/R/uN5inT53zUY/usuq84fiQ7Z2GvEU3rDY/bhlY8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lNyAKO1q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lNyAKO1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0529C4CEE3;
	Fri, 27 Jun 2025 21:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751061261;
	bh=I+pyrYPWXX3mKcjqsSTyhUb251VCijXJjeHkSIuy5kc=;
	h=Date:To:From:Subject:From;
	b=lNyAKO1qTQv9akahIoCLVdbpHNebnTodHUtHJd8lxrQZ9iYC97JiAypPKTAGZ2+GA
	 7V30mz5f7+naYPeTFs8bxG6DGrIZWbsbjKFm0Ba7nnPRBok//gyshL3ppcq09QL/og
	 16dkUk33O1Zigr9HFoi1ACTHxtDgYxJmrSHfA1X8=
Date: Fri, 27 Jun 2025 14:54:21 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,osalvador@suse.de,mhocko@kernel.org,linmiaohe@huawei.com,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-fix-hwpoisoned-large-folio-handling-in-do_migrate_range.patch added to mm-hotfixes-unstable branch
Message-Id: <20250627215421.B0529C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory_hotplug: fix hwpoisoned large folio handling in do_migrate_range
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory_hotplug-fix-hwpoisoned-large-folio-handling-in-do_migrate_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-fix-hwpoisoned-large-folio-handling-in-do_migrate_range.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-fix-hwpoisoned-large-folio-handling-in-do_migrate_range
+++ a/mm/memory_hotplug.c
@@ -1795,7 +1795,7 @@ found:
 	return 0;
 }
 
-static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
+static int do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 {
 	struct folio *folio;
 	unsigned long pfn;
@@ -1819,8 +1819,10 @@ static void do_migrate_range(unsigned lo
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
@@ -1877,6 +1879,11 @@ put_folio:
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
@@ -2041,11 +2048,9 @@ int offline_pages(unsigned long start_pf
 
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

mm-memory_hotplug-fix-hwpoisoned-large-folio-handling-in-do_migrate_range.patch

