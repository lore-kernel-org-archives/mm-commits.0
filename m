From: akpm@osdl.org
Subject: + pc110pad-return-proper-error.patch added to -mm tree
Date: Wed, 20 Dec 2006 19:43:36 -0800
Message-ID: <200612210343.kBL3haDa014787@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34922 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422677AbWLUDno (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 22:43:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, dmitry.torokhov@gmail.com, vojtech@suse.cz


The patch titled
     pc110pad: return proper error
has been added to the -mm tree.  Its filename is
     pc110pad-return-proper-error.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pc110pad: return proper error
From: Akinobu Mita <akinobu.mita@gmail.com>

According to the comment, "if we find any PCI devices in the machine, we
don't have a PC110" in pc110pad.c, we should return -ENODEV rather than
-ENOENT in this case.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Vojtech Pavlik <vojtech@suse.cz>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/input/mouse/pc110pad.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/mouse/pc110pad.c~pc110pad-return-proper-error drivers/input/mouse/pc110pad.c
--- a/drivers/input/mouse/pc110pad.c~pc110pad-return-proper-error
+++ a/drivers/input/mouse/pc110pad.c
@@ -113,7 +113,7 @@ static int __init pc110pad_init(void)
 	dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL);
 	if (dev) {
 		pci_dev_put(dev);
-		return -ENOENT;
+		return -ENODEV;
 	}
 
 	if (!request_region(pc110pad_io, 4, "pc110pad")) {
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
audit-fix-kstrdup-error-check.patch
gss_spkm3-fix-error-handling-in-module-init.patch
git-acpi.patch
git-alsa.patch
powerpc-use-is_init.patch
git-drm.patch
ehca-fix-kthread_create-error-check.patch
ehca-fix-do_mmap-error-check.patch
pc110pad-return-proper-error.patch
git-mtd.patch
net-use-bitrev8.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
iscsi-fix-crypto_alloc_hash-error-check.patch
git-watchdog.patch

