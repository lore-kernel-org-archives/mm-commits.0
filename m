From: akpm@linux-foundation.org
Subject: [merged]
 parport-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch removed
 from -mm tree
Date: Mon, 09 Jun 2014 12:38:53 -0700
Message-ID: <53960d4d.g6rqMHE84iXLxvsL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54292 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbaFITix (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:38:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [merged] parport-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:38:53 -0700


The patch titled
     Subject: parport: convert use of typedef ctl_table to struct ctl_table
has been removed from the -mm tree.  Its filename was
     parport-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: parport: convert use of typedef ctl_table to struct ctl_table

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/procfs.c |   58 ++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff -puN drivers/parport/procfs.c~parport-convert-use-of-typedef-ctl_table-to-struct-ctl_table drivers/parport/procfs.c
--- a/drivers/parport/procfs.c~parport-convert-use-of-typedef-ctl_table-to-struct-ctl_table
+++ a/drivers/parport/procfs.c
@@ -31,7 +31,7 @@
 #define PARPORT_MIN_SPINTIME_VALUE 1
 #define PARPORT_MAX_SPINTIME_VALUE 1000
 
-static int do_active_device(ctl_table *table, int write,
+static int do_active_device(struct ctl_table *table, int write,
 		      void __user *result, size_t *lenp, loff_t *ppos)
 {
 	struct parport *port = (struct parport *)table->extra1;
@@ -68,7 +68,7 @@ static int do_active_device(ctl_table *t
 }
 
 #ifdef CONFIG_PARPORT_1284
-static int do_autoprobe(ctl_table *table, int write,
+static int do_autoprobe(struct ctl_table *table, int write,
 			void __user *result, size_t *lenp, loff_t *ppos)
 {
 	struct parport_device_info *info = table->extra2;
@@ -110,9 +110,9 @@ static int do_autoprobe(ctl_table *table
 }
 #endif /* IEEE1284.3 support. */
 
-static int do_hardware_base_addr (ctl_table *table, int write,
-				  void __user *result,
-				  size_t *lenp, loff_t *ppos)
+static int do_hardware_base_addr(struct ctl_table *table, int write,
+				 void __user *result,
+				 size_t *lenp, loff_t *ppos)
 {
 	struct parport *port = (struct parport *)table->extra1;
 	char buffer[20];
@@ -138,9 +138,9 @@ static int do_hardware_base_addr (ctl_ta
 	return copy_to_user(result, buffer, len) ? -EFAULT : 0;
 }
 
-static int do_hardware_irq (ctl_table *table, int write,
-			    void __user *result,
-			    size_t *lenp, loff_t *ppos)
+static int do_hardware_irq(struct ctl_table *table, int write,
+			   void __user *result,
+			   size_t *lenp, loff_t *ppos)
 {
 	struct parport *port = (struct parport *)table->extra1;
 	char buffer[20];
@@ -166,9 +166,9 @@ static int do_hardware_irq (ctl_table *t
 	return copy_to_user(result, buffer, len) ? -EFAULT : 0;
 }
 
-static int do_hardware_dma (ctl_table *table, int write,
-			    void __user *result,
-			    size_t *lenp, loff_t *ppos)
+static int do_hardware_dma(struct ctl_table *table, int write,
+			   void __user *result,
+			   size_t *lenp, loff_t *ppos)
 {
 	struct parport *port = (struct parport *)table->extra1;
 	char buffer[20];
@@ -194,9 +194,9 @@ static int do_hardware_dma (ctl_table *t
 	return copy_to_user(result, buffer, len) ? -EFAULT : 0;
 }
 
-static int do_hardware_modes (ctl_table *table, int write,
-			      void __user *result,
-			      size_t *lenp, loff_t *ppos)
+static int do_hardware_modes(struct ctl_table *table, int write,
+			     void __user *result,
+			     size_t *lenp, loff_t *ppos)
 {
 	struct parport *port = (struct parport *)table->extra1;
 	char buffer[40];
@@ -255,11 +255,11 @@ PARPORT_MAX_SPINTIME_VALUE;
 
 struct parport_sysctl_table {
 	struct ctl_table_header *sysctl_header;
-	ctl_table vars[12];
-	ctl_table device_dir[2];
-	ctl_table port_dir[2];
-	ctl_table parport_dir[2];
-	ctl_table dev_dir[2];
+	struct ctl_table vars[12];
+	struct ctl_table device_dir[2];
+	struct ctl_table port_dir[2];
+	struct ctl_table parport_dir[2];
+	struct ctl_table dev_dir[2];
 };
 
 static const struct parport_sysctl_table parport_sysctl_template = {
@@ -369,12 +369,12 @@ static const struct parport_sysctl_table
 struct parport_device_sysctl_table
 {
 	struct ctl_table_header *sysctl_header;
-	ctl_table vars[2];
-	ctl_table device_dir[2];
-	ctl_table devices_root_dir[2];
-	ctl_table port_dir[2];
-	ctl_table parport_dir[2];
-	ctl_table dev_dir[2];
+	struct ctl_table vars[2];
+	struct ctl_table device_dir[2];
+	struct ctl_table devices_root_dir[2];
+	struct ctl_table port_dir[2];
+	struct ctl_table parport_dir[2];
+	struct ctl_table dev_dir[2];
 };
 
 static const struct parport_device_sysctl_table
@@ -422,10 +422,10 @@ parport_device_sysctl_template = {
 struct parport_default_sysctl_table
 {
 	struct ctl_table_header *sysctl_header;
-	ctl_table vars[3];
-        ctl_table default_dir[2];
-	ctl_table parport_dir[2];
-	ctl_table dev_dir[2];
+	struct ctl_table vars[3];
+	struct ctl_table default_dir[2];
+	struct ctl_table parport_dir[2];
+	struct ctl_table dev_dir[2];
 };
 
 static struct parport_default_sysctl_table
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-check-git-commit-descriptions.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

