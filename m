From: akpm@linux-foundation.org
Subject: - fix-race-between-rmmod-and-cat-proc-kallsyms-fix.patch removed from -mm tree
Date: Mon, 30 Apr 2007 13:05:36 -0700
Message-ID: <200704302005.l3UK5cEj013726@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423632AbXD3UGn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 16:06:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, adobriyan@sw.ru, mm-commits@vger.kernel.org


The patch titled
     make kernel/module.c:is_exported() static
has been removed from the -mm tree.  Its filename was
     fix-race-between-rmmod-and-cat-proc-kallsyms-fix.patch

This patch was dropped because it was folded into fix-race-between-rmmod-and-cat-proc-kallsyms.patch

------------------------------------------------------
Subject: make kernel/module.c:is_exported() static
From: Adrian Bunk <bunk@stusta.de>

is_exported() can now become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/module.h |    7 -------
 kernel/module.c        |    2 +-
 2 files changed, 1 insertion(+), 8 deletions(-)

diff -puN include/linux/module.h~fix-race-between-rmmod-and-cat-proc-kallsyms-fix include/linux/module.h
--- a/include/linux/module.h~fix-race-between-rmmod-and-cat-proc-kallsyms-fix
+++ a/include/linux/module.h
@@ -379,8 +379,6 @@ int module_get_kallsym(unsigned int symn
 /* Look for this name: can be of form module:name. */
 unsigned long module_kallsyms_lookup_name(const char *name);
 
-int is_exported(const char *name, const struct module *mod);
-
 extern void __module_put_and_exit(struct module *mod, long code)
 	__attribute__((noreturn));
 #define module_put_and_exit(code) __module_put_and_exit(THIS_MODULE, code);
@@ -542,11 +540,6 @@ static inline unsigned long module_kalls
 	return 0;
 }
 
-static inline int is_exported(const char *name, const struct module *mod)
-{
-	return 0;
-}
-
 static inline int register_module_notifier(struct notifier_block * nb)
 {
 	/* no events will happen anyway, so this can always succeed */
diff -puN kernel/module.c~fix-race-between-rmmod-and-cat-proc-kallsyms-fix kernel/module.c
--- a/kernel/module.c~fix-race-between-rmmod-and-cat-proc-kallsyms-fix
+++ a/kernel/module.c
@@ -1547,7 +1547,7 @@ static void setup_modinfo(struct module 
 }
 
 #ifdef CONFIG_KALLSYMS
-int is_exported(const char *name, const struct module *mod)
+static int is_exported(const char *name, const struct module *mod)
 {
 	if (!mod && lookup_symbol(name, __start___ksymtab, __stop___ksymtab))
 		return 1;
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
git-netdev-all.patch
ibmtr_cs-fix-hang-on-eject.patch
git-ocfs2.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
git-ipwireless_cs.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
the-scheduled-removal-of-obsolete_oss-options.patch
drivers-macintosh-mac_hidc-make-code-static.patch
add-file-position-info-to-proc.patch
more-scheduled-oss-driver-removal.patch
schedule-obsolete-oss-drivers-for-removal-4th-round.patch
make-remove_inode_dquot_ref-static.patch
unexport-pci_proc_attach_device.patch
fix-race-between-rmmod-and-cat-proc-kallsyms.patch
fix-race-between-rmmod-and-cat-proc-kallsyms-fix.patch
the-scheduled-einval-for-invalid-timevals-in-setitimer.patch
ext2-reservations.patch
make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch
remove-nfs4_acl_add_ace.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
no-longer-include-asm-kdebugh.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
fbdev-display-class-fix.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-hecuba-framebuffer-driver-fix.patch
slim-main-patch.patch
slim-debug-output.patch
mutex-subsystem-synchro-test-module.patch
