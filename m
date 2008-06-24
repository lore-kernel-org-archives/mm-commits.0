From: akpm@linux-foundation.org
Subject: + lxfb-drop-dead-declarations-from-header.patch added to -mm tree
Date: Tue, 24 Jun 2008 16:46:40 -0700
Message-ID: <200806242346.m5ONkeMZ012467@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53394 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751072AbYFXXqv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jun 2008 19:46:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, dilinger@debian.org


The patch titled
     lxfb: drop dead declarations from header
has been added to the -mm tree.  Its filename is
     lxfb-drop-dead-declarations-from-header.patch

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
Subject: lxfb: drop dead declarations from header
From: Andres Salomon <dilinger@queued.net>

We never sent the gamma stuff upstream, and don't really care about it. 
However, lx_[gs]_et_gamma prototypes snuck into lxfb.h anyways; there are
no definitions for them.  Drop the dead code.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/lxfb.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/video/geode/lxfb.h~lxfb-drop-dead-declarations-from-header drivers/video/geode/lxfb.h
--- a/drivers/video/geode/lxfb.h~lxfb-drop-dead-declarations-from-header
+++ a/drivers/video/geode/lxfb.h
@@ -51,8 +51,6 @@ static inline unsigned int lx_get_pitch(
 }
 
 void lx_set_mode(struct fb_info *);
-void lx_get_gamma(struct fb_info *, unsigned int *, int);
-void lx_set_gamma(struct fb_info *, unsigned int *, int);
 unsigned int lx_framebuffer_size(void);
 int lx_blank_display(struct fb_info *, int);
 void lx_set_palette_reg(struct fb_info *, unsigned int, unsigned int,
_

Patches currently in -mm which might be from dilinger@queued.net are

olpc-sdhci-add-quirk-for-the-marvell-cafes-vdd-powerup-issue.patch
olpc-sdhci-add-quirk-for-the-marvell-cafes-interrupt-timeout.patch
lxfb-drop-dead-declarations-from-header.patch

