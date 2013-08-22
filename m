From: akpm@linux-foundation.org
Subject: +
 mm-munlock-batch-non-thp-page-isolation-and-munlockputback-using-pagevec-fix.patch added to -mm tree
Date: Thu, 22 Aug 2013 15:50:33 -0700
Message-ID: <521695b9.T+fErZHU/jE34OEL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47422 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab3HVWud (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Aug 2013 18:50:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz

Subject: + mm-munlock-batch-non-thp-page-isolation-and-munlockputback-using-pagevec-fix.patch added to -mm tree
To: vbabka@suse.cz
From: akpm@linux-foundation.org
Date: Thu, 22 Aug 2013 15:50:33 -0700


The patch titled
     Subject:  mm-munlock-batch-non-thp-page-isolation-and-munlockputback-using-pagevec-fix
has been added to the -mm tree.  Its filename is
     mm-munlock-batch-non-thp-page-isolation-and-munlockputback-using-pagevec-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-munlock-batch-non-thp-page-isolation-and-munlockputback-using-pagevec-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-munlock-batch-non-thp-page-isolation-and-munlockputback-using-pagevec-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-munlock-batch-non-thp-page-isolation-and-munlockputback-using-pagevec-fix.patch
mm-munlock-batch-nr_mlock-zone-state-updates.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix.patch
mm-munlock-remove-redundant-get_page-put_page-pair-on-the-fast-path.patch
mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask.patch

