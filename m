From: akpm@linux-foundation.org
Subject: + swapfile-fix-the-wrong-return-value.patch added to -mm tree
Date: Tue, 02 Mar 2010 16:10:47 -0800
Message-ID: <201003030010.o230AllT006274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753412Ab0CCAKy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Mar 2010 19:10:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shijie8@gmail.com, hugh.dickins@tiscali.co.uk


The patch titled
     swapfile: fix wrong return value
has been added to the -mm tree.  Its filename is
     swapfile-fix-the-wrong-return-value.patch

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

