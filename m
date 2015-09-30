From: akpm@linux-foundation.org
Subject: [to-be-updated]
 page-flags-define-pg_reserved-behavior-on-compound-pages.patch removed from -mm tree
Date: Wed, 30 Sep 2015 14:56:45 -0700
Message-ID: <560c5a9d.apLAkCmLGnsTYp5h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52670 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742AbbI3V4q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Sep 2015 17:56:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: page-flags: define PG_reserved behavior on compound pages
has been removed from the -mm tree.  Its filename was
     page-flags-define-pg_reserved-behavior-on-compound-pages.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: page-flags: define PG_reserved behavior on compound pages

As far as I can see there's no users of PG_reserved on compound pages.
Let's use NO_COMPOUND here.

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

 include/linux/page-flags.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/page-flags.h~page-flags-define-pg_reserved-behavior-on-compound-pages include/linux/page-flags.h
--- a/include/linux/page-flags.h~page-flags-define-pg_reserved-behavior-on-compound-pages
+++ a/include/linux/page-flags.h
@@ -248,7 +248,8 @@ PAGEFLAG(Pinned, pinned, NO_COMPOUND) TE
 PAGEFLAG(SavePinned, savepinned, NO_COMPOUND)
 PAGEFLAG(Foreign, foreign, NO_COMPOUND)
 
-PAGEFLAG(Reserved, reserved, ANY) __CLEARPAGEFLAG(Reserved, reserved, ANY)
+PAGEFLAG(Reserved, reserved, NO_COMPOUND)
+	__CLEARPAGEFLAG(Reserved, reserved, NO_COMPOUND)
 PAGEFLAG(SwapBacked, swapbacked, ANY)
 	__CLEARPAGEFLAG(SwapBacked, swapbacked, ANY)
 	__SETPAGEFLAG(SwapBacked, swapbacked, ANY)
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
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-support-madvisemadv_free-fix-3.patch

