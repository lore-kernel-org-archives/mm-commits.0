From: akpm@linux-foundation.org
Subject: + spi-spidev_test-gives-error-upon-1-byte-transfer.patch added to -mm tree
Date: Thu, 29 Apr 2010 15:02:28 -0700
Message-ID: <201004292202.o3TM2TZv014295@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932740Ab0D3RJN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 13:09:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hector.palacios@digi.com, dbrownell@users.sourceforge.net, grant.likely@secretlab.ca


The patch titled
     spi: spidev_test gives error upon 1-byte transfer
has been added to the -mm tree.  Its filename is
     spi-spidev_test-gives-error-upon-1-byte-transfer.patch

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
Subject: spi: spidev_test gives error upon 1-byte transfer
From: Hector Palacios <hector.palacios@digi.com>

The sample application spidev_test.c is using SPI_IOC_MESSAGE ioctl to do
an SPI transfer.  This ioctl returns the number of bytes successfully
transmitted or a negative error code upon erroneous completion.  The
application however is returning an error if the result of the ioclt if
the return value is 1.  This makes the application to fail upon 1-byte
length transfers.

Signed-off-by: Hector Palacios <hector.palacios@digi.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/spi/spidev_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/spi/spidev_test.c~spi-spidev_test-gives-error-upon-1-byte-transfer Documentation/spi/spidev_test.c
--- a/Documentation/spi/spidev_test.c~spi-spidev_test-gives-error-upon-1-byte-transfer
+++ a/Documentation/spi/spidev_test.c
@@ -58,7 +58,7 @@ static void transfer(int fd)
 	};
 
 	ret = ioctl(fd, SPI_IOC_MESSAGE(1), &tr);
-	if (ret == 1)
+	if (ret < 1)
 		pabort("can't send spi message");
 
 	for (ret = 0; ret < ARRAY_SIZE(tx); ret++) {
_

Patches currently in -mm which might be from hector.palacios@digi.com are

spi-spidev_test-gives-error-upon-1-byte-transfer.patch

