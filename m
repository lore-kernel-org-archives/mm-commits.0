From: akpm@linux-foundation.org
Subject: [nacked] drivers-char-miscc-use-a-proper-range-for-minor-number-dynamic-allocation.patch removed from -mm tree
Date: Tue, 15 Dec 2009 15:40:37 -0800
Message-ID: <200912152340.nBFNebIo021187@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750951AbZLOXkv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 18:40:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cascardo@holoscopio.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com, mm-commits@vger.kernel.org


The patch titled
     drivers/char/miscc.: use a proper range for minor number dynamic allocation
has been removed from the -mm tree.  Its filename was
     drivers-char-miscc-use-a-proper-range-for-minor-number-dynamic-allocation.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/miscc.: use a proper range for minor number dynamic allocation
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

The current dynamic allocation of minor number for misc devices has some
drawbacks.

First of all, the range for dynamic numbers include some statically
allocated numbers.  It goes from 63 to 0, and we have numbers in the range
from 1 to 15 already allocated.  Although, it gives priority to the higher
and not allocated numbers, we may end up in a situation where we must
reject registering a driver which got a static number because a driver got
its number with dynamic allocation.  Considering fs/dlm/user.c allocates
as many misc devices as lockspaces are created, and that we have more than
50 users around, it's not unreasonable to reach that situation.

The proposed solution uses the not yet reserved range from 64 to 127.  If
more devices are needed, we may push 64 to 16.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/misc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/char/misc.c~drivers-char-miscc-use-a-proper-range-for-minor-number-dynamic-allocation drivers/char/misc.c
--- a/drivers/char/misc.c~drivers-char-miscc-use-a-proper-range-for-minor-number-dynamic-allocation
+++ a/drivers/char/misc.c
@@ -59,6 +59,7 @@ static DEFINE_MUTEX(misc_mtx);
 /*
  * Assigned numbers, used for dynamic minors
  */
+#define DYNAMIC_MINOR_BASE 64
 #define DYNAMIC_MINORS 64 /* like dynamic majors */
 static DECLARE_BITMAP(misc_minors, DYNAMIC_MINORS);
 
@@ -201,7 +202,7 @@ int misc_register(struct miscdevice * mi
 			mutex_unlock(&misc_mtx);
 			return -EBUSY;
 		}
-		misc->minor = DYNAMIC_MINORS - i - 1;
+		misc->minor = DYNAMIC_MINOR_BASE + i;
 		set_bit(i, misc_minors);
 	}
 
@@ -210,7 +211,7 @@ int misc_register(struct miscdevice * mi
 	misc->this_device = device_create(misc_class, misc->parent, dev,
 					  misc, "%s", misc->name);
 	if (IS_ERR(misc->this_device)) {
-		int i = DYNAMIC_MINORS - misc->minor - 1;
+		int i = misc->minor - DYNAMIC_MINOR_BASE;
 		if (i < DYNAMIC_MINORS && i >= 0)
 			clear_bit(i, misc_minors);
 		err = PTR_ERR(misc->this_device);
@@ -239,7 +240,7 @@ int misc_register(struct miscdevice * mi
 
 int misc_deregister(struct miscdevice *misc)
 {
-	int i = DYNAMIC_MINORS - misc->minor - 1;
+	int i = misc->minor - DYNAMIC_MINOR_BASE;
 
 	if (list_empty(&misc->list))
 		return -EINVAL;
_

Patches currently in -mm which might be from cascardo@holoscopio.com are

origin.patch
linux-next.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-checkpatch-fixes.patch
drivers-char-miscc-use-a-proper-range-for-minor-number-dynamic-allocation.patch
spidev-use-declare_bitmap-instead-of-declaring-the-array.patch

