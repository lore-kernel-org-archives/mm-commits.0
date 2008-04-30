From: akpm@linux-foundation.org
Subject: - usb-use-non-racy-method-for-proc-entries-creation.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:47:07 -0700
Message-ID: <200804300547.m3U5l7de029676@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38967 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760475AbYD3GMP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, adobriyan@gmail.com, ebiederm@xmission.com, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     usb: use non-racy method for proc entries creation
has been removed from the -mm tree.  Its filename was
     usb-use-non-racy-method-for-proc-entries-creation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: use non-racy method for proc entries creation
From: "Denis V. Lunev" <den@openvz.org>

Use proc_create()/proc_create_data() to make sure that ->proc_fops and ->data
be setup before gluing PDE to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/at91_udc.c |   11 ++---------
 drivers/usb/gadget/omap_udc.c |    7 ++-----
 drivers/usb/host/sl811-hcd.c  |   10 +---------
 3 files changed, 5 insertions(+), 23 deletions(-)

diff -puN drivers/usb/gadget/at91_udc.c~usb-use-non-racy-method-for-proc-entries-creation drivers/usb/gadget/at91_udc.c
--- a/drivers/usb/gadget/at91_udc.c~usb-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/usb/gadget/at91_udc.c
@@ -231,6 +231,7 @@ static int proc_udc_open(struct inode *i
 }
 
 static const struct file_operations proc_ops = {
+	.owner		= THIS_MODULE,
 	.open		= proc_udc_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -239,15 +240,7 @@ static const struct file_operations proc
 
 static void create_debug_file(struct at91_udc *udc)
 {
-	struct proc_dir_entry *pde;
-
-	pde = create_proc_entry (debug_filename, 0, NULL);
-	udc->pde = pde;
-	if (pde == NULL)
-		return;
-
-	pde->proc_fops = &proc_ops;
-	pde->data = udc;
+	udc->pde = proc_create_data(debug_filename, 0, NULL, &proc_ops, udc);
 }
 
 static void remove_debug_file(struct at91_udc *udc)
diff -puN drivers/usb/gadget/omap_udc.c~usb-use-non-racy-method-for-proc-entries-creation drivers/usb/gadget/omap_udc.c
--- a/drivers/usb/gadget/omap_udc.c~usb-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/usb/gadget/omap_udc.c
@@ -2504,6 +2504,7 @@ static int proc_udc_open(struct inode *i
 }
 
 static const struct file_operations proc_ops = {
+	.owner		= THIS_MODULE,
 	.open		= proc_udc_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -2512,11 +2513,7 @@ static const struct file_operations proc
 
 static void create_proc_file(void)
 {
-	struct proc_dir_entry *pde;
-
-	pde = create_proc_entry (proc_filename, 0, NULL);
-	if (pde)
-		pde->proc_fops = &proc_ops;
+	proc_create(proc_filename, 0, NULL, &proc_ops);
 }
 
 static void remove_proc_file(void)
diff -puN drivers/usb/host/sl811-hcd.c~usb-use-non-racy-method-for-proc-entries-creation drivers/usb/host/sl811-hcd.c
--- a/drivers/usb/host/sl811-hcd.c~usb-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/usb/host/sl811-hcd.c
@@ -1506,15 +1506,7 @@ static const char proc_filename[] = "dri
 
 static void create_debug_file(struct sl811 *sl811)
 {
-	struct proc_dir_entry *pde;
-
-	pde = create_proc_entry(proc_filename, 0, NULL);
-	if (pde == NULL)
-		return;
-
-	pde->proc_fops = &proc_ops;
-	pde->data = sl811;
-	sl811->pde = pde;
+	sl811->pde = proc_create_data(proc_filename, 0, NULL, &proc_ops, sl811);
 }
 
 static void remove_debug_file(struct sl811 *sl811)
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

