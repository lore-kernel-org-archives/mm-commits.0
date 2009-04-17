From: akpm@linux-foundation.org
Subject: [merged] hda_intelc-consolidate-bitfields.patch removed from -mm tree
Date: Fri, 17 Apr 2009 11:14:14 -0700
Message-ID: <200904171814.n3HIEEBH019076@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37116 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756352AbZDQSRG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Apr 2009 14:17:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     hda_intel.c: consolidate bitfields
has been removed from the -mm tree.  Its filename was
     hda_intelc-consolidate-bitfields.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hda_intel.c: consolidate bitfields
From: Joe Perches <joe@perches.com>

Commit fa00e046b41663cbda9b1affc0594669e5f14219 ("hda_intel: fix
unexpected ring buffer positions") added a new bitfield not adjacent to
other bitfields in the same struct.  Move the new one.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/hda/hda_intel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN sound/pci/hda/hda_intel.c~hda_intelc-consolidate-bitfields sound/pci/hda/hda_intel.c
--- a/sound/pci/hda/hda_intel.c~hda_intelc-consolidate-bitfields
+++ a/sound/pci/hda/hda_intel.c
@@ -312,7 +312,6 @@ struct azx_dev {
 	unsigned int period_bytes; /* size of the period in bytes */
 	unsigned int frags;	/* number for period in the play buffer */
 	unsigned int fifo_size;	/* FIFO size */
-	unsigned int start_flag: 1;	/* stream full start flag */
 	unsigned long start_jiffies;	/* start + minimum jiffies */
 	unsigned long min_jiffies;	/* minimum jiffies before position is valid */
 
@@ -333,6 +332,7 @@ struct azx_dev {
 	unsigned int opened :1;
 	unsigned int running :1;
 	unsigned int irq_pending :1;
+	unsigned int start_flag: 1;	/* stream full start flag */
 	/*
 	 * For VIA:
 	 *  A flag to ensure DMA position is 0
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch

