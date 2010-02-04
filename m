From: akpm@linux-foundation.org
Subject: [folded] mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-rev-3.patch removed from -mm tree
Date: Thu, 04 Feb 2010 11:59:14 -0800
Message-ID: <201002041959.o14JxEO2018505@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38831 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932874Ab0BDUAD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2010 15:00:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, benh@kernel.crashing.org, kosaki.motohiro@jp.fujitsu.com, maximlevitsky@gmail.com, sebott@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-rev-3
has been removed from the -mm tree.  Its filename was
     mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-rev-3.patch

This patch was dropped because it was folded into mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-rev-3
From: "Rafael J. Wysocki" <rjw@sisk.pl>

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |   13 ++-----------
 init/main.c         |    2 +-
 mm/page_alloc.c     |   24 ++++++++++++++++++++++++
 3 files changed, 27 insertions(+), 12 deletions(-)

diff -puN include/linux/gfp.h~mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-rev-3 include/linux/gfp.h
--- a/include/linux/gfp.h~mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-rev-3
+++ a/include/linux/gfp.h
@@ -338,16 +338,7 @@ void drain_local_pages(void *dummy);
 
 extern gfp_t gfp_allowed_mask;
 
-static inline void set_gfp_allowed_mask(gfp_t mask)
-{
-	gfp_allowed_mask = mask;
-}
-
-static inline gfp_t clear_gfp_allowed_mask(gfp_t mask)
-{
-	gfp_t ret = gfp_allowed_mask;
-	gfp_allowed_mask &= ~mask;
-	return ret;
-}
+extern void set_gfp_allowed_mask(gfp_t mask);
+extern gfp_t clear_gfp_allowed_mask(gfp_t mask);
 
 #endif /* __LINUX_GFP_H */
diff -puN init/main.c~mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-rev-3 init/main.c
--- a/init/main.c~mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-rev-3
+++ a/init/main.c
@@ -602,7 +602,7 @@ asmlinkage void __init start_kernel(void
 	local_irq_enable();
 
 	/* Interrupts are enabled now so all GFP allocations are safe. */
-	set_gfp_allowed_mask(__GFP_BITS_MASK);
+	gfp_allowed_mask = __GFP_BITS_MASK;
 
 	kmem_cache_init_late();
 
diff -puN mm/page_alloc.c~mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-rev-3 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-rev-3
+++ a/mm/page_alloc.c
@@ -77,6 +77,30 @@ unsigned long totalreserve_pages __read_
 int percpu_pagelist_fraction;
 gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 
+/*
+ * The following functions are used by the suspend/hibernate code to temporarily
+ * change gfp_allowed_mask in order to avoid using I/O during memory allocations
+ * while devices are suspended.  To avoid races with the suspend/hibernate code,
+ * they should always be called with pm_mutex held (gfp_allowed_mask also should
+ * only be modified with pm_mutex held, unless the suspend/hibernate code is
+ * guaranteed not to run in parallel with that modification).
+ */
+
+void set_gfp_allowed_mask(gfp_t mask)
+{
+	WARN_ON(!mutex_is_locked(&pm_mutex));
+	gfp_allowed_mask = mask;
+}
+
+gfp_t clear_gfp_allowed_mask(gfp_t mask)
+{
+	gfp_t ret = gfp_allowed_mask;
+
+	WARN_ON(!mutex_is_locked(&pm_mutex));
+	gfp_allowed_mask &= ~mask;
+	return ret;
+}
+
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
 int pageblock_order __read_mostly;
 #endif
_

Patches currently in -mm which might be from rjw@sisk.pl are

linux-next.patch
drivers-acpi-processor_idlec-add-two-laptops-to-the-c-state-dmi-table.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-rev-3.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-rev-3-fix.patch

