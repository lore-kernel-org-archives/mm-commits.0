From: akpm@linux-foundation.org
Subject: + make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch added to -mm tree
Date: Thu, 08 Mar 2007 00:43:37 -0800
Message-ID: <200703080843.l288hbvR023369@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58414 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030304AbXCHIrB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Mar 2007 03:47:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, kkeil@suse.de


The patch titled
     make drivers/isdn/capi/capiutil.c:cdebbuf_alloc() static
has been added to the -mm tree.  Its filename is
     make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make drivers/isdn/capi/capiutil.c:cdebbuf_alloc() static
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Karsten Keil <kkeil@suse.de>
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
git-drm.patch
make-drivers-char-drm-drm_vmcdrm_io_prot-static.patch
git-dvb.patch
saa7134-fix-modules=n-compilation.patch
git-gfs2-nmw.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
remove-fs-jffs2-ioctlc.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
git-ubi.patch
git-netdev-all.patch
drivers-net-vioc-possible-cleanups.patch
drivers-net-bonding-bond_maincmake-3-functions-static.patch
net-uninline-skb_put-fix.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning.patch
i386-x86_64-early_printkc-make-simnow_init-static.patch
make-arch-i386-kernel-vmicvmi_pmd_clear-static.patch
lguest-kconfig-and-headers.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
the-scheduled-removal-of-obsolete_oss-options.patch
drivers-macintosh-mac_hidc-make-code-static.patch
ext2-reservations.patch
drivers-edac-make-code-static.patch
make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
fbdev-display-class-fix.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-hecuba-framebuffer-driver-fix.patch
slim-main-patch.patch
slim-debug-output.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
