From: akpm@linux-foundation.org
Subject: + mtd-fix-nettel-printk-formats.patch added to -mm tree
Date: Mon, 15 Dec 2008 21:53:20 -0800
Message-ID: <200812160553.mBG5rKTq001451@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46711 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751220AbYLPFx0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Dec 2008 00:53:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     mtd: fix nettel printk formats
has been added to the -mm tree.  Its filename is
     mtd-fix-nettel-printk-formats.patch

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
Subject: mtd: fix nettel printk formats
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format references:

drivers/mtd/maps/nettel.c:361: warning: format '%d' expects type 'int', but argument 2 has type 'uint64_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/nettel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/mtd/maps/nettel.c~mtd-fix-nettel-printk-formats drivers/mtd/maps/nettel.c
--- a/drivers/mtd/maps/nettel.c~mtd-fix-nettel-printk-formats
+++ a/drivers/mtd/maps/nettel.c
@@ -357,8 +357,8 @@ static int __init nettel_init(void)
 		*intel1par = 0;
 	}
 
-	printk(KERN_NOTICE "SNAPGEAR: Intel flash device size = %dK\n",
-		(intel_mtd->size >> 10));
+	printk(KERN_NOTICE "SNAPGEAR: Intel flash device size = %lluK\n",
+		(unsigned long long)(intel_mtd->size >> 10));
 
 	intel_mtd->owner = THIS_MODULE;
 
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

