From: akpm@linux-foundation.org
Subject: - drivers-message-fusion-mptctlc-mostly-kmalloc-memset-conversion-to-kzalloc.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:27:35 -0700
Message-ID: <200709160927.l8G9RZIx009271@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44586 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752007AbXIPJi2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:38:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, Eric.Moore@lsil.com, mm-commits@vger.kernel.org


The patch titled
     drivers/message/fusion/mptctl.c: mostly kmalloc + memset conversion to kzalloc
has been removed from the -mm tree.  Its filename was
     drivers-message-fusion-mptctlc-mostly-kmalloc-memset-conversion-to-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/message/fusion/mptctl.c: mostly kmalloc + memset conversion to kzalloc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

This patch does kmalloc + memset conversion to kzalloc anSigned-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
d simplifies mptctl_probe().

 drivers/message/fusion/mptctl.c | 82092 -> 81884 (-208 bytes)
 drivers/message/fusion/mptctl.o | 201784 -> 200648 (-1136 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptctl.c |   36 ++++++++++--------------------
 1 file changed, 12 insertions(+), 24 deletions(-)

diff -puN drivers/message/fusion/mptctl.c~drivers-message-fusion-mptctlc-mostly-kmalloc-memset-conversion-to-kzalloc drivers/message/fusion/mptctl.c
--- a/drivers/message/fusion/mptctl.c~drivers-message-fusion-mptctlc-mostly-kmalloc-memset-conversion-to-kzalloc
+++ a/drivers/message/fusion/mptctl.c
@@ -977,10 +977,9 @@ kbuf_alloc_2_sgl(int bytes, u32 sgdir, i
 	 * structures for the SG elements.
 	 */
 	i = MAX_SGL_BYTES / 8;
-	buflist = kmalloc(i, GFP_USER);
-	if (buflist == NULL)
+	buflist = kzalloc(i, GFP_USER);
+	if (!buflist)
 		return NULL;
-	memset(buflist, 0, i);
 	buflist_ent = 0;
 
 	/* Allocate a single block of memory to store the sg elements and
@@ -1379,13 +1378,12 @@ mptctl_gettargetinfo (unsigned long arg)
 	 *      15- 8: Bus Number
 	 *       7- 0: Target ID
 	 */
-	pmem = kmalloc(numBytes, GFP_KERNEL);
-	if (pmem == NULL) {
+	pmem = kzalloc(numBytes, GFP_KERNEL);
+	if (!pmem) {
 		printk(KERN_ERR "%s::mptctl_gettargetinfo() @%d - no memory available!\n",
 				__FILE__, __LINE__);
 		return -ENOMEM;
 	}
-	memset(pmem, 0, numBytes);
 	pdata =  (int *) pmem;
 
 	/* Get number of devices
@@ -1570,12 +1568,11 @@ mptctl_eventenable (unsigned long arg)
 		/* Have not yet allocated memory - do so now.
 		 */
 		int sz = MPTCTL_EVENT_LOG_SIZE * sizeof(MPT_IOCTL_EVENTS);
-		ioc->events = kmalloc(sz, GFP_KERNEL);
-		if (ioc->events == NULL) {
+		ioc->events = kzalloc(sz, GFP_KERNEL);
+		if (!ioc->events) {
 			printk(KERN_ERR MYNAM ": ERROR - Insufficient memory to add adapter!\n");
 			return -ENOMEM;
 		}
-		memset(ioc->events, 0, sz);
 		ioc->alloc_total += sz;
 
 		ioc->eventContext = 0;
@@ -2865,31 +2862,22 @@ static long compat_mpctl_ioctl(struct fi
 static int
 mptctl_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	int err;
-	int sz;
-	u8 *mem;
+	MPT_IOCTL *mem;
 	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
 
 	/*
 	 * Allocate and inite a MPT_IOCTL structure
 	*/
-	sz = sizeof (MPT_IOCTL);
-	mem = kmalloc(sz, GFP_KERNEL);
-	if (mem == NULL) {
-		err = -ENOMEM;
-		goto out_fail;
+	mem = kzalloc(sizeof(MPT_IOCTL), GFP_KERNEL);
+	if (!mem) {
+		mptctl_remove(pdev);
+		return -ENOMEM;
 	}
 
-	memset(mem, 0, sz);
-	ioc->ioctl = (MPT_IOCTL *) mem;
+	ioc->ioctl = mem;
 	ioc->ioctl->ioc = ioc;
 	mutex_init(&ioc->ioctl->ioctl_mutex);
 	return 0;
-
-out_fail:
-
-	mptctl_remove(pdev);
-	return err;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

git-alsa.patch
arm-unbalanced-parenthesis-fix.patch
fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc.patch
git-powerpc.patch
git-dvb.patch
git-mmc.patch
git-mtd.patch
git-net.patch
skge-remove-broken-and-unused-phy_m_pc_mdi_xmode-macro.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
git-scsi-misc.patch
include-asm-frv-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
include-asm-m32r-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-consolemapc-kmalloc-memset-conversion-to-kzalloc.patch
doc-firmware_sample_firmware_classc-kmalloc-memset-conversion-to-kzalloc.patch
fs-autofs4-inodec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-ip2-ip2mainc-kmalloc-memset-conversion-to-kzalloc.patch
add-a-rounddown_pow_of_two-routine-to-log2hpatch-fix.patch
fs-jbd2-journalc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
