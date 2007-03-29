From: akpm@linux-foundation.org
Subject: - uml-fix-device-unplug-crash.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:37:12 -0700
Message-ID: <200703292337.l2TNbCia015078@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42944 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945907AbXC2XhS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:37:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix device unplug crash
has been removed from the -mm tree.  Its filename was
     uml-fix-device-unplug-crash.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: fix device unplug crash
From: Jeff Dike <jdike@addtoit.com>

Fix a NULL dereference when unplugging a device.  The default value of
err_msg wants to be "" in case the driver doesn't modify it.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/mconsole_kern.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/um/drivers/mconsole_kern.c~uml-fix-device-unplug-crash arch/um/drivers/mconsole_kern.c
--- a/arch/um/drivers/mconsole_kern.c~uml-fix-device-unplug-crash
+++ a/arch/um/drivers/mconsole_kern.c
@@ -615,6 +615,9 @@ void mconsole_remove(struct mc_request *
 	err_msg = NULL;
 	err = (*dev->remove)(n, &err_msg);
 	switch(err){
+	case 0:
+		err_msg = "";
+		break;
 	case -ENODEV:
 		if(err_msg == NULL)
 			err_msg = "Device doesn't exist";
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-unreasonably-long-udelay.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
array_size-check-for-type-uml-fix.patch
uml-fix-prototypes.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
