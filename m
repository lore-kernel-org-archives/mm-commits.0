From: akpm@linux-foundation.org
Subject: [merged] mmc-s3cmci-fix-hangup-in-do_pio_write.patch removed from -mm tree
Date: Thu, 19 Feb 2009 11:17:30 -0800
Message-ID: <200902191917.n1JJHU15016382@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59091 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753871AbZBSTS0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 14:18:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jekhor@gmail.com, ben-linux@fluff.org, drzeus-mmc@drzeus.cx, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mmc: s3cmci: Fix hangup in do_pio_write()
has been removed from the -mm tree.  Its filename was
     mmc-s3cmci-fix-hangup-in-do_pio_write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: s3cmci: Fix hangup in do_pio_write()
From: Yauhen Kharuzhy <jekhor@gmail.com>

This commit fixes the regression what was added by commit
088a78af978d0c8e339071a9b2bca1f4cb368f30 "s3cmci: Support transfers
which are not multiple of 32 bits."

fifo_free() now returns amount of available space in FIFO buffer in
bytes.  But do_pio_write() writes to FIFO 32-bit words.  Condition for
return from cycle is (fifo_free() == 0), but when fifo has 1..3 bytes
of free space then this condition will never be true and system hangs.

This patch changes condition in the while() to (fifo_free() > 3).

Signed-off-by: Yauhen Kharuzhy <jekhor@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/s3cmci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/host/s3cmci.c~mmc-s3cmci-fix-hangup-in-do_pio_write drivers/mmc/host/s3cmci.c
--- a/drivers/mmc/host/s3cmci.c~mmc-s3cmci-fix-hangup-in-do_pio_write
+++ a/drivers/mmc/host/s3cmci.c
@@ -329,7 +329,7 @@ static void do_pio_write(struct s3cmci_h
 
 	to_ptr = host->base + host->sdidata;
 
-	while ((fifo = fifo_free(host))) {
+	while ((fifo = fifo_free(host)) > 3) {
 		if (!host->pio_bytes) {
 			res = get_data_buffer(host, &host->pio_bytes,
 							&host->pio_ptr);
_

Patches currently in -mm which might be from jekhor@gmail.com are

origin.patch

