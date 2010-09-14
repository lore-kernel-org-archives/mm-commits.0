From: akpm@linux-foundation.org
Subject: + vmscan-delete-dead-code.patch added to -mm tree
Date: Tue, 14 Sep 2010 16:33:55 -0700
Message-ID: <201009142333.o8ENXtMG024955@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39030 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752035Ab0INXd7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Sep 2010 19:33:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     vmscan: delete dead code
has been added to the -mm tree.  Its filename is
     vmscan-delete-dead-code.patch

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
Subject: vmscan: delete dead code
From: Shaohua Li <shaohua.li@intel.com>

`priority' cannot be negative here.  And the comment is obsolete.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN mm/vmscan.c~vmscan-delete-dead-code mm/vmscan.c
--- a/mm/vmscan.c~vmscan-delete-dead-code
+++ a/mm/vmscan.c
@@ -2033,16 +2033,6 @@ static unsigned long do_try_to_free_page
 	}
 
 out:
-	/*
-	 * Now that we've scanned all the zones at this priority level, note
-	 * that level within the zone so that the next thread which performs
-	 * scanning of this zone will immediately start out at this priority
-	 * level.  This affects only the decision whether or not to bring
-	 * mapped pages onto the inactive list.
-	 */
-	if (priority < 0)
-		priority = 0;
