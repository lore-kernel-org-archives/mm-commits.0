From: akpm@linux-foundation.org
Subject: - stifb-detect-cards-in-double-buffer-mode-more-reliably.patch removed from -mm tree
Date: Mon, 13 Aug 2007 22:02:32 -0700
Message-ID: <200708140502.l7E52Wdf031982@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33440 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760212AbXHNFDW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 01:03:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deller@gmx.de, adaplas@gmail.com, kyle@mcmartin.ca, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     stifb: detect cards in double buffer mode more reliably
has been removed from the -mm tree.  Its filename was
     stifb-detect-cards-in-double-buffer-mode-more-reliably.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: stifb: detect cards in double buffer mode more reliably
From: Helge Deller <deller@gmx.de>

Visualize-EG, Graffiti and A4450A graphics cards on PARISC can
be configured in double-buffer and standard mode, but the stifb
driver supports standard mode only.
This patch detects double-buffered cards more reliable.

It is a real bugfix for a very nasty problem for all parisc users which have
wrongly configured their graphic card.  The problem: The stifb graphics driver
will not detect that the card is wrongly configured and then nevertheless just
enables the graphics mode, which it shouldn't.  In the end, the user will see
no further updates / boot messages on the screen.

We had documented this problem already on our FAQ
(http://parisc-linux.org/faq/index.html#viseg "Why do I get corrupted graphics
with my Vis-EG/Graffiti/A4450A card?") but people still run into this problem.
 So having this fix in as early as possible can help us.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Cc: <stable@kernel.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/stifb.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff -puN drivers/video/stifb.c~stifb-detect-cards-in-double-buffer-mode-more-reliably drivers/video/stifb.c
--- a/drivers/video/stifb.c~stifb-detect-cards-in-double-buffer-mode-more-reliably
+++ a/drivers/video/stifb.c
@@ -1100,13 +1100,18 @@ stifb_init_fb(struct sti_struct *sti, in
 	/* only supported cards are allowed */
 	switch (fb->id) {
 	case CRT_ID_VISUALIZE_EG:
-		/* look for a double buffering device like e.g. the 
-		   "INTERNAL_EG_DX1024" in the RDI precisionbook laptop
-		   which won't work. The same device in non-double 
-		   buffering mode returns "INTERNAL_EG_X1024". */
-		if (strstr(sti->outptr.dev_name, "EG_DX")) {
-		   printk(KERN_WARNING 
-			"stifb: ignoring '%s'. Disable double buffering in IPL menu.\n",
+		/* Visualize cards can run either in "double buffer" or
+ 		  "standard" mode. Depending on the mode, the card reports
+		  a different device name, e.g. "INTERNAL_EG_DX1024" in double
+		  buffer mode and "INTERNAL_EG_X1024" in standard mode.
+		  Since this driver only supports standard mode, we check
+		  if the device name contains the string "DX" and tell the
+		  user how to reconfigure the card. */
+		if (strstr(sti->outptr.dev_name, "DX")) {
+		   printk(KERN_WARNING "WARNING: stifb framebuffer driver does not "
+			"support '%s' in double-buffer mode.\n"
+			KERN_WARNING "WARNING: Please disable the double-buffer mode "
+			"in IPL menu (the PARISC-BIOS).\n",
 			sti->outptr.dev_name);
 		   goto out_err0;
 		}
_

Patches currently in -mm which might be from deller@gmx.de are
