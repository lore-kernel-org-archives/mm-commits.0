From: akpm@linux-foundation.org
Subject: [merged] kexec-add-the-values-related-to-buddy-system-for-filtering-free-pages.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:12:04 -0800
Message-ID: <20130228201204.CBA1E31C211@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:34334 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab3B1UMG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:12:06 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so260971qaj.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:12:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kumagai-atsushi@mxc.nes.nec.co.jp, ebiederm@xmission.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: add the values related to buddy system for filtering free pages.
has been removed from the -mm tree.  Its filename was
     kexec-add-the-values-related-to-buddy-system-for-filtering-free-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Subject: kexec: add the values related to buddy system for filtering free pages.

tAdd adds the values related to buddy system to vmcoreinfo data so that
makedumpfile (dump filtering command) can filter out all free pages with
the new logic.

It's faster than the current logic because it can distinguish free page by
analyzing page structure at the same time as filtering for other
unnecessary pages (e.g.  anonymous page).

OTOH, the current logic has to trace free_list to distinguish free pages
while analyzing page structure to filter out other unnecessary pages.

The new logic uses the fact that buddy page is marked by _mapcount ==
PAGE_BUDDY_MAPCOUNT_VALUE.  But, _mapcount shares its memory with other
fields for SLAB/SLUB when PG_slab is set, so we need to check if PG_slab
is set or not before looking up _mapcount value.  And we can get the order
of buddy system from private field.  To sum it up, the values below are
required for this logic.

Required values:
  - OFFSET(page._mapcount)
  - OFFSET(page.private)
  - NUMBER(PG_slab)
  - NUMBER(PAGE_BUDDY_MAPCOUNT_VALUE)

Changelog from v1 to v2:
1. remove SIZE(pageflags)
  The new logic was changed after I sent v1 patch.
  Accordingly, SIZE(pageflags) has been unnecessary for makedumpfile.

What's makedumpfile:
  makedumpfile creates a small dumpfile by excluding unnecessary pages
  for the analysis. To distinguish unnecessary pages, makedumpfile gets
  the vmcoreinfo data which has the minimum debugging information only
  for dump filtering.

Signed-off-by: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/kexec.c~kexec-add-the-values-related-to-buddy-system-for-filtering-free-pages kernel/kexec.c
--- a/kernel/kexec.c~kexec-add-the-values-related-to-buddy-system-for-filtering-free-pages
+++ a/kernel/kexec.c
@@ -1514,6 +1514,8 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_OFFSET(page, _count);
 	VMCOREINFO_OFFSET(page, mapping);
 	VMCOREINFO_OFFSET(page, lru);
+	VMCOREINFO_OFFSET(page, _mapcount);
+	VMCOREINFO_OFFSET(page, private);
 	VMCOREINFO_OFFSET(pglist_data, node_zones);
 	VMCOREINFO_OFFSET(pglist_data, nr_zones);
 #ifdef CONFIG_FLAT_NODE_MEM_MAP
@@ -1536,6 +1538,8 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_NUMBER(PG_lru);
 	VMCOREINFO_NUMBER(PG_private);
 	VMCOREINFO_NUMBER(PG_swapcache);
+	VMCOREINFO_NUMBER(PG_slab);
+	VMCOREINFO_NUMBER(PAGE_BUDDY_MAPCOUNT_VALUE);
 
 	arch_crash_save_vmcoreinfo();
 	update_vmcoreinfo_note();
_

Patches currently in -mm which might be from kumagai-atsushi@mxc.nes.nec.co.jp are

origin.patch

