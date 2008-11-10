From: akpm@linux-foundation.org
Subject: - cpqarry-fix-return-value-of-cpqarray_init.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:31:47 -0800
Message-ID: <200811102031.mAAKVlKm023583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752946AbYKJUcf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:32:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arvidjaar@mail.ru, dvgevers@xs4all.nl, gregkh@suse.de, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     cpqarry: fix return value of cpqarray_init()
has been removed from the -mm tree.  Its filename was
     cpqarry-fix-return-value-of-cpqarray_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpqarry: fix return value of cpqarray_init()
From: Andrey Borzenkov <arvidjaar@mail.ru>

As reported by Dick Gevers on Compaq ProLiant:

Oct 13 18:06:51 dvgcpl kernel: Compaq SMART2 Driver (v 2.6.0)
Oct 13 18:06:51 dvgcpl kernel: sys_init_module: 'cpqarray'->init
suspiciously returned 1, it should follow 0/-E convention
Oct 13 18:06:51 dvgcpl kernel: sys_init_module: loading module anyway...
Oct 13 18:06:51 dvgcpl kernel: Pid: 315, comm: modprobe Not tainted
2.6.27-desktop-0.rc8.2mnb #1
Oct 13 18:06:51 dvgcpl kernel:  [<c0380612>] ? printk+0x18/0x1e
Oct 13 18:06:51 dvgcpl kernel:  [<c0158f85>] sys_init_module+0x155/0x1c0
Oct 13 18:06:51 dvgcpl kernel:  [<c0103f06>] syscall_call+0x7/0xb
Oct 13 18:06:51 dvgcpl kernel:  =======================


Make it return 0 on success and -ENODEV if no array was found.

Reported-by: Dick Gevers <dvgevers@xs4all.nl>
Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cpqarray.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/block/cpqarray.c~cpqarry-fix-return-value-of-cpqarray_init drivers/block/cpqarray.c
--- a/drivers/block/cpqarray.c~cpqarry-fix-return-value-of-cpqarray_init
+++ a/drivers/block/cpqarray.c
@@ -567,7 +567,12 @@ static int __init cpqarray_init(void)
 			num_cntlrs_reg++;
 	}
 
-	return(num_cntlrs_reg);
+	if (num_cntlrs_reg)
+		return 0;
+	else {
+		pci_unregister_driver(&cpqarray_pci_driver);
+		return -ENODEV;
+	}
 }
 
 /* Function to find the first free pointer into our hba[] array */
_

Patches currently in -mm which might be from arvidjaar@mail.ru are

linux-next.patch
acpi-toshiba-only-register-rfkill-if-bt-is-enabled.patch
x86-use-bios-reboot-on-toshiba-portege-4000.patch

