From: akpm@linux-foundation.org
Subject: [merged] drivers-gpu-vga-vgaarbc-add-missing-kfree.patch removed from -mm tree
Date: Wed, 23 Nov 2011 13:45:06 -0800
Message-ID: <201111232145.pANLj6Iq026639@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:38170 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab1KWVpL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Nov 2011 16:45:11 -0500
Received: by wwp14 with SMTP id 14so13575wwp.1
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2011 13:45:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, airlied@redhat.com, jj@chaosbits.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/gpu/vga/vgaarb.c: add missing kfree
has been removed from the -mm tree.  Its filename was
     drivers-gpu-vga-vgaarbc-add-missing-kfree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Julia Lawall <julia@diku.dk>
Subject: drivers/gpu/vga/vgaarb.c: add missing kfree

kbuf is a buffer that is local to this function, so all of the error paths
leaving the function should release it.

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/vga/vgaarb.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN drivers/gpu/vga/vgaarb.c~drivers-gpu-vga-vgaarbc-add-missing-kfree drivers/gpu/vga/vgaarb.c
--- a/drivers/gpu/vga/vgaarb.c~drivers-gpu-vga-vgaarbc-add-missing-kfree
+++ a/drivers/gpu/vga/vgaarb.c
@@ -993,14 +993,20 @@ static ssize_t vga_arb_write(struct file
 				uc = &priv->cards[i];
 		}
 
-		if (!uc)
-			return -EINVAL;
+		if (!uc) {
+			ret_val = -EINVAL;
+			goto done;
+		}
 
-		if (io_state & VGA_RSRC_LEGACY_IO && uc->io_cnt == 0)
-			return -EINVAL;
+		if (io_state & VGA_RSRC_LEGACY_IO && uc->io_cnt == 0) {
+			ret_val = -EINVAL;
+			goto done;
+		}
 
-		if (io_state & VGA_RSRC_LEGACY_MEM && uc->mem_cnt == 0)
-			return -EINVAL;
+		if (io_state & VGA_RSRC_LEGACY_MEM && uc->mem_cnt == 0) {
+			ret_val = -EINVAL;
+			goto done;
+		}
 
 		vga_put(pdev, io_state);
 
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch

