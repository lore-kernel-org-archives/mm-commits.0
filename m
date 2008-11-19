From: akpm@linux-foundation.org
Subject: + do_mpage_readpage-remove-useless-clear_buffer_mapped-call.patch added to -mm tree
Date: Wed, 19 Nov 2008 00:31:53 -0800
Message-ID: <200811190831.mAJ8Vr3t013536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751147AbYKSIbz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Nov 2008 03:31:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fbuihuu@gmail.com


The patch titled
     do_mpage_readpage(): remove useless clear_buffer_mapped() call
has been added to the -mm tree.  Its filename is
     do_mpage_readpage-remove-useless-clear_buffer_mapped-call.patch

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
Subject: do_mpage_readpage(): remove useless clear_buffer_mapped() call
From: Franck Bui-Huu <fbuihuu@gmail.com>

It is known that buffer_mapped() is false in this code path.

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/mpage.c~do_mpage_readpage-remove-useless-clear_buffer_mapped-call fs/mpage.c
--- a/fs/mpage.c~do_mpage_readpage-remove-useless-clear_buffer_mapped-call
+++ a/fs/mpage.c
@@ -241,7 +241,6 @@ do_mpage_readpage(struct bio *bio, struc
 				first_hole = page_block;
 			page_block++;
 			block_in_file++;
-			clear_buffer_mapped(map_bh);
 			continue;
 		}
 
_

Patches currently in -mm which might be from fbuihuu@gmail.com are

do_mpage_readpage-remove-useless-clear_buffer_mapped-call.patch

