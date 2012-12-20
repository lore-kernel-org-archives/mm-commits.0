From: akpm@linux-foundation.org
Subject: + kexec-add-the-values-related-to-buddy-system-for-filtering-free-pages.patch added to -mm tree
Date: Wed, 19 Dec 2012 16:20:10 -0800
Message-ID: <20121220002011.2D9EF200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f201.google.com ([74.125.82.201]:49033 "EHLO
	mail-we0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab2LTAUN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 19:20:13 -0500
Received: by mail-we0-f201.google.com with SMTP id t11so140577wey.0
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 16:20:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kumagai-atsushi@mxc.nes.nec.co.jp, ebiederm@xmission.com, vgoyal@redhat.com


The patch titled
     Subject: kexec: add the values related to buddy system for filtering free pages.
has been added to the -mm tree.  Its filename is
     kexec-add-the-values-related-to-buddy-system-for-filtering-free-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/kexec.c~kexec-add-the-values-related-to-buddy-system-for-filtering-free-pages kernel/kexec.c
--- a/kernel/kexec.c~kexec-add-the-values-related-to-buddy-system-for-filtering-free-pages
+++ a/kernel/kexec.c
@@ -1490,6 +1490,8 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_OFFSET(page, _count);
 	VMCOREINFO_OFFSET(page, mapping);
 	VMCOREINFO_OFFSET(page, lru);
+	VMCOREINFO_OFFSET(page, _mapcount);
+	VMCOREINFO_OFFSET(page, private);
 	VMCOREINFO_OFFSET(pglist_data, node_zones);
 	VMCOREINFO_OFFSET(pglist_data, nr_zones);
 #ifdef CONFIG_FLAT_NODE_MEM_MAP
@@ -1512,6 +1514,8 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_NUMBER(PG_lru);
 	VMCOREINFO_NUMBER(PG_private);
 	VMCOREINFO_NUMBER(PG_swapcache);
+	VMCOREINFO_NUMBER(PG_slab);
+	VMCOREINFO_NUMBER(PAGE_BUDDY_MAPCOUNT_VALUE);
 
 	arch_crash_save_vmcoreinfo();
 	update_vmcoreinfo_note();
_

Patches currently in -mm which might be from kumagai-atsushi@mxc.nes.nec.co.jp are

kexec-add-the-values-related-to-buddy-system-for-filtering-free-pages.patch

