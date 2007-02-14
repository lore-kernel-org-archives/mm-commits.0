From: akpm@linux-foundation.org
Subject: + tty-use-null-for-ptrs.patch added to -mm tree
Date: Wed, 14 Feb 2007 14:41:40 -0800
Message-ID: <200702142241.l1EMfeoh011591@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49697 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbXBNWlo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 17:41:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     tty: use NULL for ptrs
has been added to the -mm tree.  Its filename is
     tty-use-null-for-ptrs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tty: use NULL for ptrs
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix sparse warning in tty_io:
drivers/char/tty_io.c:1536:34: warning: Using plain integer as NULL pointer

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/tty_io.c~tty-use-null-for-ptrs drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty-use-null-for-ptrs
+++ a/drivers/char/tty_io.c
@@ -1533,7 +1533,7 @@ void disassociate_ctty(int on_exit)
 
 	spin_lock_irq(&current->sighand->siglock);
 	tty_pgrp = current->signal->tty_old_pgrp;
-	current->signal->tty_old_pgrp = 0;
+	current->signal->tty_old_pgrp = NULL;
 	spin_unlock_irq(&current->sighand->siglock);
 	put_pid(tty_pgrp);
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2.patch
build-errors-uevent-with-config_sysfs=n.patch
git-drm.patch
git-netdev-all.patch
phy-layer-add-kernel-doc-docbook.patch
parisc-fix-module_param-iommu-permission.patch
pci-sysfs-kobject-kernel-doc-fixes.patch
ueagle-atmc-needs-schedh.patch
kernel-doc-include-struct-short-description-in-title.patch
tty-use-null-for-ptrs.patch
irq-kernel-doc-fixes.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
acpi-use-null-for-ptrs.patch
sata-use-null-for-ptrs.patch
cdrom-use-unsigned-bitfields.patch
