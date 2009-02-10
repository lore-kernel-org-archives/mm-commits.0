From: akpm@linux-foundation.org
Subject: + vfs-check-bh-b_blocknr-only-if-bh_mapped-is-set.patch added to -mm tree
Date: Tue, 10 Feb 2009 12:48:25 -0800
Message-ID: <200902102048.n1AKmP59022123@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754472AbZBJUsb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Feb 2009 15:48:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: knikanth@suse.de


The patch titled
     vfs: check bh->b_blocknr only if BH_Mapped is set
has been added to the -mm tree.  Its filename is
     vfs-check-bh-b_blocknr-only-if-bh_mapped-is-set.patch

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
Subject: vfs: check bh->b_blocknr only if BH_Mapped is set
From: Nikanth Karthikesan <knikanth@suse.de>

Check bh->b_blocknr only if BH_Mapped is set.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/buffer.c~vfs-check-bh-b_blocknr-only-if-bh_mapped-is-set fs/buffer.c
--- a/fs/buffer.c~vfs-check-bh-b_blocknr-only-if-bh_mapped-is-set
+++ a/fs/buffer.c
@@ -344,13 +344,13 @@ __find_get_block_slow(struct block_devic
 	head = page_buffers(page);
 	bh = head;
 	do {
-		if (bh->b_blocknr == block) {
+		if (!buffer_mapped(bh))
+			all_mapped = 0;
+		else if (bh->b_blocknr == block) {
 			ret = bh;
 			get_bh(bh);
 			goto out_unlock;
 		}
-		if (!buffer_mapped(bh))
-			all_mapped = 0;
 		bh = bh->b_this_page;
 	} while (bh != head);
 
_

Patches currently in -mm which might be from knikanth@suse.de are

vfs-check-bh-b_blocknr-only-if-bh_mapped-is-set.patch

