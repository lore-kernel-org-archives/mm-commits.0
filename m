From: akpm@linux-foundation.org
Subject: + bf54x-framebuffer-driver-bf542-does-not-have-eppi0-so-dont-allow-the-lq034-driver-for-now.patch added to -mm tree
Date: Sun, 27 Apr 2008 19:28:09 -0700
Message-ID: <200804280228.m3S2S91r003476@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56570 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753547AbYD1C2y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 22:28:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier.adi@gmail.com, cooloney@kernel.org


The patch titled
     BF54x Framebuffer Driver: BF542 does not have EPPI0, so dont allow the LQ034 driver for now
has been added to the -mm tree.  Its filename is
     bf54x-framebuffer-driver-bf542-does-not-have-eppi0-so-dont-allow-the-lq034-driver-for-now.patch

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
Subject: BF54x Framebuffer Driver: BF542 does not have EPPI0, so dont allow the LQ034 driver for now
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/Kconfig~bf54x-framebuffer-driver-bf542-does-not-have-eppi0-so-dont-allow-the-lq034-driver-for-now drivers/video/Kconfig
--- a/drivers/video/Kconfig~bf54x-framebuffer-driver-bf542-does-not-have-eppi0-so-dont-allow-the-lq034-driver-for-now
+++ a/drivers/video/Kconfig
@@ -581,7 +581,7 @@ config FB_VGA16
 
 config FB_BF54X_LQ043
 	tristate "SHARP LQ043 TFT LCD (BF548 EZKIT)"
-	depends on FB && (BF54x)
+	depends on FB && (BF54x) && !BF542
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
git-watchdog.patch
bf54x-framebuffer-driver-drop-request_irq-cast.patch
bf54x-framebuffer-driver-bf542-does-not-have-eppi0-so-dont-allow-the-lq034-driver-for-now.patch
procfs-task-exe-symlink-fix-2.patch
add-kbuildh-that-contains-common-definitions-for-kbuild-users.patch
blackfin-use-kbuildh-instead-of-defining-macros-in-asm-macrosc.patch

