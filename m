From: akpm@linux-foundation.org
Subject: - isdn-use-non-racy-method-for-proc-entries-creation.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:47:27 -0700
Message-ID: <200804300547.m3U5lR6t029706@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758641AbYD3FsE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:48:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, adobriyan@gmail.com, ebiederm@xmission.com, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     isdn: use non-racy method for proc entries creation
has been removed from the -mm tree.  Its filename was
     isdn-use-non-racy-method-for-proc-entries-creation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isdn: use non-racy method for proc entries creation
From: "Denis V. Lunev" <den@openvz.org>

Use proc_create()/proc_create_data() to make sure that ->proc_fops and ->data
be setup before gluing PDE to main tree.

Add correct ->owner to proc_fops to fix reading/module unloading race.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Acked-by: Karsten Keil <kkeil@suse.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/capi/kcapi_proc.c          |   24 +++++++++-------------
 drivers/isdn/divert/divert_procfs.c     |    5 +---
 drivers/isdn/hardware/eicon/divasproc.c |    8 +------
 drivers/isdn/hysdn/hysdn_procconf.c     |    9 +++-----
 drivers/isdn/hysdn/hysdn_proclog.c      |    8 +++----
 5 files changed, 22 insertions(+), 32 deletions(-)

diff -puN drivers/isdn/capi/kcapi_proc.c~isdn-use-non-racy-method-for-proc-entries-creation drivers/isdn/capi/kcapi_proc.c
--- a/drivers/isdn/capi/kcapi_proc.c~isdn-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/isdn/capi/kcapi_proc.c
@@ -114,6 +114,7 @@ static int seq_contrstats_open(struct in
 }
 
 static const struct file_operations proc_controller_ops = {
+	.owner		= THIS_MODULE,
 	.open		= seq_controller_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -121,6 +122,7 @@ static const struct file_operations proc
 };
 
 static const struct file_operations proc_contrstats_ops = {
+	.owner		= THIS_MODULE,
 	.open		= seq_contrstats_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -219,6 +221,7 @@ seq_applstats_open(struct inode *inode, 
 }
 
 static const struct file_operations proc_applications_ops = {
+	.owner		= THIS_MODULE,
 	.open		= seq_applications_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -226,21 +229,13 @@ static const struct file_operations proc
 };
 
 static const struct file_operations proc_applstats_ops = {
+	.owner		= THIS_MODULE,
 	.open		= seq_applstats_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= seq_release,
 };
 
-static void
-create_seq_entry(char *name, mode_t mode, const struct file_operations *f)
-{
-	struct proc_dir_entry *entry;
-	entry = create_proc_entry(name, mode, NULL);
-	if (entry)
-		entry->proc_fops = f;
-}
-
 // ---------------------------------------------------------------------------
 
 static void *capi_driver_start(struct seq_file *seq, loff_t *pos)
@@ -283,6 +278,7 @@ seq_capi_driver_open(struct inode *inode
 }
 
 static const struct file_operations proc_driver_ops = {
+	.owner		= THIS_MODULE,
 	.open		= seq_capi_driver_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -296,11 +292,11 @@ kcapi_proc_init(void)
 {
 	proc_mkdir("capi",             NULL);
 	proc_mkdir("capi/controllers", NULL);
-	create_seq_entry("capi/controller",   0, &proc_controller_ops);
-	create_seq_entry("capi/contrstats",   0, &proc_contrstats_ops);
-	create_seq_entry("capi/applications", 0, &proc_applications_ops);
-	create_seq_entry("capi/applstats",    0, &proc_applstats_ops);
-	create_seq_entry("capi/driver",       0, &proc_driver_ops);
+	proc_create("capi/controller",   0, NULL, &proc_controller_ops);
+	proc_create("capi/contrstats",   0, NULL, &proc_contrstats_ops);
+	proc_create("capi/applications", 0, NULL, &proc_applications_ops);
+	proc_create("capi/applstats",    0, NULL, &proc_applstats_ops);
+	proc_create("capi/driver",       0, NULL, &proc_driver_ops);
 }
 
 void __exit
diff -puN drivers/isdn/divert/divert_procfs.c~isdn-use-non-racy-method-for-proc-entries-creation drivers/isdn/divert/divert_procfs.c
--- a/drivers/isdn/divert/divert_procfs.c~isdn-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/isdn/divert/divert_procfs.c
@@ -288,13 +288,12 @@ divert_dev_init(void)
 	isdn_proc_entry = proc_mkdir("isdn", init_net.proc_net);
 	if (!isdn_proc_entry)
 		return (-1);
-	isdn_divert_entry = create_proc_entry("divert", S_IFREG | S_IRUGO, isdn_proc_entry);
+	isdn_divert_entry = proc_create("divert", S_IFREG | S_IRUGO,
+					isdn_proc_entry, &isdn_fops);
 	if (!isdn_divert_entry) {
 		remove_proc_entry("isdn", init_net.proc_net);
 		return (-1);
 	}
-	isdn_divert_entry->proc_fops = &isdn_fops; 
-	isdn_divert_entry->owner = THIS_MODULE; 
 #endif	/* CONFIG_PROC_FS */
 
 	return (0);
diff -puN drivers/isdn/hardware/eicon/divasproc.c~isdn-use-non-racy-method-for-proc-entries-creation drivers/isdn/hardware/eicon/divasproc.c
--- a/drivers/isdn/hardware/eicon/divasproc.c~isdn-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/isdn/hardware/eicon/divasproc.c
@@ -125,15 +125,11 @@ static const struct file_operations diva
 
 int create_divas_proc(void)
 {
-	divas_proc_entry = create_proc_entry(divas_proc_name,
-					     S_IFREG | S_IRUGO,
-					     proc_net_eicon);
+	proc_create(divas_proc_name, S_IFREG | S_IRUGO, proc_net_eicon,
+		    &divas_fops);
 	if (!divas_proc_entry)
 		return (0);
 
-	divas_proc_entry->proc_fops = &divas_fops;
-	divas_proc_entry->owner = THIS_MODULE;
-
 	return (1);
 }
 
diff -puN drivers/isdn/hysdn/hysdn_procconf.c~isdn-use-non-racy-method-for-proc-entries-creation drivers/isdn/hysdn/hysdn_procconf.c
--- a/drivers/isdn/hysdn/hysdn_procconf.c~isdn-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/isdn/hysdn/hysdn_procconf.c
@@ -370,6 +370,7 @@ hysdn_conf_close(struct inode *ino, stru
 /******************************************************/
 static const struct file_operations conf_fops =
 {
+	.owner		= THIS_MODULE,
 	.llseek         = no_llseek,
 	.read           = hysdn_conf_read,
 	.write          = hysdn_conf_write,
@@ -402,11 +403,9 @@ hysdn_procconf_init(void)
 	while (card) {
 
 		sprintf(conf_name, "%s%d", PROC_CONF_BASENAME, card->myid);
-		if ((card->procconf = (void *) create_proc_entry(conf_name,
-					     S_IFREG | S_IRUGO | S_IWUSR,
-					    hysdn_proc_entry)) != NULL) {
-			((struct proc_dir_entry *) card->procconf)->proc_fops = &conf_fops;
-			((struct proc_dir_entry *) card->procconf)->owner = THIS_MODULE;
+		if ((card->procconf = (void *) proc_create(conf_name,
+						S_IFREG | S_IRUGO | S_IWUSR,
+						hysdn_proc_entry)) != NULL) {
 			hysdn_proclog_init(card);	/* init the log file entry */
 		}
 		card = card->next;	/* next entry */
diff -puN drivers/isdn/hysdn/hysdn_proclog.c~isdn-use-non-racy-method-for-proc-entries-creation drivers/isdn/hysdn/hysdn_proclog.c
--- a/drivers/isdn/hysdn/hysdn_proclog.c~isdn-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/isdn/hysdn/hysdn_proclog.c
@@ -380,6 +380,7 @@ hysdn_log_poll(struct file *file, poll_t
 /**************************************************/
 static const struct file_operations log_fops =
 {
+	.owner		= THIS_MODULE,
 	.llseek         = no_llseek,
 	.read           = hysdn_log_read,
 	.write          = hysdn_log_write,
@@ -402,10 +403,9 @@ hysdn_proclog_init(hysdn_card * card)
 
 	if ((pd = kzalloc(sizeof(struct procdata), GFP_KERNEL)) != NULL) {
 		sprintf(pd->log_name, "%s%d", PROC_LOG_BASENAME, card->myid);
-		if ((pd->log = create_proc_entry(pd->log_name, S_IFREG | S_IRUGO | S_IWUSR, hysdn_proc_entry)) != NULL) {
-		        pd->log->proc_fops = &log_fops; 
-		        pd->log->owner = THIS_MODULE;
-		}
+		pd->log = proc_create(pd->log_name,
+				S_IFREG | S_IRUGO | S_IWUSR, hysdn_proc_entry,
+				&log_fops);
 
 		init_waitqueue_head(&(pd->rd_queue));
 
_

Patches currently in -mm which might be from den@openvz.org are

origin.patch
drivers-use-non-racy-method-for-proc-entries-creation-2-rio.patch
sunrpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch
netfilter-assign-pde-data-before-gluing-pde-into-proc-tree.patch
net-assign-pde-data-before-gluing-pde-into-proc-tree.patch
ipv6-assign-pde-data-before-gluing-pde-into-proc-tree.patch
atm-assign-pde-data-before-gluing-pde-into-proc-tree.patch
vlan-assign-pde-data-before-gluing-pde-into-proc-tree.patch
cciss-assign-pde-data-before-gluing-pde-into-proc-tree.patch
powerpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch
ipv4-assign-pde-data-before-gluing-pde-into-proc-tree.patch
netfilter-assign-pde-fops-before-gluing-pde-into-proc-tree.patch
netfilter-assign-pde-data-before-gluing-pde-into-proc-tree-2.patch
netns-assign-pde-data-before-gluing-entry-into-proc-tree.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

