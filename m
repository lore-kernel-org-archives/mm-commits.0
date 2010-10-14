From: akpm@linux-foundation.org
Subject: + drivers-misc-ad525x_dpot-fix-typo-in-spi-write16-and-write24-transfer-counts.patch added to -mm tree
Date: Thu, 14 Oct 2010 15:22:35 -0700
Message-ID: <201010142222.o9EMMZp8022854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755255Ab0JNWWj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Oct 2010 18:22:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.hennerich@analog.com, chrisv@cyberswitching.com, vapier@gentoo.org


The patch titled
     drivers/misc/ad525x_dpot.c: fix typo in spi write16 and write24 transfer counts
has been added to the -mm tree.  Its filename is
     drivers-misc-ad525x_dpot-fix-typo-in-spi-write16-and-write24-transfer-counts.patch

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
Subject: drivers/misc/ad525x_dpot.c: fix typo in spi write16 and write24 transfer counts
From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Chris Verges <chrisv@cyberswitching.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/ad525x_dpot-spi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/misc/ad525x_dpot-spi.c~drivers-misc-ad525x_dpot-fix-typo-in-spi-write16-and-write24-transfer-counts drivers/misc/ad525x_dpot-spi.c
--- a/drivers/misc/ad525x_dpot-spi.c~drivers-misc-ad525x_dpot-fix-typo-in-spi-write16-and-write24-transfer-counts
+++ a/drivers/misc/ad525x_dpot-spi.c
@@ -53,13 +53,13 @@ static int write8(void *client, u8 val)
 static int write16(void *client, u8 reg, u8 val)
 {
 	u8 data[2] = {reg, val};
-	return spi_write(client, data, 1);
+	return spi_write(client, data, 2);
 }
 
 static int write24(void *client, u8 reg, u16 val)
 {
 	u8 data[3] = {reg, val >> 8, val};
-	return spi_write(client, data, 1);
+	return spi_write(client, data, 3);
 }
 
 static int read8(void *client)
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

linux-next.patch
drivers-misc-ad525x_dpot-fix-typo-in-spi-write16-and-write24-transfer-counts.patch
drivers-misc-ad525x_dpot-fix-part-name-typos-in-defines.patch
drivers-misc-ad525x_dpot-new-features.patch
misc-devices-do-not-enable-by-default.patch

