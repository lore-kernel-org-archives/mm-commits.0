Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B121F23B0
	for <mm-commits@vger.kernel.org>; Sat, 23 Aug 2025 01:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755913351; cv=none; b=CpqZKXYtXLsBrGzj260ABmBng7LrfMKtWt4l3CnMk0QMzuyMX/RuG5NJ4ZAX8Kvd0nWkrxxZZrzEpvtbYX0drRLqqxbI55PoUG6LmtSAAboKfCoTHh69oTSwkGUXp5Cp9DzQVl7sMQ57qjev7dT2sjH1hj3VGgFNELi5qU1R3co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755913351; c=relaxed/simple;
	bh=wX8qFrmJ17h9UJDRO42oYwP/S8RCtgBbTd2V0RPh2mo=;
	h=Date:To:From:Subject:Message-Id; b=Ez1QnPkRFpTngU6PY/0UTcknrBNGDZiVQ7j5Hlu6XUn8jADBOeEmJLSlKgVS8toD6ouQoiP6NPyJiXkvReQLOBzHR3+Je0e2u9iDiYwwcy99PcJrHqTvkuyPiiSBigZB0vaTESxd+eTc0BAZEAI9b0A9llJSujV9IDfeiOrD+yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OnoeP6IP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OnoeP6IP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273C8C4CEED;
	Sat, 23 Aug 2025 01:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755913351;
	bh=wX8qFrmJ17h9UJDRO42oYwP/S8RCtgBbTd2V0RPh2mo=;
	h=Date:To:From:Subject:From;
	b=OnoeP6IPnBdmzmYf2V4PNDHaI1G8L6QniNco6RDsoXjXC3VO5T5r49+Q3euej5uux
	 MOm6v6x00/0aXwqGJdyiF/el/hInSgYV0PzIzkZqFDCvOyjr3vWzIfbzWiEIeyuZ7A
	 Zpkva4fdCCRciD1LdG3PziiW82f7okBgag2lSmy4=
Date: Fri, 22 Aug 2025 18:42:30 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,wangkefeng.wang@huawei.com,osalvador@suse.de,mhocko@kernel.org,mcgrof@kernel.org,linmiaohe@huawei.com,kernel@pankajraghav.com,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-fix-hwpoisoned-large-folio-handling-in-do_migrate_range.patch added to mm-hotfixes-unstable branch
Message-Id: <20250823014231.273C8C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory_hotplug: fix hwpoisoned large folio handling in do_migrate_range()
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
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pankaj Raghav <kernel@pankajraghav.com>
Cc: Zi Yan <ziy@nvidia.com>
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

mm-memory_hotplug-fix-hwpoisoned-large-folio-handling-in-do_migrate_range.patch

