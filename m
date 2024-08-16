Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4E11C460C
	for <mm-commits@vger.kernel.org>; Fri, 16 Aug 2024 21:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723844580; cv=none; b=WlE16ZWmOXDqkct0LcYfpqRsDNh+tZgNYEVdVNrijBGy5TGDoZRzLb4EjugSHpHxTq2OdJJXm7PNi46B9HGkXl8O9nMea9ruZSwGNuAYqjXE0sF4uuyvmANEgi2Ya5puRGFSbIbK8cIsuLXYq8C8+UXaLc65mChGM/ok2AD5WGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723844580; c=relaxed/simple;
	bh=oqFO2e400vSyvjxG8j2sbGlsmLCyuy8/rB5Xz8Rjd1g=;
	h=Date:To:From:Subject:Message-Id; b=mGwq/FKfdAD2EBEPYymJI9rCVLWfUx5UNz5EjcyjV0AX/ydrR3Q5SlKIKez2VYZyxJlindeNH7OOuylN7hTz4hWSUSG/AqjoHjtwPsYAP+EIeux42bNzfwzDw+TKkPlJ048AfPSag3q0w7tw0ifyivZY8BC04GNb9mQZ1FAW0wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZPvdginN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZPvdginN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D7F0C32782;
	Fri, 16 Aug 2024 21:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723844580;
	bh=oqFO2e400vSyvjxG8j2sbGlsmLCyuy8/rB5Xz8Rjd1g=;
	h=Date:To:From:Subject:From;
	b=ZPvdginNeO81KqkSNDw3seyGVrGjcfdunsrLyTLih+9vJqbZe8M9V7rSRabJO8RIu
	 sPb9uH6Guzq3vOWkVwsrmgpc1vXCGND/nhg/V0+xLeyjDDc+zGuwzvdpBPplmdXyG2
	 eMSgy9PURKQHWZDrDb8EOSe+g9ntPdmqf2bxp2Xg=
Date: Fri, 16 Aug 2024 14:42:59 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range.patch added to mm-unstable branch
Message-Id: <20240816214300.5D7F0C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memory_hotplug: check hwpoisoned page firstly in do_migrate_range()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range.patch

This patch will later appear in the mm-unstable branch at
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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory_hotplug: check hwpoisoned page firstly in do_migrate_range()
Date: Fri, 16 Aug 2024 17:04:33 +0800

The commit b15c87263a69 ("hwpoison, memory_hotplug: allow hwpoisoned pages
to be offlined") don't handle the hugetlb pages, the endless loop still
occur if offline a hwpoison hugetlb, luckly, with the commit e591ef7d96d6
("mm,hwpoison,hugetlb,memory_hotplug: hotremove memory section with
hwpoisoned hugepage") section with hwpoisoned hugepage"), the
HPageMigratable of hugetlb page will be clear, and the hwpoison hugetlb
page will be skipped in scan_movable_pages(), so the endless loop issue is
fixed.

However if the HPageMigratable() check passed(without reference and lock),
the hugetlb page may be hwpoisoned, it won't cause issue since the
hwpoisoned page will be handled correctly in the next movable pages scan
loop, and it will be isolated in do_migrate_range() but fails to migrate. 
In order to avoid the unnecessary isolation and unify all hwpoisoned page
handling, let's unconditionally check hwpoison firstly, and if it is a
hwpoisoned hugetlb page, try to unmap it as the catch all safety net like
normal page does.

Link: https://lkml.kernel.org/r/20240816090435.888946-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range
+++ a/mm/memory_hotplug.c
@@ -1793,13 +1793,8 @@ static void do_migrate_range(unsigned lo
 		 * but out loop could handle that as it revisits the split
 		 * folio later.
 		 */
-		if (folio_test_large(folio)) {
+		if (folio_test_large(folio))
 			pfn = folio_pfn(folio) + folio_nr_pages(folio) - 1;
-			if (folio_test_hugetlb(folio)) {
-				isolate_hugetlb(folio);
-				continue;
-			}
-		}
 
 		/*
 		 * HWPoison pages have elevated reference counts so the migration would
@@ -1808,11 +1803,17 @@ static void do_migrate_range(unsigned lo
 		 * (e.g. current hwpoison implementation doesn't unmap KSM pages but keep
 		 * the unmap as the catch all safety net).
 		 */
-		if (PageHWPoison(page)) {
+		if (folio_test_hwpoison(folio) ||
+		    (folio_test_large(folio) && folio_test_has_hwpoisoned(folio))) {
 			if (WARN_ON(folio_test_lru(folio)))
 				folio_isolate_lru(folio);
 			if (folio_mapped(folio))
-				try_to_unmap(folio, TTU_IGNORE_MLOCK);
+				unmap_posioned_folio(folio, TTU_IGNORE_MLOCK);
+			continue;
+		}
+
+		if (folio_test_hugetlb(folio)) {
+			isolate_hugetlb(folio, &source);
 			continue;
 		}
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hugetlb-remove-left-over-comment-about-follow_huge_foo.patch
mm-memory_hotplug-remove-head-variable-in-do_migrate_range.patch
mm-memory-failure-add-unmap_posioned_folio.patch
mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range.patch
mm-migrate-add-isolate_folio_to_list.patch
mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation.patch

