From: akpm@linux-foundation.org
Subject: - proc-remove-proc-mac_iop.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:46:11 -0700
Message-ID: <200804300546.m3U5kBmF029587@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758265AbYD3Frj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:47:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, joern@wohnheim.fh-wedel.de, simon@fire.lp0.eu, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     proc: remove /proc/mac_iop
has been removed from the -mm tree.  Its filename was
     proc-remove-proc-mac_iop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: remove /proc/mac_iop
From: Alexey Dobriyan <adobriyan@sw.ru>

Entry creation was commented for a long time and right now it stands on
the way of ->get_info removal, so unless nobody objects...

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Simon Arlott <simon@fire.lp0.eu>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Joern Engel <joern@wohnheim.fh-wedel.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/mac/iop.c |   85 ------------------------------------------
 1 file changed, 85 deletions(-)

diff -puN arch/m68k/mac/iop.c~proc-remove-proc-mac_iop arch/m68k/mac/iop.c
--- a/arch/m68k/mac/iop.c~proc-remove-proc-mac_iop
+++ a/arch/m68k/mac/iop.c
@@ -109,7 +109,6 @@
 #include <linux/mm.h>
 #include <linux/delay.h>
 #include <linux/init.h>
-#include <linux/proc_fs.h>
 #include <linux/interrupt.h>
 
 #include <asm/bootinfo.h>
@@ -124,10 +123,6 @@
 
 int iop_scc_present,iop_ism_present;
 
-#ifdef CONFIG_PROC_FS
-static int iop_get_proc_info(char *, char **, off_t, int);
-#endif /* CONFIG_PROC_FS */
-
 /* structure for tracking channel listeners */
 
 struct listener {
@@ -299,12 +294,6 @@ void __init iop_init(void)
 		iop_listeners[IOP_NUM_ISM][i].devname = NULL;
 		iop_listeners[IOP_NUM_ISM][i].handler = NULL;
 	}
-
-#if 0	/* Crashing in 2.4 now, not yet sure why.   --jmt */
-#ifdef CONFIG_PROC_FS
-	create_proc_info_entry("mac_iop", 0, NULL, iop_get_proc_info);
-#endif
-#endif
 }
 
 /*
@@ -637,77 +626,3 @@ irqreturn_t iop_ism_irq(int irq, void *d
 	}
 	return IRQ_HANDLED;
 }
-
-#ifdef CONFIG_PROC_FS
-
-char *iop_chan_state(int state)
-{
-	switch(state) {
-		case IOP_MSG_IDLE	: return "idle      ";
-		case IOP_MSG_NEW	: return "new       ";
-		case IOP_MSG_RCVD	: return "received  ";
-		case IOP_MSG_COMPLETE	: return "completed ";
-		default			: return "unknown   ";
-	}
-}
-
-int iop_dump_one_iop(char *buf, int iop_num, char *iop_name)
-{
-	int i,len = 0;
-	volatile struct mac_iop *iop = iop_base[iop_num];
-
-	len += sprintf(buf+len, "%s IOP channel states:\n\n", iop_name);
-	len += sprintf(buf+len, "##  send_state  recv_state  device\n");
-	len += sprintf(buf+len, "------------------------------------------------\n");
-	for (i = 0 ; i < NUM_IOP_CHAN ; i++) {
-		len += sprintf(buf+len, "%2d  %10s  %10s  %s\n", i,
-			iop_chan_state(iop_readb(iop, IOP_ADDR_SEND_STATE+i)),
-			iop_chan_state(iop_readb(iop, IOP_ADDR_RECV_STATE+i)),
-			iop_listeners[iop_num][i].handler?
-				      iop_listeners[iop_num][i].devname : "");
-
-	}
-	len += sprintf(buf+len, "\n");
-	return len;
-}
-
-static int iop_get_proc_info(char *buf, char **start, off_t pos, int count)
-{
-	int len, cnt;
-
-	cnt = 0;
-	len =  sprintf(buf, "IOPs detected:\n\n");
-
-	if (iop_scc_present) {
-		len += sprintf(buf+len, "SCC IOP (%p): status %02X\n",
-				iop_base[IOP_NUM_SCC],
-				(uint) iop_base[IOP_NUM_SCC]->status_ctrl);
-	}
-	if (iop_ism_present) {
-		len += sprintf(buf+len, "ISM IOP (%p): status %02X\n\n",
-				iop_base[IOP_NUM_ISM],
-				(uint) iop_base[IOP_NUM_ISM]->status_ctrl);
-	}
-
-	if (iop_scc_present) {
-		len += iop_dump_one_iop(buf+len, IOP_NUM_SCC, "SCC");
-
-	}
-
-	if (iop_ism_present) {
-		len += iop_dump_one_iop(buf+len, IOP_NUM_ISM, "ISM");
-
-	}
-
-	if (len >= pos) {
-		if (!*start) {
-			*start = buf + pos;
-			cnt = len - pos;
-		} else {
-			cnt += len;
-		}
-	}
-	return (count > cnt) ? cnt : count;
-}
