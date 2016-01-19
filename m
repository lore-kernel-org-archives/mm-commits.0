From: akpm@linux-foundation.org
Subject: [merged]
 page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
 removed from -mm tree
Date: Tue, 19 Jan 2016 12:00:54 -0800
Message-ID: <569e95f6.e39ITSA6xW1pGRGo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932981AbcASUAz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:00:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: page-flags: define behavior SL*B-related flags on compoun=
d pages
has been removed from the -mm tree.  Its filename was
     page-flags-define-behavior-slb-related-flags-on-compound-pages.pat=
ch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: page-flags: define behavior SL*B-related flags on compound pag=
es

SL*B uses compound pages and marks head pages with PG_slab.
__SetPageSlab() and __ClearPageSlab() are never called for tail pages.

The same situation with PG_slob_free in SLOB allocator.

PF_NO_TAIL is appropriate for these flags.

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
Cc: J=E9r=F4me Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN include/linux/page-flags.h~page-flags-define-behavior-slb-rel=
ated-flags-on-compound-pages include/linux/page-flags.h
--- a/include/linux/page-flags.h~page-flags-define-behavior-slb-related=
-flags-on-compound-pages
+++ a/include/linux/page-flags.h
@@ -266,7 +266,8 @@ PAGEFLAG(Dirty, dirty, PF_HEAD) TESTSCFL
 PAGEFLAG(LRU, lru, PF_HEAD) __CLEARPAGEFLAG(LRU, lru, PF_HEAD)
 PAGEFLAG(Active, active, PF_HEAD) __CLEARPAGEFLAG(Active, active, PF_H=
EAD)
 	TESTCLEARFLAG(Active, active, PF_HEAD)
-__PAGEFLAG(Slab, slab, PF_ANY)
+__PAGEFLAG(Slab, slab, PF_NO_TAIL)
+__PAGEFLAG(SlobFree, slob_free, PF_NO_TAIL)
 PAGEFLAG(Checked, checked, PF_NO_COMPOUND)	   /* Used by some filesyst=
ems */
 PAGEFLAG(Pinned, pinned, PF_ANY) TESTSCFLAG(Pinned, pinned, PF_ANY)	/*=
 Xen */
 PAGEFLAG(SavePinned, savepinned, PF_ANY);			/* Xen */
@@ -276,8 +277,6 @@ PAGEFLAG(SwapBacked, swapbacked, PF_ANY)
 	__CLEARPAGEFLAG(SwapBacked, swapbacked, PF_ANY)
 	__SETPAGEFLAG(SwapBacked, swapbacked, PF_ANY)
=20
-__PAGEFLAG(SlobFree, slob_free, PF_ANY)
