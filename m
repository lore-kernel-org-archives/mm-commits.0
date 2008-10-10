From: akpm@linux-foundation.org
Subject: + framebuffer-fix-carminefb-section-mismatch.patch added to -mm tree
Date: Fri, 10 Oct 2008 13:47:27 -0700
Message-ID: <200810102047.m9AKlRcp000655@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44997 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759821AbYJJUtQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Oct 2008 16:49:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, bigeasy@linutronix.de, geert@linux-m68k.org, krzysztof.h1@poczta.fm


The patch titled
     framebuffer: fix carminefb section mismatch
has been added to the -mm tree.  Its filename is
     framebuffer-fix-carminefb-section-mismatch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: framebuffer: fix carminefb section mismatch
From: Randy Dunlap <randy.dunlap@oracle.com>

Make alloc_carmine_fb() __devinit.

WARNING: drivers/video/carminefb.o(.text+0x81b): Section mismatch in reference from the function alloc_carmine_fb() to the variable .devinit.data:carminefb_fix

The function alloc_carmine_fb() references the variable __devinitdata
carminefb_fix.  This is often because alloc_carmine_fb lacks a
__devinitdata annotation or the annotation of carminefb_fix is wrong.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sebastian Siewior <bigeasy@linutronix.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/carminefb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/carminefb.c~framebuffer-fix-carminefb-section-mismatch drivers/video/carminefb.c
--- a/drivers/video/carminefb.c~framebuffer-fix-carminefb-section-mismatch
+++ a/drivers/video/carminefb.c
@@ -535,7 +535,7 @@ static struct fb_ops carminefb_ops = {
 	.fb_setcolreg	= carmine_setcolreg,
 };
 
-static int alloc_carmine_fb(void __iomem *regs, void __iomem *smem_base,
+static int __devinit alloc_carmine_fb(void __iomem *regs, void __iomem *smem_base,
 		int smem_offset, struct device *device, struct fb_info **rinfo)
 {
 	int ret;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-tip.patch
git-hid.patch
git-net.patch
git-sound.patch
git-block.patch
git-drm.patch
git-security-testing.patch
mfd-ucb1400-sound-driver-uses-depends-on-ac97_bus.patch
fb-metronome-printk-format-warning.patch
toshiba_acpi-depends-on-input.patch
fujitsu-laptop-fix-section-mismatch-warning.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
memory_probe-fix-wrong-sysfs-file-attribute.patch
memory_probe-fix-wrong-sysfs-file-attribute-fix.patch
eeepc-laptop-use-standard-interfaces-fix.patch
eeepc-laptop-use-standard-interfaces-fix-fix.patch
dontdiff-more-updates-to-be-closer-to-gitignore.patch
documentation-explain-memory-barriers.patch
framebuffer-fix-carminefb-section-mismatch.patch
docbook-update-procfs-credits.patch
w1-documentation-w1-masters-ds2490-update.patch
configure-out-aio-support-fix.patch
profile-likely-unlikely-macros.patch

