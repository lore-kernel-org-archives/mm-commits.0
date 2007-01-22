From: akpm@osdl.org
Subject: - fix-bttv-and-friends-on-64bit-machines-with-lots-of-memory.patch removed from -mm tree
Date: Mon, 22 Jan 2007 12:45:51 -0800
Message-ID: <200701222045.l0MKjpaT001502@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50385 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932497AbXAVUqu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jan 2007 15:46:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kraxel@novell.com, kraxel@suse.de, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Fix bttv and friends on 64bit machines with lots of memory
has been removed from the -mm tree.  Its filename was
     fix-bttv-and-friends-on-64bit-machines-with-lots-of-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix bttv and friends on 64bit machines with lots of memory
From: Gerd Hoffmann <kraxel@novell.com>

Fix bttv and friends on 64bit machines with lots of memory.

We have a DMA32 zone now, lets use it to make sure the card
can reach the memory we have allocated for the video frame
buffers.

Signed-off-by: Gerds Hoffmann <kraxel@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/media/video/video-buf.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/video-buf.c~fix-bttv-and-friends-on-64bit-machines-with-lots-of-memory drivers/media/video/video-buf.c
--- a/drivers/media/video/video-buf.c~fix-bttv-and-friends-on-64bit-machines-with-lots-of-memory
+++ a/drivers/media/video/video-buf.c
@@ -1229,7 +1229,7 @@ videobuf_vm_nopage(struct vm_area_struct
 		vaddr,vma->vm_start,vma->vm_end);
 	if (vaddr > vma->vm_end)
 		return NOPAGE_SIGBUS;
-	page = alloc_page(GFP_USER);
+	page = alloc_page(GFP_USER | __GFP_DMA32);
 	if (!page)
 		return NOPAGE_OOM;
 	clear_user_page(page_address(page), vaddr, page);
_

Patches currently in -mm which might be from kraxel@novell.com are

origin.patch
git-dvb.patch
