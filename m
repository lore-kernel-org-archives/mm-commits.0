From: akpm@linux-foundation.org
Subject: - dilnetpc-fix-warning.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:58:31 -0800
Message-ID: <200703152158.l2FLwVbg027736@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42508 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022AbXCOV6x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:58:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     dilnetpc: Fix warning
has been removed from the -mm tree.  Its filename was
     dilnetpc-fix-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dilnetpc: Fix warning
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

The type of a resource could be 32 or 64bit depending upon platform or
option so cast it explicitly.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/dilnetpc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/mtd/maps/dilnetpc.c~dilnetpc-fix-warning drivers/mtd/maps/dilnetpc.c
--- a/drivers/mtd/maps/dilnetpc.c~dilnetpc-fix-warning
+++ a/drivers/mtd/maps/dilnetpc.c
@@ -402,8 +402,8 @@ static int __init init_dnpc(void)
 			++higlvl_partition_info[i].name;
 	}
 
-	printk(KERN_NOTICE "DIL/Net %s flash: 0x%lx at 0x%lx\n",
-		is_dnp ? "DNPC" : "ADNP", dnpc_map.size, dnpc_map.phys);
+	printk(KERN_NOTICE "DIL/Net %s flash: 0x%lx at 0x%llx\n",
+		is_dnp ? "DNPC" : "ADNP", dnpc_map.size, (unsigned long long)dnpc_map.phys);
 
 	dnpc_map.virt = ioremap_nocache(dnpc_map.phys, dnpc_map.size);
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-libata-all.patch
pcmcia-spot-slave-decode-flaws-for-testing.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
baycom_ser_fdx-also-allow-i-o-ports-=-0x1000-and-enhanced.patch
resend-iphase-64bit-cleanup.patch
serial-suppress-rts-assertion-with-disabled-crtscts.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
tty-clarify-documentation-of-write.patch
tty-i386-x86_64-arbitary-speed-support.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
