From: akpm@linux-foundation.org
Subject: - mtd-fix-nettel-printk-formats.patch removed from -mm tree
Date: Fri, 09 Jan 2009 12:51:51 -0800
Message-ID: <200901092051.n09KppSW012402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751081AbZAIUwA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2009 15:52:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     mtd: fix nettel printk formats
has been removed from the -mm tree.  Its filename was
     mtd-fix-nettel-printk-formats.patch

This patch was dropped because an alternative patch was merged

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

origin.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
leds-add-a-dac124s085-spi-led-driver.patch
mtd-fix-nettel-printk-formats.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
sunrpc-fix-rdma-dependency.patch
proc-move-inode-comment-text-file-to-source-file.patch
esp-fix-section-mismatch-warning.patch
max3100-spi-uart-driver-select-serial_core.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch

