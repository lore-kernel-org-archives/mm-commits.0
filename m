From: akpm@linux-foundation.org
Subject: [to-be-updated] ksm-clean-up-page_trans_compound_anon_split.patch removed from -mm tree
Date: Tue, 06 Mar 2012 15:46:57 -0800
Message-ID: <20120306234657.D7203A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:36962 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab2CFXrA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Mar 2012 18:47:00 -0500
Received: by wgbdt11 with SMTP id dt11so210514wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Mar 2012 15:46:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lliubbo@gmail.com, aarcange@redhat.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: clean up page_trans_compound_anon_split()
has been removed from the -mm tree.  Its filename was
     ksm-clean-up-page_trans_compound_anon_split.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Bob Liu <lliubbo@gmail.com>
Subject: ksm: clean up page_trans_compound_anon_split()

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>				
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff -puN mm/ksm.c~ksm-clean-up-page_trans_compound_anon_split mm/ksm.c
--- a/mm/ksm.c~ksm-clean-up-page_trans_compound_anon_split
+++ a/mm/ksm.c
@@ -816,7 +816,7 @@ out:
 
 static int page_trans_compound_anon_split(struct page *page)
 {
-	int ret = 0;
+	int ret = 1;
 	struct page *transhuge_head = page_trans_compound_anon(page);
 	if (transhuge_head) {
 		/* Get the reference on the head to split it. */
@@ -827,16 +827,8 @@ static int page_trans_compound_anon_spli
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

Patches currently in -mm which might be from lliubbo@gmail.com are

origin.patch
linux-next.patch
ksm-cleanup-introduce-ksm_check_mm.patch
ksm-cleanup-introduce-ksm_check_mm-fix.patch

