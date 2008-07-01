From: akpm@linux-foundation.org
Subject: + parport_pc-add-base_hi-bar-for-oxsemi_840.patch added to -mm tree
Date: Tue, 01 Jul 2008 15:00:40 -0700
Message-ID: <200807012200.m61M0eZ6016753@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43088 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752275AbYGAWAp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 18:00:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de


The patch titled
     parport_pc: add base_hi BAR for oxsemi_840
has been added to the -mm tree.  Its filename is
     parport_pc-add-base_hi-bar-for-oxsemi_840.patch

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
parport_pc-add-base_hi-bar-for-oxsemi_840.patch
linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
revert-revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
revert-revert-revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
drivers-char-rtcc-make-2-functions-static.patch

