From: akpm@linux-foundation.org
Subject: - s390-drivers-use-array_size-macro-when-appropriate.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:51:04 -0800
Message-ID: <200702122251.l1CMp41X014275@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45878 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030427AbXBLWvQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:51:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darwish.07@gmail.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     s390-drivers: Use ARRAY_SIZE macro when appropriate
has been removed from the -mm tree.  Its filename was
     s390-drivers-use-array_size-macro-when-appropriate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: s390-drivers: Use ARRAY_SIZE macro when appropriate
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Use ARRAY_SIZE macro already defined in kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/cio/device_id.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/s390/cio/device_id.c~s390-drivers-use-array_size-macro-when-appropriate drivers/s390/cio/device_id.c
--- a/drivers/s390/cio/device_id.c~s390-drivers-use-array_size-macro-when-appropriate
+++ a/drivers/s390/cio/device_id.c
@@ -11,6 +11,7 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/kernel.h>
 
 #include <asm/ccwdev.h>
 #include <asm/delay.h>
@@ -138,7 +139,7 @@ VM_virtual_device_info (__u16 devno, str
 		ps->cu_model = 0x60;
 		return;
 	}
-	for (i = 0; i < sizeof(vm_devices) / sizeof(vm_devices[0]); i++)
+	for (i = 0; i < ARRAY_SIZE(vm_devices); i++)
 		if (diag_data.vrdcvcla == vm_devices[i].vrdcvcla &&
 		    diag_data.vrdcvtyp == vm_devices[i].vrdcvtyp) {
 			ps->cu_type = vm_devices[i].cu_type;
_

Patches currently in -mm which might be from darwish.07@gmail.com are

origin.patch
git-acpi.patch
git-agpgart.patch
git-arm.patch
git-avr32.patch
git-drm.patch
git-dvb.patch
git-infiniband.patch
git-mips.patch
atm-use-array_size-macro-when-appropriate.patch
s390-kmalloc-kzalloc-casting-cleanups.patch
rcutorture-use-array_size-macro-when-appropriate.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
