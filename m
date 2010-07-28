From: akpm@linux-foundation.org
Subject: + backlight-s6e63m0-fix-section-mismatch.patch added to -mm tree
Date: Wed, 28 Jul 2010 15:31:31 -0700
Message-ID: <201007282231.o6SMVVP0006245@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752206Ab0G1Whw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Jul 2010 18:37:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, inki.dae@samsung.com, rpurdie@rpsys.net


The patch titled
     backlight: s6e63m0: fix section mismatch
has been added to the -mm tree.  Its filename is
     backlight-s6e63m0-fix-section-mismatch.patch

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
Subject: backlight: s6e63m0: fix section mismatch
From: Axel Lin <axel.lin@gmail.com>

Eliminate section mismatch warning by marking s6e63m0_probe() as __devinit.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: InKi Dae <inki.dae@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/s6e63m0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/s6e63m0.c~backlight-s6e63m0-fix-section-mismatch drivers/video/backlight/s6e63m0.c
--- a/drivers/video/backlight/s6e63m0.c~backlight-s6e63m0-fix-section-mismatch
+++ a/drivers/video/backlight/s6e63m0.c
@@ -732,7 +732,7 @@ static ssize_t s6e63m0_sysfs_show_gamma_
 static DEVICE_ATTR(gamma_table, 0444,
 		s6e63m0_sysfs_show_gamma_table, NULL);
 
-static int __init s6e63m0_probe(struct spi_device *spi)
+static int __devinit s6e63m0_probe(struct spi_device *spi)
 {
 	int ret = 0;
 	struct s6e63m0 *lcd = NULL;
_

Patches currently in -mm which might be from axel.lin@gmail.com are

linux-next.patch
drivers-video-backlight-s6e63m0c-set-permissions-on-gamma_table-file-to-0444.patch
backlight-s6e63m0-unregister-backlight-device-and-remove-sysfs-attribute-file-in-s6e63m0_remove.patch
backlight-s6e63m0-fix-section-mismatch.patch
edd-fix-possible-memory-leak-in-edd_init-error-path.patch
edd-fix-possible-memory-leak-in-edd_init-error-path-fix.patch

