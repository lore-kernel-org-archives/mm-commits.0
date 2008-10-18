From: akpm@linux-foundation.org
Subject: - uvesafb-dont-treat-mode-info-retrieval-failures-as-errors.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:17:46 -0700
Message-ID: <200810182317.m9INHkMd029152@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751813AbYJRXRv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:17:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: spock@gentoo.org, hpa@zytor.com, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     uvesafb: don't treat mode info retrieval failures as errors
has been removed from the -mm tree.  Its filename was
     uvesafb-dont-treat-mode-info-retrieval-failures-as-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uvesafb: don't treat mode info retrieval failures as errors
From: Michal Januszewski <spock@gentoo.org>

Some BIOSes return error codes when queried for information about
modes from their own modelist.  uvesafb treats this as an error
case and bails out.

Change this behavior so that broken modes do not prevent the driver
from working.  Only the failure to retrieve information about any
usable video mode is considered to be an error case.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/uvesafb.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/video/uvesafb.c~uvesafb-dont-treat-mode-info-retrieval-failures-as-errors drivers/video/uvesafb.c
--- a/drivers/video/uvesafb.c~uvesafb-dont-treat-mode-info-retrieval-failures-as-errors
+++ a/drivers/video/uvesafb.c
@@ -516,10 +516,12 @@ static int __devinit uvesafb_vbe_getmode
 
 		err = uvesafb_exec(task);
 		if (err || (task->t.regs.eax & 0xffff) != 0x004f) {
-			printk(KERN_ERR "uvesafb: Getting mode info block "
+			printk(KERN_WARNING "uvesafb: Getting mode info block "
 				"for mode 0x%x failed (eax=0x%x, err=%d)\n",
 				*mode, (u32)task->t.regs.eax, err);
-			return -EINVAL;
+			mode++;
+			par->vbe_modes_cnt--;
+			continue;
 		}
 
 		mib = task->buf;
@@ -548,7 +550,10 @@ static int __devinit uvesafb_vbe_getmode
 			mib->depth = mib->bits_per_pixel;
 	}
 
-	return 0;
+	if (par->vbe_modes_cnt > 0)
+		return 0;
+	else
+		return -EINVAL;
 }
 
 /*
_

Patches currently in -mm which might be from spock@gentoo.org are

origin.patch

