From: akpm@linux-foundation.org
Subject: [merged] viafb-deprecate-private-ioctls.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:55:56 -0400
Message-ID: <201003150656.o2F6uTN8016285@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42406 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934447Ab0COG4k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:56:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     viafb: deprecate private ioctls
has been removed from the -mm tree.  Its filename was
     viafb-deprecate-private-ioctls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: deprecate private ioctls
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Print a warning when viafb ioctls are called.  Those should not be used as
their exact meaning is sometimes unknown and they in parts duplicate
functionality present in the framebuffer interface.

There is no known user of these ioctls.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/viafbdev.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/via/viafbdev.c~viafb-deprecate-private-ioctls drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-deprecate-private-ioctls
+++ a/drivers/video/via/viafbdev.c
@@ -476,6 +476,7 @@ static int viafb_ioctl(struct fb_info *i
 	u32 gpu32;
 
 	DEBUG_MSG(KERN_INFO "viafb_ioctl: 0x%X !!\n", cmd);
+	printk(KERN_WARNING "viafb_ioctl: Please avoid this interface as it is unstable and might change or vanish at any time!\n");
 	memset(&u, 0, sizeof(u));
 
 	switch (cmd) {
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

origin.patch

