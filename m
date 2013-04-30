From: akpm@linux-foundation.org
Subject: [merged] page_alloc-make-setup_nr_node_ids-usable-for-arch-init-code.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:48:27 -0700
Message-ID: <20130430184827.AD6B05A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:51206 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871Ab3D3Ss2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:48:28 -0400
Received: by mail-vb0-f73.google.com with SMTP id p12so85029vbe.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:48:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cody@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: page_alloc: make setup_nr_node_ids() usable for arch init code
has been removed from the -mm tree.  Its filename was
     page_alloc-make-setup_nr_node_ids-usable-for-arch-init-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: page_alloc: make setup_nr_node_ids() usable for arch init code

powerpc and x86 were opencoding copies of setup_nr_node_ids(), which
page_alloc provides but makes static. Make it avaliable to the archs in
linux/mm.h.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---

index 7acc9dc..3405405 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 ++++++
 mm/page_alloc.c    |    6 +-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff -puN include/linux/mm.h~page_alloc-make-setup_nr_node_ids-usable-for-arch-init-code include/linux/mm.h
--- a/include/linux/mm.h~page_alloc-make-setup_nr_node_ids-usable-for-arch-init-code
+++ a/include/linux/mm.h
@@ -1816,5 +1816,11 @@ static inline unsigned int debug_guardpa
 static inline bool page_is_guard(struct page *page) { return false; }
 #endif /* CONFIG_DEBUG_PAGEALLOC */
 
+#if MAX_NUMNODES > 1
+void __init setup_nr_node_ids(void);
+#else
+static inline void setup_nr_node_ids(void) {}
+#endif
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
diff -puN mm/page_alloc.c~page_alloc-make-setup_nr_node_ids-usable-for-arch-init-code mm/page_alloc.c
--- a/mm/page_alloc.c~page_alloc-make-setup_nr_node_ids-usable-for-arch-init-code
+++ a/mm/page_alloc.c
@@ -4749,7 +4749,7 @@ void __paginginit free_area_init_node(in
 /*
  * Figure out the number of possible node ids.
  */
-static void __init setup_nr_node_ids(void)
+void __init setup_nr_node_ids(void)
 {
 	unsigned int node;
 	unsigned int highest = 0;
@@ -4758,10 +4758,6 @@ static void __init setup_nr_node_ids(voi
 		highest = node;
 	nr_node_ids = highest + 1;
 }
-#else
-static inline void setup_nr_node_ids(void)
-{
-}
 #endif
 
 /**
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

origin.patch
linux-next.patch

