From: akpm@linux-foundation.org
Subject: + mtd-fix-nandsim-schedh-references.patch added to -mm tree
Date: Mon, 15 Dec 2008 21:53:18 -0800
Message-ID: <200812160553.mBG5rIbL001410@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751169AbYLPFxY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Dec 2008 00:53:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     mtd: fix nandsim sched.h references
has been added to the -mm tree.  Its filename is
     mtd-fix-nandsim-schedh-references.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: fix nandsim sched.h references
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix sched.h references:

build-r7149.out:/local/linsrc/linux-next-20081215/drivers/mtd/nand/nandsim.c:1326: error: dereferencing pointer to incomplete type
build-r7149.out:/local/linsrc/linux-next-20081215/drivers/mtd/nand/nandsim.c:1326: error: 'PF_MEMALLOC' undeclared (first use in this function)
build-r7149.out:/local/linsrc/linux-next-20081215/drivers/mtd/nand/nandsim.c:1328: error: dereferencing pointer to incomplete type
build-r7149.out:/local/linsrc/linux-next-20081215/drivers/mtd/nand/nandsim.c:1335: error: dereferencing pointer to incomplete type
build-r7149.out:/local/linsrc/linux-next-20081215/drivers/mtd/nand/nandsim.c:1335: error: 'PF_MEMALLOC' undeclared (first use in this function)
build-r7149.out:make[4]: *** [drivers/mtd/nand/nandsim.o] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/nandsim.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/mtd/nand/nandsim.c~mtd-fix-nandsim-schedh-references drivers/mtd/nand/nandsim.c
--- a/drivers/mtd/nand/nandsim.c~mtd-fix-nandsim-schedh-references
+++ a/drivers/mtd/nand/nandsim.c
@@ -38,6 +38,7 @@
 #include <linux/delay.h>
 #include <linux/list.h>
 #include <linux/random.h>
+#include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
kgdb-fix-kernel-doc-error.patch
mtd-fix-dataflash-printk-formats.patch
mtd-fix-m25p80-printk-formats.patch
mtd-fix-nandsim-schedh-references.patch
mtd-fix-nettel-printk-formats.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
proc-move-inode-comment-text-file-to-source-file.patch
esp-fix-section-mismatch-warning.patch
fs-use-menuconfig-to-control-the-misc-filesystems-menu.patch
documentation-when-to-bug-and-when-to-not-bug.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
max3100-spi-uart-driver-select-serial_core.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
i2o-remove-extraneous-kernel-doc.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
documentation-update-header-file-paths.patch
documentation-update-s390-header-file-paths.patch
w1-add-list-masters-w1-command.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch
fix-similar-typos-to-successfull-v2.patch

