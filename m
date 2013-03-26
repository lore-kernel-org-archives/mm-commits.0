From: akpm@linux-foundation.org
Subject: + page_alloc-make-setup_nr_node_ids-usable-for-arch-init-code.patch added to -mm tree
Date: Tue, 26 Mar 2013 13:14:31 -0700
Message-ID: <20130326201431.CCC4931C228@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:42080 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab3CZUOc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Mar 2013 16:14:32 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so761019qcr.2
        for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2013 13:14:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cody@linux.vnet.ibm.com


The patch titled
     Subject: page_alloc: make setup_nr_node_ids() usable for arch init code
has been added to the -mm tree.  Its filename is
     page_alloc-make-setup_nr_node_ids-usable-for-arch-init-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1812,5 +1812,11 @@ static inline unsigned int debug_guardpa
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

page_alloc-make-setup_nr_node_ids-usable-for-arch-init-code.patch
x86-mm-numa-use-setup_nr_node_ids-instead-of-opencoding.patch
powerpc-mm-numa-use-setup_nr_node_ids-instead-of-opencoding.patch

