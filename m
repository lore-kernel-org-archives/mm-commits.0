From: akpm@linux-foundation.org
Subject: + rmap-simplify-try_to_unmap_file.patch added to -mm tree
Date: Tue, 03 Nov 2009 14:07:50 -0800
Message-ID: <200911032207.nA3M7oCd008463@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755212AbZKCWIh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 17:08:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shijie8@gmail.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     rmap: simplify try_to_unmap_file()
has been added to the -mm tree.  Its filename is
     rmap-simplify-try_to_unmap_file.patch

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
Subject: rmap: simplify try_to_unmap_file()
From: Huang Shijie <shijie8@gmail.com>

Just simplify the code when `mlocked' is true.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/rmap.c~rmap-simplify-try_to_unmap_file mm/rmap.c
--- a/mm/rmap.c~rmap-simplify-try_to_unmap_file
+++ a/mm/rmap.c
@@ -1103,13 +1103,10 @@ static int try_to_unmap_file(struct page
 		if (ret == SWAP_MLOCK) {
 			mlocked = try_to_mlock_page(page, vma);
 			if (mlocked)
-				break;  /* stop if actually mlocked page */
+				goto out;  /* stop if actually mlocked page */
 		}
 	}
 
-	if (mlocked)
-		goto out;
