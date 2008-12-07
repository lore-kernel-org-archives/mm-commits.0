From: akpm@linux-foundation.org
Subject: + block_write_begin-remove-useless-goto.patch added to -mm tree
Date: Sat, 06 Dec 2008 22:45:41 -0800
Message-ID: <200812070645.mB76jfs0000878@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752130AbYLGGpo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 7 Dec 2008 01:45:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fbuihuu@gmail.com


The patch titled
     block_write_begin(): remove useless goto
has been added to the -mm tree.  Its filename is
     block_write_begin-remove-useless-goto.patch

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
Subject: block_write_begin(): remove useless goto
From: Franck Bui-Huu <fbuihuu@gmail.com>

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/buffer.c~block_write_begin-remove-useless-goto fs/buffer.c
--- a/fs/buffer.c~block_write_begin-remove-useless-goto
+++ a/fs/buffer.c
@@ -2022,7 +2022,6 @@ int block_write_begin(struct file *file,
 			if (pos + len > inode->i_size)
 				vmtruncate(inode, inode->i_size);
 		}
-		goto out;
 	}
 
 out:
_

Patches currently in -mm which might be from fbuihuu@gmail.com are

do_mpage_readpage-remove-useless-clear_buffer_mapped-call.patch
do_mpage_readpage-remove-first_logical_block-parameter.patch
block_write_begin-remove-useless-goto.patch

