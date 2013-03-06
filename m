From: akpm@linux-foundation.org
Subject: + mm-cleancache-clean-up-cleancache_enabled.patch added to -mm tree
Date: Wed, 06 Mar 2013 13:10:10 -0800
Message-ID: <20130306211010.DDB5531C1B6@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:47240 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab3CFVKN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Mar 2013 16:10:13 -0500
Received: by mail-qc0-f201.google.com with SMTP id o22so342824qcr.0
        for <mm-commits@vger.kernel.org>; Wed, 06 Mar 2013 13:10:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lliubbo@gmail.com, andor.daam@googlemail.com, dan.magenheimer@oracle.com, fschmaus@gmail.com, ilendir@googlemail.com, konrad.wilk@oracle.com, liwanp@linux.vnet.ibm.com, minchan@kernel.org


The patch titled
     Subject: mm: cleancache: clean up cleancache_enabled
has been added to the -mm tree.  Its filename is
     mm-cleancache-clean-up-cleancache_enabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
-
-/*
  * cleancache_ops is set by cleancache_ops_register to contain the pointers
  * to the cleancache "backend" implementation functions.
  */
@@ -414,7 +404,6 @@ static int __init init_cleancache(void)
 		fs_poolid_map[i] = FS_UNKNOWN;
 		shared_fs_poolid_map[i] = FS_UNKNOWN;
 	}
-	cleancache_enabled = 1;
 	return 0;
 }
 module_init(init_cleancache)
_

Patches currently in -mm which might be from lliubbo@gmail.com are

mm-frontswap-lazy-initialization-to-allow-tmem-backends-to-build-run-as-modules.patch
frontswap-make-frontswap_init-use-a-pointer-for-the-ops.patch
mm-frontswap-cleanup-code.patch
frontswap-get-rid-of-swap_lock-dependency.patch
mm-cleancache-lazy-initialization-to-allow-tmem-backends-to-build-run-as-modules.patch
cleancache-make-cleancache_init-use-a-pointer-for-the-ops.patch
mm-cleancache-clean-up-cleancache_enabled.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module.patch
zcache-tmem-better-error-checking-on-frontswap_register_ops-return-value.patch
staging-zcache-enable-ramster-to-be-built-loaded-as-a-module.patch
staging-zcache-enable-zcache-to-be-built-loaded-as-a-module.patch

