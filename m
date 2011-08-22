From: akpm@linux-foundation.org
Subject: + drivers-gpu-vga-vgaarbc-add-missing-kfree.patch added to -mm tree
Date: Mon, 22 Aug 2011 15:55:33 -0700
Message-ID: <201108222255.p7MMtX6M011568@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53082 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530Ab1HVW4O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Aug 2011 18:56:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, airlied@redhat.com, jj@chaosbits.net


The patch titled
     drivers/gpu/vga/vgaarb.c: add missing kfree
has been added to the -mm tree.  Its filename is
     drivers-gpu-vga-vgaarbc-add-missing-kfree.patch

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
Subject: drivers/gpu/vga/vgaarb.c: add missing kfree
From: Julia Lawall <julia@diku.dk>

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
drivers-gpu-vga-vgaarbc-add-missing-kfree.patch

