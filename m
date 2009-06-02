From: akpm@linux-foundation.org
Subject: + kbuild-fix-detection-of-config_frame_warn=0.patch added to -mm tree
Date: Mon, 01 Jun 2009 22:29:02 -0700
Message-ID: <200906020529.n525T2bk016431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755094AbZFBF3I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jun 2009 01:29:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, ak@suse.de, sam@ravnborg.org


The patch titled
     kbuild: fix detection of CONFIG_FRAME_WARN=0
has been added to the -mm tree.  Its filename is
     kbuild-fix-detection-of-config_frame_warn=0.patch

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
Subject: kbuild: fix detection of CONFIG_FRAME_WARN=0
From: Mike Frysinger <vapier@gentoo.org>

The checking of CONFIG_FRAME_WARN in the top level Makefile forgot to
actually derefence the variable thus leading to an always true check.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Makefile~kbuild-fix-detection-of-config_frame_warn=0 Makefile
--- a/Makefile~kbuild-fix-detection-of-config_frame_warn=0
+++ a/Makefile
@@ -533,7 +533,7 @@ endif
 
 include $(srctree)/arch/$(SRCARCH)/Makefile
 
-ifneq (CONFIG_FRAME_WARN,0)
+ifneq ($(CONFIG_FRAME_WARN),0)
 KBUILD_CFLAGS += $(call cc-option,-Wframe-larger-than=${CONFIG_FRAME_WARN})
 endif
 
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
kbuild-fix-detection-of-config_frame_warn=0.patch
linux-next.patch
pcmcia-yenta-add-missing-__devexit-marking.patch
drivers-hvc-add-missing-__devexit_p.patch
plat_nand-add-missing-__devexit_p.patch
irda-new-blackfin-on-chip-sir-irda-driver.patch
virtio_blk-add-missing-__devinitexit-markings.patch
kmap_types-make-most-arches-use-generic-header-file.patch
drivers-char-rtc-disable-legacy-rtc-driver-on-blackfin-systems.patch
gpio-max7301-add-missing-__devexit-marking.patch
istallion-add-missing-__devexit-marking.patch
edac-add-missing-__devexit_p.patch
cramfs-move-cramfs-magic-out-of-cramfs_fsh.patch

