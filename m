From: akpm@linux-foundation.org
Subject: [merged] drivers-misc-ioc4c-fix-section-mismatch-race-condition.patch removed from -mm tree
Date: Tue, 28 Jun 2011 13:42:50 -0700
Message-ID: <201106282042.p5SKgWgI003022@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41480 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096Ab1F1Umm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jun 2011 16:42:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, bcasavan@sgi.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     drivers/misc/ioc4.c: fix section mismatch / race condition
has been removed from the -mm tree.  Its filename was
     drivers-misc-ioc4c-fix-section-mismatch-race-condition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/misc/ioc4.c: fix section mismatch / race condition
From: Ralf Baechle <ralf@linux-mips.org>

WARNING: drivers/misc/ioc4.o(.data+0x144): Section mismatch in reference from the variable ioc4_load_modules_work to the function .devinit.text:ioc4_load_modules()
The variable ioc4_load_modules_work references
the function __devinit ioc4_load_modules()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

This one is potentially fatal; by the time ioc4_load_modules is invoked it
may already have been freed.  For that reason ioc4_load_modules_work can't
be turned to __devinitdata but also because it's referenced in ioc4_exit.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Brent Casavant <bcasavan@sgi.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/ioc4.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/ioc4.c~drivers-misc-ioc4c-fix-section-mismatch-race-condition drivers/misc/ioc4.c
--- a/drivers/misc/ioc4.c~drivers-misc-ioc4c-fix-section-mismatch-race-condition
+++ a/drivers/misc/ioc4.c
@@ -270,7 +270,7 @@ ioc4_variant(struct ioc4_driver_data *id
 	return IOC4_VARIANT_PCI_RT;
 }
 
-static void __devinit
+static void
 ioc4_load_modules(struct work_struct *work)
 {
 	request_module("sgiioc4");
_

Patches currently in -mm which might be from ralf@linux-mips.org are

linux-next.patch
mips-exec-remove-redundant-addr_limit-assignment.patch
pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const.patch

