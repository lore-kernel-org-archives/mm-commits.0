From: akpm@linux-foundation.org
Subject: - make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch removed from -mm tree
Date: Tue, 08 May 2007 19:53:16 -0700
Message-ID: <200705090253.l492rGUK009674@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54215 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032083AbXEICx2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:53:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     make drivers/isdn/capi/capiutil.c:cdebbuf_alloc() static
has been removed from the -mm tree.  Its filename was
     make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: make drivers/isdn/capi/capiutil.c:cdebbuf_alloc() static
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/capi/capiutil.c  |    8 +-------
 include/linux/isdn/capiutil.h |    1 -
 2 files changed, 1 insertion(+), 8 deletions(-)

diff -puN drivers/isdn/capi/capiutil.c~make-drivers-isdn-capi-capiutilccdebbuf_alloc-static drivers/isdn/capi/capiutil.c
--- a/drivers/isdn/capi/capiutil.c~make-drivers-isdn-capi-capiutilccdebbuf_alloc-static
+++ a/drivers/isdn/capi/capiutil.c
@@ -855,7 +855,7 @@ static _cdebbuf *g_debbuf;
 static u_long g_debbuf_lock;
 static _cmsg *g_cmsg;
 
-_cdebbuf *cdebbuf_alloc(void)
+static _cdebbuf *cdebbuf_alloc(void)
 {
 	_cdebbuf *cdb;
 
@@ -989,11 +989,6 @@ _cdebbuf *capi_cmsg2str(_cmsg * cmsg)
 	return &g_debbuf;
 }
 
-_cdebbuf *cdebbuf_alloc(void)
-{
-	return &g_debbuf;
-}
-
 void cdebbuf_free(_cdebbuf *cdb)
 {
 }
@@ -1009,7 +1004,6 @@ void __exit cdebug_exit(void)
 
 #endif
 
-EXPORT_SYMBOL(cdebbuf_alloc);
 EXPORT_SYMBOL(cdebbuf_free);
 EXPORT_SYMBOL(capi_cmsg2message);
 EXPORT_SYMBOL(capi_message2cmsg);
diff -puN include/linux/isdn/capiutil.h~make-drivers-isdn-capi-capiutilccdebbuf_alloc-static include/linux/isdn/capiutil.h
--- a/include/linux/isdn/capiutil.h~make-drivers-isdn-capi-capiutilccdebbuf_alloc-static
+++ a/include/linux/isdn/capiutil.h
@@ -187,7 +187,6 @@ typedef struct {
 #define	CDEBUG_SIZE	1024
 #define	CDEBUG_GSIZE	4096
 
-_cdebbuf *cdebbuf_alloc(void);
 void cdebbuf_free(_cdebbuf *cdb);
 int cdebug_init(void);
 void cdebug_exit(void);
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-alsa.patch
git-dvb.patch
git-ieee1394.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
drivers-mtd-maps-nettelc-possible-cleanups.patch
ibmtr_cs-fix-hang-on-eject.patch
git-battery.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
scsi-lpfc-lpfc_initc-remove-unused-variable.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
drivers-scsi-ipsc-remove-kernel-24-code.patch
drivers-scsi-nsp32c-remove-kernel-24-code.patch
git-unionfs.patch
git-watchdog.patch
git-wireless.patch
git-ipwireless_cs.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
more-scheduled-oss-driver-removal.patch
unexport-pci_proc_attach_device.patch
ext2-reservations.patch
remove-nfs4_acl_add_ace.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
compiler-introduce-__used-and-__maybe_unused.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
slim-main-patch.patch
slim-debug-output.patch
mutex-subsystem-synchro-test-module.patch
