From: akpm@linux-foundation.org
Subject: + uml-fix-device-unplug-crash.patch added to -mm tree
Date: Tue, 27 Mar 2007 13:32:30 -0700
Message-ID: <200703272032.l2RKWUGQ027094@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42048 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965380AbXC0Uce (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 16:32:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: fix device unplug crash
has been added to the -mm tree.  Its filename is
     uml-fix-device-unplug-crash.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 3 insertions(+)

diff -puN arch/um/drivers/mconsole_kern.c~uml-fix-device-unplug-crash arch/um/drivers/mconsole_kern.c
--- a/arch/um/drivers/mconsole_kern.c~uml-fix-device-unplug-crash
+++ a/arch/um/drivers/mconsole_kern.c
@@ -614,6 +614,9 @@ void mconsole_remove(struct mc_request *
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

uml-fix-epoll.patch
uml-fix-static-linking.patch
uml-use-correct-register-file-size-everywhere.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
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
i386-fix-cmpxchg-warning.patch
uml-fix-device-unplug-crash.patch
uml-irq-locking-fixes.patch
uml-fix-compilation-problems.patch
