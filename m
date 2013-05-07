From: akpm@linux-foundation.org
Subject: [merged] mm-cleancache-clean-up-cleancache_enabled.patch removed from -mm tree
Date: Tue, 07 May 2013 10:46:39 -0700
Message-ID: <20130507174639.8D1225A41B9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:54305 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758408Ab3EGRql (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:46:41 -0400
Received: by mail-vb0-f73.google.com with SMTP id e13so85119vbg.0
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:46:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lliubbo@gmail.com, andor.daam@googlemail.com, dan.magenheimer@oracle.com, fschmaus@gmail.com, ilendir@googlemail.com, konrad.wilk@oracle.com, liwanp@linux.vnet.ibm.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cleancache: clean up cleancache_enabled
has been removed from the -mm tree.  Its filename was
     mm-cleancache-clean-up-cleancache_enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bob Liu <lliubbo@gmail.com>
Subject: mm: cleancache: clean up cleancache_enabled

cleancache_ops is used to decide whether backend is registered.
So now cleancache_enabled is always true if defined CONFIG_CLEANCACHE.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andor Daam <andor.daam@googlemail.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Florian Schmaus <fschmaus@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Stefan Hengelein <ilendir@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cleancache.h |    2 +-
 mm/cleancache.c            |   11 -----------
 2 files changed, 1 insertion(+), 12 deletions(-)

diff -puN include/linux/cleancache.h~mm-cleancache-clean-up-cleancache_enabled include/linux/cleancache.h
--- a/include/linux/cleancache.h~mm-cleancache-clean-up-cleancache_enabled
+++ a/include/linux/cleancache.h
@@ -42,9 +42,9 @@ extern void __cleancache_put_page(struct
 extern void __cleancache_invalidate_page(struct address_space *, struct page *);
 extern void __cleancache_invalidate_inode(struct address_space *);
 extern void __cleancache_invalidate_fs(struct super_block *);
-extern int cleancache_enabled;
 
 #ifdef CONFIG_CLEANCACHE
+#define cleancache_enabled (1)
 static inline bool cleancache_fs_enabled(struct page *page)
 {
 	return page->mapping->host->i_sb->cleancache_poolid >= 0;
diff -puN mm/cleancache.c~mm-cleancache-clean-up-cleancache_enabled mm/cleancache.c
--- a/mm/cleancache.c~mm-cleancache-clean-up-cleancache_enabled
+++ a/mm/cleancache.c
@@ -19,16 +19,6 @@
 #include <linux/cleancache.h>
 
 /*
- * This global enablement flag may be read thousands of times per second
- * by cleancache_get/put/invalidate even on systems where cleancache_ops
- * is not claimed (e.g. cleancache is config'ed on but remains
- * disabled), so is preferred to the slower alternative: a function
- * call that checks a non-global.
- */
-int cleancache_enabled __read_mostly;
-EXPORT_SYMBOL(cleancache_enabled);
