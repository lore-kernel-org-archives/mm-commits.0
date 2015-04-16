From: akpm@linux-foundation.org
Subject: [merged] arm-plat-pxa-remove-use-of-seq_printf-return-value.patch removed from -mm tree
Date: Thu, 16 Apr 2015 09:55:24 -0700
Message-ID: <552fe97c.X7hFHpgc/U/q0Iu/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43184 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbbDPQtz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:49:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, linux@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: plat-pxa: remove use of seq_printf return value
has been removed from the -mm tree.  Its filename was
     arm-plat-pxa-remove-use-of-seq_printf-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: ARM: plat-pxa: remove use of seq_printf return value

The seq_printf return value, because it's frequently misused,
(as it is here, it doesn't return # of chars emitted) will
eventually be converted to void.

See: commit 1f33c41c03da ("seq_file: Rename seq_overflow() to
     seq_has_overflowed() and make public")

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/plat-pxa/dma.c |  111 ++++++++++++++++++--------------------
 1 file changed, 53 insertions(+), 58 deletions(-)

diff -puN arch/arm/plat-pxa/dma.c~arm-plat-pxa-remove-use-of-seq_printf-return-value arch/arm/plat-pxa/dma.c
--- a/arch/arm/plat-pxa/dma.c~arm-plat-pxa-remove-use-of-seq_printf-return-value
+++ a/arch/arm/plat-pxa/dma.c
@@ -51,19 +51,19 @@ static struct dentry *dbgfs_root, *dbgfs
 
 static int dbg_show_requester_chan(struct seq_file *s, void *p)
 {
-	int pos = 0;
 	int chan = (int)s->private;
 	int i;
 	u32 drcmr;
 
-	pos += seq_printf(s, "DMA channel %d requesters list :\n", chan);
+	seq_printf(s, "DMA channel %d requesters list :\n", chan);
 	for (i = 0; i < DMA_MAX_REQUESTERS; i++) {
 		drcmr = DRCMR(i);
 		if ((drcmr & DRCMR_CHLNUM) == chan)
-			pos += seq_printf(s, "\tRequester %d (MAPVLD=%d)\n", i,
-					  !!(drcmr & DRCMR_MAPVLD));
+			seq_printf(s, "\tRequester %d (MAPVLD=%d)\n",
+				   i, !!(drcmr & DRCMR_MAPVLD));
 	}
-	return pos;
+
+	return 0;
 }
 
 static inline int dbg_burst_from_dcmd(u32 dcmd)
@@ -83,7 +83,6 @@ static int is_phys_valid(unsigned long a
 
 static int dbg_show_descriptors(struct seq_file *s, void *p)
 {
-	int pos = 0;
 	int chan = (int)s->private;
 	int i, max_show = 20, burst, width;
 	u32 dcmd;
@@ -94,44 +93,43 @@ static int dbg_show_descriptors(struct s
 	spin_lock_irqsave(&dma_channels[chan].lock, flags);
 	phys_desc = DDADR(chan);
 
-	pos += seq_printf(s, "DMA channel %d descriptors :\n", chan);
-	pos += seq_printf(s, "[%03d] First descriptor unknown\n", 0);
+	seq_printf(s, "DMA channel %d descriptors :\n", chan);
+	seq_printf(s, "[%03d] First descriptor unknown\n", 0);
 	for (i = 1; i < max_show && is_phys_valid(phys_desc); i++) {
 		desc = phys_to_virt(phys_desc);
 		dcmd = desc->dcmd;
 		burst = dbg_burst_from_dcmd(dcmd);
 		width = (1 << ((dcmd >> 14) & 0x3)) >> 1;
 
-		pos += seq_printf(s, "[%03d] Desc at %08lx(virt %p)\n",
-				  i, phys_desc, desc);
-		pos += seq_printf(s, "\tDDADR = %08x\n", desc->ddadr);
-		pos += seq_printf(s, "\tDSADR = %08x\n", desc->dsadr);
-		pos += seq_printf(s, "\tDTADR = %08x\n", desc->dtadr);
-		pos += seq_printf(s, "\tDCMD  = %08x (%s%s%s%s%s%s%sburst=%d"
-				  " width=%d len=%d)\n",
-				  dcmd,
-				  DCMD_STR(INCSRCADDR), DCMD_STR(INCTRGADDR),
-				  DCMD_STR(FLOWSRC), DCMD_STR(FLOWTRG),
-				  DCMD_STR(STARTIRQEN), DCMD_STR(ENDIRQEN),
-				  DCMD_STR(ENDIAN), burst, width,
-				  dcmd & DCMD_LENGTH);
+		seq_printf(s, "[%03d] Desc at %08lx(virt %p)\n",
+			   i, phys_desc, desc);
+		seq_printf(s, "\tDDADR = %08x\n", desc->ddadr);
+		seq_printf(s, "\tDSADR = %08x\n", desc->dsadr);
+		seq_printf(s, "\tDTADR = %08x\n", desc->dtadr);
+		seq_printf(s, "\tDCMD  = %08x (%s%s%s%s%s%s%sburst=%d width=%d len=%d)\n",
+			   dcmd,
+			   DCMD_STR(INCSRCADDR), DCMD_STR(INCTRGADDR),
+			   DCMD_STR(FLOWSRC), DCMD_STR(FLOWTRG),
+			   DCMD_STR(STARTIRQEN), DCMD_STR(ENDIRQEN),
+			   DCMD_STR(ENDIAN), burst, width,
+			   dcmd & DCMD_LENGTH);
 		phys_desc = desc->ddadr;
 	}
 	if (i == max_show)
-		pos += seq_printf(s, "[%03d] Desc at %08lx ... max display reached\n",
-				  i, phys_desc);
+		seq_printf(s, "[%03d] Desc at %08lx ... max display reached\n",
+			   i, phys_desc);
 	else
-		pos += seq_printf(s, "[%03d] Desc at %08lx is %s\n",
-				  i, phys_desc, phys_desc == DDADR_STOP ?
-				  "DDADR_STOP" : "invalid");
+		seq_printf(s, "[%03d] Desc at %08lx is %s\n",
+			   i, phys_desc, phys_desc == DDADR_STOP ?
+			   "DDADR_STOP" : "invalid");
 
 	spin_unlock_irqrestore(&dma_channels[chan].lock, flags);
-	return pos;
+
+	return 0;
 }
 
 static int dbg_show_chan_state(struct seq_file *s, void *p)
 {
-	int pos = 0;
 	int chan = (int)s->private;
 	u32 dcsr, dcmd;
 	int burst, width;
@@ -142,42 +140,39 @@ static int dbg_show_chan_state(struct se
 	burst = dbg_burst_from_dcmd(dcmd);
 	width = (1 << ((dcmd >> 14) & 0x3)) >> 1;
 
-	pos += seq_printf(s, "DMA channel %d\n", chan);
-	pos += seq_printf(s, "\tPriority : %s\n",
-			  str_prio[dma_channels[chan].prio]);
-	pos += seq_printf(s, "\tUnaligned transfer bit: %s\n",
-			  DALGN & (1 << chan) ? "yes" : "no");
-	pos += seq_printf(s, "\tDCSR  = %08x (%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s)\n",
-			  dcsr, DCSR_STR(RUN), DCSR_STR(NODESC),
-			  DCSR_STR(STOPIRQEN), DCSR_STR(EORIRQEN),
-			  DCSR_STR(EORJMPEN), DCSR_STR(EORSTOPEN),
-			  DCSR_STR(SETCMPST), DCSR_STR(CLRCMPST),
-			  DCSR_STR(CMPST), DCSR_STR(EORINTR), DCSR_STR(REQPEND),
-			  DCSR_STR(STOPSTATE), DCSR_STR(ENDINTR),
-			  DCSR_STR(STARTINTR), DCSR_STR(BUSERR));
-
-	pos += seq_printf(s, "\tDCMD  = %08x (%s%s%s%s%s%s%sburst=%d width=%d"
-			  " len=%d)\n",
-			  dcmd,
-			  DCMD_STR(INCSRCADDR), DCMD_STR(INCTRGADDR),
-			  DCMD_STR(FLOWSRC), DCMD_STR(FLOWTRG),
-			  DCMD_STR(STARTIRQEN), DCMD_STR(ENDIRQEN),
-			  DCMD_STR(ENDIAN), burst, width, dcmd & DCMD_LENGTH);
-	pos += seq_printf(s, "\tDSADR = %08x\n", DSADR(chan));
-	pos += seq_printf(s, "\tDTADR = %08x\n", DTADR(chan));
-	pos += seq_printf(s, "\tDDADR = %08x\n", DDADR(chan));
-	return pos;
+	seq_printf(s, "DMA channel %d\n", chan);
+	seq_printf(s, "\tPriority : %s\n", str_prio[dma_channels[chan].prio]);
+	seq_printf(s, "\tUnaligned transfer bit: %s\n",
+		   DALGN & (1 << chan) ? "yes" : "no");
+	seq_printf(s, "\tDCSR  = %08x (%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s)\n",
+		   dcsr, DCSR_STR(RUN), DCSR_STR(NODESC),
+		   DCSR_STR(STOPIRQEN), DCSR_STR(EORIRQEN),
+		   DCSR_STR(EORJMPEN), DCSR_STR(EORSTOPEN),
+		   DCSR_STR(SETCMPST), DCSR_STR(CLRCMPST),
+		   DCSR_STR(CMPST), DCSR_STR(EORINTR), DCSR_STR(REQPEND),
+		   DCSR_STR(STOPSTATE), DCSR_STR(ENDINTR),
+		   DCSR_STR(STARTINTR), DCSR_STR(BUSERR));
+
+	seq_printf(s, "\tDCMD  = %08x (%s%s%s%s%s%s%sburst=%d width=%d len=%d)\n",
+		   dcmd,
+		   DCMD_STR(INCSRCADDR), DCMD_STR(INCTRGADDR),
+		   DCMD_STR(FLOWSRC), DCMD_STR(FLOWTRG),
+		   DCMD_STR(STARTIRQEN), DCMD_STR(ENDIRQEN),
+		   DCMD_STR(ENDIAN), burst, width, dcmd & DCMD_LENGTH);
+	seq_printf(s, "\tDSADR = %08x\n", DSADR(chan));
+	seq_printf(s, "\tDTADR = %08x\n", DTADR(chan));
+	seq_printf(s, "\tDDADR = %08x\n", DDADR(chan));
+
+	return 0;
 }
 
 static int dbg_show_state(struct seq_file *s, void *p)
 {
-	int pos = 0;
-
 	/* basic device status */
-	pos += seq_printf(s, "DMA engine status\n");
-	pos += seq_printf(s, "\tChannel number: %d\n", num_dma_channels);
+	seq_puts(s, "DMA engine status\n");
+	seq_printf(s, "\tChannel number: %d\n", num_dma_channels);
 
-	return pos;
+	return 0;
 }
 
 #define DBGFS_FUNC_DECL(name) \
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
lib-vsprintfc-even-faster-decimal-conversion.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
checkpatch-add-spell-checking-of-email-subject-line.patch
checkpatch-spell-check-reudce.patch
checkpatch-add-optional-codespell-dictionary-to-find-more-typos.patch
checkpatch-match-more-world-writable-permissions.patch
checkpatch-match-more-world-writable-permissions-fix.patch
checkpatch-improve-return-negative-errno-check.patch
checkpatch-add-test-for-repeated-const-uses.patch
checkpatch-dont-ask-for-asm-fileh-to-linux-fileh-unconditionally.patch
checkpatch-submittingpatches-suggest-line-wrapping-commit-messages-at-75-columns.patch
checkpatch-add-define-foo-string-long-line-exception.patch
checkpatch-add-uart_ops-to-normally-const-structs.patch
checkpatch-add-prefer-array_size-test.patch
checkpatch-improve-operator-spacing-check.patch
checkpatch-add-a-test-for-const-with-__read_mostly-uses.patch
checkpatchpl-new-instances-of-enosys-are-errors.patch
errnoh-improve-enosyss-comment.patch
checkpatch-fix-fix-use-with-a-patch-of-multiple-files.patch
checkpatch-avoid-spaces-required-around-that-false-positive.patch
rtc-use-more-standard-kernel-logging-styles.patch
adfs-returning-correct-return-values.patch
linux-next.patch
proc-show-locks-in-proc-pid-fdinfo-x.patch
proc-show-locks-in-proc-pid-fdinfo-x-v2.patch

