From: akpm@linux-foundation.org
Subject: - mbcs-remove-lots-of-global-symbols.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:00:55 -0700
Message-ID: <200707192000.l6JK0tk6019487@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41407 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932135AbXGSU3C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:29:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, blosure@sgi.com, jes@sgi.com, mm-commits@vger.kernel.org


The patch titled
     mbcs: Remove lots of global symbols
has been removed from the -mm tree.  Its filename was
     mbcs-remove-lots-of-global-symbols.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mbcs: Remove lots of global symbols
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

MBCS has a collection of things that searches say are not used elsewhere
and could be static.  If this is the case they should be static, if not
then someone at SGI should rename things like "soft_list" so they don't
pollute the global namespace with generic names...

Signed-off-by: Alan Cox <alan@redhat.com>
Acked-by: Bruce Losure <blosure@sgi.com>
Cc: Jes Sorensen <jes@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mbcs.c |   20 ++++++++++----------
 drivers/char/mbcs.h |   10 +++++-----
 2 files changed, 15 insertions(+), 15 deletions(-)

diff -puN drivers/char/mbcs.c~mbcs-remove-lots-of-global-symbols drivers/char/mbcs.c
--- a/drivers/char/mbcs.c~mbcs-remove-lots-of-global-symbols
+++ a/drivers/char/mbcs.c
@@ -39,14 +39,14 @@
 #else
 #define DBG(fmt...)
 #endif
-int mbcs_major;
+static int mbcs_major;
 
-LIST_HEAD(soft_list);
+static LIST_HEAD(soft_list);
 
 /*
  * file operations
  */
-const struct file_operations mbcs_ops = {
+static const struct file_operations mbcs_ops = {
 	.open = mbcs_open,
 	.llseek = mbcs_sram_llseek,
 	.read = mbcs_sram_read,
@@ -377,7 +377,7 @@ dmaread_exit:
 	return rv;
 }
 
-int mbcs_open(struct inode *ip, struct file *fp)
+static int mbcs_open(struct inode *ip, struct file *fp)
 {
 	struct mbcs_soft *soft;
 	int minor;
@@ -394,7 +394,7 @@ int mbcs_open(struct inode *ip, struct f
 	return -ENODEV;
 }
 
-ssize_t mbcs_sram_read(struct file * fp, char __user *buf, size_t len, loff_t * off)
+static ssize_t mbcs_sram_read(struct file * fp, char __user *buf, size_t len, loff_t * off)
 {
 	struct cx_dev *cx_dev = fp->private_data;
 	struct mbcs_soft *soft = cx_dev->soft;
@@ -418,7 +418,7 @@ ssize_t mbcs_sram_read(struct file * fp,
 	return rv;
 }
 
-ssize_t
+static ssize_t
 mbcs_sram_write(struct file * fp, const char __user *buf, size_t len, loff_t * off)
 {
 	struct cx_dev *cx_dev = fp->private_data;
@@ -443,7 +443,7 @@ mbcs_sram_write(struct file * fp, const 
 	return rv;
 }
 
-loff_t mbcs_sram_llseek(struct file * filp, loff_t off, int whence)
+static loff_t mbcs_sram_llseek(struct file * filp, loff_t off, int whence)
 {
 	loff_t newpos;
 
@@ -491,7 +491,7 @@ static void mbcs_gscr_pioaddr_set(struct
 	soft->gscr_addr = mbcs_pioaddr(soft, MBCS_GSCR_START);
 }
 
-int mbcs_gscr_mmap(struct file *fp, struct vm_area_struct *vma)
+static int mbcs_gscr_mmap(struct file *fp, struct vm_area_struct *vma)
 {
 	struct cx_dev *cx_dev = fp->private_data;
 	struct mbcs_soft *soft = cx_dev->soft;
@@ -793,7 +793,7 @@ static int mbcs_remove(struct cx_dev *de
 	return 0;
 }
 
-const struct cx_device_id __devinitdata mbcs_id_table[] = {
+static const struct cx_device_id __devinitdata mbcs_id_table[] = {
 	{
 	 .part_num = MBCS_PART_NUM,
 	 .mfg_num = MBCS_MFG_NUM,
@@ -807,7 +807,7 @@ const struct cx_device_id __devinitdata 
 
 MODULE_DEVICE_TABLE(cx, mbcs_id_table);
 
-struct cx_drv mbcs_driver = {
+static struct cx_drv mbcs_driver = {
 	.name = DEVICE_NAME,
 	.id_table = mbcs_id_table,
 	.probe = mbcs_probe,
diff -puN drivers/char/mbcs.h~mbcs-remove-lots-of-global-symbols drivers/char/mbcs.h
--- a/drivers/char/mbcs.h~mbcs-remove-lots-of-global-symbols
+++ a/drivers/char/mbcs.h
@@ -542,12 +542,12 @@ struct mbcs_soft {
 	struct semaphore algolock;
 };
 
-extern int mbcs_open(struct inode *ip, struct file *fp);
-extern ssize_t mbcs_sram_read(struct file *fp, char __user *buf, size_t len,
+static int mbcs_open(struct inode *ip, struct file *fp);
+static ssize_t mbcs_sram_read(struct file *fp, char __user *buf, size_t len,
 			      loff_t * off);
-extern ssize_t mbcs_sram_write(struct file *fp, const char __user *buf, size_t len,
+static ssize_t mbcs_sram_write(struct file *fp, const char __user *buf, size_t len,
 			       loff_t * off);
-extern loff_t mbcs_sram_llseek(struct file *filp, loff_t off, int whence);
-extern int mbcs_gscr_mmap(struct file *fp, struct vm_area_struct *vma);
+static loff_t mbcs_sram_llseek(struct file *filp, loff_t off, int whence);
+static int mbcs_gscr_mmap(struct file *fp, struct vm_area_struct *vma);
 
 #endif				// __MBCS_H__
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer.patch
ata-use-iomap_name.patch
sata_mv-test-patch-for-hightpoint-rocketraid-1740-1742.patch
ata-fix-reported-task-file-values-in-sense-data.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
geode-setup-correct-chipset-access-functions.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
blackfin-enable-arbitary-speed-serial-setting.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
