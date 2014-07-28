From: akpm@linux-foundation.org
Subject: + mm-fix-filemapc-pagecache_get_page-kernel-doc-warnings.patch
 added to -mm tree
Date: Mon, 28 Jul 2014 15:24:44 -0700
Message-ID: <53d6cdac.ibLlFg4rCX42YhcV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:32891 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbaG1WYq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Jul 2014 18:24:46 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so1979395pab.3
        for <mm-commits@vger.kernel.org>; Mon, 28 Jul 2014 15:24:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix filemap.c pagecache_get_page() kernel-doc warnings
has been added to the -mm tree.  Its filename is
     mm-fix-filemapc-pagecache_get_page-kernel-doc-warnings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-filemapc-pagecache_get_page-kernel-doc-warnings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-filemapc-pagecache_get_page-kernel-doc-warnings.patch

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
Subject: mm: fix filemap.c pagecache_get_page() kernel-doc warnings

Fix kernel-doc warnings in mm/filemap.c: pagecache_get_page():

Warning(..//mm/filemap.c:1054): No description found for parameter 'cache_gfp_mask'
Warning(..//mm/filemap.c:1054): No description found for parameter 'radix_gfp_mask'
Warning(..//mm/filemap.c:1054): Excess function parameter 'gfp_mask' description in 'pagecache_get_page'

Fixes: 2457aec63745 ("mm: non-atomically mark page accessed during page cache allocation where possible")

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/filemap.c~mm-fix-filemapc-pagecache_get_page-kernel-doc-warnings mm/filemap.c
--- a/mm/filemap.c~mm-fix-filemapc-pagecache_get_page-kernel-doc-warnings
+++ a/mm/filemap.c
@@ -1031,16 +1031,17 @@ EXPORT_SYMBOL(find_lock_entry);
  * @mapping: the address_space to search
  * @offset: the page index
  * @fgp_flags: PCG flags
- * @gfp_mask: gfp mask to use if a page is to be allocated
+ * @cache_gfp_mask: gfp mask to use if a page is to be allocated
+ * @radix_gfp_mask: gfp mask to use for page cache LRU allocation
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
+ *		@cache_gfp_mask and added to the page cache and the VM's LRU
  *		list. The page is returned locked and with an increased
  *		refcount. Otherwise, %NULL is returned.
  *
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-fix-filemapc-pagecache_get_page-kernel-doc-warnings.patch
mm-fix-filemapc-pagecache_get_page-kernel-doc-warnings-fix.patch
kbuild-explain-stack-protector-strong-config-logic.patch
add-lib-globc.patch
lib-globc-add-config_glob_selftest.patch
libata-use-glob_match-from-lib-globc.patch
panic-add-taint_softlockup.patch
panic-add-taint_softlockup-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

