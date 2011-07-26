From: akpm@linux-foundation.org
Subject: [merged] writeback-account-nr_written-at-io-completion-time.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:53:55 -0700
Message-ID: <201107260752.p6Q7qwPe003187@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753039Ab1GZHx3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:53:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, mrubin@google.com, mm-commits@vger.kernel.org


The patch titled
     writeback: account NR_WRITTEN at IO completion time
has been removed from the -mm tree.  Its filename was
     writeback-account-nr_written-at-io-completion-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback: account NR_WRITTEN at IO completion time
From: Wu Fengguang <fengguang.wu@intel.com>

NR_WRITTEN is now accounted at block IO enqueue time, which is not very
accurate as to common understanding.  This moves NR_WRITTEN accounting to
the IO completion time and makes it more consistent with BDI_WRITTEN,
which is used for bandwidth estimation.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Michael Rubin <mrubin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/page-writeback.c~writeback-account-nr_written-at-io-completion-time mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-account-nr_written-at-io-completion-time
+++ a/mm/page-writeback.c
@@ -1141,7 +1141,6 @@ EXPORT_SYMBOL(account_page_dirtied);
 void account_page_writeback(struct page *page)
 {
 	inc_zone_page_state(page, NR_WRITEBACK);
-	inc_zone_page_state(page, NR_WRITTEN);
 }
 EXPORT_SYMBOL(account_page_writeback);
 
@@ -1358,8 +1357,10 @@ int test_clear_page_writeback(struct pag
 	} else {
 		ret = TestClearPageWriteback(page);
 	}
-	if (ret)
+	if (ret) {
 		dec_zone_page_state(page, NR_WRITEBACK);
+		inc_zone_page_state(page, NR_WRITTEN);
+	}
 	return ret;
 }
 
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch

