From: akpm@linux-foundation.org
Subject: - do_mpage_readpage-remove-useless-clear_buffer_mapped-call.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:12:09 -0800
Message-ID: <200901072212.n07MC9aI012384@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755248AbZAGWMM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:12:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fbuihuu@gmail.com, mm-commits@vger.kernel.org


The patch titled
     do_mpage_readpage(): remove useless clear_buffer_mapped() call
has been removed from the -mm tree.  Its filename was
     do_mpage_readpage-remove-useless-clear_buffer_mapped-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

