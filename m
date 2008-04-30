From: akpm@linux-foundation.org
Subject: - proc-switch-proc-irda-irnet-to-seq_file-interface.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:46:19 -0700
Message-ID: <200804300546.m3U5kJW0029609@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757188AbYD3Frd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:47:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, davem@davemloft.net, samuel@sortiz.org, mm-commits@vger.kernel.org


The patch titled
     proc: switch /proc/irda/irnet to seq_file interface
has been removed from the -mm tree.  Its filename was
     proc-switch-proc-irda-irnet-to-seq_file-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: switch /proc/irda/irnet to seq_file interface
From: Alexey Dobriyan <adobriyan@sw.ru>

Probably interface misuse, because of the way iterating over hashbin is done.
However! Printing of socket number ("IrNET socket %d - ", i++") made conversion
to proper ->start/->next difficult enough to do blindly without hardware.
Said that, please apply.

Remove useless comment while I am it.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Samuel Ortiz <samuel@sortiz.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/irda/irnet/irnet_irda.c |   65 +++++++++++++++++-----------------
 net/irda/irnet/irnet_irda.h |    8 ----
 2 files changed, 34 insertions(+), 39 deletions(-)

diff -puN net/irda/irnet/irnet_irda.c~proc-switch-proc-irda-irnet-to-seq_file-interface net/irda/irnet/irnet_irda.c
--- a/net/irda/irnet/irnet_irda.c~proc-switch-proc-irda-irnet-to-seq_file-interface
+++ a/net/irda/irnet/irnet_irda.c
@@ -9,6 +9,7 @@
  */
 
 #include "irnet_irda.h"		/* Private header */
+#include <linux/seq_file.h>
 
 /*
  * PPP disconnect work: we need to make sure we're in
@@ -1717,34 +1718,23 @@ irnet_expiry_indication(discinfo_t *	exp
  */
 
 #ifdef CONFIG_PROC_FS
-/*------------------------------------------------------------------*/
-/*
- * Function irnet_proc_read (buf, start, offset, len, unused)
- *
- *    Give some info to the /proc file system
- */
 static int
-irnet_proc_read(char *	buf,
-		char **	start,
-		off_t	offset,
-		int	len)
+irnet_proc_show(struct seq_file *m, void *v)
 {
   irnet_socket *	self;
   char *		state;
   int			i = 0;
 
-  len = 0;
-
   /* Get the IrNET server information... */
-  len += sprintf(buf+len, "IrNET server - ");
-  len += sprintf(buf+len, "IrDA state: %s, ",
+  seq_printf(m, "IrNET server - ");
+  seq_printf(m, "IrDA state: %s, ",
 		 (irnet_server.running ? "running" : "dead"));
-  len += sprintf(buf+len, "stsap_sel: %02x, ", irnet_server.s.stsap_sel);
-  len += sprintf(buf+len, "dtsap_sel: %02x\n", irnet_server.s.dtsap_sel);
+  seq_printf(m, "stsap_sel: %02x, ", irnet_server.s.stsap_sel);
+  seq_printf(m, "dtsap_sel: %02x\n", irnet_server.s.dtsap_sel);
 
   /* Do we need to continue ? */
   if(!irnet_server.running)
-    return len;
+    return 0;
 
   /* Protect access to the instance list */
   spin_lock_bh(&irnet_server.spinlock);
@@ -1754,23 +1744,23 @@ irnet_proc_read(char *	buf,
   while(self != NULL)
     {
       /* Start printing info about the socket. */
-      len += sprintf(buf+len, "\nIrNET socket %d - ", i++);
+      seq_printf(m, "\nIrNET socket %d - ", i++);
 
       /* First, get the requested configuration */
-      len += sprintf(buf+len, "Requested IrDA name: \"%s\", ", self->rname);
-      len += sprintf(buf+len, "daddr: %08x, ", self->rdaddr);
-      len += sprintf(buf+len, "saddr: %08x\n", self->rsaddr);
+      seq_printf(m, "Requested IrDA name: \"%s\", ", self->rname);
+      seq_printf(m, "daddr: %08x, ", self->rdaddr);
+      seq_printf(m, "saddr: %08x\n", self->rsaddr);
 
       /* Second, get all the PPP info */
-      len += sprintf(buf+len, "	PPP state: %s",
+      seq_printf(m, "	PPP state: %s",
 		 (self->ppp_open ? "registered" : "unregistered"));
       if(self->ppp_open)
 	{
-	  len += sprintf(buf+len, ", unit: ppp%d",
+	  seq_printf(m, ", unit: ppp%d",
 			 ppp_unit_number(&self->chan));
-	  len += sprintf(buf+len, ", channel: %d",
+	  seq_printf(m, ", channel: %d",
 			 ppp_channel_index(&self->chan));
-	  len += sprintf(buf+len, ", mru: %d",
+	  seq_printf(m, ", mru: %d",
 			 self->mru);
 	  /* Maybe add self->flags ? Later... */
 	}
@@ -1789,10 +1779,10 @@ irnet_proc_read(char *	buf,
 	      state = "weird";
 	    else
 	      state = "idle";
-      len += sprintf(buf+len, "\n	IrDA state: %s, ", state);
-      len += sprintf(buf+len, "daddr: %08x, ", self->daddr);
-      len += sprintf(buf+len, "stsap_sel: %02x, ", self->stsap_sel);
-      len += sprintf(buf+len, "dtsap_sel: %02x\n", self->dtsap_sel);
+      seq_printf(m, "\n	IrDA state: %s, ", state);
+      seq_printf(m, "daddr: %08x, ", self->daddr);
+      seq_printf(m, "stsap_sel: %02x, ", self->stsap_sel);
+      seq_printf(m, "dtsap_sel: %02x\n", self->dtsap_sel);
 
       /* Next socket, please... */
       self = (irnet_socket *) hashbin_get_next(irnet_server.list);
@@ -1801,8 +1791,21 @@ irnet_proc_read(char *	buf,
   /* Spin lock end */
   spin_unlock_bh(&irnet_server.spinlock);
 
-  return len;
+  return 0;
 }
+
+static int irnet_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, irnet_proc_show, NULL);
+}
+
+static const struct file_operations irnet_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= irnet_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 #endif /* PROC_FS */
 
 
@@ -1841,7 +1844,7 @@ irda_irnet_init(void)
 
 #ifdef CONFIG_PROC_FS
   /* Add a /proc file for irnet infos */
-  create_proc_info_entry("irnet", 0, proc_irda, irnet_proc_read);
+  proc_create("irnet", 0, proc_irda, &irnet_proc_fops);
 #endif /* CONFIG_PROC_FS */
 
   /* Setup the IrNET server */
diff -puN net/irda/irnet/irnet_irda.h~proc-switch-proc-irda-irnet-to-seq_file-interface net/irda/irnet/irnet_irda.h
--- a/net/irda/irnet/irnet_irda.h~proc-switch-proc-irda-irnet-to-seq_file-interface
+++ a/net/irda/irnet/irnet_irda.h
@@ -159,14 +159,6 @@ static void
 				DISCOVERY_MODE,
 				void *);
 #endif
-/* -------------------------- PROC ENTRY -------------------------- */
-#ifdef CONFIG_PROC_FS
-static int
-	irnet_proc_read(char *,
-			char **,
-			off_t,
-			int);
-#endif /* CONFIG_PROC_FS */
 
 /**************************** VARIABLES ****************************/
 
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
single_open-seq_release-leak-diagnostics.patch

