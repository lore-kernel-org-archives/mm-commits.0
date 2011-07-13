From: akpm@linux-foundation.org
Subject: + writeback-account-nr_written-at-io-completion-time.patch added to -mm tree
Date: Wed, 13 Jul 2011 16:27:04 -0700
Message-ID: <201107132327.p6DNR4f5010091@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752530Ab1GMX1g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jul 2011 19:27:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, mrubin@google.com


The patch titled
     writeback: account NR_WRITTEN at IO completion time
has been added to the -mm tree.  Its filename is
     writeback-account-nr_written-at-io-completion-time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1146,7 +1146,6 @@ EXPORT_SYMBOL(account_page_dirtied);
 void account_page_writeback(struct page *page)
 {
 	inc_zone_page_state(page, NR_WRITEBACK);
-	inc_zone_page_state(page, NR_WRITTEN);
 }
 EXPORT_SYMBOL(account_page_writeback);
 
@@ -1363,8 +1362,10 @@ int test_clear_page_writeback(struct pag
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

linux-next.patch
bdi_min_ratio-never-shrinks-ultimately-preventing-valid-setting-of-min_ratio.patch
writeback-account-nr_written-at-io-completion-time.patch

