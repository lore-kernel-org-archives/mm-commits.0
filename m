From: akpm@linux-foundation.org
Subject: + video-fbdev-intelfb-move-inline-before-return-type.patch added
 to -mm tree
Date: Wed, 05 Jul 2017 13:45:32 -0700
Message-ID: <595d4fec.Opg2jYRZCUtyx4Kf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54752 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753454AbdGEUpi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jul 2017 16:45:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, b.zolnierkie@samsung.com, mbroemme@libmpq.org, mm-commits@vger.kernel.org


The patch titled
     Subject: video: fbdev: intelfb: move inline before return type
has been added to the -mm tree.  Its filename is
     video-fbdev-intelfb-move-inline-before-return-type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/video-fbdev-intelfb-move-inline-before-return-type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/video-fbdev-intelfb-move-inline-before-return-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: video: fbdev: intelfb: move inline before return type

Make the code like the rest of the kernel.

But there is an oddity here because the inline should probably be removed.

It's an extern function in intelfb.h and it is used in intelfbdrv.c and
intelfbhw.c.

The inline is kept here as I suppose it's possible for some compiler to
make the uses inline in intelfbdrv and and also create an external
function for intelfbhw.

Link: http://lkml.kernel.org/r/8ba151a1fdc84e42cbf4aafc798513c0158edee1.1499284835.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Maik Broemme <mbroemme@libmpq.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbdev/intelfb/intelfbdrv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/fbdev/intelfb/intelfbdrv.c~video-fbdev-intelfb-move-inline-before-return-type drivers/video/fbdev/intelfb/intelfbdrv.c
--- a/drivers/video/fbdev/intelfb/intelfbdrv.c~video-fbdev-intelfb-move-inline-before-return-type
+++ a/drivers/video/fbdev/intelfb/intelfbdrv.c
@@ -907,7 +907,7 @@ static void intelfb_pci_unregister(struc
  *                       helper functions                      *
  ***************************************************************/
 
-int __inline__ intelfb_var_to_depth(const struct fb_var_screeninfo *var)
+__inline__ int intelfb_var_to_depth(const struct fb_var_screeninfo *var)
 {
 	DBG_MSG("intelfb_var_to_depth: bpp: %d, green.length is %d\n",
 		var->bits_per_pixel, var->green.length);
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-improve-the-unnecessary-oom-message-test.patch
checkpatch-warn-when-a-maintainers-entry-isnt-t.patch
checkpatch-fix-stepping-through-statements-with-stat-and-ctx_statement_block.patch
checkpatch-improve-tests-for-multiple-line-function-definitions.patch
checkpatch-improve-macro-reuse-test.patch
checkpatch-improve-multi-line-alignment-test.patch
checkpatch-improve-the-storage_class-test.patch
arm-kvm-move-asmlinkage-before-type.patch
arm-hp-jornada-7xx-move-inline-before-return-type.patch
cris-gpio-move-inline-before-return-type.patch
frv-tlbflush-move-asmlinkage-before-return-type.patch
ia64-move-inline-before-return-type.patch
ia64-sn-pci-move-inline-before-type.patch
m68k-coldfire-move-inline-before-return-type.patch
mips-smp-move-asmlinkage-before-return-type.patch
sh-move-inline-before-return-type.patch
x86-efi-move-asmlinkage-before-return-type.patch
drivers-s390-move-static-and-inline-before-return-type.patch
drivers-tty-serial-move-inline-before-return-type.patch
usb-serial-safe_serial-move-__inline__-before-return-type.patch
video-fbdev-intelfb-move-inline-before-return-type.patch
video-fbdev-omap-move-inline-before-return-type.patch
arm-samsung-usb-ohci-move-inline-before-return-type.patch
alsa-opl4-move-inline-before-return-type.patch

