From: akpm@linux-foundation.org
Subject: + ide-fix-ideh-compiler-warning.patch added to -mm tree
Date: Mon, 17 Mar 2008 20:44:21 -0700
Message-ID: <200803180344.m2I3iLRu012562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752640AbYCRDoz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 23:44:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, bzolnier@gmail.com


The patch titled
     IDE: fix ide.h compiler warning
has been added to the -mm tree.  Its filename is
     ide-fix-ideh-compiler-warning.patch

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
Subject: IDE: fix ide.h compiler warning
From: Jiri Slaby <jirislaby@gmail.com>

Fix following compiler warning by returning EINVAL
In file included from ANYTHING-INCLUDING-IDE.H:45:
include/linux/ide.h: In function `ide_hwif_setup_dma':
include/linux/ide.h:1022: warning: no return statement in function returning non-void

This fix is only for CONFIG_BLK_DEV_IDEDMA_PCI=n configs and is introduced by
ide: do complete DMA setup in ->init_dma method.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ide.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN include/linux/ide.h~ide-fix-ideh-compiler-warning include/linux/ide.h
--- a/include/linux/ide.h~ide-fix-ideh-compiler-warning
+++ a/include/linux/ide.h
@@ -1009,7 +1009,10 @@ unsigned long ide_pci_dma_base(ide_hwif_
 int ide_hwif_setup_dma(ide_hwif_t *, const struct ide_port_info *);
 #else
 static inline int ide_hwif_setup_dma(ide_hwif_t *hwif,
-				     const struct ide_port_info *d) { }
+				     const struct ide_port_info *d)
+{
+	return -EINVAL;
+}
 #endif
 
 extern void default_hwif_iops(ide_hwif_t *);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

git-drm.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc-update.patch
ide-fix-ideh-compiler-warning.patch
wdev-ath5k-typecheck-on-nondebug.patch
x86_32-fix-fault_msg-nul-termination.patch
capabilities-implement-per-process-securebits-fix.patch
misc-phantom-add-compat-ioctl.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
misc-phantom-fix-poll.patch
misc-phantom-consistent-whitespace.patch
mxser-prepare-for-bkl-pushdown.patch
tty-bkl-pushdown-fix.patch
tty-bkl-pushdown-fix1.patch
char-moxa-remove-static-isa-support.patch
char-moxa-cleanup-module-param-passed-isa-init.patch
char-moxa-pci-io-space-fixup.patch
char-moxa-fix-tiocg-ssoftcar-param.patch
char-moxa-add-firmware-loading.patch
char-moxa-merge-c2xx-and-c320-firmware-loading.patch
char-moxa-remove-port-port.patch
char-moxa-remove-unused-port-entries.patch
char-moxa-centralize-board-readiness.patch
char-moxa-timer-cleanup.patch
char-moxa-ioctl-cleanup.patch
char-moxa-merge-2-poll-functions.patch
char-moxa-cleanup-rx-tx.patch
char-moxa-serialise-timer.patch
char-moxa-rework-open-close.patch
char-moxa-little-cleanup.patch
char-moxa-remove-useless-tty-functions.patch
char-moxa-introduce-moxa_is_320-macro.patch
char-moxa-notify-about-board-readiness.patch
char-moxa-update-credits.patch
char-moxa-add-firmware-loading-fix.patch
char-espc-fix-possible-double-unlock.patch
mxser-convert-large-macros-to-functions.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

