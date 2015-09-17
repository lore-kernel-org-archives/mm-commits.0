From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-make-inactive_anon_is_low_global-return-directly.patch added to
 -mm tree
Date: Thu, 17 Sep 2015 14:37:41 -0700
Message-ID: <55fb32a5.k5vKOFDqImAdemxM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51990 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbbIQVhl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Sep 2015 17:37:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: make inactive_anon_is_low_global return directly
has been added to the -mm tree.  Its filename is
     mm-vmscan-make-inactive_anon_is_low_global-return-directly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-make-inactive_anon_is_low_global-return-directly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-make-inactive_anon_is_low_global-return-directly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: mm/vmscan: make inactive_anon_is_low_global return directly

Delete unnecessary if to let inactive_anon_is_low_global return
directly.

No functional changes.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-make-inactive_anon_is_low_global-return-directly mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-make-inactive_anon_is_low_global-return-directly
+++ a/mm/vmscan.c
@@ -1866,10 +1866,7 @@ static int inactive_anon_is_low_global(s
 	active = zone_page_state(zone, NR_ACTIVE_ANON);
 	inactive = zone_page_state(zone, NR_INACTIVE_ANON);
 
-	if (inactive * zone->inactive_ratio < active)
-		return 1;
