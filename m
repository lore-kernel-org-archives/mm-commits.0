From: akpm@linux-foundation.org
Subject: [patch 07/15] pcmcia: remove left-over %Z format
Date: Fri, 02 Jun 2017 14:46:28 -0700
Message-ID: <5931dcb4.E2ZM5k74ouboNgs+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51460 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdFBVq3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jun 2017 17:46:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, nicolas.iooss_linux@m4x.org, adobriyan@gmail.com, laforge@gnumonks.org, stable@vger.kernel.org

From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: pcmcia: remove left-over %Z format

5b5e0928f742 ("lib/vsprintf.c: remove %Z support") removed some usages of
format %Z but forgot "%.2Zx".  This makes clang 4.0 reports a
-Wformat-extra-args warning because it does not know about %Z.

Replace %Z with %z.

Link: http://lkml.kernel.org/r/20170520090946.22562-1-nicolas.iooss_linux@m4x.org
Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Cc: Harald Welte <laforge@gnumonks.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: <stable@vger.kernel.org>	[4.11+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/pcmcia/cm4040_cs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/char/pcmcia/cm4040_cs.c~pcmcia-remove-left-over-%z-format drivers/char/pcmcia/cm4040_cs.c
--- a/drivers/char/pcmcia/cm4040_cs.c~pcmcia-remove-left-over-%z-format
+++ a/drivers/char/pcmcia/cm4040_cs.c
@@ -374,7 +374,7 @@ static ssize_t cm4040_write(struct file
 
 	rc = write_sync_reg(SCR_HOST_TO_READER_START, dev);
 	if (rc <= 0) {
-		DEBUGP(5, dev, "write_sync_reg c=%.2Zx\n", rc);
+		DEBUGP(5, dev, "write_sync_reg c=%.2zx\n", rc);
 		DEBUGP(2, dev, "<- cm4040_write (failed)\n");
 		if (rc == -ERESTARTSYS)
 			return rc;
@@ -387,7 +387,7 @@ static ssize_t cm4040_write(struct file
 	for (i = 0; i < bytes_to_write; i++) {
 		rc = wait_for_bulk_out_ready(dev);
 		if (rc <= 0) {
-			DEBUGP(5, dev, "wait_for_bulk_out_ready rc=%.2Zx\n",
+			DEBUGP(5, dev, "wait_for_bulk_out_ready rc=%.2zx\n",
 			       rc);
 			DEBUGP(2, dev, "<- cm4040_write (failed)\n");
 			if (rc == -ERESTARTSYS)
@@ -403,7 +403,7 @@ static ssize_t cm4040_write(struct file
 	rc = write_sync_reg(SCR_HOST_TO_READER_DONE, dev);
 
 	if (rc <= 0) {
-		DEBUGP(5, dev, "write_sync_reg c=%.2Zx\n", rc);
+		DEBUGP(5, dev, "write_sync_reg c=%.2zx\n", rc);
 		DEBUGP(2, dev, "<- cm4040_write (failed)\n");
 		if (rc == -ERESTARTSYS)
 			return rc;
_
