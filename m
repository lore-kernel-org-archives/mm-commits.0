From: akpm@linux-foundation.org
Subject: + m25p80-fix-detection-of-spi-parts.patch added to -mm tree
Date: Mon, 03 Nov 2008 13:37:31 -0800
Message-ID: <200811032137.mA3LbVCD014086@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753456AbYKCVho (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Nov 2008 16:37:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, dwmw2@infradead.org


The patch titled
     m25p80: fix detection of SPI parts
has been added to the -mm tree.  Its filename is
     m25p80-fix-detection-of-spi-parts.patch

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
Subject: m25p80: fix detection of SPI parts
From: Mike Frysinger <vapier@gentoo.org>

Commit d0e8c47c58575b9131e786edb488fd029eba443e ("m25p80.c extended jedec
support") added support for extended ids but in the process managed to
break detection of all flashes.

The ext jedec id check was inserted into an if statement that lacked
braces, and it did not add the required braces.  As such, the detection
routine always returns the first entry in the SPI flash list.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/m25p80.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/mtd/devices/m25p80.c~m25p80-fix-detection-of-spi-parts drivers/mtd/devices/m25p80.c
--- a/drivers/mtd/devices/m25p80.c~m25p80-fix-detection-of-spi-parts
+++ a/drivers/mtd/devices/m25p80.c
@@ -574,10 +574,11 @@ static struct flash_info *__devinit jede
 	for (tmp = 0, info = m25p_data;
 			tmp < ARRAY_SIZE(m25p_data);
 			tmp++, info++) {
-		if (info->jedec_id == jedec)
+		if (info->jedec_id == jedec) {
 			if (ext_jedec != 0 && info->ext_id != ext_jedec)
 				continue;
 			return info;
+		}
 	}
 	dev_err(&spi->dev, "unrecognized JEDEC id %06x\n", jedec);
 	return NULL;
_

Patches currently in -mm which might be from vapier@gentoo.org are

linux-next.patch
linux-timexh-cleanup-for-userspace.patch
m25p80-fix-detection-of-spi-parts.patch
m25p80-fix-detection-of-m25p16-flashes.patch

