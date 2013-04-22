From: akpm@linux-foundation.org
Subject: + mm-fix-memory_hotplugc-printk-format-warning.patch added to -mm tree
Date: Mon, 22 Apr 2013 13:47:07 -0700
Message-ID: <20130422204707.71C145A40F3@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:63063 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab3DVUrI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Apr 2013 16:47:08 -0400
Received: by mail-qe0-f73.google.com with SMTP id 1so738184qee.2
        for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2013 13:47:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@infradead.org, geert@linux-m68k.org


The patch titled
     Subject: mm: fix memory_hotplug.c printk format warning
has been added to the -mm tree.  Its filename is
     mm-fix-memory_hotplugc-printk-format-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm: fix memory_hotplug.c printk format warning

PFN_PHYS() is a phys_addr_t, which can be u32 or u64.
Fix the build warning when phys_addr_t is u32.

mm/memory_hotplug.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 2 has type 'unsigned int' [-Wformat]:  => 1685:3
mm/memory_hotplug.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 3 has type 'unsigned int' [-Wformat]:  => 1685:3

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN mm/memory_hotplug.c~mm-fix-memory_hotplugc-printk-format-warning mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-fix-memory_hotplugc-printk-format-warning
+++ a/mm/memory_hotplug.c
@@ -1690,11 +1690,15 @@ static int is_memblock_offlined_cb(struc
 {
 	int ret = !is_memblock_offlined(mem);
 
-	if (unlikely(ret))
+	if (unlikely(ret)) {
+		phys_addr_t beginpa, endpa;
+
+		beginpa = PFN_PHYS(section_nr_to_pfn(mem->start_section_nr));
+		endpa = PFN_PHYS(section_nr_to_pfn(mem->end_section_nr + 1))-1;
 		pr_warn("removing memory fails, because memory "
-			"[%#010llx-%#010llx] is onlined\n",
-			PFN_PHYS(section_nr_to_pfn(mem->start_section_nr)),
-			PFN_PHYS(section_nr_to_pfn(mem->end_section_nr + 1))-1);
+			"[%pa-%pa] is onlined\n",
+			&beginpa, &endpa);
+	}
 
 	return ret;
 }
_

Patches currently in -mm which might be from rdunlap@infradead.org are

linux-next.patch
mm-fix-memory_hotplugc-printk-format-warning.patch
kconfig-consolidate-config_debug_strict_user_copy_checks-fix.patch
kconfig-menu-move-virtualization-drivers-near-other-virtualization-options.patch
init-kconfig-make-expert-as-config-instead-of-menuconfig.patch
debugging-keep-track-of-page-owners-fix-2.patch

