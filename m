From: akpm@linux-foundation.org
Subject: [merged] drivers-char-miscc-use-bitmap-bitops-functions-for-dynamic-minor-number-allocation.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:56:13 -0800
Message-ID: <200912152156.nBFLuDBG015555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60749 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933783AbZLOV4v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:56:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cascardo@holoscopio.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com, mm-commits@vger.kernel.org


The patch titled
     drivers/char/misc.c: use bitmap/bitops functions for dynamic minor number allocation
has been removed from the -mm tree.  Its filename was
     drivers-char-miscc-use-bitmap-bitops-functions-for-dynamic-minor-number-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/misc.c: use bitmap/bitops functions for dynamic minor number allocation
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

Use DECLARE_BITMAP(), find_first_zero_bit(), set_bit() and clear_bit()
instead of rewriting code to do it with the minor number dynamic
allocation bitmap.

We need to invert the bit position to keep the code behaviour of using the
last minor numbers first, since we don't have a find_last_zero_bit.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/misc.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff -puN drivers/char/misc.c~drivers-char-miscc-use-bitmap-bitops-functions-for-dynamic-minor-number-allocation drivers/char/misc.c
--- a/drivers/char/misc.c~drivers-char-miscc-use-bitmap-bitops-functions-for-dynamic-minor-number-allocation
+++ a/drivers/char/misc.c
@@ -60,7 +60,7 @@ static DEFINE_MUTEX(misc_mtx);
  * Assigned numbers, used for dynamic minors
  */
 #define DYNAMIC_MINORS 64 /* like dynamic majors */
-static unsigned char misc_minors[DYNAMIC_MINORS / 8];
+static DECLARE_BITMAP(misc_minors, DYNAMIC_MINORS);
 
 #ifdef CONFIG_PROC_FS
 static void *misc_seq_start(struct seq_file *seq, loff_t *pos)
@@ -196,27 +196,23 @@ int misc_register(struct miscdevice * mi
 	}
 
 	if (misc->minor == MISC_DYNAMIC_MINOR) {
-		int i = DYNAMIC_MINORS;
-		while (--i >= 0)
-			if ( (misc_minors[i>>3] & (1 << (i&7))) == 0)
-				break;
-		if (i<0) {
+		int i = find_first_zero_bit(misc_minors, DYNAMIC_MINORS);
+		if (i >= DYNAMIC_MINORS) {
 			mutex_unlock(&misc_mtx);
 			return -EBUSY;
 		}
-		misc->minor = i;
+		misc->minor = DYNAMIC_MINORS - i - 1;
+		set_bit(i, misc_minors);
 	}
 
-	if (misc->minor < DYNAMIC_MINORS)
-		misc_minors[misc->minor >> 3] |= 1 << (misc->minor & 7);
 	dev = MKDEV(MISC_MAJOR, misc->minor);
 
 	misc->this_device = device_create(misc_class, misc->parent, dev,
 					  misc, "%s", misc->name);
 	if (IS_ERR(misc->this_device)) {
-		int i = misc->minor;
+		int i = DYNAMIC_MINORS - misc->minor - 1;
 		if (i < DYNAMIC_MINORS && i >= 0)
-			misc_minors[i>>3] &= ~(1 << (i & 7));
+			clear_bit(i, misc_minors);
 		err = PTR_ERR(misc->this_device);
 		goto out;
 	}
@@ -243,7 +239,7 @@ int misc_register(struct miscdevice * mi
 
 int misc_deregister(struct miscdevice *misc)
 {
-	int i = misc->minor;
+	int i = DYNAMIC_MINORS - misc->minor - 1;
 
 	if (list_empty(&misc->list))
 		return -EINVAL;
@@ -252,7 +248,7 @@ int misc_deregister(struct miscdevice *m
 	list_del(&misc->list);
 	device_destroy(misc_class, MKDEV(MISC_MAJOR, misc->minor));
 	if (i < DYNAMIC_MINORS && i >= 0)
-		misc_minors[i>>3] &= ~(1 << (i & 7));
+		clear_bit(i, misc_minors);
 	mutex_unlock(&misc_mtx);
 	return 0;
 }
_

Patches currently in -mm which might be from cascardo@holoscopio.com are

origin.patch
linux-next.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-checkpatch-fixes.patch
drivers-char-miscc-use-a-proper-range-for-minor-number-dynamic-allocation.patch
spidev-use-declare_bitmap-instead-of-declaring-the-array.patch

