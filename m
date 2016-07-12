From: akpm@linux-foundation.org
Subject: +
 mm-rmap-call-page_check_address-with-sync-enabled-to-avoid-racy-check.patch added to -mm tree
Date: Tue, 12 Jul 2016 10:46:03 -0700
Message-ID: <57852cdb.Zr5BhRwWUlijtfQB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38182 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbcGLRqF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Jul 2016 13:46:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rmap: call page_check_address() with sync enabled to avoid racy check
has been added to the -mm tree.  Its filename is
     mm-rmap-call-page_check_address-with-sync-enabled-to-avoid-racy-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-call-page_check_address-with-sync-enabled-to-avoid-racy-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-call-page_check_address-with-sync-enabled-to-avoid-racy-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: rmap: call page_check_address() with sync enabled to avoid racy check

The previous patch addresses the race between split_huge_pmd_address() and
someone changing the pmd. The fix is only for splitting of normal thp
(i.e. pmd-mapped thp,) and for splitting of pte-mapped thp there still is
the similar race.

For splitting pte-mapped thp, the pte's conversion is done by
try_to_unmap_one(TTU_MIGRATION). This function checks page_check_address() to
get the target pte, but it can return NULL under some race, leading to
VM_BUG_ON() in freeze_page(). Fortunately, page_check_address() already has
an argument to decide whether we do a quick/racy check or not, so let's flip
it when called from freeze_page().

Link: http://lkml.kernel.org/r/1466990929-7452-2-git-send-email-n-horiguchi@ah.jp.nec.com
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 1 file changed, 2 insertions(+), 1 deletion(-)

index 256e585..a8bce293 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/rmap.c~mm-rmap-call-page_check_address-with-sync-enabled-to-avoid-racy-check mm/rmap.c
--- a/mm/rmap.c~mm-rmap-call-page_check_address-with-sync-enabled-to-avoid-racy-check
+++ a/mm/rmap.c
@@ -1427,7 +1427,8 @@ static int try_to_unmap_one(struct page
 			goto out;
 	}
 
-	pte = page_check_address(page, mm, address, &ptl, 0);
+	pte = page_check_address(page, mm, address, &ptl,
+				 PageTransCompound(page));
 	if (!pte)
 		goto out;
 
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-thp-move-pmd-check-inside-ptl-for-freeze_page.patch
mm-rmap-call-page_check_address-with-sync-enabled-to-avoid-racy-check.patch
mm-thp-check-pmd_trans_unstable-after-split_huge_pmd.patch

