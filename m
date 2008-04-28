From: akpm@linux-foundation.org
Subject: + bf54x-framebuffer-driver-drop-request_irq-cast.patch added to -mm tree
Date: Sun, 27 Apr 2008 19:28:21 -0700
Message-ID: <200804280228.m3S2SLCs003479@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55833 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760882AbYD1C3G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 22:29:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier.adi@gmail.com, cooloney@kernel.org


The patch titled
     BF54x Framebuffer Driver: drop request_irq cast
has been added to the -mm tree.  Its filename is
     bf54x-framebuffer-driver-drop-request_irq-cast.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: BF54x Framebuffer Driver: drop request_irq cast
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/bf54x-lq043fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/bf54x-lq043fb.c~bf54x-framebuffer-driver-drop-request_irq-cast drivers/video/bf54x-lq043fb.c
--- a/drivers/video/bf54x-lq043fb.c~bf54x-framebuffer-driver-drop-request_irq-cast
+++ a/drivers/video/bf54x-lq043fb.c
@@ -652,7 +652,7 @@ static int __init bfin_bf54x_probe(struc
 		goto out7;
 	}
 
-	if (request_irq(info->irq, (void *)bfin_bf54x_irq_error, IRQF_DISABLED,
+	if (request_irq(info->irq, bfin_bf54x_irq_error, IRQF_DISABLED,
 			"PPI ERROR", info) < 0) {
 		printk(KERN_ERR DRIVER_NAME
 		       ": unable to request PPI ERROR IRQ\n");
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
git-watchdog.patch
bf54x-framebuffer-driver-drop-request_irq-cast.patch
bf54x-framebuffer-driver-bf542-does-not-have-eppi0-so-dont-allow-the-lq034-driver-for-now.patch
procfs-task-exe-symlink-fix-2.patch
add-kbuildh-that-contains-common-definitions-for-kbuild-users.patch
blackfin-use-kbuildh-instead-of-defining-macros-in-asm-macrosc.patch

