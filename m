From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-resv-map-memory-leak-for-placeholder-entries-v2.patch added to
 -mm tree
Date: Wed, 02 Dec 2015 13:46:00 -0800
Message-ID: <565f6698.hJGKwOZUmgioR6kV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbbLBVqB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2015 16:46:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, dvyukov@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-resv-map-memory-leak-for-placeholder-entries-v2
has been added to the -mm tree.  Its filename is
     mm-hugetlb-resv-map-memory-leak-for-placeholder-entries-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-resv-map-memory-leak-for-placeholder-entries-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-resv-map-memory-leak-for-placeholder-entries-v2.patch

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
mm-hugetlb-resv-map-memory-leak-for-placeholder-entries-v2.patch

