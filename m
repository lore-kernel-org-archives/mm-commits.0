From: akpm@linux-foundation.org
Subject: + fb-metronome-printk-format-warning.patch added to -mm tree
Date: Tue, 26 Aug 2008 16:13:55 -0700
Message-ID: <200808262313.m7QNDtur000328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750778AbYHZXOs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 19:14:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, eric.miao@marvell.com, jayakumar.lkml@gmail.com, krzysztof.h1@wp.pl, rmk+kernel@arm.linux.org.uk


The patch titled
     fb: metronome printk format warning
has been added to the -mm tree.  Its filename is
     fb-metronome-printk-format-warning.patch

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
Subject: fb: metronome printk format warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warning:

drivers/video/metronomefb.c:191: warning: format '%d' expects type 'int', but argument 4 has type 'size_t

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Eric Miao <eric.miao@marvell.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/metronomefb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/metronomefb.c~fb-metronome-printk-format-warning drivers/video/metronomefb.c
--- a/drivers/video/metronomefb.c~fb-metronome-printk-format-warning
+++ a/drivers/video/metronomefb.c
@@ -188,7 +188,7 @@ static int __devinit load_waveform(u8 *m
 		epd_frame_table[par->dt].wfm_size = user_wfm_size;
 
 	if (size != epd_frame_table[par->dt].wfm_size) {
-		dev_err(dev, "Error: unexpected size %d != %d\n", size,
+		dev_err(dev, "Error: unexpected size %zu != %d\n", size,
 					epd_frame_table[par->dt].wfm_size);
 		return -EINVAL;
 	}
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
mfd-ucb1400-sound-driver-uses-depends-on-ac97_bus.patch
fb-metronome-printk-format-warning.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
w1-documentation-w1-masters-ds2490-update.patch
profile-likely-unlikely-macros.patch

