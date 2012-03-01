From: akpm@linux-foundation.org
Subject: + ksm-clean-up-page_trans_compound_anon_split.patch added to -mm tree
Date: Thu, 01 Mar 2012 12:51:32 -0800
Message-ID: <20120301205133.42A83A01F8@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:37826 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985Ab2CAUve (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Mar 2012 15:51:34 -0500
Received: by yhgm50 with SMTP id m50so118966yhg.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Mar 2012 12:51:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lliubbo@gmail.com, hughd@google.com, kamezawa.hiroyuki@gmail.com, minchan.kim@gmail.com, rientjes@google.com


The patch titled
     Subject: ksm: clean up page_trans_compound_anon_split()
has been added to the -mm tree.  Its filename is
     ksm-clean-up-page_trans_compound_anon_split.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bob Liu <lliubbo@gmail.com>
Subject: ksm: clean up page_trans_compound_anon_split()

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff -puN mm/ksm.c~ksm-clean-up-page_trans_compound_anon_split mm/ksm.c
--- a/mm/ksm.c~ksm-clean-up-page_trans_compound_anon_split
+++ a/mm/ksm.c
@@ -817,7 +817,7 @@ out:
 
 static int page_trans_compound_anon_split(struct page *page)
 {
-	int ret = 0;
+	int ret = 1;
 	struct page *transhuge_head = page_trans_compound_anon(page);
 	if (transhuge_head) {
 		/* Get the reference on the head to split it. */
@@ -828,16 +828,8 @@ static int page_trans_compound_anon_spli
 			 */
 			if (PageAnon(transhuge_head))
 				ret = split_huge_page(transhuge_head);
-			else
-				/*
-				 * Retry later if split_huge_page run
-				 * from under us.
-				 */
-				ret = 1;
 			put_page(transhuge_head);
-		} else
-			/* Retry later if split_huge_page run from under us. */
-			ret = 1;
+		}
 	}
 	return ret;
 }
_
Subject: Subject: ksm: clean up page_trans_compound_anon_split()

Patches currently in -mm which might be from lliubbo@gmail.com are

linux-next.patch
ksm-clean-up-page_trans_compound_anon_split.patch
ksm-cleanup-introduce-ksm_check_mm.patch
ksm-cleanup-introduce-ksm_check_mm-fix.patch

