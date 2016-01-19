From: akpm@linux-foundation.org
Subject: [merged]
 page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
 removed from -mm tree
Date: Tue, 19 Jan 2016 12:00:52 -0800
Message-ID: <569e95f4.txLbJRkUWu5uUpK8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42456 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932953AbcASUAy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:00:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: page-flags: define behavior of LRU-related flags on compo=
und pages
has been removed from the -mm tree.  Its filename was
     page-flags-define-behavior-of-lru-related-flags-on-compound-pages.=
patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: page-flags: define behavior of LRU-related flags on compound p=
ages

Only head pages are ever on LRU. Let's use PF_HEAD policy to avoid any
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
Cc: J=E9r=F4me Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN include/linux/page-flags.h~page-flags-define-behavior-of-lru-=
related-flags-on-compound-pages include/linux/page-flags.h
--- a/include/linux/page-flags.h~page-flags-define-behavior-of-lru-rela=
ted-flags-on-compound-pages
+++ a/include/linux/page-flags.h
@@ -258,13 +258,14 @@ static inline int __TestClearPage##uname
=20
 __PAGEFLAG(Locked, locked, PF_NO_TAIL)
 PAGEFLAG(Error, error, PF_NO_COMPOUND) TESTCLEARFLAG(Error, error, PF_=
NO_COMPOUND)
-PAGEFLAG(Referenced, referenced, PF_ANY) TESTCLEARFLAG(Referenced, ref=
erenced, PF_ANY)
-	__SETPAGEFLAG(Referenced, referenced, PF_ANY)
+PAGEFLAG(Referenced, referenced, PF_HEAD)
+	TESTCLEARFLAG(Referenced, referenced, PF_HEAD)
+	__SETPAGEFLAG(Referenced, referenced, PF_HEAD)
 PAGEFLAG(Dirty, dirty, PF_HEAD) TESTSCFLAG(Dirty, dirty, PF_HEAD)
 	__CLEARPAGEFLAG(Dirty, dirty, PF_HEAD)
-PAGEFLAG(LRU, lru, PF_ANY) __CLEARPAGEFLAG(LRU, lru, PF_ANY)
-PAGEFLAG(Active, active, PF_ANY) __CLEARPAGEFLAG(Active, active, PF_AN=
Y)
-	TESTCLEARFLAG(Active, active, PF_ANY)
+PAGEFLAG(LRU, lru, PF_HEAD) __CLEARPAGEFLAG(LRU, lru, PF_HEAD)
+PAGEFLAG(Active, active, PF_HEAD) __CLEARPAGEFLAG(Active, active, PF_H=
EAD)
+	TESTCLEARFLAG(Active, active, PF_HEAD)
 __PAGEFLAG(Slab, slab, PF_ANY)
 PAGEFLAG(Checked, checked, PF_NO_COMPOUND)	   /* Used by some filesyst=
ems */
 PAGEFLAG(Pinned, pinned, PF_ANY) TESTSCFLAG(Pinned, pinned, PF_ANY)	/*=
 Xen */
@@ -318,9 +319,9 @@ PAGEFLAG(SwapCache, swapcache, PF_ANY)
 PAGEFLAG_FALSE(SwapCache)
 #endif
=20
-PAGEFLAG(Unevictable, unevictable, PF_ANY)
-	__CLEARPAGEFLAG(Unevictable, unevictable, PF_ANY)
-	TESTCLEARFLAG(Unevictable, unevictable, PF_ANY)
+PAGEFLAG(Unevictable, unevictable, PF_HEAD)
+	__CLEARPAGEFLAG(Unevictable, unevictable, PF_HEAD)
+	TESTCLEARFLAG(Unevictable, unevictable, PF_HEAD)
=20
 #ifdef CONFIG_MMU
 PAGEFLAG(Mlocked, mlocked, PF_ANY) __CLEARPAGEFLAG(Mlocked, mlocked, P=
=46_ANY)
_

Patches currently in -mm which might be from kirill.shutemov@linux.inte=
l.com are

thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch
thp-add-debugfs-handle-to-split-all-huge-pages.patch
thp-increase-split_huge_page-success-rate.patch
thp-fix-split_huge_page-after-mremap-of-thp.patch
memblock-fix-section-mismatch.patch
mm-fix-locking-order-in-mm_take_all_locks.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
