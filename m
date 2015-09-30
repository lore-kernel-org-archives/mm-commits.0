From: akpm@linux-foundation.org
Subject: [to-be-updated]
 page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
 removed from -mm tree
Date: Wed, 30 Sep 2015 14:56:33 -0700
Message-ID: <560c5a91.YcFBNEIUOJUjr0YY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52591 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbbI3V4e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Sep 2015 17:56:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: page-flags: define behavior of FS/IO-related flags on compound pages
has been removed from the -mm tree.  Its filename was
     page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: page-flags: define behavior of FS/IO-related flags on compound pages

It seems we don't have compound page on FS/IO path currently.  Use
NO_COMPOUND to catch if we have.

The odd exception is PG_dirty: sound uses compound pages and maps them
with PTEs.  NO_COMPOUND triggers VM_BUG_ON() in set_page_dirty() on
handling shared fault.  Let's use HEAD for PG_dirty.

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

 include/linux/page-flags.h |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff -puN include/linux/page-flags.h~page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages include/linux/page-flags.h
--- a/include/linux/page-flags.h~page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages
+++ a/include/linux/page-flags.h
@@ -230,16 +230,16 @@ static inline int PageTail(struct page *
 static inline struct page *compound_head(struct page *page);
 
 __PAGEFLAG(Locked, locked, NO_TAIL)
-PAGEFLAG(Error, error, ANY) TESTCLEARFLAG(Error, error, ANY)
+PAGEFLAG(Error, error, NO_COMPOUND) TESTCLEARFLAG(Error, error, NO_COMPOUND)
 PAGEFLAG(Referenced, referenced, ANY) TESTCLEARFLAG(Referenced, referenced, ANY)
 	__SETPAGEFLAG(Referenced, referenced, ANY)
-PAGEFLAG(Dirty, dirty, ANY) TESTSCFLAG(Dirty, dirty, ANY)
-	__CLEARPAGEFLAG(Dirty, dirty, ANY)
+PAGEFLAG(Dirty, dirty, HEAD) TESTSCFLAG(Dirty, dirty, HEAD)
+	__CLEARPAGEFLAG(Dirty, dirty, HEAD)
 PAGEFLAG(LRU, lru, ANY) __CLEARPAGEFLAG(LRU, lru, ANY)
 PAGEFLAG(Active, active, ANY) __CLEARPAGEFLAG(Active, active, ANY)
 	TESTCLEARFLAG(Active, active, ANY)
 __PAGEFLAG(Slab, slab, ANY)
-PAGEFLAG(Checked, checked, ANY)		/* Used by some filesystems */
+PAGEFLAG(Checked, checked, NO_COMPOUND) /* Used by some filesystems */
 PAGEFLAG(Pinned, pinned, ANY) TESTSCFLAG(Pinned, pinned, ANY)	/* Xen */
 PAGEFLAG(SavePinned, savepinned, ANY);			/* Xen */
 PAGEFLAG(Foreign, foreign, ANY);				/* Xen */
@@ -265,12 +265,15 @@ PAGEFLAG(OwnerPriv1, owner_priv_1, ANY)
  * Only test-and-set exist for PG_writeback.  The unconditional operators are
  * risky: they bypass page accounting.
  */
-TESTPAGEFLAG(Writeback, writeback, ANY) TESTSCFLAG(Writeback, writeback, ANY)
-PAGEFLAG(MappedToDisk, mappedtodisk, ANY)
+TESTPAGEFLAG(Writeback, writeback, NO_COMPOUND)
+	TESTSCFLAG(Writeback, writeback, NO_COMPOUND)
+PAGEFLAG(MappedToDisk, mappedtodisk, NO_COMPOUND)
 
 /* PG_readahead is only used for reads; PG_reclaim is only for writes */
-PAGEFLAG(Reclaim, reclaim, ANY) TESTCLEARFLAG(Reclaim, reclaim, ANY)
-PAGEFLAG(Readahead, reclaim, ANY) TESTCLEARFLAG(Readahead, reclaim, ANY)
+PAGEFLAG(Reclaim, reclaim, NO_COMPOUND)
+	TESTCLEARFLAG(Reclaim, reclaim, NO_COMPOUND)
+PAGEFLAG(Readahead, reclaim, NO_COMPOUND)
+	TESTCLEARFLAG(Readahead, reclaim, NO_COMPOUND)
 
 #ifdef CONFIG_HIGHMEM
 /*
@@ -386,7 +389,7 @@ static inline int PageUptodate(struct pa
 static inline void __SetPageUptodate(struct page *page)
 {
 	smp_wmb();
-	__set_bit(PG_uptodate, &(page)->flags);
+	__set_bit(PG_uptodate, &page->flags);
 }
 
 static inline void SetPageUptodate(struct page *page)
@@ -397,7 +400,7 @@ static inline void SetPageUptodate(struc
 	 * uptodate are actually visible before PageUptodate becomes true.
 	 */
 	smp_wmb();
-	set_bit(PG_uptodate, &(page)->flags);
+	set_bit(PG_uptodate, &page->flags);
 }
 
 CLEARPAGEFLAG(Uptodate, uptodate, ANY)
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
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
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

