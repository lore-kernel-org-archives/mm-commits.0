From: akpm@linux-foundation.org
Subject: [to-be-updated]
 page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
 removed from -mm tree
Date: Wed, 30 Sep 2015 14:56:36 -0700
Message-ID: <560c5a94.ZXM3L/WudZnioW2C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52614 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676AbbI3V4h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Sep 2015 17:56:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: page-flags: define behavior of LRU-related flags on compound pages
has been removed from the -mm tree.  Its filename was
     page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: page-flags: define behavior of LRU-related flags on compound pages

Only head pages are ever on LRU. Let's use HEAD policy to avoid any
confusion for all LRU-related flags.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN include/linux/page-flags.h~page-flags-define-behavior-of-lru-related-flags-on-compound-pages include/linux/page-flags.h
--- a/include/linux/page-flags.h~page-flags-define-behavior-of-lru-related-flags-on-compound-pages
+++ a/include/linux/page-flags.h
@@ -231,13 +231,14 @@ static inline struct page *compound_head
 
 __PAGEFLAG(Locked, locked, NO_TAIL)
 PAGEFLAG(Error, error, NO_COMPOUND) TESTCLEARFLAG(Error, error, NO_COMPOUND)
-PAGEFLAG(Referenced, referenced, ANY) TESTCLEARFLAG(Referenced, referenced, ANY)
-	__SETPAGEFLAG(Referenced, referenced, ANY)
+PAGEFLAG(Referenced, referenced, HEAD)
+	TESTCLEARFLAG(Referenced, referenced, HEAD)
+	__SETPAGEFLAG(Referenced, referenced, HEAD)
 PAGEFLAG(Dirty, dirty, HEAD) TESTSCFLAG(Dirty, dirty, HEAD)
 	__CLEARPAGEFLAG(Dirty, dirty, HEAD)
-PAGEFLAG(LRU, lru, ANY) __CLEARPAGEFLAG(LRU, lru, ANY)
-PAGEFLAG(Active, active, ANY) __CLEARPAGEFLAG(Active, active, ANY)
-	TESTCLEARFLAG(Active, active, ANY)
+PAGEFLAG(LRU, lru, HEAD) __CLEARPAGEFLAG(LRU, lru, HEAD)
+PAGEFLAG(Active, active, HEAD) __CLEARPAGEFLAG(Active, active, HEAD)
+	TESTCLEARFLAG(Active, active, HEAD)
 __PAGEFLAG(Slab, slab, ANY)
 PAGEFLAG(Checked, checked, NO_COMPOUND) /* Used by some filesystems */
 PAGEFLAG(Pinned, pinned, ANY) TESTSCFLAG(Pinned, pinned, ANY)	/* Xen */
@@ -291,9 +292,9 @@ PAGEFLAG(SwapCache, swapcache, ANY)
 PAGEFLAG_FALSE(SwapCache)
 #endif
 
-PAGEFLAG(Unevictable, unevictable, ANY)
-	__CLEARPAGEFLAG(Unevictable, unevictable, ANY)
-	TESTCLEARFLAG(Unevictable, unevictable, ANY)
+PAGEFLAG(Unevictable, unevictable, HEAD)
+	__CLEARPAGEFLAG(Unevictable, unevictable, HEAD)
+	TESTCLEARFLAG(Unevictable, unevictable, HEAD)
 
 #ifdef CONFIG_MMU
 PAGEFLAG(Mlocked, mlocked, ANY) __CLEARPAGEFLAG(Mlocked, mlocked, ANY)
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

rcu-force-alignment-on-struct-callback_head-rcu_head.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
mm-drop-page-slab_page.patch
slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast.patch
zsmalloc-use-page-private-instead-of-page-first_page.patch
mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page.patch
mm-make-compound_head-robust.patch
mm-use-unsigned-int-for-page-order.patch
mm-use-unsigned-int-for-compound_dtor-compound_order-on-64bit.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-support-madvisemadv_free-fix-3.patch

