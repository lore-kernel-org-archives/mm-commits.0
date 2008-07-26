From: akpm@linux-foundation.org
Subject: - parport_pc-add-base_hi-bar-for-oxsemi_840.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:13:49 -0700
Message-ID: <200807262113.m6QLDnNx019628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757491AbYGZVNx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:13:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, mm-commits@vger.kernel.org


The patch titled
     parport_pc: add base_hi BAR for oxsemi_840
has been removed from the -mm tree.  Its filename was
     parport_pc-add-base_hi-bar-for-oxsemi_840.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: parport_pc: add base_hi BAR for oxsemi_840
From: Bernhard Walle <bwalle@suse.de>

Use the 2nd BAR for the oxsemi_840 chip as BAR for base_hi.  Tested with:

Parallel controller [0701]: Oxford Semiconductor Ltd VScom 011H-EP1
        1 port parallel adaptor [1415:8403] (prog-if 03 [IEEE1284])

This patch is needed to make 'TRISTATE' work with that adaptor.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_pc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/parport/parport_pc.c~parport_pc-add-base_hi-bar-for-oxsemi_840 drivers/parport/parport_pc.c
--- a/drivers/parport/parport_pc.c~parport_pc-add-base_hi-bar-for-oxsemi_840
+++ a/drivers/parport/parport_pc.c
@@ -2867,7 +2867,7 @@ static struct parport_pc_pci {
 	 * and 840 locks up if you write 1 to bit 2! */
 	/* oxsemi_952 */		{ 1, { { 0, 1 }, } },
 	/* oxsemi_954 */		{ 1, { { 0, -1 }, } },
-	/* oxsemi_840 */		{ 1, { { 0, -1 }, } },
+	/* oxsemi_840 */		{ 1, { { 0, 1 }, } },
 	/* aks_0100 */                  { 1, { { 0, -1 }, } },
 	/* mobility_pp */		{ 1, { { 0, 1 }, } },
 	/* netmos_9705 */               { 1, { { 0, -1 }, } }, /* untested */
_

Patches currently in -mm which might be from bwalle@suse.de are

origin.patch
linux-next.patch
firmware-fix-memmap-printk-format-warnings.patch

