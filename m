From: akpm@linux-foundation.org
Subject: [patch 17/20] mm: rmap: call page_check_address() with sync
 enabled to avoid racy check
Date: Thu, 14 Jul 2016 12:07:35 -0700
Message-ID: <5787e2f7.Jc7u/9Hg01twvwWI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41020 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbcGNTHg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jul 2016 15:07:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, n-horiguchi@ah.jp.nec.com, kirill.shutemov@linux.intel.com

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
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
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
