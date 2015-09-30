From: akpm@linux-foundation.org
Subject: +
 page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
 added to -mm tree
Date: Wed, 30 Sep 2015 15:09:41 -0700
Message-ID: <560c5da5.lDUHOtZFuEAi3cr6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55569 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbbI3WJm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Sep 2015 18:09:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: page-flags: define behavior of FS/IO-related flags on com=
pound pages
has been added to the -mm tree.  Its filename is
     page-flags-define-behavior-of-fs-io-related-flags-on-compound-page=
s.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/page-flags-define-behavior=
-of-fs-io-related-flags-on-compound-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/page-flags-define-behavior=
-of-fs-io-related-flags-on-compound-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: page-flags: define behavior of FS/IO-related flags on compound=
 pages

It seems we don't have compound page on FS/IO path currently.
Use PF_NO_COMPOUND to catch if we have.

The odd exception is PG_dirty: sound uses compound pages and maps them
with PTEs.  PF_NO_COMPOUND triggers VM_BUG_ON() in set_page_dirty() on
handling shared fault.  Let's use PF_HEAD for PG_dirty.

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

 include/linux/page-flags.h |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff -puN include/linux/page-flags.h~page-flags-define-behavior-of-fs-i=
o-related-flags-on-compound-pages include/linux/page-flags.h
--- a/include/linux/page-flags.h~page-flags-define-behavior-of-fs-io-re=
lated-flags-on-compound-pages
+++ a/include/linux/page-flags.h
@@ -245,16 +245,16 @@ static inline int __TestClearPage##uname
 	TESTSETFLAG_FALSE(uname) TESTCLEARFLAG_FALSE(uname)
=20
 __PAGEFLAG(Locked, locked, PF_NO_TAIL)
-PAGEFLAG(Error, error, PF_ANY) TESTCLEARFLAG(Error, error, PF_ANY)
+PAGEFLAG(Error, error, PF_NO_COMPOUND) TESTCLEARFLAG(Error, error, PF_=
NO_COMPOUND)
 PAGEFLAG(Referenced, referenced, PF_ANY) TESTCLEARFLAG(Referenced, ref=
erenced, PF_ANY)
 	__SETPAGEFLAG(Referenced, referenced, PF_ANY)
-PAGEFLAG(Dirty, dirty, PF_ANY) TESTSCFLAG(Dirty, dirty, PF_ANY)
-	__CLEARPAGEFLAG(Dirty, dirty, PF_ANY)
+PAGEFLAG(Dirty, dirty, PF_HEAD) TESTSCFLAG(Dirty, dirty, PF_HEAD)
+	__CLEARPAGEFLAG(Dirty, dirty, PF_HEAD)
 PAGEFLAG(LRU, lru, PF_ANY) __CLEARPAGEFLAG(LRU, lru, PF_ANY)
 PAGEFLAG(Active, active, PF_ANY) __CLEARPAGEFLAG(Active, active, PF_AN=
Y)
 	TESTCLEARFLAG(Active, active, PF_ANY)
 __PAGEFLAG(Slab, slab, PF_ANY)
-PAGEFLAG(Checked, checked, PF_ANY)		/* Used by some filesystems */
+PAGEFLAG(Checked, checked, PF_NO_COMPOUND)	   /* Used by some filesyst=
ems */
 PAGEFLAG(Pinned, pinned, PF_ANY) TESTSCFLAG(Pinned, pinned, PF_ANY)	/*=
 Xen */
 PAGEFLAG(SavePinned, savepinned, PF_ANY);			/* Xen */
 PAGEFLAG(Foreign, foreign, PF_ANY);				/* Xen */
@@ -280,12 +280,15 @@ PAGEFLAG(OwnerPriv1, owner_priv_1, PF_AN
  * Only test-and-set exist for PG_writeback.  The unconditional operat=
ors are
  * risky: they bypass page accounting.
  */
-TESTPAGEFLAG(Writeback, writeback, PF_ANY) TESTSCFLAG(Writeback, write=
back, PF_ANY)
-PAGEFLAG(MappedToDisk, mappedtodisk, PF_ANY)
+TESTPAGEFLAG(Writeback, writeback, PF_NO_COMPOUND)
+	TESTSCFLAG(Writeback, writeback, PF_NO_COMPOUND)
+PAGEFLAG(MappedToDisk, mappedtodisk, PF_NO_COMPOUND)
=20
 /* PG_readahead is only used for reads; PG_reclaim is only for writes =
*/
-PAGEFLAG(Reclaim, reclaim, PF_ANY) TESTCLEARFLAG(Reclaim, reclaim, PF_=
ANY)
-PAGEFLAG(Readahead, reclaim, PF_ANY) TESTCLEARFLAG(Readahead, reclaim,=
 PF_ANY)
+PAGEFLAG(Reclaim, reclaim, PF_NO_COMPOUND)
+	TESTCLEARFLAG(Reclaim, reclaim, PF_NO_COMPOUND)
+PAGEFLAG(Readahead, reclaim, PF_NO_COMPOUND)
+	TESTCLEARFLAG(Readahead, reclaim, PF_NO_COMPOUND)
=20
 #ifdef CONFIG_HIGHMEM
 /*
@@ -401,7 +404,7 @@ static inline int PageUptodate(struct pa
 static inline void __SetPageUptodate(struct page *page)
 {
 	smp_wmb();
-	__set_bit(PG_uptodate, &(page)->flags);
+	__set_bit(PG_uptodate, &page->flags);
 }
=20
 static inline void SetPageUptodate(struct page *page)
@@ -412,7 +415,7 @@ static inline void SetPageUptodate(struc
 	 * uptodate are actually visible before PageUptodate becomes true.
 	 */
 	smp_wmb();
-	set_bit(PG_uptodate, &(page)->flags);
+	set_bit(PG_uptodate, &page->flags);
 }
=20
 CLEARPAGEFLAG(Uptodate, uptodate, PF_ANY)
_

Patches currently in -mm which might be from kirill.shutemov@linux.inte=
l.com are

rcu-force-alignment-on-struct-callback_head-rcu_head.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
mm-drop-page-slab_page.patch
slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast.patch
zsmalloc-use-page-private-instead-of-page-first_page.patch
mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page.p=
atch
mm-make-compound_head-robust.patch
mm-use-unsigned-int-for-page-order.patch
mm-use-unsigned-int-for-compound_dtor-compound_order-on-64bit.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-move-code-around.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.pat=
ch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-at-head-page-if-the-flag-is-encoded-in-page-mapping.pat=
ch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-support-madvisemadv_free-fix-3.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
