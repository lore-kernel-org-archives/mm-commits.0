From: akpm@linux-foundation.org
Subject: +
 page-flags-look-at-head-page-if-the-flag-is-encoded-in-page-mapping.patch
 added to -mm tree
Date: Wed, 30 Sep 2015 15:10:02 -0700
Message-ID: <560c5dba.vycxNta4zkOlpEpg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55707 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbbI3WKD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Sep 2015 18:10:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: page-flags: look at head page if the flag is encoded in p=
age->mapping
has been added to the -mm tree.  Its filename is
     page-flags-look-at-head-page-if-the-flag-is-encoded-in-page-mappin=
g.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/page-flags-look-at-head-pa=
ge-if-the-flag-is-encoded-in-page-mapping.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/page-flags-look-at-head-pa=
ge-if-the-flag-is-encoded-in-page-mapping.patch

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
Subject: page-flags: look at head page if the flag is encoded in page->=
mapping

PageAnon() and PageKsm() look at lower bits of page->mapping to check i=
f
the page is Anon or KSM.  page->mapping can be overloaded in tail pages=
=2E

Let's always look at head page to avoid false-positives.

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

 include/linux/page-flags.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/page-flags.h~page-flags-look-at-head-page-if-th=
e-flag-is-encoded-in-page-mapping include/linux/page-flags.h
--- a/include/linux/page-flags.h~page-flags-look-at-head-page-if-the-fl=
ag-is-encoded-in-page-mapping
+++ a/include/linux/page-flags.h
@@ -369,6 +369,7 @@ PAGEFLAG(Idle, idle, PF_ANY)
=20
 static inline int PageAnon(struct page *page)
 {
+	page =3D compound_head(page);
 	return ((unsigned long)page->mapping & PAGE_MAPPING_ANON) !=3D 0;
 }
=20
@@ -381,6 +382,7 @@ static inline int PageAnon(struct page *
  */
 static inline int PageKsm(struct page *page)
 {
+	page =3D compound_head(page);
 	return ((unsigned long)page->mapping & PAGE_MAPPING_FLAGS) =3D=3D
 				(PAGE_MAPPING_ANON | PAGE_MAPPING_KSM);
 }
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
