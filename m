From: akpm@linux-foundation.org
Subject: [merged]
 page-flags-define-pg_mlocked-behavior-on-compound-pages.patch removed from
 -mm tree
Date: Tue, 19 Jan 2016 12:01:04 -0800
Message-ID: <569e9600.AcRbfqM8YIrsPO3l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42490 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933005AbcASUBF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:01:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: page-flags: define PG_mlocked behavior on compound pages
has been removed from the -mm tree.  Its filename was
     page-flags-define-pg_mlocked-behavior-on-compound-pages.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: page-flags: define PG_mlocked behavior on compound pages

Transparent huge pages can be mlocked -- whole compund page at once.
Something went wrong if we're trying to mlock() tail page.
Let's use PF_NO_TAIL.

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

 include/linux/page-flags.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/page-flags.h~page-flags-define-pg_mlocked-behav=
ior-on-compound-pages include/linux/page-flags.h
--- a/include/linux/page-flags.h~page-flags-define-pg_mlocked-behavior-=
on-compound-pages
+++ a/include/linux/page-flags.h
@@ -328,8 +328,10 @@ PAGEFLAG(Unevictable, unevictable, PF_HE
 	TESTCLEARFLAG(Unevictable, unevictable, PF_HEAD)
=20
 #ifdef CONFIG_MMU
-PAGEFLAG(Mlocked, mlocked, PF_ANY) __CLEARPAGEFLAG(Mlocked, mlocked, P=
=46_ANY)
-	TESTSCFLAG(Mlocked, mlocked, PF_ANY) __TESTCLEARFLAG(Mlocked, mlocked=
, PF_ANY)
+PAGEFLAG(Mlocked, mlocked, PF_NO_TAIL)
+	__CLEARPAGEFLAG(Mlocked, mlocked, PF_NO_TAIL)
+	TESTSCFLAG(Mlocked, mlocked, PF_NO_TAIL)
+	__TESTCLEARFLAG(Mlocked, mlocked, PF_NO_TAIL)
 #else
 PAGEFLAG_FALSE(Mlocked) __CLEARPAGEFLAG_NOOP(Mlocked)
 	TESTSCFLAG_FALSE(Mlocked) __TESTCLEARFLAG_FALSE(Mlocked)
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
