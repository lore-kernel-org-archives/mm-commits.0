From: akpm@linux-foundation.org
Subject: + mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-rev-3.patch added to -mm tree
Date: Wed, 03 Feb 2010 17:21:54 -0800
Message-ID: <201002040121.o141Lsm7031441@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933037Ab0BDBWP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 20:22:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, benh@kernel.crashing.org, kosaki.motohiro@jp.fujitsu.com, maximlevitsky@gmail.com, sebott@linux.vnet.ibm.com


The patch titled
     mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-rev-3
has been added to the -mm tree.  Its filename is
     mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-rev-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

