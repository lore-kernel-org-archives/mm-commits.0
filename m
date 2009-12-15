From: akpm@linux-foundation.org
Subject: [merged] rmap-simplify-try_to_unmap_file.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:52:08 -0800
Message-ID: <200912152152.nBFLq8kl015170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54270 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761225AbZLOVwi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:52:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shijie8@gmail.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     rmap: simplify try_to_unmap_file()
has been removed from the -mm tree.  Its filename was
     rmap-simplify-try_to_unmap_file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rmap: simplify try_to_unmap_file()
From: Huang Shijie <shijie8@gmail.com>

Just simplify the code when `mlocked' is true.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

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
