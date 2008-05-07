From: akpm@linux-foundation.org
Subject: - powerpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch removed from -mm tree
Date: Tue, 06 May 2008 22:23:48 -0700
Message-ID: <200805070523.m475NmxS013225@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754636AbYEGFX7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 01:23:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, adobriyan@openvz.org, benh@kernel.crashing.org, ebiederm@xmission.com, paulus@au.ibm.com, mm-commits@vger.kernel.org


The patch titled
     powerpc: assign PDE->data before gluing PDE into /proc tree
has been removed from the -mm tree.  Its filename was
     powerpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: assign PDE->data before gluing PDE into /proc tree
From: "Denis V. Lunev" <den@openvz.org>

Simply replace proc_create and further data assigned with proc_create_data. 
No need to check for data!=NULL after that.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Paul Mackerras <paulus@au.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pseries/scanlog.c |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff -puN arch/powerpc/platforms/pseries/scanlog.c~powerpc-assign-pde-data-before-gluing-pde-into-proc-tree arch/powerpc/platforms/pseries/scanlog.c
--- a/arch/powerpc/platforms/pseries/scanlog.c~powerpc-assign-pde-data-before-gluing-pde-into-proc-tree
+++ a/arch/powerpc/platforms/pseries/scanlog.c
@@ -55,11 +55,6 @@ static ssize_t scanlog_read(struct file 
         dp = PDE(inode);
  	data = (unsigned int *)dp->data;
 
-	if (!data) {
-		printk(KERN_ERR "scanlog: read failed no data\n");
-		return -EIO;
-	}
-
 	if (count > RTAS_DATA_BUF_SIZE)
 		count = RTAS_DATA_BUF_SIZE;
 
@@ -146,11 +141,6 @@ static int scanlog_open(struct inode * i
 	struct proc_dir_entry *dp = PDE(inode);
 	unsigned int *data = (unsigned int *)dp->data;
 
-	if (!data) {
-		printk(KERN_ERR "scanlog: open failed no data\n");
-		return -EIO;
-	}
-
 	if (data[0] != 0) {
 		/* This imperfect test stops a second copy of the
 		 * data (or a reset while data is being copied)
@@ -168,10 +158,6 @@ static int scanlog_release(struct inode 
 	struct proc_dir_entry *dp = PDE(inode);
 	unsigned int *data = (unsigned int *)dp->data;
 
-	if (!data) {
-		printk(KERN_ERR "scanlog: release failed no data\n");
-		return -EIO;
-	}
 	data[0] = 0;
 
 	return 0;
@@ -200,12 +186,11 @@ static int __init scanlog_init(void)
 	if (!data)
 		goto err;
 
-	ent = proc_create("ppc64/rtas/scan-log-dump", S_IRUSR, NULL,
-			  &scanlog_fops);
+	ent = proc_create_data("ppc64/rtas/scan-log-dump", S_IRUSR, NULL,
+			       &scanlog_fops, data);
 	if (!ent)
 		goto err;
 
-	ent->data = data;
 	proc_ppc64_scan_log_dump = ent;
 
 	return 0;
_

Patches currently in -mm which might be from den@openvz.org are

origin.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

