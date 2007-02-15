From: akpm@linux-foundation.org
Subject: + Fabric7-VIOC-driver-fixes.patch added to -mm tree
Date: Wed, 14 Feb 2007 22:43:36 -0800
Message-ID: <200702150643.l1F6haHG022133@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36690 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964914AbXBOGnj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 01:43:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, driver-support@fabric7.com, schidambaram@fabric7.com


The patch titled
     Fabric7-VIOC-driver-fixes
has been added to the -mm tree.  Its filename is
     Fabric7-VIOC-driver-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fabric7-VIOC-driver-fixes
From: Andrew Morton <akpm@linux-foundation.org>

drivers/net/vioc/vioc_driver.c: In function `vioc_free_resources':
drivers/net/vioc/vioc_driver.c:364: warning: implicit declaration of function `vfree'
drivers/net/vioc/vioc_driver.c: In function `vioc_alloc_resources':
drivers/net/vioc/vioc_driver.c:547: warning: implicit declaration of function `vmalloc'
drivers/net/vioc/vioc_driver.c:547: warning: assignment makes pointer from integer without a cast
drivers/net/vioc/vioc_driver.c:572: warning: cast to pointer from integer of different size

and

drivers/net/vioc/vioc_irq.c:50:22: asm/apic.h: No such file or directory

and

drivers/net/vioc/vioc_transmit.c:64:21: asm/msr.h: No such file or directory

and

drivers/net/vioc/vioc_transmit.c: In function `vnic_alloc_tx_resources':
drivers/net/vioc/vioc_transmit.c:917: warning: implicit declaration of function `vmalloc'
drivers/net/vioc/vioc_transmit.c:917: warning: assignment makes pointer from integer without a cast
drivers/net/vioc/vioc_transmit.c: In function `vnic_free_tx_resources':
drivers/net/vioc/vioc_transmit.c:951: warning: implicit declaration of function `vfree'


Cc: Sriram Chidambaram <schidambaram@fabric7.com>
Signed-off-by: Fabric7 Driver-Support <driver-support@fabric7.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/vioc/vioc_driver.c   |    1 +
 drivers/net/vioc/vioc_irq.c      |    1 -
 drivers/net/vioc/vioc_transmit.c |    2 +-
 3 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/vioc/vioc_driver.c~Fabric7-VIOC-driver-fixes drivers/net/vioc/vioc_driver.c
--- a/drivers/net/vioc/vioc_driver.c~Fabric7-VIOC-driver-fixes
+++ a/drivers/net/vioc/vioc_driver.c
@@ -44,6 +44,7 @@
 #include <linux/sched.h>
 #include <linux/notifier.h>
 #include <linux/errno.h>
+#include <linux/vmalloc.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
diff -puN drivers/net/vioc/vioc_irq.c~Fabric7-VIOC-driver-fixes drivers/net/vioc/vioc_irq.c
--- a/drivers/net/vioc/vioc_irq.c~Fabric7-VIOC-driver-fixes
+++ a/drivers/net/vioc/vioc_irq.c
@@ -47,7 +47,6 @@
 #include <asm/io.h>
 #include <asm/byteorder.h>
 #include <asm/uaccess.h>
-#include <asm/apic.h>
 
 #include "f7/vioc_hw_registers.h"
 #include "f7/vnic_defs.h"
diff -puN drivers/net/vioc/vioc_transmit.c~Fabric7-VIOC-driver-fixes drivers/net/vioc/vioc_transmit.c
--- a/drivers/net/vioc/vioc_transmit.c~Fabric7-VIOC-driver-fixes
+++ a/drivers/net/vioc/vioc_transmit.c
@@ -50,6 +50,7 @@
 #include <linux/if_vlan.h>
 #include <linux/timex.h>
 #include <linux/ethtool.h>
+#include <linux/vmalloc.h>
 
 #include <net/dst.h>
 #include <net/arp.h>
@@ -61,7 +62,6 @@
 #include <asm/checksum.h>
 #include <asm/io.h>
 #include <asm/byteorder.h>
-#include <asm/msr.h>
 
 #include "f7/vnic_defs.h"
 #include "f7/vioc_pkts_defs.h"
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-agpgart.patch
git-arm.patch
git-cpufreq.patch
powerpc-rtas-msi-support-fix.patch
fix-warning-in-device_add_attrs.patch
git-drm.patch
git-dvb.patch
git-dvb-fixup.patch
sis-warning-fixes.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler-tidy.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-mips-fixup.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
Fabric7-VIOC-driver-fixes.patch
git-backlight.patch
git-backlight-sony-fix.patch
git-sh.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-unionfs-fixup.patch
revert-x86_64-mm-msr-on-cpu.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
kprobes-list-all-active-probes-in-the-system.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-epoll-compat-code-to-kernel-compatc-tidy.patch
revert-x86_64-mm-putreg-check.patch
r-o-bind-mounts-r-o-bind-mounts-stub-functions-fix.patch
r-o-bind-mounts-r-o-bind-mounts-stub-functions-unhack.patch
git-gccbug-fixup.patch
