From: akpm@linux-foundation.org
Subject: + hda_intelc-consolidate-bitfields.patch added to -mm tree
Date: Thu, 16 Apr 2009 17:06:46 -0700
Message-ID: <200904170006.n3H06krE007559@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752339AbZDQAJf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Apr 2009 20:09:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, tiwai@suse.de


The patch titled
     hda_intel.c: consolidate bitfields
has been added to the -mm tree.  Its filename is
     hda_intelc-consolidate-bitfields.patch

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
hda_intelc-consolidate-bitfields.patch

