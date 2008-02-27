From: akpm@linux-foundation.org
Subject: + char-moxa-add-firmware-loading-fix.patch added to -mm tree
Date: Wed, 27 Feb 2008 15:13:41 -0800
Message-ID: <200802272313.m1RNDfqQ003319@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751005AbYB0XTX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 18:19:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, Oyvind.Aabling@uni-c.dk


The patch titled
     Char: moxa, add firmware loading fix
has been added to the -mm tree.  Its filename is
     char-moxa-add-firmware-loading-fix.patch

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
Subject: Char: moxa, add firmware loading fix
From: Jiri Slaby <jirislaby@gmail.com>

Be more verbose on fw load fail as noted by Oyvind.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/char/moxa.c~char-moxa-add-firmware-loading-fix drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-add-firmware-loading-fix
+++ a/drivers/char/moxa.c
@@ -846,7 +846,10 @@ static int moxa_init_board(struct moxa_b
 
 	ret = request_firmware(&fw, file, dev);
 	if (ret) {
-		printk(KERN_ERR "request_firmware failed\n");
+		printk(KERN_ERR "MOXA: request_firmware failed. Make sure "
+				"you've placed '%s' file into your firmware "
+				"loader directory (e.g. /lib/firmware)\n",
+				file);
 		goto err_free;
 	}
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
wdev-ath5k-typecheck-on-nondebug.patch
misc-phantom-add-compat-ioctl.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
misc-phantom-fix-poll.patch
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
mxser-convert-large-macros-to-functions.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
