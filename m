From: akpm@linux-foundation.org
Subject: + mm-hugetlb-optimize-minimum-size-min_size-accounting.patch
 added to -mm tree
Date: Mon, 28 Mar 2016 14:58:17 -0700
Message-ID: <56f9a8f9.FFzc2NFVwekHVzPO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57792 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbcC1V6S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2016 17:58:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, dave.hansen@linux.intel.com, hillf.zj@alibaba-inc.com, kirill.shutemov@linux.intel.com, n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: optimize minimum size (min_size) accounting
has been added to the -mm tree.  Its filename is
     mm-hugetlb-optimize-minimum-size-min_size-accounting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-optimize-minimum-size-min_size-accounting.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-optimize-minimum-size-min_size-accounting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm/hugetlb: optimize minimum size (min_size) accounting

It was observed that minimum size accounting associated with the
hugetlbfs min_size mount option may not perform optimally and as
expected.  As huge pages/reservations are released from the filesystem
and given back to the global pools, they are reserved for subsequent
filesystem use as long as the subpool reserved count is less than
subpool minimum size.  It does not take into account used pages
within the filesystem.  The filesystem size limits are not exceeded
and this is technically not a bug.  However, better behavior would
be to wait for the number of used pages/reservations associated with
the filesystem to drop below the minimum size before taking reservations
to satisfy minimum size.

An optimization is also made to the hugepage_subpool_get_pages()
routine which is called when pages/reservations are allocated.  This
does not change behavior, but simply avoids the accounting if all
reservations have already been taken (subpool reserved count == 0).

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-optimize-minimum-size-min_size-accounting mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-optimize-minimum-size-min_size-accounting
+++ a/mm/hugetlb.c
@@ -144,7 +144,8 @@ static long hugepage_subpool_get_pages(s
 		}
 	}
 
-	if (spool->min_hpages != -1) {		/* minimum size accounting */
+	/* minimum size accounting */
+	if (spool->min_hpages != -1 && spool->rsv_hpages) {
 		if (delta > spool->rsv_hpages) {
 			/*
 			 * Asking for more reserves than those already taken on
@@ -182,7 +183,8 @@ static long hugepage_subpool_put_pages(s
 	if (spool->max_hpages != -1)		/* maximum size accounting */
 		spool->used_hpages -= delta;
 
-	if (spool->min_hpages != -1) {		/* minimum size accounting */
+	 /* minimum size accounting */
+	if (spool->min_hpages != -1 && spool->used_hpages < spool->min_hpages) {
 		if (spool->rsv_hpages + delta <= spool->min_hpages)
 			ret = 0;
 		else
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

mm-hugetlb-optimize-minimum-size-min_size-accounting.patch

