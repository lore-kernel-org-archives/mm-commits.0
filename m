From: akpm@linux-foundation.org
Subject: + vmalloc-remove-redundant-unlikely.patch added to -mm tree
Date: Thu, 09 Dec 2010 12:47:32 -0800
Message-ID: <201012092047.oB9KlWm4006036@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756838Ab0LIUsH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Dec 2010 15:48:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tklauser@distanz.ch, minchan.kim@gmail.com


The patch titled
     vmalloc: remove redundant unlikely()
has been added to the -mm tree.  Its filename is
     vmalloc-remove-redundant-unlikely.patch

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
Subject: vmalloc: remove redundant unlikely()
From: Tobias Klauser <tklauser@distanz.ch>

IS_ERR() already implies unlikely(), so it can be omitted here.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmalloc.c~vmalloc-remove-redundant-unlikely mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-remove-redundant-unlikely
+++ a/mm/vmalloc.c
@@ -805,7 +805,7 @@ static struct vmap_block *new_vmap_block
 	va = alloc_vmap_area(VMAP_BLOCK_SIZE, VMAP_BLOCK_SIZE,
 					VMALLOC_START, VMALLOC_END,
 					node, gfp_mask);
-	if (unlikely(IS_ERR(va))) {
+	if (IS_ERR(va)) {
 		kfree(vb);
 		return ERR_CAST(va);
 	}
_

Patches currently in -mm which might be from tklauser@distanz.ch are

linux-next.patch
vmalloc-remove-redundant-unlikely.patch

