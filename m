From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-m48t35c-is-borked-too.patch added to -mm tree
Date: Wed, 15 Oct 2008 18:07:18 -0700
Message-ID: <200810160121.m9G1LoQs002178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752828AbYJPBWK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 21:22:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alessandro.zummo@towertech.it, ralf@linux-mips.org, tsbogend@alpha.franken.de


The patch titled
     drivers/rtc/rtc-m48t35.c is borked too
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-m48t35c-is-borked-too.patch

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
Subject: drivers/rtc/rtc-m48t35.c is borked too
From: Andrew Morton <akpm@linux-foundation.org>

drivers/rtc/rtc-m48t35.c: In function 'm48t35_read_time':
drivers/rtc/rtc-m48t35.c:59: error: implicit declaration of function 'readb'
drivers/rtc/rtc-m48t35.c:60: error: implicit declaration of function 'writeb'
drivers/rtc/rtc-m48t35.c: In function 'm48t35_probe':
drivers/rtc/rtc-m48t35.c:168: error: implicit declaration of function 'ioremap'
drivers/rtc/rtc-m48t35.c:168: warning: assignment makes pointer from integer without a cast
drivers/rtc/rtc-m48t35.c:188: error: implicit declaration of function 'iounmap'

Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/rtc-m48t35.c~drivers-rtc-rtc-m48t35c-is-borked-too drivers/rtc/rtc-m48t35.c
diff -puN drivers/rtc/Kconfig~drivers-rtc-rtc-m48t35c-is-borked-too drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~drivers-rtc-rtc-m48t35c-is-borked-too
+++ a/drivers/rtc/Kconfig
@@ -422,6 +422,7 @@ config RTC_DRV_M48T86
 
 config RTC_DRV_M48T35
 	tristate "ST M48T35"
+	depends on MIPS
 	help
 	  If you say Y here you will get support for the
 	  ST M48T35 RTC chip.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.patch
make-taint-bit-reliable-v3.patch
kernel-sysc-improve-code-generation.patch
compat-generic-compat-get-settimeofday.patch
allow-recursion-in-binfmt_script-and-binfmt_misc.patch
autofs4-track-uid-and-gid-of-last-mount-requester.patch
autofs4-add-miscellaneous-device-for-ioctls.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip.patch
viafb-accelc-accelh.patch
viafb-dvic-dvih-globalc-and-globalh.patch
viafb-hwc-hwh.patch
viafb-viafbdevc-viafbdevh.patch
fbdev-kconfig-update.patch
fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver.patch
ext2-avoid-printk-floods-in-the-face-of-directory-corruption.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
w1-be-able-to-manually-add-and-remove-slaves.patch
w1-new-driver-ds2431-chip.patch
gru-driver-minor-updates.patch
drivers-rtc-rtc-ds1286c-is-borked.patch
drivers-rtc-rtc-m48t35c-is-borked-too.patch

