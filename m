From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-munlock-batch-non-thp-page-isolation-and-munlockputback-using-pagevec-fix.patch removed from -mm tree
Date: Wed, 11 Sep 2013 14:00:07 -0700
Message-ID: <5230d9d7.DmBOyYxP07oXeyif%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49104 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628Ab3IKVAI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 17:00:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz

Subject: [folded-merged] mm-munlock-batch-non-thp-page-isolation-and-munlockputback-using-pagevec-fix.patch removed from -mm tree
To: vbabka@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 14:00:07 -0700


The patch titled
     Subject:  mm-munlock-batch-non-thp-page-isolation-and-munlockputback-using-pagevec-fix
has been removed from the -mm tree.  Its filename was
     mm-munlock-batch-non-thp-page-isolation-and-munlockputback-using-pagevec-fix.patch

This patch was dropped because it was folded into mm-munlock-batch-non-thp-page-isolation-and-munlockputback-using-pagevec.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject:  mm-munlock-batch-non-thp-page-isolation-and-munlockputback-using-pagevec-fix

Clarify in __munlock_pagevec() comment that pagegec is modified and
reinited.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/mlock.c~mm-munlock-batch-non-thp-page-isolation-and-munlockputback-using-pagevec-fix mm/mlock.c
--- a/mm/mlock.c~mm-munlock-batch-non-thp-page-isolation-and-munlockputback-using-pagevec-fix
+++ a/mm/mlock.c
@@ -233,6 +233,9 @@ static int __mlock_posix_error_return(lo
  * and attempts to isolate the pages, all under a single zone lru lock.
  * The second phase finishes the munlock only for pages where isolation
  * succeeded.
+ *
+ * Note that pvec is modified during the process. Before returning
+ * pagevec_reinit() is called on it.
  */
 static void __munlock_pagevec(struct pagevec *pvec, struct zone *zone)
 {
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-putback_lru_page-remove-unnecessary-call-to-page_lru_base_type.patch
mm-munlock-remove-unnecessary-call-to-lru_add_drain.patch
mm-munlock-batch-non-thp-page-isolation-and-munlockputback-using-pagevec.patch
mm-munlock-batch-nr_mlock-zone-state-updates.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix.patch
mm-munlock-remove-redundant-get_page-put_page-pair-on-the-fast-path.patch
mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask.patch
mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask-v3.patch

