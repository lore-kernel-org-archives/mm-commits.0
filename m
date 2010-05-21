From: akpm@linux-foundation.org
Subject: + m68knommu-fix-broken-use-of-buad_table_size-in-68328serial-driver.patch added to -mm tree
Date: Fri, 21 May 2010 12:51:16 -0700
Message-ID: <201005211951.o4LJpGC8030817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43412 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753391Ab0EUTvc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 May 2010 15:51:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerg@snapgear.com, alan@lxorguk.ukuu.org.uk, gerg@uclinux.org, stable@kernel.org, tfransosi@gmail.com


The patch titled
     m68knommu: fix broken use of BUAD_TABLE_SIZE in 68328serial driver
has been added to the -mm tree.  Its filename is
     m68knommu-fix-broken-use-of-buad_table_size-in-68328serial-driver.patch

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
Subject: m68knommu: fix broken use of BUAD_TABLE_SIZE in 68328serial driver
From: Greg Ungerer <gerg@snapgear.com>

Commit 8b505ca8e2600eb9e7dd2d6b2682a81717671374 ("serial: 68328serial.c:
remove BAUD_TABLE_SIZE macro") misses one use of BAUD_TABLE_SIZE.  So the
resulting 68328serial.c does not compile:

drivers/serial/68328serial.c: In function `m68328_console_setup':
drivers/serial/68328serial.c:1439: error: `BAUD_TABLE_SIZE' undeclared (first use in this function)
drivers/serial/68328serial.c:1439: error: (Each undeclared identifier is reported only once
drivers/serial/68328serial.c:1439: error: for each function it appears in.)

Fix that last use of it.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Cc: Thiago Farina <tfransosi@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/68328serial.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/68328serial.c~m68knommu-fix-broken-use-of-buad_table_size-in-68328serial-driver drivers/serial/68328serial.c
--- a/drivers/serial/68328serial.c~m68knommu-fix-broken-use-of-buad_table_size-in-68328serial-driver
+++ a/drivers/serial/68328serial.c
@@ -1437,7 +1437,7 @@ int m68328_console_setup(struct console 
 	for (i = 0; i < ARRAY_SIZE(baud_table); i++)
 		if (baud_table[i] == n)
 			break;
-	if (i < BAUD_TABLE_SIZE) {
+	if (i < ARRAY_SIZE(baud_table)) {
 		m68328_console_baud = n;
 		m68328_console_cbaud = 0;
 		if (i > 15) {
_

Patches currently in -mm which might be from gerg@snapgear.com are

m68knommu-fix-broken-use-of-buad_table_size-in-68328serial-driver.patch

