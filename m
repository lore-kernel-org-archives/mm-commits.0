From: akpm@linux-foundation.org
Subject: [folded] proc_fops-convert-drivers-isdn-to-seq_file-fix.patch removed from -mm tree
Date: Mon, 21 Dec 2009 15:57:49 -0800
Message-ID: <200912212357.nBLNvnS4003745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751606AbZLUX6A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Dec 2009 18:58:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, isdn@linux-pingi.de, tilman@imap.cc, mm-commits@vger.kernel.org


The patch titled
     proc_fops-convert-drivers-isdn-to-seq_file-fix
has been removed from the -mm tree.  Its filename was
     proc_fops-convert-drivers-isdn-to-seq_file-fix.patch

This patch was dropped because it was folded into proc_fops-convert-drivers-isdn-to-seq_file.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc_fops-convert-drivers-isdn-to-seq_file-fix
From: Alexey Dobriyan <adobriyan@gmail.com>

Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/gigaset/capi.c |   70 +++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 35 deletions(-)

diff -puN drivers/isdn/gigaset/capi.c~proc_fops-convert-drivers-isdn-to-seq_file-fix drivers/isdn/gigaset/capi.c
--- a/drivers/isdn/gigaset/capi.c~proc_fops-convert-drivers-isdn-to-seq_file-fix
+++ a/drivers/isdn/gigaset/capi.c
@@ -2106,35 +2106,22 @@ static char *gigaset_procinfo(struct cap
 	return ctr->name;	/* ToDo: more? */
 }
 
-/**
- * gigaset_ctr_read_proc() - build controller proc file entry
- * @page:	buffer of PAGE_SIZE bytes for receiving the entry.
- * @start:	unused.
- * @off:	unused.
- * @count:	unused.
- * @eof:	unused.
- * @ctr:	controller descriptor structure.
- *
- * Return value: length of generated entry
- */
-static int gigaset_ctr_read_proc(char *page, char **start, off_t off,
-			  int count, int *eof, struct capi_ctr *ctr)
+static int gigaset_proc_show(struct seq_file *m, void *v)
 {
+	struct capi_ctr *ctr = m->private;
 	struct cardstate *cs = ctr->driverdata;
 	char *s;
 	int i;
-	int len = 0;
-	len += sprintf(page+len, "%-16s %s\n", "name", ctr->name);
-	len += sprintf(page+len, "%-16s %s %s\n", "dev",
+
+	seq_printf(m, "%-16s %s\n", "name", ctr->name);
+	seq_printf(m, "%-16s %s %s\n", "dev",
 			dev_driver_string(cs->dev), dev_name(cs->dev));
-	len += sprintf(page+len, "%-16s %d\n", "id", cs->myid);
+	seq_printf(m, "%-16s %d\n", "id", cs->myid);
 	if (cs->gotfwver)
-		len += sprintf(page+len, "%-16s %d.%d.%d.%d\n", "firmware",
+		seq_printf(m, "%-16s %d.%d.%d.%d\n", "firmware",
 			cs->fwver[0], cs->fwver[1], cs->fwver[2], cs->fwver[3]);
-	len += sprintf(page+len, "%-16s %d\n", "channels",
-			cs->channels);
-	len += sprintf(page+len, "%-16s %s\n", "onechannel",
-			cs->onechannel ? "yes" : "no");
+	seq_printf(m, "%-16s %d\n", "channels", cs->channels);
+	seq_printf(m, "%-16s %s\n", "onechannel", cs->onechannel ? "yes" : "no");
 
 	switch (cs->mode) {
 	case M_UNKNOWN:
@@ -2152,7 +2139,7 @@ static int gigaset_ctr_read_proc(char *p
 	default:
 		s = "??";
 	}
-	len += sprintf(page+len, "%-16s %s\n", "mode", s);
+	seq_printf(m, "%-16s %s\n", "mode", s);
 
 	switch (cs->mstate) {
 	case MS_UNINITIALIZED:
@@ -2176,25 +2163,25 @@ static int gigaset_ctr_read_proc(char *p
 	default:
 		s = "??";
 	}
-	len += sprintf(page+len, "%-16s %s\n", "mstate", s);
+	seq_printf(m, "%-16s %s\n", "mstate", s);
 
-	len += sprintf(page+len, "%-16s %s\n", "running",
+	seq_printf(m, "%-16s %s\n", "running",
 			cs->running ? "yes" : "no");
-	len += sprintf(page+len, "%-16s %s\n", "connected",
+	seq_printf(m, "%-16s %s\n", "connected",
 			cs->connected ? "yes" : "no");
-	len += sprintf(page+len, "%-16s %s\n", "isdn_up",
+	seq_printf(m, "%-16s %s\n", "isdn_up",
 			cs->isdn_up ? "yes" : "no");
-	len += sprintf(page+len, "%-16s %s\n", "cidmode",
+	seq_printf(m, "%-16s %s\n", "cidmode",
 			cs->cidmode ? "yes" : "no");
 
 	for (i = 0; i < cs->channels; i++) {
-		len += sprintf(page+len, "[%d]%-13s %d\n", i, "corrupted",
+		seq_printf(m, "[%d]%-13s %d\n", i, "corrupted",
 				cs->bcs[i].corrupted);
-		len += sprintf(page+len, "[%d]%-13s %d\n", i, "trans_down",
+		seq_printf(m, "[%d]%-13s %d\n", i, "trans_down",
 				cs->bcs[i].trans_down);
-		len += sprintf(page+len, "[%d]%-13s %d\n", i, "trans_up",
+		seq_printf(m, "[%d]%-13s %d\n", i, "trans_up",
 				cs->bcs[i].trans_up);
-		len += sprintf(page+len, "[%d]%-13s %d\n", i, "chstate",
+		seq_printf(m, "[%d]%-13s %d\n", i, "chstate",
 				cs->bcs[i].chstate);
 		switch (cs->bcs[i].proto2) {
 		case L2_BITSYNC:
@@ -2209,11 +2196,24 @@ static int gigaset_ctr_read_proc(char *p
 		default:
 			s = "??";
 		}
-		len += sprintf(page+len, "[%d]%-13s %s\n", i, "proto2", s);
+		seq_printf(m, "[%d]%-13s %s\n", i, "proto2", s);
 	}
-	return len;
+	return 0;
 }
 
+static int gigaset_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, gigaset_proc_show, PDE(inode)->data);
+}
+
+static const struct file_operations gigaset_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= gigaset_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 
 static struct capi_driver capi_driver_gigaset = {
 	.name		= "gigaset",
@@ -2256,7 +2256,7 @@ int gigaset_isdn_register(struct cardsta
 	iif->ctr.release_appl  = gigaset_release_appl;
 	iif->ctr.send_message  = gigaset_send_message;
 	iif->ctr.procinfo      = gigaset_procinfo;
-	iif->ctr.ctr_read_proc = gigaset_ctr_read_proc;
+	iif->ctr.proc_fops = &gigaset_proc_fops;
 	INIT_LIST_HEAD(&iif->appls);
 	skb_queue_head_init(&iif->sendqueue);
 	atomic_set(&iif->sendqlen, 0);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
asus_acpi-convert-to-seq_file.patch
toshiba_acpi-convert-to-seq_file.patch
arm-convert-proc-cpu-aligment-to-seq_file.patch
iseries-convert-to-proc_fops.patch
proc_fops-convert-av7110.patch
proc_fops-convert-drivers-isdn-to-seq_file.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix2.patch
mpt-fusion-convert-to-seq_file.patch
uml-irq-register-race-condition.patch

