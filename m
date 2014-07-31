From: akpm@linux-foundation.org
Subject: [merged]
 mm-fix-filemapc-pagecache_get_page-kernel-doc-warnings.patch removed from
 -mm tree
Date: Thu, 31 Jul 2014 13:22:16 -0700
Message-ID: <53daa578.Iqfesa+fHBgZmbUg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:32976 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaGaUWR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Jul 2014 16:22:17 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so926778oig.1
        for <mm-commits@vger.kernel.org>; Thu, 31 Jul 2014 13:22:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix filemap.c pagecache_get_page() kernel-doc warnings
has been removed from the -mm tree.  Its filename was
     mm-fix-filemapc-pagecache_get_page-kernel-doc-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm: fix filemap.c pagecache_get_page() kernel-doc warnings

Fix kernel-doc warnings in mm/filemap.c: pagecache_get_page():

Warning(..//mm/filemap.c:1054): No description found for parameter 'cache_gfp_mask'
Warning(..//mm/filemap.c:1054): No description found for parameter 'radix_gfp_mask'
Warning(..//mm/filemap.c:1054): Excess function parameter 'gfp_mask' description in 'pagecache_get_page'

Fixes: 2457aec63745 ("mm: non-atomically mark page accessed during page cache allocation where possible")

[mgorman@suse.de: change everything]
[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN mm/filemap.c~mm-fix-filemapc-pagecache_get_page-kernel-doc-warnings mm/filemap.c
--- a/mm/filemap.c~mm-fix-filemapc-pagecache_get_page-kernel-doc-warnings
+++ a/mm/filemap.c
@@ -1031,18 +1031,21 @@ EXPORT_SYMBOL(find_lock_entry);
  * @mapping: the address_space to search
  * @offset: the page index
  * @fgp_flags: PCG flags
- * @gfp_mask: gfp mask to use if a page is to be allocated
+ * @cache_gfp_mask: gfp mask to use for the page cache data page allocation
+ * @radix_gfp_mask: gfp mask to use for radix tree node allocation
  *
  * Looks up the page cache slot at @mapping & @offset.
  *
- * PCG flags modify how the page is returned
+ * PCG flags modify how the page is returned.
  *
  * FGP_ACCESSED: the page will be marked accessed
  * FGP_LOCK: Page is return locked
  * FGP_CREAT: If page is not present then a new page is allocated using
- *		@gfp_mask and added to the page cache and the VM's LRU
- *		list. The page is returned locked and with an increased
- *		refcount. Otherwise, %NULL is returned.
+ *		@cache_gfp_mask and added to the page cache and the VM's LRU
+ *		list. If radix tree nodes are allocated during page cache
+ *		insertion then @radix_gfp_mask is used. The page is returned
+ *		locked and with an increased refcount. Otherwise, %NULL is
+ *		returned.
  *
  * If FGP_LOCK or FGP_CREAT are specified then the function may sleep even
  * if the GFP flags specified for FGP_CREAT are atomic.
_

Patches currently in -mm which might be from rdunlap@infradead.org are

origin.patch
kbuild-explain-stack-protector-strong-config-logic.patch
add-lib-globc.patch
lib-globc-add-config_glob_selftest.patch
libata-use-glob_match-from-lib-globc.patch
panic-add-taint_softlockup.patch
panic-add-taint_softlockup-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

