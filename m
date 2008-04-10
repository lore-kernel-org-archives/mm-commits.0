From: akpm@linux-foundation.org
Subject: + proc-switch-proc-ip2mem-to-seq_file-interface.patch added to -mm tree
Date: Thu, 10 Apr 2008 14:34:59 -0700
Message-ID: <200804102134.m3ALYxdL018484@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57232 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757889AbYDJVnb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 17:43:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, gregkh@suse.de, jdike@addtoit.com, jeff@garzik.org


The patch titled
     proc: switch /proc/ip2mem to seq_file interface
has been added to the -mm tree.  Its filename is
     proc-switch-proc-ip2mem-to-seq_file-interface.patch

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
Subject: proc: switch /proc/ip2mem to seq_file interface
From: Alexey Dobriyan <adobriyan@sw.ru>

/******************************************/
/* Remove useless comment, while I am it. */
/******************************************/

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ip2/ip2main.c |   53 ++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 28 deletions(-)

diff -puN drivers/char/ip2/ip2main.c~proc-switch-proc-ip2mem-to-seq_file-interface drivers/char/ip2/ip2main.c
--- a/drivers/char/ip2/ip2main.c~proc-switch-proc-ip2mem-to-seq_file-interface
+++ a/drivers/char/ip2/ip2main.c
@@ -133,8 +133,9 @@
  *****************/
 
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 
-static int ip2_read_procmem(char *, char **, off_t, int);
+static const struct file_operations ip2mem_proc_fops;
 static int ip2_read_proc(char *, char **, off_t, int, int *, void * );
 
 /********************/
@@ -697,7 +698,7 @@ ip2_loadmain(int *iop, int *irqp, unsign
 		}
 	}
 	/* Register the read_procmem thing */
-	if (!create_proc_info_entry("ip2mem",0,NULL,ip2_read_procmem)) {
+	if (!proc_create("ip2mem",0,NULL,&ip2mem_proc_fops)) {
 		printk(KERN_ERR "IP2: failed to register read_procmem\n");
 	} else {
 
@@ -2969,65 +2970,61 @@ ip2_ipl_open( struct inode *pInode, stru
 	}
 	return 0;
 }
-/******************************************************************************/
-/* Function:   ip2_read_procmem                                               */
-/* Parameters:                                                                */
-/*                                                                            */
-/* Returns: Length of output                                                  */
-/*                                                                            */
-/* Description:                                                               */
-/*   Supplies some driver operating parameters                                */
-/*	Not real useful unless your debugging the fifo							  */
-/*                                                                            */
-/******************************************************************************/
-
-#define LIMIT  (PAGE_SIZE - 120)
 
 static int
-ip2_read_procmem(char *buf, char **start, off_t offset, int len)
+proc_ip2mem_show(struct seq_file *m, void *v)
 {
 	i2eBordStrPtr  pB;
 	i2ChanStrPtr  pCh;
 	PTTY tty;
 	int i;
 
-	len = 0;
-
 #define FMTLINE	"%3d: 0x%08x 0x%08x 0%011o 0%011o\n"
 #define FMTLIN2	"     0x%04x 0x%04x tx flow 0x%x\n"
 #define FMTLIN3	"     0x%04x 0x%04x rc flow\n"
 
-	len += sprintf(buf+len,"\n");
+	seq_printf(m,"\n");
 
 	for( i = 0; i < IP2_MAX_BOARDS; ++i ) {
 		pB = i2BoardPtrTable[i];
 		if ( pB ) {
-			len += sprintf(buf+len,"board %d:\n",i);
-			len += sprintf(buf+len,"\tFifo rem: %d mty: %x outM %x\n",
+			seq_printf(m,"board %d:\n",i);
+			seq_printf(m,"\tFifo rem: %d mty: %x outM %x\n",
 				pB->i2eFifoRemains,pB->i2eWaitingForEmptyFifo,pB->i2eOutMailWaiting);
 		}
 	}
 
-	len += sprintf(buf+len,"#: tty flags, port flags,     cflags,     iflags\n");
+	seq_printf(m,"#: tty flags, port flags,     cflags,     iflags\n");
 	for (i=0; i < IP2_MAX_PORTS; i++) {
-		if (len > LIMIT)
-			break;
 		pCh = DevTable[i];
 		if (pCh) {
 			tty = pCh->pTTY;
 			if (tty && tty->count) {
-				len += sprintf(buf+len,FMTLINE,i,(int)tty->flags,pCh->flags,
+				seq_printf(m,FMTLINE,i,(int)tty->flags,pCh->flags,
 									tty->termios->c_cflag,tty->termios->c_iflag);
 
-				len += sprintf(buf+len,FMTLIN2,
+				seq_printf(m,FMTLIN2,
 						pCh->outfl.asof,pCh->outfl.room,pCh->channelNeeds);
-				len += sprintf(buf+len,FMTLIN3,pCh->infl.asof,pCh->infl.room);
+				seq_printf(m,FMTLIN3,pCh->infl.asof,pCh->infl.room);
 			}
 		}
 	}
-	return len;
+	return 0;
+}
+
+static int proc_ip2mem_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, proc_ip2mem_show, NULL);
 }
 
+static const struct file_operations ip2mem_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= proc_ip2mem_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /*
  * This is the handler for /proc/tty/driver/ip2
  *
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

