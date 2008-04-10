From: akpm@linux-foundation.org
Subject: + proc-remove-proc-mac_iop.patch added to -mm tree
Date: Thu, 10 Apr 2008 14:34:46 -0700
Message-ID: <200804102134.m3ALYkwn018469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753373AbYDJVg1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 17:36:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, joern@wohnheim.fh-wedel.de, simon@fire.lp0.eu, zippel@linux-m68k.org


The patch titled
     proc: remove /proc/mac_iop
has been added to the -mm tree.  Its filename is
     proc-remove-proc-mac_iop.patch

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
-
-#endif /* CONFIG_PROC_FS */
_

Patches currently in -mm which might be from adobriyan@sw.ru are

git-x86.patch
git-net.patch
git-cryptodev.patch
keys-switch-to-proc_create.patch
proc-print-more-information-when-removing-non-empty-directories.patch
proc-switch-to-proc_create.patch
proc-switch-proc-driver-ray_cs-ray_cs-to-seq_file-interface.patch
proc-switch-proc-driver-radio-typhoon-to-seq_file-interface.patch
proc-switch-proc-bus-zorro-devices-to-seq_file-interface.patch
proc-switch-proc-apm-to-seq_file-interface.patch
proc-remove-proc-mac_iop.patch
proc-switch-proc-bus-ecard-devices-to-seq_file-interface.patch
proc-switch-proc-excite-unit_id-to-seq_file-interface.patch
proc-switch-proc-irda-irnet-to-seq_file-interface.patch
proc-convert-proc-bus-nubus-to-seq_file-interface.patch
proc-switch-proc-ip2mem-to-seq_file-interface.patch
proc-switch-proc-scsi-device_info-to-seq_file-interface.patch
proc-remove-get_info-infrastructure.patch
sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch
single_open-seq_release-leak-diagnostics.patch

