From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hugetlb-resv-map-memory-leak-for-placeholder-entries-v2.patch removed
 from -mm tree
Date: Fri, 11 Dec 2015 13:37:45 -0800
Message-ID: <566b4229.ZMwOK2DZ0lOPKgTT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44115 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbbLKVhq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Dec 2015 16:37:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, dvyukov@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-resv-map-memory-leak-for-placeholder-entries-v2
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-resv-map-memory-leak-for-placeholder-entries-v2.patch

This patch was dropped because it was folded into mm-hugetlb-resv-map-memory-leak-for-placeholder-entries.patch

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm-hugetlb-resv-map-memory-leak-for-placeholder-entries-v2

V2: The original version of the patch did not correctly handle placeholder
    entries before the range to be deleted.  The new check is more specific
    and only matches placeholders at the start of range.

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-resv-map-memory-leak-for-placeholder-entries-v2 mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-resv-map-memory-leak-for-placeholder-entries-v2
+++ a/mm/hugetlb.c
@@ -486,13 +486,15 @@ retry:
 	spin_lock(&resv->lock);
 	list_for_each_entry_safe(rg, trg, head, link) {
 		/*
-		 * file_region ranges are normally of the form [from, to).
-		 * However, there may be a "placeholder" entry in the map
-		 * which is of the form (from, to) with from == to.  Check
-		 * for placeholder entries as well.
+		 * Skip regions before the range to be deleted.  file_region
+		 * ranges are normally of the form [from, to).  However, there
+		 * may be a "placeholder" entry in the map which is of the form
+		 * (from, to) with from == to.  Check for placeholder entries
+		 * at the beginning of the range to be deleted.
 		 */
-		if (rg->to <= f && rg->to != rg->from)
+		if (rg->to <= f && (rg->to != rg->from || rg->to != f))
 			continue;
+
 		if (rg->from >= t)
 			break;
 
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

mm-hugetlb-resv-map-memory-leak-for-placeholder-entries.patch

