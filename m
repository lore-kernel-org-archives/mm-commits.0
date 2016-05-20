From: akpm@linux-foundation.org
Subject: [patch 042/117] mm/hugetlb: optimize minimum size (min_size)
 accounting
Date: Thu, 19 May 2016 17:11:01 -0700
Message-ID: <573e5615.w2sb+cp3wy3A/Hn3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46098 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298AbcETALD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:11:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mike.kravetz@oracle.com, dave.hansen@linux.intel.com, hillf.zj@alibaba-inc.com, kirill.shutemov@linux.intel.com, n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, rientjes@google.com

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
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
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
