From: akpm@linux-foundation.org
Subject: [merged] kbuild-fix-detection-of-config_frame_warn=0.patch removed from -mm tree
Date: Fri, 05 Jun 2009 11:55:15 -0700
Message-ID: <200906051855.n55ItF6Y020598@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752275AbZFESzY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Jun 2009 14:55:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, ak@suse.de, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kbuild: fix detection of CONFIG_FRAME_WARN=0
has been removed from the -mm tree.  Its filename was
     kbuild-fix-detection-of-config_frame_warn=0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
shm-fix-unused-warnings-on-nommu.patch
linux-next.patch
pcmcia-yenta-add-missing-__devexit-marking.patch
drivers-hvc-add-missing-__devexit_p.patch
plat_nand-add-missing-__devexit_p.patch
irda-new-blackfin-on-chip-sir-irda-driver.patch
virtio_blk-add-missing-__devinitexit-markings.patch
kmap_types-make-most-arches-use-generic-header-file.patch
gitignore-ignore-patch-files.patch
drivers-char-rtc-disable-legacy-rtc-driver-on-blackfin-systems.patch
gpio-max7301-add-missing-__devexit-marking.patch
istallion-add-missing-__devexit-marking.patch
edac-add-missing-__devexit_p.patch
cramfs-move-cramfs-magic-out-of-cramfs_fsh.patch

