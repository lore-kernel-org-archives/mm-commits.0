From: akpm@linux-foundation.org
Subject: - scsi-53c7xx-brackets-fix.patch removed from -mm tree
Date: Thu, 08 Feb 2007 01:48:24 -0800
Message-ID: <200702080948.l189mO7V011038@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35754 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423199AbXBHJs3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 04:48:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, mm-commits@vger.kernel.org


The patch titled
     scsi: 53c7xx brackets fix
has been removed from the -mm tree.  Its filename was
     scsi-53c7xx-brackets-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: scsi: 53c7xx brackets fix
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/53c7xx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/53c7xx.c~scsi-53c7xx-brackets-fix drivers/scsi/53c7xx.c
--- a/drivers/scsi/53c7xx.c~scsi-53c7xx-brackets-fix
+++ a/drivers/scsi/53c7xx.c
@@ -4400,7 +4400,7 @@ abort_connected (struct Scsi_Host *host)
  * account the current synchronous offset) 
  */
 
-    sstat = (NCR53c8x0_read8 (SSTAT2_REG);
+    sstat = NCR53c8x0_read8 (SSTAT2_REG);
     offset = OFFSET (sstat & SSTAT2_FF_MASK) >> SSTAT2_FF_SHIFT;
     phase = sstat & SSTAT2_PHASE_MASK;
 
@@ -5423,7 +5423,7 @@ insn_to_offset (Scsi_Cmnd *cmd, u32 *ins
     	    	     --buffers, offset += segment->length, ++segment)
 #if 0
 		    printk("scsi%d: comparing 0x%p to 0x%p\n", 
-			cmd->device->host->host_no, saved, page_address(segment->page+segment->offset);
+			cmd->device->host->host_no, saved, page_address(segment->page+segment->offset));
 #else
 		    ;
 #endif
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
git-alsa.patch
git-powerpc.patch
git-dvb.patch
git-scsi-misc.patch
