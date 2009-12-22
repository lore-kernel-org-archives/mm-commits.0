From: akpm@linux-foundation.org
Subject: + viafb-deprecate-private-ioctls.patch added to -mm tree
Date: Tue, 22 Dec 2009 15:59:19 -0800
Message-ID: <200912222359.nBMNxJvY032294@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48034 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751537AbZLVX7v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Dec 2009 18:59:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn, krzysztof.h1@poczta.fm


The patch titled
     viafb: deprecate private ioctls
has been added to the -mm tree.  Its filename is
     viafb-deprecate-private-ioctls.patch

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
@@ -477,6 +477,7 @@ static int viafb_ioctl(struct fb_info *i
 	u32 gpu32;
 
 	DEBUG_MSG(KERN_INFO "viafb_ioctl: 0x%X !!\n", cmd);
+	printk(KERN_WARNING "viafb_ioctl: Please avoid this interface as it is unstable and might change or vanish at any time!\n");
 	memset(&u, 0, sizeof(u));
 
 	switch (cmd) {
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

viafb-deprecate-private-ioctls.patch
viafb-remove-dead-code.patch
viafb-split-global-index-up.patch
viafb-remove-the-remaining-via_res_-uses.patch
viafb-some-dvi-cleanup.patch

