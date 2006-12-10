From: akpm@osdl.org
Subject: + i2o_exec_exit-and-i2o_driver_exit-should-not-be-__exit.patch added to -mm tree
Date: Sun, 10 Dec 2006 12:16:19 -0800
Message-ID: <200612102016.kBAKGJ5V002024@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58039 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762486AbWLJUQf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 15:16:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, Markus.Lidel@shadowconnect.com


The patch titled
     i2o_exec_exit and i2o_driver_exit should not be __exit.
has been added to the -mm tree.  Its filename is
     i2o_exec_exit-and-i2o_driver_exit-should-not-be-__exit.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i2o_exec_exit and i2o_driver_exit should not be __exit.
From: Ralf Baechle <ralf@linux-mips.org>

i2o_exec_exit and i2o_driver_exit were marked as __exit which is a bug
because both are invoked from __init and __exit functions.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/message/i2o/core.h     |    4 ++--
 drivers/message/i2o/driver.c   |    2 +-
 drivers/message/i2o/exec-osm.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/message/i2o/core.h~i2o_exec_exit-and-i2o_driver_exit-should-not-be-__exit drivers/message/i2o/core.h
--- a/drivers/message/i2o/core.h~i2o_exec_exit-and-i2o_driver_exit-should-not-be-__exit
+++ a/drivers/message/i2o/core.h
@@ -18,7 +18,7 @@ extern struct i2o_driver i2o_exec_driver
 extern int i2o_exec_lct_get(struct i2o_controller *);
 
 extern int __init i2o_exec_init(void);
-extern void __exit i2o_exec_exit(void);
+extern void i2o_exec_exit(void);
 
 /* driver */
 extern struct bus_type i2o_bus_type;
@@ -26,7 +26,7 @@ extern struct bus_type i2o_bus_type;
 extern int i2o_driver_dispatch(struct i2o_controller *, u32);
 
 extern int __init i2o_driver_init(void);
-extern void __exit i2o_driver_exit(void);
+extern void i2o_driver_exit(void);
 
 /* PCI */
 extern int __init i2o_pci_init(void);
diff -puN drivers/message/i2o/driver.c~i2o_exec_exit-and-i2o_driver_exit-should-not-be-__exit drivers/message/i2o/driver.c
--- a/drivers/message/i2o/driver.c~i2o_exec_exit-and-i2o_driver_exit-should-not-be-__exit
+++ a/drivers/message/i2o/driver.c
@@ -362,7 +362,7 @@ int __init i2o_driver_init(void)
  *
  *	Unregisters the I2O bus and frees driver array.
  */
-void __exit i2o_driver_exit(void)
+void i2o_driver_exit(void)
 {
 	bus_unregister(&i2o_bus_type);
 	kfree(i2o_drivers);
diff -puN drivers/message/i2o/exec-osm.c~i2o_exec_exit-and-i2o_driver_exit-should-not-be-__exit drivers/message/i2o/exec-osm.c
--- a/drivers/message/i2o/exec-osm.c~i2o_exec_exit-and-i2o_driver_exit-should-not-be-__exit
+++ a/drivers/message/i2o/exec-osm.c
@@ -595,7 +595,7 @@ int __init i2o_exec_init(void)
  *
  *	Unregisters the Exec OSM from the I2O core.
  */
-void __exit i2o_exec_exit(void)
+void i2o_exec_exit(void)
 {
 	i2o_driver_unregister(&i2o_exec_driver);
 };
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
sysctl-remove-unused-context-param.patch
dont-build-some-broken-isdn-drivers-on-big-endian-mips.patch
i2o_exec_exit-and-i2o_driver_exit-should-not-be-__exit.patch
make-lm70_remove-a-__devexit-function.patch
mips-dbg_io-stray-brackets-fix.patch
git-mtd.patch
git-net.patch
fix-pnx8550-serial-breakage.patch
pnx8550-uart-driver.patch
pci-legacy-resource-fix.patch
pci-legacy-resource-fix-tidy.patch
xfs-remove-useless-wmb-memory-barrier.patch
tty-remove-useless-memory-barrier.patch
getting-rid-of-all-casts-of-kalloc-calls.patch

