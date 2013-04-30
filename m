From: akpm@linux-foundation.org
Subject: [merged] mm-fix-memory_hotplugc-printk-format-warning.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:50:12 -0700
Message-ID: <20130430185012.76C1431C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:49149 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247Ab3D3SuN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:50:13 -0400
Received: by mail-qe0-f73.google.com with SMTP id 9so86049qea.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:50:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix memory_hotplug.c printk format warning
has been removed from the -mm tree.  Its filename was
     mm-fix-memory_hotplugc-printk-format-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
kconfig-consolidate-config_debug_strict_user_copy_checks-fix.patch
kconfig-menu-move-virtualization-drivers-near-other-virtualization-options.patch
init-kconfig-re-order-config_expert-options-to-fix-menuconfig-display.patch
arm-etm-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch
documentation-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch
debugging-keep-track-of-page-owners-fix-2.patch

