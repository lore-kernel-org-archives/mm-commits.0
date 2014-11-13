From: akpm@linux-foundation.org
Subject: + mm-mincore-add-hwpoison-page-handle.patch added to -mm tree
Date: Thu, 13 Nov 2014 12:08:28 -0800
Message-ID: <54650fbc.7IWWKYQNIqZ4pKra%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933383AbaKMUIa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Nov 2014 15:08:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weijie.yang@samsung.com, hannes@cmpxchg.org, hughd@google.com, mgorman@suse.com, n-horiguchi@ah.jp.nec.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mincore: add hwpoison page handle
has been added to the -mm tree.  Its filename is
     mm-mincore-add-hwpoison-page-handle.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mincore-add-hwpoison-page-handle.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-mincore-add-hwpoison-page-handle.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Weijie Yang <weijie.yang@samsung.com>
Subject: mm: mincore: add hwpoison page handle

When the encountered pte is a swap entry, the current code handles two
cases: migration and normal swapentry, but we have a third case: hwpoison
page.

This patch adds hwpoison page handle, consider hwpoison page incore as
same as migration.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/mincore.c~mm-mincore-add-hwpoison-page-handle mm/mincore.c
--- a/mm/mincore.c~mm-mincore-add-hwpoison-page-handle
+++ a/mm/mincore.c
@@ -137,8 +137,8 @@ static void mincore_pte_range(struct vm_
 		} else { /* pte is a swap entry */
 			swp_entry_t entry = pte_to_swp_entry(pte);
 
-			if (is_migration_entry(entry)) {
-				/* migration entries are always uptodate */
+			if (non_swap_entry(entry)) {
+			/* migration or hwpoison entries are always uptodate */
 				*vec = 1;
 			} else {
 #ifdef CONFIG_SWAP
_

Patches currently in -mm which might be from weijie.yang@samsung.com are

zram-avoid-kunmap_atomic-a-null-pointer.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-mincore-add-hwpoison-page-handle.patch

