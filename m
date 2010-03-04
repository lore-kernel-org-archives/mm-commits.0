From: akpm@linux-foundation.org
Subject: [nacked] swapfile-fix-the-wrong-return-value.patch removed from -mm tree
Date: Thu, 04 Mar 2010 13:39:26 -0800
Message-ID: <201003042139.o24LdQEa031424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754219Ab0CDVjd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Mar 2010 16:39:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shijie8@gmail.com, hugh.dickins@tiscali.co.uk, mm-commits@vger.kernel.org


The patch titled
     swapfile: fix wrong return value
has been removed from the -mm tree.  Its filename was
     swapfile-fix-the-wrong-return-value.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: swapfile: fix wrong return value
From: Huang Shijie <shijie8@gmail.com>

If __swap_duplicate() returns a negative value except of the -ENOMEM, but
the err is zero at this time, the return value of swap_duplicate() is
wrong in this situation.

The callers such as try_to_unmap_one(), will do the wrong operation in
this situation.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swapfile.c~swapfile-fix-the-wrong-return-value mm/swapfile.c
--- a/mm/swapfile.c~swapfile-fix-the-wrong-return-value
+++ a/mm/swapfile.c
@@ -2170,7 +2170,7 @@ int swap_duplicate(swp_entry_t entry)
 {
 	int err = 0;
 
-	while (!err && __swap_duplicate(entry, 1) == -ENOMEM)
+	while (!err && (err = __swap_duplicate(entry, 1)) == -ENOMEM)
 		err = add_swap_count_continuation(entry, GFP_ATOMIC);
 	return err;
 }
_

Patches currently in -mm which might be from shijie8@gmail.com are

origin.patch
linux-next.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix-2.patch
swapfile-fix-the-wrong-return-value.patch

